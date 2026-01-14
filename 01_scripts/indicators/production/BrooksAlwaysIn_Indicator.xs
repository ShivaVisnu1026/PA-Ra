// ===================================================================
// 腳本名稱：Brooks Always-In 指標
// 腳本類型：指標（Indicator）
// 功能描述：顯示 Al Brooks Always-In 方向（多頭/空頭/中性）
// 資料週期：5分鐘（建議）
// 作者：PriceActions Project
// 建立日期：2025-12-09
// 版本：1.0
// ===================================================================
// Description:
//   Displays Al Brooks Always-In direction using EMA20/EMA50
//   and two-bar breakout logic
// ===================================================================

{@type:indicator}

// === 參數宣告 ===
settotalbar(250);

input: EMA20_Period(20, "EMA20 週期"),
       EMA50_Period(50, "EMA50 週期");

// === 變數宣告 ===
var: EMA20_Value(0),
     EMA50_Value(0),
     AlwaysInState(0),  // 1=Bull, -1=Bear, 0=Neutral
     TwoBarBreakoutUp(false),
     TwoBarBreakoutDown(false),
     PrevState(0);

// === 計算 EMA ===
EMA20_Value = XAverage(Close, EMA20_Period);
EMA50_Value = XAverage(Close, EMA50_Period);

// === 兩根K棒突破判斷 ===
// 需要至少3根K棒才能判斷
if CurrentBarNumber >= 3 then begin
    // 多頭突破：當前收盤 > 前一根最高價 且 前一根收盤 > 前兩根最高價
    TwoBarBreakoutUp = (Close > High[1]) and (Close[1] > High[2]);
    
    // 空頭突破：當前收盤 < 前一根最低價 且 前一根收盤 < 前兩根最低價
    TwoBarBreakoutDown = (Close < Low[1]) and (Close[1] < Low[2]);
    
    // 取得前一狀態
    PrevState = AlwaysInState[1];
    
    // === Always-In 狀態判斷 ===
    // 多頭條件：兩根K棒向上突破 且 當前價格 > EMA50
    if TwoBarBreakoutUp and (Close > EMA50_Value) then
        AlwaysInState = 1  // Bull
    // 空頭條件：兩根K棒向下突破 且 當前價格 < EMA50
    else if TwoBarBreakoutDown and (Close < EMA50_Value) then
        AlwaysInState = -1  // Bear
    // 中性條件：價格穿越EMA50的另一側
    else if (PrevState = 1) and (Close < EMA50_Value) then
        AlwaysInState = 0  // 從多頭轉為中性
    else if (PrevState = -1) and (Close > EMA50_Value) then
        AlwaysInState = 0  // 從空頭轉為中性
    else
        AlwaysInState = PrevState;  // 維持前一狀態
end
else
    AlwaysInState = 0;  // 初始狀態為中性

// === 繪製指標 ===
// 繪製 EMA20 和 EMA50
plot1(EMA20_Value, "EMA20");
plot2(EMA50_Value, "EMA50");

// 繪製 Always-In 狀態（使用不同顏色）
if AlwaysInState = 1 then
    plot3(Close, "Always-In Bull", Red)
else if AlwaysInState = -1 then
    plot3(Close, "Always-In Bear", Blue)
else
    plot3(Close, "Always-In Neutral", Yellow);

// === 輸出欄位（可選） ===
OutputField(1, AlwaysInState, "Always-In State");
OutputField(2, EMA20_Value, "EMA20");
OutputField(3, EMA50_Value, "EMA50");

