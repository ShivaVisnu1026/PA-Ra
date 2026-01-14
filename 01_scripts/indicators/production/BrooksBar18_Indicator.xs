// ===================================================================
// 腳本名稱：Brooks Bar-18 指標
// 腳本類型：指標（Indicator）
// 功能描述：Bar-18 標記（早盤極值檢測）
// 資料週期：5分鐘（建議）
// 作者：PriceActions Project
// 建立日期：2025-12-09
// 版本：1.0
// ===================================================================
// Description:
//   Brooks heuristic: by bar 18, the day usually prints its high or low
//   Flags when morning extremes hold as day extremes
// ===================================================================

{@type:indicator}

// === 參數宣告 ===
settotalbar(250);

input: StartBar(16, "開始K棒（Bar 16）"),
       EndBar(20, "結束K棒（Bar 20）");

// === 變數宣告 ===
var: HighAtBar18(0),
     LowAtBar18(0),
     CurrentDayHigh(0),
     CurrentDayLow(0),
     HighStillHolds(false),
     LowStillHolds(false),
     Bar18Flag(0);

// === 計算 Bar-18 標記 ===
if CurrentBarNumber >= EndBar then begin
    // === 計算 Bar 16-20 的極值 ===
    HighAtBar18 = Highest(High[EndBar - StartBar], EndBar - StartBar + 1);
    LowAtBar18 = Lowest(Low[EndBar - StartBar], EndBar - StartBar + 1);
    
    // === 計算當前日內極值 ===
    CurrentDayHigh = Highest(High, CurrentBarNumber);
    CurrentDayLow = Lowest(Low, CurrentBarNumber);
    
    // === 檢查早盤極值是否仍為日內極值 ===
    // 允許小的浮點誤差（0.01）
    if AbsValue(HighAtBar18 - CurrentDayHigh) < 0.01 then
        HighStillHolds = true
    else
        HighStillHolds = false;
    
    if AbsValue(LowAtBar18 - CurrentDayLow) < 0.01 then
        LowStillHolds = true
    else
        LowStillHolds = false;
    
    // === 設定標記 ===
    if HighStillHolds or LowStillHolds then
        Bar18Flag = 1
    else
        Bar18Flag = 0;
end
else
    Bar18Flag = 0;  // K棒不足，無法判斷

// === 繪製指標 ===
// 繪製 Bar-18 高點和低點
plot1(HighAtBar18, "Bar18 High", Red);
plot2(LowAtBar18, "Bar18 Low", Blue);

// 繪製當前日內極值
plot3(CurrentDayHigh, "Current Day High", Magenta);
plot4(CurrentDayLow, "Current Day Low", Cyan);

// 標記 Bar-18 標記狀態
if Bar18Flag = 1 then
    plot5(Close, "Bar18 Flag Active", Yellow);

// === 輸出欄位 ===
OutputField(1, Bar18Flag, "Bar18 Flag");
OutputField(2, HighAtBar18, "Bar18 High");
OutputField(3, LowAtBar18, "Bar18 Low");
OutputField(4, HighStillHolds, "High Still Holds");
OutputField(5, LowStillHolds, "Low Still Holds");

