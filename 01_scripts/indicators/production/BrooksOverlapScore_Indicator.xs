// ===================================================================
// 腳本名稱：Brooks Overlap Score 指標
// 腳本類型：指標（Indicator）
// 功能描述：顯示重疊分數（交易區間 vs 趨勢指標）
// 資料週期：5分鐘（建議）
// 作者：PriceActions Project
// 建立日期：2025-12-09
// 版本：1.0
// ===================================================================
// Description:
//   Displays overlap score (0-1) indicating trading range vs trend
//   0 = strong trend day, 1 = strong range day
// ===================================================================

{@type:indicator}

// === 參數宣告 ===
settotalbar(250);

input: Window(24, "計算窗口期數");

// === 變數宣告 ===
var: RollingHigh(0),
     RollingLow(0),
     RangeWidth(0),
     RangeMid(0),
     CloseNearMid(0),
     FailedBO_Up(0),
     FailedBO_Down(0),
     MidTimeScore(0),
     FailedBreakoutScore(0),
     OverlapScore(0);

// === 計算滾動最高最低價 ===
RollingHigh = Highest(High, Window);
RollingLow = Lowest(Low, Window);
RangeWidth = RollingHigh - RollingLow;
RangeMid = (RollingHigh + RollingLow) / 2;

// === 避免除以零 ===
if RangeWidth > 0 then begin
    // === 計算中位時間分數 ===
    // 檢查當前收盤價是否接近區間中位（±20%範圍內）
    if AbsValue(Close - RangeMid) < (0.2 * RangeWidth) then
        CloseNearMid = 1
    else
        CloseNearMid = 0;
    
    MidTimeScore = CloseNearMid;
    
    // === 計算失敗突破分數 ===
    // 向上突破後立即回落的失敗突破
    if (Close > RollingHigh[1]) and (Close[1] < RollingHigh[2]) then
        FailedBO_Up = 1
    else
        FailedBO_Up = 0;
    
    // 向下突破後立即反彈的失敗突破
    if (Close < RollingLow[1]) and (Close[1] > RollingLow[2]) then
        FailedBO_Down = 1
    else
        FailedBO_Down = 0;
    
    FailedBreakoutScore = FailedBO_Up + FailedBO_Down;
    
    // === 組合分數：70% 中位時間 + 30% 失敗突破 ===
    OverlapScore = (0.7 * MidTimeScore) + (0.3 * FailedBreakoutScore);
    
    // === 限制在 0-1 範圍 ===
    if OverlapScore > 1 then
        OverlapScore = 1;
    if OverlapScore < 0 then
        OverlapScore = 0;
end
else
    OverlapScore = 0.5;  // 預設值

// === 繪製指標 ===
// 繪製重疊分數（0-1 範圍）
plot1(OverlapScore, "Overlap Score");

// 繪製參考線
plot2(0.75, "Strong Range", Red);
plot3(0.25, "Strong Trend", Green);
plot4(0.5, "Neutral", Yellow);

// === 輸出欄位 ===
OutputField(1, OverlapScore, "Overlap Score");
OutputField(2, RollingHigh, "Rolling High");
OutputField(3, RollingLow, "Rolling Low");
OutputField(4, RangeMid, "Range Mid");

