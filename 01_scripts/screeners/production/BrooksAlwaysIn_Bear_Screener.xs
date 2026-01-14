// ===================================================================
// 腳本名稱：Brooks Always-In 空頭選股
// 腳本類型：選股（Screener）
// 功能描述：篩選 Always-In 為空頭的股票
// 資料週期：5分鐘（建議）
// 作者：PriceActions Project
// 建立日期：2025-12-09
// 版本：1.0
// ===================================================================
// Description:
//   Screens for stocks with Always-In bearish state
//   Uses EMA20/EMA50 and two-bar breakout logic
// ===================================================================

// === 參數宣告 ===
settotalbar(250);

input: EMA20_Period(20, "EMA20 週期"),
       EMA50_Period(50, "EMA50 週期"),
       MinVolume(500, "最小成交量(張)");

// === 變數宣告 ===
var: EMA20_Value(0),
     EMA50_Value(0),
     AlwaysInState(0),
     PrevAIState(0),
     TwoBarBreakoutUp(false),
     TwoBarBreakoutDown(false),
     VolumeOK(false),
     ConditionMet(false);

// === 計算 EMA ===
EMA20_Value = XAverage(Close, EMA20_Period);
EMA50_Value = XAverage(Close, EMA50_Period);

// === 成交量過濾 ===
VolumeOK = (Volume / 1000) >= MinVolume;  // 轉換為張數

// === Always-In 狀態判斷 ===
if CurrentBarNumber >= 3 then begin
    PrevAIState = AlwaysInState[1];
    TwoBarBreakoutUp = (Close > High[1]) and (Close[1] > High[2]);
    TwoBarBreakoutDown = (Close < Low[1]) and (Close[1] < Low[2]);
    
    if TwoBarBreakoutUp and (Close > EMA50_Value) then
        AlwaysInState = 1
    else if TwoBarBreakoutDown and (Close < EMA50_Value) then
        AlwaysInState = -1
    else if (PrevAIState = 1) and (Close < EMA50_Value) then
        AlwaysInState = 0
    else if (PrevAIState = -1) and (Close > EMA50_Value) then
        AlwaysInState = 0
    else
        AlwaysInState = PrevAIState;
end
else
    AlwaysInState = 0;

// === 選股條件：Always-In 為空頭 且 成交量達標 ===
ConditionMet = (AlwaysInState = -1) and VolumeOK;

// === 輸出結果 ===
if ConditionMet then
    Ret = 1  // 符合條件
else
    Ret = 0;  // 不符合

// === 輸出數值供排序 ===
OutputField(1, AlwaysInState, "Always-In State");
OutputField(2, EMA20_Value, "EMA20");
OutputField(3, EMA50_Value, "EMA50");
OutputField(4, Volume / 1000, "Volume (Lots)");

