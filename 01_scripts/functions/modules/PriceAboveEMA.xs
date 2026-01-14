// ===================================================================
// 函數名稱：PriceAboveEMA
// 功能描述：檢查價格是否在 EMA 上方
// 版本：1.0
// 建立日期：2025-12-19
// ===================================================================

// === 參數定義 ===
inputs: Price(numericseries), 
        EMA_Period(numericsimple),
        MinTicksAbove(numericsimple);  // 最少要高於幾個tick

// === 變數宣告 ===
variables: EMA_Value(0),
           TickSize(0),
           MinDistance(0),
           PriceDistance(0),
           IsAboveEMA(false);

// === 計算 EMA ===
EMA_Value = XAverage(Price, EMA_Period);

// === 計算 Tick Size ===
if Close >= 1000 then
    TickSize = 5.0
else if Close >= 500 then
    TickSize = 1.0
else if Close >= 100 then
    TickSize = 0.5
else if Close >= 50 then
    TickSize = 0.1
else
    TickSize = 0.05;

// === 計算最小距離 ===
MinDistance = MinTicksAbove * TickSize;

// === 判斷是否在 EMA 上方 ===
PriceDistance = Price - EMA_Value;
IsAboveEMA = (PriceDistance >= MinDistance);

// === 返回值 ===
PriceAboveEMA = if IsAboveEMA then 1 else 0;

