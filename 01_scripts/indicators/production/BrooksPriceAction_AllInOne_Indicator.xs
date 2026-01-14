// ===================================================================
// 腳本名稱：Brooks Price Action 全功能指標
// 腳本類型：指標（Indicator）
// 功能描述：整合所有 Brooks 價格行為指標
// 資料週期：5分鐘（建議）
// 作者：PriceActions Project
// 建立日期：2025-12-09
// 版本：1.0
// ===================================================================
// Description:
//   Comprehensive indicator combining all Brooks price action metrics:
//   - Always-In direction
//   - Overlap score
//   - Microchannel lengths
//   - Bar-18 flag
//   - Opening range
// ===================================================================

{@type:indicator}

// === 參數宣告 ===
settotalbar(250);

input: EMA20_Period(20, "EMA20 週期"),
       EMA50_Period(50, "EMA50 週期"),
       OverlapWindow(24, "重疊分數計算窗口"),
       OR_Bars(6, "開盤區間K棒數"),
       Bar18_Start(16, "Bar-18 開始K棒"),
       Bar18_End(20, "Bar-18 結束K棒");

// === Always-In 變數 ===
var: EMA20_Value(0),
     EMA50_Value(0),
     AlwaysInState(0),
     TwoBarBreakoutUp(false),
     TwoBarBreakoutDown(false),
     PrevAIState(0);

// === Overlap Score 變數 ===
var: RollingHigh(0),
     RollingLow(0),
     RangeWidth(0),
     RangeMid(0),
     OverlapScore(0);

// === Microchannel 變數 ===
var: BullRunLength(0),
     BearRunLength(0);

// === Bar-18 變數 ===
var: HighAtBar18(0),
     LowAtBar18(0),
     Bar18Flag(0);

// === Opening Range 變數 ===
var: OR_High(0),
     OR_Low(0),
     OR_Mid(0);

// === 計算 Always-In ===
EMA20_Value = XAverage(Close, EMA20_Period);
EMA50_Value = XAverage(Close, EMA50_Period);

if CurrentBarNumber >= 3 then begin
    TwoBarBreakoutUp = (Close > High[1]) and (Close[1] > High[2]);
    TwoBarBreakoutDown = (Close < Low[1]) and (Close[1] < Low[2]);
    PrevAIState = AlwaysInState[1];
    
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

// === 計算 Overlap Score ===
RollingHigh = Highest(High, OverlapWindow);
RollingLow = Lowest(Low, OverlapWindow);
RangeWidth = RollingHigh - RollingLow;
RangeMid = (RollingHigh + RollingLow) / 2;

if RangeWidth > 0 then begin
    if AbsValue(Close - RangeMid) < (0.2 * RangeWidth) then
        OverlapScore = 0.7
    else
        OverlapScore = 0;
    
    if (Close > RollingHigh[1]) and (Close[1] < RollingHigh[2]) then
        OverlapScore = OverlapScore + 0.3;
    if (Close < RollingLow[1]) and (Close[1] > RollingLow[2]) then
        OverlapScore = OverlapScore + 0.3;
    
    if OverlapScore > 1 then OverlapScore = 1;
    if OverlapScore < 0 then OverlapScore = 0;
end
else
    OverlapScore = 0.5;

// === 計算 Microchannel ===
if CurrentBarNumber > 1 then begin
    if Low > Low[1] then
        BullRunLength = BullRunLength[1] + 1
    else
        BullRunLength = 0;
    
    if High < High[1] then
        BearRunLength = BearRunLength[1] + 1
    else
        BearRunLength = 0;
end
else begin
    BullRunLength = 0;
    BearRunLength = 0;
end;

// === 計算 Bar-18 ===
if CurrentBarNumber >= Bar18_End then begin
    HighAtBar18 = Highest(High[Bar18_End - Bar18_Start], Bar18_End - Bar18_Start + 1);
    LowAtBar18 = Lowest(Low[Bar18_End - Bar18_Start], Bar18_End - Bar18_Start + 1);
    
    if (AbsValue(HighAtBar18 - Highest(High, CurrentBarNumber)) < 0.01) or
       (AbsValue(LowAtBar18 - Lowest(Low, CurrentBarNumber)) < 0.01) then
        Bar18Flag = 1
    else
        Bar18Flag = 0;
end
else
    Bar18Flag = 0;

// === 計算 Opening Range ===
if CurrentBarNumber >= OR_Bars then begin
    OR_High = Highest(High[OR_Bars - 1], OR_Bars);
    OR_Low = Lowest(Low[OR_Bars - 1], OR_Bars);
    OR_Mid = (OR_High + OR_Low) / 2;
end
else begin
    OR_High = High;
    OR_Low = Low;
    OR_Mid = (High + Low) / 2;
end;

// === 繪製指標 ===
// EMA
plot1(EMA20_Value, "EMA20", Cyan);
plot2(EMA50_Value, "EMA50", Magenta);

// Opening Range
plot3(OR_High, "OR High", Red);
plot4(OR_Low, "OR Low", Blue);
plot5(OR_Mid, "OR Mid", Yellow);

// Always-In 狀態標記
if AlwaysInState = 1 then
    plot6(Close, "AI Bull", Green)
else if AlwaysInState = -1 then
    plot6(Close, "AI Bear", Red)
else
    plot6(Close, "AI Neutral", White);

// === 輸出欄位 ===
OutputField(1, AlwaysInState, "Always-In");
OutputField(2, OverlapScore, "Overlap Score");
OutputField(3, BullRunLength, "Bull MC");
OutputField(4, BearRunLength, "Bear MC");
OutputField(5, Bar18Flag, "Bar18 Flag");
OutputField(6, OR_High, "OR High");
OutputField(7, OR_Low, "OR Low");

