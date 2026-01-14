// ===================================================================
// 函數名稱：ATRFilter
// 功能描述：基於 ATR 的過濾條件（波動度檢查）
// 版本：1.0
// 建立日期：2025-12-19
// ===================================================================

// === 參數定義 ===
inputs: ATR_Period(numericsimple),
        MinATR_Multiple(numericsimple),  // 最小 ATR 倍數
        MaxATR_Multiple(numericsimple);  // 最大 ATR 倍數

// === 變數宣告 ===
variables: TrueRange(0),
           ATR_Value(0),
           CurrentRange(0),
           ATR_Multiple(0),
           IsValidVolatility(false);

// === 計算 ATR ===
TrueRange = MaxList(
    High - Low,
    AbsValue(High - Close[1]),
    AbsValue(Low - Close[1])
);

if CurrentBar = 1 then
    ATR_Value = TrueRange
else if CurrentBar <= ATR_Period then
    ATR_Value = Average(TrueRange, CurrentBar)
else
    ATR_Value = (ATR_Value[1] * (ATR_Period - 1) + TrueRange) / ATR_Period;

// === 判斷波動度是否合適 ===
CurrentRange = High - Low;
if ATR_Value > 0 then begin
    ATR_Multiple = CurrentRange / ATR_Value;
    IsValidVolatility = (ATR_Multiple >= MinATR_Multiple) and 
                        (ATR_Multiple <= MaxATR_Multiple);
end
else
    IsValidVolatility = false;

// === 返回值 ===
ATRFilter = if IsValidVolatility then 1 else 0;

