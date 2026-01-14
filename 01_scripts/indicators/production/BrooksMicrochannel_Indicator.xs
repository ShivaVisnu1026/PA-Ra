// ===================================================================
// 腳本名稱：Brooks Microchannel 指標
// 腳本類型：指標（Indicator）
// 功能描述：顯示微通道長度（連續更高低點或更低高點）
// 資料週期：5分鐘（建議）
// 作者：PriceActions Project
// 建立日期：2025-12-09
// 版本：1.0
// ===================================================================
// Description:
//   Displays microchannel lengths (consecutive higher lows or lower highs)
//   Identifies trend persistence and exhaustion patterns
// ===================================================================

{@type:indicator}

// === 參數宣告 ===
settotalbar(250);

// === 變數宣告 ===
var: BullRunLength(0),
     BearRunLength(0),
     PrevBullRun(0),
     PrevBearRun(0);

// === 計算微通道長度 ===
if CurrentBarNumber > 1 then begin
    PrevBullRun = BullRunLength[1];
    PrevBearRun = BearRunLength[1];
    
    // === 計算多頭微通道長度（連續更高低點） ===
    if Low > Low[1] then
        BullRunLength = PrevBullRun + 1
    else
        BullRunLength = 0;
    
    // === 計算空頭微通道長度（連續更低高點） ===
    if High < High[1] then
        BearRunLength = PrevBearRun + 1
    else
        BearRunLength = 0;
end
else begin
    BullRunLength = 0;
    BearRunLength = 0;
end;

// === 繪製指標 ===
// 繪製多頭微通道長度
plot1(BullRunLength, "Bull Microchannel", Green);

// 繪製空頭微通道長度
plot2(BearRunLength, "Bear Microchannel", Red);

// 繪製參考線（微通道耗盡警告：≥6）
plot3(6, "Exhaustion Level", Yellow);

// === 輸出欄位 ===
OutputField(1, BullRunLength, "Bull MC Length");
OutputField(2, BearRunLength, "Bear MC Length");

