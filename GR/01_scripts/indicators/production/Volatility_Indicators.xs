// ===================================================================
// 指標名稱：Volatility Indicators (波動率指標)
// 腳本類型：指標（Indicator）
// 功能描述：計算平均每日波動範圍（ADR）、平均真實波動範圍（ATR）、
//          以及平均上漲/下跌波動率
// 資料週期：日線（建議使用日線圖表）
// 作者：Auto
// 建立日期：2025-01-XX
// 版本：1.0
// ===================================================================

{@type:indicator}

// === 參數設定 ===
settotalbar(250);

// --- 波動率計算參數 ---
input: ADR_Period(20, "ADR 計算週期"),
       ATR_Period(14, "ATR 計算週期"),
       UpsideDownside_Period(20, "上漲/下跌波動率計算週期");

// === 變數宣告 ===
var: DailyHigh(0),              // 當日最高價
     DailyLow(0),                // 當日最低價
     DailyOpen(0),               // 當日開盤價
     DailyClose(0),              // 當日收盤價
     DailyRange(0),               // 當日波動範圍
     DailyRangePct(0),           // 當日波動範圍百分比
     
     // ADR 相關
     ADR_Absolute(0),             // ADR 絕對值
     ADR_Percentage(0),           // ADR 百分比
     ADR_Ratio(0),                // 當日範圍 / ADR 比率
     
     // ATR 相關
     TrueRange(0),                // 真實波動範圍
     ATR_Absolute(0),             // ATR 絕對值
     ATR_Percentage(0),           // ATR 百分比
     
     // 上漲/下跌波動率
     UpsideMove(0),               // 上漲幅度（高點 - 開盤）
     DownsideMove(0),             // 下跌幅度（開盤 - 低點）
     AvgUpsidePct(0),             // 平均上漲百分比
     AvgDownsidePct(0),           // 平均下跌百分比
     
     // 輔助變數
     PreviousClose(0),            // 前一日收盤價
     AvgClosePrice(0);             // 平均收盤價

// ===================================================================
// 取得日線資料（如果當前是日線圖，直接使用；否則使用 GetField）
// ===================================================================
if barfreq = "Day" then begin
    // 日線圖：直接使用當前 K 棒資料
    DailyHigh = High;
    DailyLow = Low;
    DailyOpen = Open;
    DailyClose = Close;
    PreviousClose = Close[1];
end
else begin
    // 非日線圖：使用 GetField 取得日線資料
    DailyHigh = GetField("High", "D");
    DailyLow = GetField("Low", "D");
    DailyOpen = GetField("Open", "D");
    DailyClose = GetField("Close", "D");
    PreviousClose = GetField("Close", "D")[1];
end;

// ===================================================================
// 計算當日波動範圍
// ===================================================================
DailyRange = DailyHigh - DailyLow;
if DailyClose > 0 then
    DailyRangePct = (DailyRange / DailyClose) * 100
else
    DailyRangePct = 0;

// ===================================================================
// 計算 ADR (Average Daily Range) - 平均每日波動範圍
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
    ADR_Ratio = DailyRange / ADR_Absolute
else
    ADR_Ratio = 0;

// ===================================================================
// 計算 ATR (Average True Range) - 平均真實波動範圍
// ===================================================================
// True Range = Max of:
//   1. Current High - Current Low
//   2. |Current High - Previous Close|
//   3. |Current Low - Previous Close|
TrueRange = MaxList(
    DailyRange,
    AbsValue(DailyHigh - PreviousClose),
    AbsValue(DailyLow - PreviousClose)
);

// ATR 使用指數移動平均（Wilder's smoothing）
ATR_Absolute = XAverage(TrueRange, ATR_Period);
if DailyClose > 0 then
    ATR_Percentage = (ATR_Absolute / DailyClose) * 100
else
    ATR_Percentage = 0;

// ===================================================================
// 計算平均上漲/下跌波動率
// ===================================================================
// 上漲幅度：當日最高價 - 開盤價
UpsideMove = DailyHigh - DailyOpen;

// 下跌幅度：開盤價 - 當日最低價
DownsideMove = DailyOpen - DailyLow;

// 計算平均上漲百分比（過去 N 日的平均）
if DailyOpen > 0 then begin
    AvgUpsidePct = Average((UpsideMove / DailyOpen) * 100, UpsideDownside_Period);
    AvgDownsidePct = Average((DownsideMove / DailyOpen) * 100, UpsideDownside_Period);
end
else begin
    AvgUpsidePct = 0;
    AvgDownsidePct = 0;
end;

// ===================================================================
// 繪製指標
// ===================================================================
// Plot 1-2: ADR 相關
plot1(ADR_Absolute, "ADR (絕對值)");
plot2(ADR_Percentage, "ADR (%)");

// Plot 3-4: ATR 相關
plot3(ATR_Absolute, "ATR (絕對值)");
plot4(ATR_Percentage, "ATR (%)");

// Plot 5-6: 當日範圍
plot5(DailyRange, "當日範圍");
plot6(DailyRangePct, "當日範圍 (%)");

// Plot 7-8: 上漲/下跌波動率
plot7(AvgUpsidePct, "平均上漲波動率 (%)");
plot8(AvgDownsidePct, "平均下跌波動率 (%)");

// Plot 9: ADR 比率
plot9(ADR_Ratio, "ADR 比率");








