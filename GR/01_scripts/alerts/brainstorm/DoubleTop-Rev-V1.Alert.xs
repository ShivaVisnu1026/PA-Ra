// ============================================================
// Double Top Reversal Pattern Alert V1
// ============================================================
// 描述：
//   偵測雙頂反轉型態並在第二個頂部出現 bear bar 時發出警示
//
// 資料週期：日線圖（Daily）
//
// 均線計算方式：
//   - EMA8: 典型價格的指數移動平均
//           典型價格 = (High + Low + Open + Close) / 4
//   - EMA20: 收盤價的指數移動平均
//   - EMA56: 最低價的指數移動平均
//   - WMA233: 典型價格的加權移動平均
//
// 型態條件：
//   1. 尋找 swing high
//   2. 回檔：少於 6 根 K 棒
//   3. 第二個頂部：價格再次創高，且高點在 8EMA 上方
//   4. Bear bar：收盤價等於最低價（收在低點）
//   5. 在 bear bar 當日發出警示
//
// 策略邏輯：
//   - 使用狀態機追蹤型態形成過程
//   - 尋找 swing high → 回檔 → 第二個高點 → bear bar 收在低點
//   - 在 bear bar 收在最低價時觸發警示
//
// 檔案名稱：DoubleTop-Rev-V1.Alert.xs
// 備註：檔案已從 DoubleTop-rev-V1_Alert.xs 重新命名
// ============================================================

{@type:sensor}

// ===== 參數設定 =====
settotalbar(250);

// --- 均線參數 ---
input: ema8_period(8, "EMA8 週期"),
       ema20_period(20, "EMA20 週期"),
       ema56_period(56, "EMA56 週期"),
       wma233_period(233, "WMA233 週期");

// --- 型態參數 ---
input: pullback_max_bars(6, "最大回檔 K 棒數"),
       swing_high_lookback(5, "Swing High 回看期數"),
       swing_high_left_bars(3, "Swing High 左側期數"),
       swing_high_right_bars(3, "Swing High 右側期數");

// --- 其他過濾條件 ---
input: min_volume(100, "最小成交量");

// ===== 變數宣告 =====

// --- 均線相關變數 ---
var: ema8(0),                    // EMA8 當前值 (典型價格, 8)
     ema20(0),                   // EMA20 當前值 (Close, 20)
     ema56(0),                   // EMA56 當前值 (Low, 56)
     wma233(0);                  // WMA233 當前值 (典型價格, 233)

// --- 型態狀態追蹤變數（使用 intrabarpersist 保持狀態）---
var: intrabarpersist patternState(0),      // 型態狀態：0=未開始, 1=swing high已找到, 2=回檔中, 3=第二個頂部已找到, 4=完成
     intrabarpersist firstHighFound(false),  // 第一個 swing high 是否已找到
     intrabarpersist firstHighPrice(0),     // 第一個 swing high 價格
     intrabarpersist pullbackBarCount(0),   // 回檔 K 棒計數器
     intrabarpersist pullbackConditionMet(false), // 回檔條件是否已滿足
     intrabarpersist secondHighFound(false), // 第二個頂部是否已找到
     intrabarpersist secondHighPrice(0),    // 第二個頂部價格
     intrabarpersist alertTriggered(false);  // 警示是否已觸發

// --- 輔助變數 ---
var: isBearBar(false),            // 是否為 bear bar (close < open)
     isBearBarAtLow(false),       // Bear bar 是否收在最低價
     isSwingHigh(false),          // 是否為 swing high
     swingHighPrice(0),           // Swing high 價格
     highAboveEMA8(false),        // 高點是否在 8EMA 上方
     foundFirstHighCondition(false), // 第一個 swing high 條件是否成立
     foundSecondHighCondition(false), // 第二個頂部條件是否成立
     foundBearBarCondition(false); // Bear bar 條件是否成立

// ============================================================
// 計算均線（日線圖專用）
// ============================================================
// EMA8: 典型價格的指數移動平均
// 典型價格 = (High + Low + Open + Close) / 4
ema8 = EMA((high + low + open + close) / 4, ema8_period);

// EMA20: 收盤價的指數移動平均
ema20 = EMA(close, ema20_period);

// EMA56: 最低價的指數移動平均
ema56 = EMA(low, ema56_period);

// WMA233: 典型價格的加權移動平均
// 典型價格 = (High + Low + Open + Close) / 4
wma233 = WMA((high + low + open + close) / 4, wma233_period);

// ============================================================
// 輔助函數：判斷是否為 bear bar
// ============================================================
isBearBar = (close < open);

// ============================================================
// 輔助函數：判斷 bear bar 是否收在最低價
// ============================================================
isBearBarAtLow = (isBearBar and close = low);

// ============================================================
// 輔助函數：判斷是否為 swing high
// ============================================================
// 使用 SwingHigh 函數找出轉折高點
// SwingHigh(資料, 回看期數, 左側期數, 右側期數, 第幾個)
swingHighPrice = SwingHigh(high, swing_high_lookback, swing_high_left_bars, swing_high_right_bars, 1);
// 如果當前 high 等於 swing high 價格，則為 swing high
isSwingHigh = (swingHighPrice > 0 and absvalue(high - swingHighPrice) < high * 0.001); // 允許微小誤差

// ============================================================
// 輔助函數：判斷高點是否在 8EMA 上方
// ============================================================
highAboveEMA8 = (high > ema8);

// ============================================================
// 型態偵測狀態機
// ============================================================

// ============================================================
// 階段 1：尋找第一個 swing high
// ============================================================
if not firstHighFound then
begin
    foundFirstHighCondition = isSwingHigh;
    
    if foundFirstHighCondition then
    begin
        firstHighFound = true;
        firstHighPrice = high;
        pullbackBarCount = 0;  // 重置回檔計數器
        patternState = 1;
    end;
end;

// ============================================================
// 階段 2：監控回檔（少於 6 根 K 棒）
// ============================================================
if firstHighFound and not pullbackConditionMet then
begin
    // 增加回檔 K 棒計數器
    pullbackBarCount = pullbackBarCount + 1;
    
    // 檢查回檔條件：少於 6 根 K 棒
    if pullbackBarCount < pullback_max_bars then
    begin
        pullbackConditionMet = true;
        patternState = 2;
    end
    // 如果回檔超過最大 K 棒數，重置型態
    else if pullbackBarCount >= pullback_max_bars then
    begin
        // 重置狀態
        firstHighFound = false;
        pullbackBarCount = 0;
        pullbackConditionMet = false;
        patternState = 0;
    end;
end;

// ============================================================
// 階段 3：尋找第二個頂部（高點在 8EMA 上方）
// ============================================================
if pullbackConditionMet and not secondHighFound then
begin
    foundSecondHighCondition = highAboveEMA8;
    
    if foundSecondHighCondition then
    begin
        secondHighFound = true;
        secondHighPrice = high;
        patternState = 3;
    end;
end;

// ============================================================
// 階段 4：等待 bear bar 收在最低價
// ============================================================
if secondHighFound and not alertTriggered then
begin
    foundBearBarCondition = isBearBarAtLow;
    
    if foundBearBarCondition then
    begin
        patternState = 4;
    end;
end;

// ============================================================
// 警示觸發
// ============================================================
// 當型態完成（狀態 4）且尚未觸發警示時，發出警示
if patternState = 4 
   and not alertTriggered
   and (volume >= min_volume) then
begin
    ret = 1;
    alertTriggered = true;
end
else
    ret = 0;

// ============================================================
// 重置機制
// ============================================================
// 如果回檔超過最大 K 棒數，重置型態（已在階段 2 處理）
// 當警示觸發後，重置型態以便尋找下一個型態
if alertTriggered then
begin
    patternState = 0;
    firstHighFound = false;
    pullbackBarCount = 0;
    pullbackConditionMet = false;
    secondHighFound = false;
    alertTriggered = false;
end;

