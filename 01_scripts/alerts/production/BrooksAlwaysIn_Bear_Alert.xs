// ===================================================================
// 腳本名稱：Brooks Always-In 轉空頭警示
// 腳本類型：警示（Alert）
// 功能描述：當 Always-In 轉為空頭時觸發警示
// 資料週期：5分鐘（建議）
// 作者：PriceActions Project
// 建立日期：2025-12-09
// 版本：1.0
// ===================================================================
// Description:
//   Alerts when Always-In direction turns bearish
//   Uses EMA20/EMA50 and two-bar breakout logic
// ===================================================================

// === 參數宣告 ===
settotalbar(250);

input: EMA20_Period(20, "EMA20 週期"),
       EMA50_Period(50, "EMA50 週期");

// === 變數宣告 ===
var: EMA20_Value(0),
     EMA50_Value(0),
     AlwaysInState(0),
     PrevAIState(0),
     TwoBarBreakoutDown(false),
     intrabarpersist AlertTriggered(false);

// === 計算 EMA ===
EMA20_Value = XAverage(Close, EMA20_Period);
EMA50_Value = XAverage(Close, EMA50_Period);

// === Always-In 狀態判斷 ===
if CurrentBarNumber >= 3 then begin
    PrevAIState = AlwaysInState[1];
    
    // 兩根K棒向下突破判斷
    TwoBarBreakoutDown = (Close < Low[1]) and (Close[1] < Low[2]);
    
    // 空頭條件：兩根K棒向下突破 且 當前價格 < EMA50
    if TwoBarBreakoutDown and (Close < EMA50_Value) then
        AlwaysInState = -1
    else if (PrevAIState = -1) and (Close > EMA50_Value) then
        AlwaysInState = 0
    else if (PrevAIState = 1) and (Close < EMA50_Value) then
        AlwaysInState = 0
    else
        AlwaysInState = PrevAIState;
    
    // === 觸發條件：從非空頭轉為空頭 ===
    if (AlwaysInState = -1) and (PrevAIState <> -1) and not AlertTriggered then begin
        Alert("Always-In 轉為空頭！價格: " + Text(Close) + ", EMA50: " + Text(EMA50_Value));
        AlertTriggered = true;
    end;
end;

// === 重置機制：當 Always-In 轉為非空頭時重置 ===
if AlwaysInState <> -1 then
    AlertTriggered = false;

