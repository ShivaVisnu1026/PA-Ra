// ===================================================================
// 函數名稱：ATRMeasurement
// 功能描述：計算 ATR（Average True Range）並返回相關指標
// 版本：1.0
// 建立日期：2025-12-19
// ===================================================================

// === 參數定義 ===
inputs: ATR_Period(numericsimple);

// === 變數宣告 ===
variables: TrueRange(0),
           ATR_Value(0),
           CurrentRange(0),
           ATR_Multiple(0);

// === 計算 True Range ===
TrueRange = MaxList(
    High - Low,                    // 當日高低差
    AbsValue(High - Close[1]),     // 高點與前收差
    AbsValue(Low - Close[1])       // 低點與前收差
);

// === 計算 ATR（使用 Wilder's smoothing） ===
if CurrentBar = 1 then
    ATR_Value = TrueRange
else if CurrentBar <= ATR_Period then
    ATR_Value = Average(TrueRange, CurrentBar)
else
    ATR_Value = (ATR_Value[1] * (ATR_Period - 1) + TrueRange) / ATR_Period;

// === 計算當前區間相對於 ATR 的倍數 ===
CurrentRange = High - Low;
if ATR_Value > 0 then
    ATR_Multiple = CurrentRange / ATR_Value
else
    ATR_Multiple = 0;

// === 返回值 ===
ATRMeasurement = ATR_Value;

