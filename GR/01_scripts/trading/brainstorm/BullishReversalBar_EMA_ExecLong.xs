// ============================================================
// Bullish Reversal Bar with EMA Uptrend - Execution Script (Long)
// ============================================================
// 描述：
//   在多頭趨勢中出現 bullish reversal bar 時執行做多交易
//
// 進場條件：
//   1. 最新一期收 bullish reversal bar (基於 Nial Fuller 定義)
//   2. EMA20、EMA56、WMA233 呈現上升趨勢（確保多方環境）
//   3. 均線多頭排列：EMA20 > EMA56 > WMA233
//   4. 價格強勢：收盤價 > EMA20
//   5. 成交量達到最低門檻
//
// 交易邏輯：
//   進場：買進設定單位數（預設2單位）
//   停損：跌破買進K棒的最低價
//   停利：
//     - 獲利達到停損的N倍（預設2倍）則停利設定單位（預設1單位）
//     - 移動停利：當根K棒最低價 > 買進K棒最低價時，以當根最低價為基準
//       當股價跌破基準最低價時停利剩餘單位
// ============================================================

{@type:autotrade}

// ===== 參數設定 =====
settotalbar(250);

// --- Reversal Bar 型態參數 ---
input: tail_min_pct(0.45, "下影線最小佔比"),
       opp_tail_max_pct(0.25, "上影線最大佔比"),
       body_max_pct(0.45, "最大實體佔比"),
       body_pos_pct(0.45, "實體位置比例"),
       tail_prominence_bars(5, "影線突出比較期數");

// --- 均線參數 ---
input: ema_uptrend_bars(3, "均線上升確認期數");

// --- 交易參數 ---
input: entry_units(2, "進場單位數"),
       profit_target_ratio(2.0, "停利目標倍數"),
       partial_exit_units(1, "部分停利單位數"),
       min_volume(500, "最小成交量");

// ===== 變數宣告 =====

// --- K 棒型態相關變數 ---
var: candleRange(0),              // K 棒總範圍 (high - low)
     bodySize(0),                 // 實體大小 |close - open|
     upperShadow(0),              // 上影線長度
     lowerShadow(0),              // 下影線長度
     lowerShadowPct(0),           // 下影線佔比
     upperShadowPct(0),           // 上影線佔比
     bodyPct(0),                  // 實體佔比
     bodyPosition(0),             // 實體位置（實體底部的位置）
     lowestInRange(0),            // 區間最低點
     isBullishReversal(false);    // 是否為看漲反轉棒

// --- 均線相關變數 ---
var: ema20(0),                    // EMA20 當前值 (Close, 20)
     ema56(0),                    // EMA56 當前值 (Low, 56)
     wma233(0),                   // WMA233 當前值 (典型價格, 233)
     ema20_prev(0),               // EMA20 前 N 期值
     ema56_prev(0),               // EMA56 前 N 期值
     wma233_prev(0),              // WMA233 前 N 期值
     ema20_trend(false),          // EMA20 是否上升
     ema56_trend(false),          // EMA56 是否上升
     wma233_trend(false);         // WMA233 是否上升

// --- 交易管理變數 ---
var: intrabarpersist signal_armed(false),      // 信號是否已觸發
     intrabarpersist entry_low(0),             // 進場K棒的最低價
     intrabarpersist initial_stop(0),          // 初始停損價格
     intrabarpersist profit_target(0),         // 停利目標價格
     intrabarpersist trailing_stop(0),         // 移動停損價格
     intrabarpersist partial_exit_done(false), // 是否已部分停利
     volumeOK(false);                          // 成交量是否達標

// ============================================================
// 條件 1: Bullish Reversal Bar 偵測
// ============================================================

candleRange  = high - low;
bodySize     = absvalue(close - open);
upperShadow  = high - maxlist(open, close);
lowerShadow  = minlist(open, close) - low;

if candleRange > 0 then
begin
    lowerShadowPct = lowerShadow / candleRange;
    upperShadowPct = upperShadow / candleRange;
    bodyPct        = bodySize / candleRange;
    bodyPosition   = (minlist(open, close) - low) / candleRange;
    lowestInRange  = lowest(low, tail_prominence_bars);
    
    isBullishReversal = 
        (lowerShadowPct >= tail_min_pct)
        and (upperShadowPct <= opp_tail_max_pct)
        and (bodyPct <= body_max_pct)
        and (bodyPosition >= 1 - body_pos_pct)
        and (low <= lowestInRange);
end
else
    isBullishReversal = false;

// ============================================================
// 條件 2: 均線上升趨勢判斷
// ============================================================

ema20  = EMA(close, 20);
ema56  = EMA(low, 56);
wma233 = WMA((open + high + low + close) / 4, 233);

ema20_prev  = EMA(close[ema_uptrend_bars], 20);
ema56_prev  = EMA(low[ema_uptrend_bars], 56);
wma233_prev = WMA((open[ema_uptrend_bars] + high[ema_uptrend_bars] + low[ema_uptrend_bars] + close[ema_uptrend_bars]) / 4, 233);

ema20_trend  = (ema20 > ema20_prev);
ema56_trend  = (ema56 > ema56_prev);
wma233_trend = (wma233 > wma233_prev);

// ============================================================
// 條件 3: 成交量過濾
// ============================================================
volumeOK = (volume >= min_volume);

// ============================================================
// 進場信號判斷
// ============================================================
// 當所有條件符合時，準備進場

if isBullishReversal 
   and ema20_trend 
   and ema56_trend 
   and wma233_trend 
   and (ema20 > ema56)
   and (ema56 > wma233)
   and (close > ema20)
   and volumeOK 
   and Position = 0 then
begin
    // 記錄進場K棒資訊
    entry_low           = low;
    initial_stop        = AddSpread(entry_low, -1);      // 停損：K棒最低價下一檔
    profit_target       = close + (close - initial_stop) * profit_target_ratio;  // 停利目標
    trailing_stop       = initial_stop;                  // 初始移動停損等於初始停損
    signal_armed        = true;
    partial_exit_done   = false;
    
    // 進場：買進設定單位數
    SetPosition(entry_units, market);
end;

// ============================================================
// 部分停利管理（停利第一部分）
// ============================================================
// 當獲利達到停利目標時，停利部分單位

if Position > 0 
   and signal_armed 
   and not partial_exit_done 
   and high >= profit_target then
begin
    // 停利部分單位
    SetPosition(Position - partial_exit_units, market);
    partial_exit_done = true;
end;

// ============================================================
// 移動停損管理
// ============================================================
// 當根K棒的最低價 > 買進K棒的最低價時，更新移動停損基準

if Position > 0 and signal_armed then
begin
    // 更新移動停損：如果當根K棒最低價高於進場K棒最低價，則上移停損
    if low > entry_low then
    begin
        trailing_stop = maxlist(trailing_stop, AddSpread(low, -1));
    end;
end;

// ============================================================
// 停損/停利出場管理
// ============================================================

if Position > 0 and signal_armed then
begin
    // 停損：跌破初始停損價格（針對全部持倉）
    if low <= initial_stop then
    begin
        SetPosition(0, market);
        signal_armed = false;
        partial_exit_done = false;
    end
    // 移動停利：跌破移動停損價格（針對剩餘持倉）
    else if low <= trailing_stop and trailing_stop > initial_stop then
    begin
        SetPosition(0, market);
        signal_armed = false;
        partial_exit_done = false;
    end;
end;

