// ============================================================
// Bearish Reversal Bar with EMA Downtrend Alert
// ============================================================
// 描述：
//   在空頭趨勢中出現 bearish reversal bar 時發出警示
//
// 條件：
//   1. 最新一期收 bearish reversal bar (基於 Nial Fuller 定義)
//   2. EMA20、EMA56、WMA233 呈現下降趨勢（確保空方環境）
//   3. 成交量達到最低門檻
//
// 策略邏輯：
//   - Reversal bar 已判斷區間最高點，不需要 EMA8 遞減條件
//   - 使用中長期均線（EMA20/EMA56/WMA233）確認空頭趨勢
//   - 適合在空頭趨勢中尋找反彈放空點
// ============================================================

{@type:sensor}

// ===== 參數設定 =====
settotalbar(250);

// --- Reversal Bar 型態參數 ---
input: tail_min_pct(0.45, "上影線最小佔比"),
       opp_tail_max_pct(0.25, "下影線最大佔比"),
       body_max_pct(0.45, "最大實體佔比"),
       body_pos_pct(0.45, "實體位置比例"),
       tail_prominence_bars(5, "影線突出比較期數");

// --- 均線參數 ---
input: ema_downtrend_bars(3, "均線下降確認期數");

// --- 其他過濾條件 ---
input: min_volume(100, "最小成交量");

// ===== 變數宣告 =====

// --- K 棒型態相關變數 ---
var: candleRange(0),              // K 棒總範圍 (high - low)
     bodySize(0),                 // 實體大小 |close - open|
     upperShadow(0),              // 上影線長度
     lowerShadow(0),              // 下影線長度
     upperShadowPct(0),           // 上影線佔比
     lowerShadowPct(0),           // 下影線佔比
     bodyPct(0),                  // 實體佔比
     bodyPosition(0),             // 實體位置（實體頂部的位置）
     highestInRange(0),           // 區間最高點
     isBearishReversal(false);    // 是否為看跌反轉棒

// --- 均線相關變數 ---
var: ema20(0),                    // EMA20 當前值 (Close, 20)
     ema56(0),                    // EMA56 當前值 (Low, 56)
     wma233(0),                   // WMA233 當前值 (典型價格, 233)
     ema20_prev(0),               // EMA20 前 N 期值
     ema56_prev(0),               // EMA56 前 N 期值
     wma233_prev(0),              // WMA233 前 N 期值
     ema20_trend(false),          // EMA20 是否下降
     ema56_trend(false),          // EMA56 是否下降
     wma233_trend(false);         // WMA233 是否下降

// --- 其他過濾條件變數 ---
var: volumeOK(false);             // 成交量是否達標

// ============================================================
// 條件 1: Bearish Reversal Bar 偵測
// ============================================================
// 採用比例法（各部分佔整根 K 棒的比例）
//
// 核心特徵：
//   - 長上影線：至少佔 K 棒 45%
//   - 小實體：不超過 K 棒 45%
//   - 短下影線：不超過 K 棒 25%
//   - 實體在下方：實體頂部位置 <= 45%（即在下方 45% 區域內）
//   - 高點突出：當根 K 棒的高點是近 N 期最高
//   - 不限定紅黑：實體不一定要收黑（close < open）
// ============================================================

candleRange  = high - low;
bodySize     = absvalue(close - open);
upperShadow  = high - maxlist(open, close);
lowerShadow  = minlist(open, close) - low;

// 避免除以零
if candleRange > 0 then
begin
    // 計算各部分佔 K 棒總範圍的比例
    upperShadowPct = upperShadow / candleRange;
    lowerShadowPct = lowerShadow / candleRange;
    bodyPct        = bodySize / candleRange;
    
    // 計算實體位置：實體頂部相對於整根 K 棒的位置（0 = 最底, 1 = 最頂）
    bodyPosition = (maxlist(open, close) - low) / candleRange;
    
    // 檢查高點是否突出於周圍 K 線
    highestInRange = highest(high, tail_prominence_bars);
    
    // Bearish Reversal Bar 綜合判斷
    isBearishReversal = 
        (upperShadowPct >= tail_min_pct)         // 上影線至少 45%
        and (lowerShadowPct <= opp_tail_max_pct) // 下影線不超過 25%
        and (bodyPct <= body_max_pct)            // 實體不超過 45%
        and (bodyPosition <= body_pos_pct)       // 實體在下方（頂部位置 <= 45%）
        and (high >= highestInRange);            // 高點是近期最高
end
else
    isBearishReversal = false;

// ============================================================
// 條件 2: 均線下降趨勢判斷（確保空方環境）
// ============================================================
// 說明：
//   - 不檢查 EMA8，避免與 reversal bar 的區間最高判斷衝突
//   - 使用特定均線組合：EMA20(Close)/EMA56(Low)/WMA233(典型價格)
//   - 下降判斷：當前均線 < N 期前的均線
// ============================================================

// 計算當前均線值
ema20  = EMA(close, 20);                                           // EMA of Close, period 20
ema56  = EMA(low, 56);                                             // EMA of Low, period 56
wma233 = WMA((open + high + low + close) / 4, 233);               // WMA of typical price, period 233

// 計算 N 期前的均線值（用於判斷趨勢）
ema20_prev  = EMA(close[ema_downtrend_bars], 20);
ema56_prev  = EMA(low[ema_downtrend_bars], 56);
wma233_prev = WMA((open[ema_downtrend_bars] + high[ema_downtrend_bars] + low[ema_downtrend_bars] + close[ema_downtrend_bars]) / 4, 233);

// 判斷各均線是否下降
ema20_trend  = (ema20 < ema20_prev);
ema56_trend  = (ema56 < ema56_prev);
wma233_trend = (wma233 < wma233_prev);

// ============================================================
// 條件 3: 成交量過濾
// ============================================================
volumeOK = (volume >= min_volume);

// ============================================================
// 綜合條件判斷
// ============================================================
// 篩選邏輯：
//   1. 必須是 bearish reversal bar
//   2. EMA20/EMA56/WMA233 都呈下降趨勢（不檢查 EMA8）
//   3. 均線空頭排列：EMA20 < EMA56 < WMA233（確保強勁空方趨勢）
//   4. 價格弱勢：收盤價 < EMA20（確保反彈後仍保持弱勢）
//   5. 成交量達到最低門檻
// ============================================================

if isBearishReversal 
   and ema20_trend 
   and ema56_trend 
   and wma233_trend 
   and (ema20 < ema56)        // 方案1：均線空頭排列 - EMA20 < EMA56
   and (ema56 < wma233)       // 方案1：均線空頭排列 - EMA56 < WMA233
   and (close < ema20)        // 方案2：價格位置過濾 - 收盤價 < EMA20
   and volumeOK then
    ret = 1
else
    ret = 0;
