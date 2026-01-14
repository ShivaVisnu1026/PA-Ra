// ===================================================================
// 函數名稱：BrooksOpeningRange
// 功能描述：計算開盤區間（Opening Range）的高、低、中位
// 作者：PriceActions Project
// 建立日期：2025-12-09
// 版本：1.0
// ===================================================================
// Description:
//   Calculates opening range (first 6 bars = 30 minutes) high, low, mid
//   Returns: OR_High, OR_Low, OR_Mid
//   Note: XQScript functions can only return one value
// ===================================================================

// === 參數定義 ===
inputs: OR_Bars(numericsimple);  // 開盤區間K棒數（預設 6，即前30分鐘）

// === 變數宣告 ===
variables: OR_High(0),
           OR_Low(0),
           OR_Mid(0);

// === 檢查是否有足夠的K棒 ===
if CurrentBarNumber >= OR_Bars then begin
    // === 計算開盤區間的最高最低價 ===
    OR_High = Highest(High[OR_Bars - 1], OR_Bars);
    OR_Low = Lowest(Low[OR_Bars - 1], OR_Bars);
    
    // === 計算中位價 ===
    OR_Mid = (OR_High + OR_Low) / 2;
end
else begin
    // K棒不足時使用當前K棒的範圍
    OR_High = High;
    OR_Low = Low;
    OR_Mid = (High + Low) / 2;
end;

// === 返回值（返回中位價） ===
// 注意：由於 XQScript 限制，此函數只返回中位價
// 高價和低價需要在調用腳本中通過變數 OR_High 和 OR_Low 取得
BrooksOpeningRange = OR_Mid;

// === 說明 ===
// 由於 XQScript 函數只能返回一個值，此函數返回中位價
// 建議在指標/警示/選股腳本中直接實現此邏輯以獲得所有值

