// ===================================================================
// 腳本名稱：Brooks 開盤區間突破選股
// 腳本類型：選股（Screener）
// 功能描述：篩選突破開盤區間的股票
// 資料週期：5分鐘（建議）
// 作者：PriceActions Project
// 建立日期：2025-12-09
// 版本：1.0
// ===================================================================
// Description:
//   Screens for stocks breaking out of opening range
//   Detects upward or downward breakouts
// ===================================================================

// === 參數宣告 ===
settotalbar(250);

input: OR_Bars(6, "開盤區間K棒數"),
       MinVolume(500, "最小成交量(張)"),
       BreakoutDirection(0, "突破方向（1=向上, -1=向下, 0=雙向）");

// === 變數宣告 ===
var: OR_High(0),
     OR_Low(0),
     OR_Mid(0),
     BreakoutUp(false),
     BreakoutDown(false),
     VolumeOK(false),
     ConditionMet(false);

// === 成交量過濾 ===
VolumeOK = (Volume / 1000) >= MinVolume;

// === 計算開盤區間 ===
if CurrentBarNumber >= OR_Bars then begin
    OR_High = Highest(High[OR_Bars - 1], OR_Bars);
    OR_Low = Lowest(Low[OR_Bars - 1], OR_Bars);
    OR_Mid = (OR_High + OR_Low) / 2;
    
    // === 突破判斷 ===
    BreakoutUp = Close > OR_High;
    BreakoutDown = Close < OR_Low;
    
    // === 根據方向參數判斷條件 ===
    if BreakoutDirection = 1 then
        // 只選向上突破
        ConditionMet = BreakoutUp and VolumeOK
    else if BreakoutDirection = -1 then
        // 只選向下突破
        ConditionMet = BreakoutDown and VolumeOK
    else
        // 雙向突破
        ConditionMet = (BreakoutUp or BreakoutDown) and VolumeOK;
end
else
    ConditionMet = false;

// === 輸出結果 ===
if ConditionMet then
    Ret = 1  // 符合條件
else
    Ret = 0;  // 不符合

// === 輸出數值供排序 ===
OutputField(1, OR_High, "OR High");
OutputField(2, OR_Low, "OR Low");
OutputField(3, OR_Mid, "OR Mid");
OutputField(4, Close, "Current Price");
OutputField(5, Volume / 1000, "Volume (Lots)");
if BreakoutUp then
    OutputField(6, 1, "Breakout Direction")
else if BreakoutDown then
    OutputField(6, -1, "Breakout Direction")
else
    OutputField(6, 0, "Breakout Direction");

