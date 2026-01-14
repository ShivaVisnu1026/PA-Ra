// ===================================================================
// 函數名稱：BrooksAlwaysIn
// 功能描述：計算 Al Brooks Always-In 方向（多頭/空頭/中性）
// 作者：PriceActions Project
// 建立日期：2025-12-09
// 版本：1.0
// ===================================================================
// Description:
//   Calculates Al Brooks Always-In direction (Bull/Bear/Neutral)
//   using EMA20/EMA50 and two-bar breakout logic
//   Returns: 1=Bull, -1=Bear, 0=Neutral
// ===================================================================

// === 參數定義 ===
inputs: Price(numericseries), 
        EMA20_Period(numericsimple), 
        EMA50_Period(numericsimple);

// === 變數宣告 ===
variables: EMA20_Value(0), 
           EMA50_Value(0),
           CurrentPrice(0),
           PrevPrice(0),
           PrevHigh(0),
           PrevLow(0),
           Prev2High(0),
           Prev2Low(0),
           TwoBarBreakoutUp(false),
           TwoBarBreakoutDown(false),
           AlwaysInState(0);  // 1=Bull, -1=Bear, 0=Neutral

// === 計算 EMA ===
EMA20_Value = XAverage(Price, EMA20_Period);
EMA50_Value = XAverage(Price, EMA50_Period);

// === 取得當前和前期的價格資料 ===
CurrentPrice = Price;
PrevPrice = Close[1];
PrevHigh = High[1];
PrevLow = Low[1];
Prev2High = High[2];
Prev2Low = Low[2];

// === 兩根K棒突破判斷 ===
// 多頭突破：當前收盤 > 前一根最高價 且 前一根收盤 > 前兩根最高價
TwoBarBreakoutUp = (CurrentPrice > PrevHigh) and (PrevPrice > Prev2High);

// 空頭突破：當前收盤 < 前一根最低價 且 前一根收盤 < 前兩根最低價
TwoBarBreakoutDown = (CurrentPrice < PrevLow) and (PrevPrice < Prev2Low);

// === Always-In 狀態判斷 ===
// 需要至少3根K棒才能判斷（當前、前一根、前兩根）
if CurrentBarNumber >= 3 then begin
    // 多頭條件：兩根K棒向上突破 且 當前價格 > EMA50
    if TwoBarBreakoutUp and (CurrentPrice > EMA50_Value) then
        AlwaysInState = 1  // Bull
    // 空頭條件：兩根K棒向下突破 且 當前價格 < EMA50
    else if TwoBarBreakoutDown and (CurrentPrice < EMA50_Value) then
        AlwaysInState = -1  // Bear
    // 中性條件：價格穿越EMA50的另一側
    else if (AlwaysInState[1] = 1) and (CurrentPrice < EMA50_Value) then
        AlwaysInState = 0  // 從多頭轉為中性
    else if (AlwaysInState[1] = -1) and (CurrentPrice > EMA50_Value) then
        AlwaysInState = 0  // 從空頭轉為中性
    else
        AlwaysInState = AlwaysInState[1];  // 維持前一狀態
end
else
    AlwaysInState = 0;  // 初始狀態為中性

// === 返回值 ===
BrooksAlwaysIn = AlwaysInState;

