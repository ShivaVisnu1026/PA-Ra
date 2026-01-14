// ===================================================================
// 腳本名稱：Brooks Opening Range 指標
// 腳本類型：指標（Indicator）
// 功能描述：顯示開盤區間（Opening Range）的高、低、中位
// 資料週期：5分鐘（建議）
// 作者：PriceActions Project
// 建立日期：2025-12-09
// 版本：1.0
// ===================================================================
// Description:
//   Displays opening range (first 6 bars = 30 minutes) high, low, mid
//   Shows breakout levels and price position relative to OR
// ===================================================================

{@type:indicator}

// === 參數宣告 ===
settotalbar(250);

input: OR_Bars(6, "開盤區間K棒數（預設6，即前30分鐘）");

// === 變數宣告 ===
var: OR_High(0),
     OR_Low(0),
     OR_Mid(0),
     PriceStatus(0);  // 1=Above, 0=Inside, -1=Below

// === 計算開盤區間 ===
if CurrentBarNumber >= OR_Bars then begin
    // === 計算開盤區間的最高最低價 ===
    OR_High = Highest(High[OR_Bars - 1], OR_Bars);
    OR_Low = Lowest(Low[OR_Bars - 1], OR_Bars);
    
    // === 計算中位價 ===
    OR_Mid = (OR_High + OR_Low) / 2;
    
    // === 判斷當前價格位置 ===
    if Close > OR_High then
        PriceStatus = 1  // Above OR
    else if Close < OR_Low then
        PriceStatus = -1  // Below OR
    else
        PriceStatus = 0;  // Inside OR
end
else begin
    // K棒不足時使用當前K棒的範圍
    OR_High = High;
    OR_Low = Low;
    OR_Mid = (High + Low) / 2;
    PriceStatus = 0;
end;

// === 繪製指標 ===
// 繪製開盤區間高、低、中位
plot1(OR_High, "OR High", Red);
plot2(OR_Low, "OR Low", Blue);
plot3(OR_Mid, "OR Mid", Yellow);

// 根據價格位置標記
if PriceStatus = 1 then
    plot4(Close, "Above OR", Green)
else if PriceStatus = -1 then
    plot4(Close, "Below OR", Red)
else
    plot4(Close, "Inside OR", White);

// === 輸出欄位 ===
OutputField(1, OR_High, "OR High");
OutputField(2, OR_Low, "OR Low");
OutputField(3, OR_Mid, "OR Mid");
OutputField(4, PriceStatus, "Price Status");

