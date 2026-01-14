// ===================================================================
// 腳本名稱：Brooks 趨勢日選股
// 腳本類型：選股（Screener）
// 功能描述：篩選強趨勢日（低重疊分數）
// 資料週期：5分鐘（建議）
// 作者：PriceActions Project
// 建立日期：2025-12-09
// 版本：1.0
// ===================================================================
// Description:
//   Screens for strong trend days (low overlap score)
//   Overlap score < 0.25 indicates strong trend
// ===================================================================

// === 參數宣告 ===
settotalbar(250);

input: Window(24, "重疊分數計算窗口"),
       MaxOverlapScore(0.25, "最大重疊分數（趨勢日門檻）"),
       MinVolume(500, "最小成交量(張)");

// === 變數宣告 ===
var: RollingHigh(0),
     RollingLow(0),
     RangeWidth(0),
     RangeMid(0),
     OverlapScore(0),
     VolumeOK(false),
     ConditionMet(false);

// === 成交量過濾 ===
VolumeOK = (Volume / 1000) >= MinVolume;

// === 計算重疊分數 ===
RollingHigh = Highest(High, Window);
RollingLow = Lowest(Low, Window);
RangeWidth = RollingHigh - RollingLow;
RangeMid = (RollingHigh + RollingLow) / 2;

if RangeWidth > 0 then begin
    // 簡化版重疊分數計算
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

// === 選股條件：重疊分數低於門檻（強趨勢日）且成交量達標 ===
ConditionMet = (OverlapScore <= MaxOverlapScore) and VolumeOK;

// === 輸出結果 ===
if ConditionMet then
    Ret = 1  // 符合條件
else
    Ret = 0;  // 不符合

// === 輸出數值供排序 ===
OutputField(1, OverlapScore, "Overlap Score");
OutputField(2, RollingHigh, "Rolling High");
OutputField(3, RollingLow, "Rolling Low");
OutputField(4, Volume / 1000, "Volume (Lots)");

