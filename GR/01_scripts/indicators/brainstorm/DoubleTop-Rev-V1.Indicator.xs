// ============================================================
// Double Top Reversal Pattern Indicator V1
// ============================================================
// 描述：
//   在圖表上繪製雙頂反轉型態的關鍵點和均線
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
// 繪製內容：
//   - DTBear 標記（結合雙頂反轉型態和靠近日線高點的空方 K 棒）
//
// 策略邏輯：
//   1. 雙頂反轉型態：
//      - 使用狀態機追蹤型態形成過程
//      - 尋找 swing high → 回檔 → 第二個高點 → bear bar 收在低點
//      - 在 bear bar 收在最低價時顯示警示
//   2. 靠近日線高點的空方 K 棒：
//      - 回溯區間內的最高價（Swing High）
//      - High 接近該高點（容忍度預設 2%）
//      - 該棒為 BreakoutBear 或 ReversalBear
//      - 畫出該棒的 High 作為空方警示
//
// 檔案名稱：DoubleTop-Rev-V1.Indicator.xs
// 備註：檔案已從 DoubleTop-rev-V1_Indicator.xs 重新命名
//      已整合 Plot_BearBarNearSwingHigh 功能
// ============================================================

{@type:indicator}

// ===== 參數設定 =====
settotalbar(100);

// --- 均線參數 ---
input: ema8_period(8, "EMA8 週期"),
       ema20_period(20, "EMA20 週期"),
       ema56_period(56, "EMA56 週期"),
       wma233_period(233, "WMA233 週期");

// --- 型態參數 ---
input: pullback_max_bars(5, "最大回檔 K 棒數"),
       pullback_min_bars(3, "最小回檔 K 棒數"),
       swing_high_lookback(20, "Swing High 回看期數"),
       swing_high_left_bars(3, "Swing High 左側期數"),
       swing_high_right_bars(3, "Swing High 右側期數"),
       swing_high_angle_min_pct(50, "Swing High 最小上漲角度 %"),
       swing_low_lookback(10, "Swing Low 回看期數（用於計算角度）");

// --- 其他過濾條件 ---
input: min_volume(100, "最小成交量");

// --- BearBarNearSwingHigh 參數 ---
input: bear_lookback(20, "回溯期數（日線）"),
       bear_nearPct(2, "接近高點的容忍範圍（百分比）"),
       bear_bodyMinPct(2, "最小實體跌幅 %"),
       bear_shadowMaxPct(1.5, "收盤接近最低價的程度 %"),
       bear_dropThresholdPct(2, "與前收盤比較的跌幅 %");

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
     intrabarpersist barsSincePullback(0),  // 回檔完成後的 K 棒計數
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
     foundBearBarCondition(false), // Bear bar 條件是否成立
     swingLowPrice(0),            // Swing low 價格（swing high 之前的低點）
     swingHighAnglePct(0),         // Swing high 的上漲角度百分比
     hasValidSwingHighAngle(false), // Swing high 是否有 > 50% 角度上漲
     lowestInRange(0);            // 區間內最低價（用於計算角度）

// --- BearBarNearSwingHigh 變數 ---
var: bear_swingHigh(0),           // 回溯期間最高價
     bear_swingHighBar(0),        // 該最高價所在相對 K 棒位置
     bear_barHigh(0),             // 當前 K 棒高點
     bear_barLow(0),              // 當前 K 棒低點
     bear_barClose(0),            // 當前 K 棒收盤價
     bear_barOpen(0),             // 當前 K 棒開盤價
     bear_isBreakoutBear(false),  // 是否為 BreakoutBear
     bear_isReversalBear(false),  // 是否為 ReversalBear
     bear_nearSwingHigh(false),   // 是否靠近 swing high
     bear_bodySize(0),            // Bear bar 實體大小
     bear_bodyPct(0),             // Bear bar 實體跌幅百分比
     bear_shadowSize(0),          // Bear bar 下影線大小
     bear_shadowPct(0),           // Bear bar 下影線百分比
     bear_dropPct(0),             // 與前收盤比較的跌幅百分比
     bear_pullbackBarCount(0),    // Bear swing high 後的回檔 K 棒計數
     bear_hasValidPullback(false), // 是否有有效的回檔（>3 且 <=5 bars）
     bear_swingHighPrice(0),      // Bear swing high 價格
     bear_swingHighBarIndex(0),   // Bear swing high 所在的 bar index
     bear_priceAboveEMA8(false);  // 價格是否在 8EMA 上方

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
// 輔助函數：計算 swing high 的上漲角度
// ============================================================
// 找出 swing high 之前的 swing low，計算上漲百分比
if isSwingHigh and swingHighPrice > 0 then
begin
    // 在 swing high 之前的區間內找出最低點
    // 使用 SwingLow 函數找出轉折低點
    swingLowPrice = SwingLow(low, swing_low_lookback, swing_high_left_bars, swing_high_right_bars, 1);
    
    // 如果找到 swing low，計算上漲角度百分比
    if swingLowPrice > 0 then
    begin
        swingHighAnglePct = ((swingHighPrice - swingLowPrice) / swingLowPrice) * 100;
        hasValidSwingHighAngle = (swingHighAnglePct > swing_high_angle_min_pct);
    end
    else
    begin
        // 如果找不到 swing low，使用區間內的最低價
        lowestInRange = lowest(low, swing_low_lookback);
        if lowestInRange > 0 then
        begin
            swingHighAnglePct = ((swingHighPrice - lowestInRange) / lowestInRange) * 100;
            hasValidSwingHighAngle = (swingHighAnglePct > swing_high_angle_min_pct);
        end
        else
            hasValidSwingHighAngle = false;
    end;
end
else
    hasValidSwingHighAngle = false;

// ============================================================
// 輔助函數：判斷高點是否在 8EMA 上方
// ============================================================
highAboveEMA8 = (high > ema8);

// ============================================================
// 型態偵測狀態機
// ============================================================

// ============================================================
// 階段 1：尋找第一個 swing high（必須有 > 50% 角度上漲）
// ============================================================
if not firstHighFound then
begin
    // 第一個 swing high 必須同時滿足：
    // 1. 是 swing high
    // 2. 有 > 50% 的角度上漲
    foundFirstHighCondition = isSwingHigh and hasValidSwingHighAngle;
    
    if foundFirstHighCondition then
    begin
        firstHighFound = true;
        firstHighPrice = high;
        pullbackBarCount = 0;  // 重置回檔計數器
        patternState = 1;
    end;
end;

// ============================================================
// 階段 2：監控回檔（大於 3 根且少於等於 5 根 K 棒）
// ============================================================
if firstHighFound and not pullbackConditionMet then
begin
    // 增加回檔 K 棒計數器
    pullbackBarCount = pullbackBarCount + 1;
    
    // 檢查回檔條件：大於 3 根且少於等於 6 根 K 棒
    if pullbackBarCount > pullback_min_bars and pullbackBarCount <= pullback_max_bars then
    begin
        pullbackConditionMet = true;
        barsSincePullback = 0;  // 重置回檔完成後的計數器
        patternState = 2;
    end
    // 如果回檔超過最大 K 棒數，重置型態
    else if pullbackBarCount > pullback_max_bars then
    begin
        // 重置狀態
        firstHighFound = false;
        pullbackBarCount = 0;
        pullbackConditionMet = false;
        barsSincePullback = 0;
        patternState = 0;
    end;
    // 如果回檔少於最小 K 棒數，繼續等待
end;

// ============================================================
// 階段 2.5：回檔完成後，計數等待第二個高點（需要 > 2 根 K 棒）
// ============================================================
if pullbackConditionMet and not secondHighFound then
begin
    // 增加回檔完成後的 K 棒計數器
    barsSincePullback = barsSincePullback + 1;
end;

// ============================================================
// 階段 3：尋找第二個頂部（高點在 8EMA 上方，且回檔完成後 > 2 根 K 棒）
// ============================================================
if pullbackConditionMet and not secondHighFound and barsSincePullback > 2 then
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
// BearBarNearSwingHigh 邏輯
// ============================================================
// === Step 1：計算回溯期間的最高價與該棒位置 ===
// 使用 Extremes 函數回傳過去 bear_lookback 期內最高價與其所在的 K 棒距今幾根
value1 = Extremes(High, bear_lookback, 1, bear_swingHigh, bear_swingHighBar);

// === Step 1.5：追蹤 swing high 和回檔 ===
// bear_swingHighBar 告訴我們 swing high 是幾根 K 棒之前發生的
// 如果 bear_swingHighBar = 0，表示當前 bar 就是 swing high
// 如果 bear_swingHighBar = 3，表示 swing high 是 3 根 K 棒之前
if bear_swingHigh > 0 and bear_swingHighBar >= 0 then
begin
    // 如果 swing high 價格或位置改變，更新追蹤
    if bear_swingHighPrice <> bear_swingHigh or bear_swingHighBarIndex <> bear_swingHighBar then
    begin
        bear_swingHighPrice = bear_swingHigh;
        bear_swingHighBarIndex = bear_swingHighBar;
    end;
    
    // 計算從 swing high 到現在經過了多少根 K 棒
    // bear_swingHighBar 就是回檔的 K 棒數
    bear_pullbackBarCount = bear_swingHighBarIndex;
    
    // 檢查回檔是否在有效範圍內（>3 且 <=5 bars）
    // 注意：如果 bear_swingHighBar = 0，表示當前就是 swing high，還沒有回檔
    if bear_pullbackBarCount > pullback_min_bars and bear_pullbackBarCount <= pullback_max_bars then
        bear_hasValidPullback = true
    else
        bear_hasValidPullback = false;
end
else
begin
    bear_hasValidPullback = false;
    bear_pullbackBarCount = 0;
end;

// === Step 2：記錄目前 K 棒的高低收開價格 ===
bear_barHigh  = High;
bear_barLow   = Low;
bear_barClose = Close;
bear_barOpen  = Open;

// === Step 3：判斷是否為 BreakoutBear ===
// BreakoutBear 條件：
//   - Bear bar (close < open)
//   - 實體跌幅 >= bear_bodyMinPct%
//   - 收盤接近最低價（收盤與最低價差距 <= bear_shadowMaxPct%）
//   - 與前收盤比較跌幅 >= bear_dropThresholdPct%
if bear_barClose < bear_barOpen and bear_barHigh > 0 and close[1] > 0 then
begin
    bear_bodySize = bear_barOpen - bear_barClose;
    bear_bodyPct = (bear_bodySize / bear_barHigh) * 100;
    bear_shadowSize = bear_barClose - bear_barLow;
    bear_shadowPct = (bear_shadowSize / bear_barHigh) * 100;
    bear_dropPct = ((close[1] - bear_barClose) / close[1]) * 100;
    
    bear_isBreakoutBear = (bear_bodyPct >= bear_bodyMinPct) 
                          and (bear_shadowPct <= bear_shadowMaxPct)
                          and (bear_dropPct >= bear_dropThresholdPct);
end
else
    bear_isBreakoutBear = false;

// === Step 4：判斷是否為 ReversalBear ===
// ReversalBear 條件：簡單判斷為 bear bar 且收在最低價附近
if bear_barClose < bear_barOpen and bear_barHigh > 0 then
    bear_isReversalBear = (absvalue(bear_barClose - bear_barLow) / bear_barHigh * 100 <= bear_shadowMaxPct)
else
    bear_isReversalBear = false;

// === Step 5：如果本週 High 靠近 swing high（例如高點 2% 以內）===
bear_nearSwingHigh = (bear_swingHigh > 0) and (bear_barHigh >= bear_swingHigh * (1 - bear_nearPct / 100));

// === Step 6：測試 8EMA 條件 ===
// 檢查價格是否在 8EMA 上方（用於確認趨勢或測試阻力）
bear_priceAboveEMA8 = (bear_barHigh > ema8);

// ============================================================
// 繪製 DTBear 標記（結合兩種條件）
// ============================================================
// 條件 1：雙頂反轉型態完成（bear bar 收在最低價且符合成交量條件）
//    - 需要有效的回檔（已在狀態機中處理）
//    - 需要測試 8EMA（高點在 8EMA 上方）
// 條件 2：靠近日線高點的空方 K 棒（BreakoutBear 或 ReversalBear）
//    - 需要有效的回檔（>3 且 <=5 bars）
//    - 需要測試 8EMA（高點在 8EMA 上方）
if (foundBearBarCondition and not alertTriggered and volume >= min_volume and bear_priceAboveEMA8) 
   or (bear_nearSwingHigh and bear_hasValidPullback and (bear_isBreakoutBear or bear_isReversalBear) and bear_priceAboveEMA8) then
begin
    // 使用較高的價格位置繪製標記
    if foundBearBarCondition and not alertTriggered then
        plot1(close * 1.01, "DTBear")
    else
        plot1(bear_barHigh, "DTBear");
end;

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
    barsSincePullback = 0;
    secondHighFound = false;
    alertTriggered = false;
end;

