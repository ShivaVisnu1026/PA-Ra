// ===================================================================
// 函數名稱：BrooksOverlapScore
// 功能描述：計算 Al Brooks 重疊分數（交易區間 vs 趨勢指標）
// 作者：PriceActions Project
// 建立日期：2025-12-09
// 版本：1.0
// ===================================================================
// Description:
//   Calculates overlap score (0-1) indicating trading range vs trend
//   0 = strong trend day, 1 = strong range day
//   Combines mid-time positioning (70%) and failed breakouts (30%)
// ===================================================================

// === 參數定義 ===
inputs: Window(numericsimple);  // 計算窗口期數，預設 20-24

// === 變數宣告 ===
variables: RollingHigh(0),
           RollingLow(0),
           RangeWidth(0),
           RangeMid(0),
           MidTimeScore(0),
           FailedBreakoutScore(0),
           OverlapScore(0),
           i(0),
           CloseNearMid(0),
           FailedBO_Up(0),
           FailedBO_Down(0);

// === 計算滾動最高最低價 ===
RollingHigh = Highest(High, Window);
RollingLow = Lowest(Low, Window);
RangeWidth = RollingHigh - RollingLow;
RangeMid = (RollingHigh + RollingLow) / 2;

// === 避免除以零 ===
if RangeWidth > 0 then begin
    // === 計算中位時間分數（價格接近區間中位） ===
    // 檢查當前收盤價是否接近區間中位（±20%範圍內）
    CloseNearMid = 0;
    if AbsValue(Close - RangeMid) < (0.2 * RangeWidth) then
        CloseNearMid = 1;
    
    // 計算滾動平均（簡化版：使用當前值）
    MidTimeScore = CloseNearMid;
    
    // === 計算失敗突破分數 ===
    // 向上突破後立即回落的失敗突破
    FailedBO_Up = 0;
    if (Close > RollingHigh[1]) and (Close[1] < RollingHigh[2]) then
        FailedBO_Up = 1;
    
    // 向下突破後立即反彈的失敗突破
    FailedBO_Down = 0;
    if (Close < RollingLow[1]) and (Close[1] > RollingLow[2]) then
        FailedBO_Down = 1;
    
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

// === 返回值 ===
BrooksOverlapScore = OverlapScore;

