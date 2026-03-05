// ===================================================================
// 指標名稱：ADR Indicator (平均每日波動範圍指標)
// 腳本類型：指標（Indicator）
// 功能描述：計算並顯示平均每日波動範圍（ADR）及其百分比
// 資料週期：日線（建議使用日線圖表）
// 作者：Auto
// 建立日期：2025-01-XX
// 版本：1.0
// ===================================================================

{@type:indicator}

// === 參數設定 ===
settotalbar(250);

// --- ADR 參數 ---
input: ADR_Period(20, "ADR 計算週期");

// === 變數宣告 ===
var: DailyHigh(0),              // 當日最高價
     DailyLow(0),                // 當日最低價
     DailyClose(0),              // 當日收盤價
     DailyRange(0),              // 當日波動範圍
     ADR_Absolute(0),            // ADR 絕對值
     ADR_Percentage(0),          // ADR 百分比
     CurrentRange(0),             // 當前範圍
     CurrentRangePct(0),         // 當前範圍百分比
     ADR_Ratio(0),               // 當前範圍 / ADR 比率
     AvgClosePrice(0);          // 平均收盤價

// ===================================================================
// 取得日線資料
// ===================================================================
if barfreq = "Day" then begin
    DailyHigh = High;
    DailyLow = Low;
    DailyClose = Close;
end
else begin
    DailyHigh = GetField("High", "D");
    DailyLow = GetField("Low", "D");
    DailyClose = GetField("Close", "D");
end;

// ===================================================================
// 計算當日波動範圍
// ===================================================================
DailyRange = DailyHigh - DailyLow;
CurrentRange = DailyRange;
if DailyClose > 0 then
    CurrentRangePct = (CurrentRange / DailyClose) * 100
else
    CurrentRangePct = 0;

// ===================================================================
// 計算 ADR
// ===================================================================
// ADR = 過去 N 日的平均波動範圍
ADR_Absolute = Average(DailyRange, ADR_Period);
AvgClosePrice = Average(DailyClose, ADR_Period);
if AvgClosePrice > 0 then
    ADR_Percentage = (ADR_Absolute / AvgClosePrice) * 100
else
    ADR_Percentage = 0;

// ADR 比率：當日範圍相對於 ADR 的倍數
if ADR_Absolute > 0 then
    ADR_Ratio = CurrentRange / ADR_Absolute
else
    ADR_Ratio = 0;

// ===================================================================
// 繪製指標
// ===================================================================
plot1(ADR_Absolute, "ADR (絕對值)");
plot2(ADR_Percentage, "ADR (%)");
plot3(CurrentRange, "當日範圍");
plot4(CurrentRangePct, "當日範圍 (%)");
plot5(ADR_Ratio, "ADR 比率");








