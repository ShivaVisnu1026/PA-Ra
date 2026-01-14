// ===================================================================
// 腳本名稱：Brooks 趨勢回調警示
// 腳本類型：警示（Alert）
// 功能描述：當 Always-In 趨勢中出現回調至開盤區間邊緣時觸發警示
// 資料週期：5分鐘（建議）
// 作者：PriceActions Project
// 建立日期：2025-12-09
// 版本：1.0
// ===================================================================
// Description:
//   Alerts on trend pullback setups off opening range edges
//   Combines Always-In state with opening range position
// ===================================================================

// === 參數宣告 ===
settotalbar(250);

input: EMA20_Period(20, "EMA20 週期"),
       EMA50_Period(50, "EMA50 週期"),
       OR_Bars(6, "開盤區間K棒數"),
       PullbackThreshold(0.25, "回調門檻（OR範圍的百分比）");

// === 變數宣告 ===
var: EMA50_Value(0),
     AlwaysInState(0),
     PrevAIState(0),
     TwoBarBreakoutUp(false),
     TwoBarBreakoutDown(false),
     OR_High(0),
     OR_Low(0),
     OR_Range(0),
     DistanceToORHigh(0),
     DistanceToORLow(0),
     PullbackToORHigh(false),
     PullbackToORLow(false),
     intrabarpersist AlertTriggeredBull(false),
     intrabarpersist AlertTriggeredBear(false);

// === 計算 Always-In ===
EMA50_Value = XAverage(Close, EMA50_Period);

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

// === 計算開盤區間 ===
if CurrentBarNumber >= OR_Bars then begin
    OR_High = Highest(High[OR_Bars - 1], OR_Bars);
    OR_Low = Lowest(Low[OR_Bars - 1], OR_Bars);
    OR_Range = OR_High - OR_Low;
    
    if OR_Range > 0 then begin
        // 計算距離開盤區間邊緣的距離
        DistanceToORHigh = AbsValue(Close - OR_High);
        DistanceToORLow = AbsValue(Close - OR_Low);
        
        // 判斷是否回調至開盤區間邊緣（25%範圍內）
        PullbackToORHigh = (DistanceToORHigh <= PullbackThreshold * OR_Range) and (Close > OR_High);
        PullbackToORLow = (DistanceToORLow <= PullbackThreshold * OR_Range) and (Close < OR_Low);
        
        // === 多頭趨勢回調警示 ===
        // Always-In 多頭 + 價格突破OR高點後回調至OR高點附近
        if (AlwaysInState = 1) and PullbackToORHigh and not AlertTriggeredBull then begin
            Alert("多頭趨勢回調至開盤區間高點！價格: " + Text(Close) + ", OR High: " + Text(OR_High));
            AlertTriggeredBull = true;
        end;
        
        // === 空頭趨勢回調警示 ===
        // Always-In 空頭 + 價格跌破OR低點後回調至OR低點附近
        if (AlwaysInState = -1) and PullbackToORLow and not AlertTriggeredBear then begin
            Alert("空頭趨勢回調至開盤區間低點！價格: " + Text(Close) + ", OR Low: " + Text(OR_Low));
            AlertTriggeredBear = true;
        end;
    end;
end;

// === 重置機制 ===
if (AlwaysInState <> 1) or not PullbackToORHigh then
    AlertTriggeredBull = false;
if (AlwaysInState <> -1) or not PullbackToORLow then
    AlertTriggeredBear = false;

