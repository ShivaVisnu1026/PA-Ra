// ===================================================================
// 選股名稱：Volatility Screener (波動率選股)
// 腳本類型：選股（Screener）
// 功能描述：根據波動率指標篩選股票
//           可篩選：ADR、ATR、上漲/下跌波動率等條件
// 資料週期：日線（建議使用日線圖表）
// 作者：Auto
// 建立日期：2025-01-XX
// 版本：1.0
// ===================================================================

// === 參數設定 ===
settotalbar(250);

// --- 波動率參數 ---
input: ADR_Period(20, "ADR 計算週期"),
       ATR_Period(14, "ATR 計算週期"),
       UpsideDownside_Period(20, "上漲/下跌波動率計算週期");

// --- 篩選條件參數 ---
input: MinADR_Pct(1.5, "最小 ADR (%)"),
       MaxADR_Pct(5.0, "最大 ADR (%)"),
       MinUpsidePct(2.0, "最小平均上漲波動率 (%)"),
       MaxDownsidePct(-1.5, "最大平均下跌波動率 (%)"),
       ADR_Ratio_Min(0.8, "最小 ADR 比率"),
       ADR_Ratio_Max(1.5, "最大 ADR 比率");

// === 變數宣告 ===
var: DailyHigh(0),              // 當日最高價
     DailyLow(0),                // 當日最低價
     DailyOpen(0),               // 當日開盤價
     DailyClose(0),              // 當日收盤價
     DailyRange(0),              // 當日波動範圍
     PreviousClose(0),           // 前一日收盤價
     
     // ADR 相關
     ADR_Absolute(0),            // ADR 絕對值
     ADR_Percentage(0),          // ADR 百分比
     ADR_Ratio(0),               // ADR 比率
     
     // ATR 相關
     TrueRange(0),               // 真實波動範圍
     ATR_Absolute(0),            // ATR 絕對值
     ATR_Percentage(0),          // ATR 百分比
     
     // 上漲/下跌波動率
     UpsideMove(0),              // 上漲幅度
     DownsideMove(0),            // 下跌幅度
     AvgUpsidePct(0),            // 平均上漲百分比
     AvgDownsidePct(0),          // 平均下跌百分比
     
     // 篩選條件
     ConditionADR(false),        // ADR 條件
     ConditionUpsideDownside(false),  // 上漲/下跌波動率條件
     ConditionADR_Ratio(false);  // ADR 比率條件

// ===================================================================
// 取得日線資料
// ===================================================================
if barfreq = "Day" then begin
    DailyHigh = High;
    DailyLow = Low;
    DailyOpen = Open;
    DailyClose = Close;
    PreviousClose = Close[1];
end
else begin
    DailyHigh = GetField("High", "D");
    DailyLow = GetField("Low", "D");
    DailyOpen = GetField("Open", "D");
    DailyClose = GetField("Close", "D");
    PreviousClose = GetField("Close", "D")[1];
end;

// ===================================================================
// 計算波動率指標
// ===================================================================

// 當日波動範圍
DailyRange = DailyHigh - DailyLow;

// ADR 計算
ADR_Absolute = Average(DailyRange, ADR_Period);
if Average(DailyClose, ADR_Period) > 0 then
    ADR_Percentage = (ADR_Absolute / Average(DailyClose, ADR_Period)) * 100
else
    ADR_Percentage = 0;

// ADR 比率
if ADR_Absolute > 0 then
    ADR_Ratio = DailyRange / ADR_Absolute
else
    ADR_Ratio = 0;

// ATR 計算
TrueRange = MaxList(
    DailyRange,
    AbsValue(DailyHigh - PreviousClose),
    AbsValue(DailyLow - PreviousClose)
);
ATR_Absolute = XAverage(TrueRange, ATR_Period);
if DailyClose > 0 then
    ATR_Percentage = (ATR_Absolute / DailyClose) * 100
else
    ATR_Percentage = 0;

// 上漲/下跌波動率計算
UpsideMove = DailyHigh - DailyOpen;
DownsideMove = DailyOpen - DailyLow;
if DailyOpen > 0 then begin
    AvgUpsidePct = Average((UpsideMove / DailyOpen) * 100, UpsideDownside_Period);
    AvgDownsidePct = Average((DownsideMove / DailyOpen) * 100, UpsideDownside_Period);
end
else begin
    AvgUpsidePct = 0;
    AvgDownsidePct = 0;
end;

// ===================================================================
// 篩選條件判斷
// ===================================================================

// 條件1：ADR 百分比在指定範圍內
ConditionADR = (ADR_Percentage >= MinADR_Pct) and (ADR_Percentage <= MaxADR_Pct);

// 條件2：上漲/下跌波動率條件
ConditionUpsideDownside = (AvgUpsidePct >= MinUpsidePct) and (AvgDownsidePct <= MaxDownsidePct);

// 條件3：ADR 比率在指定範圍內
ConditionADR_Ratio = (ADR_Ratio >= ADR_Ratio_Min) and (ADR_Ratio <= ADR_Ratio_Max);

// ===================================================================
// 輸出結果
// ===================================================================
if ConditionADR and ConditionUpsideDownside and ConditionADR_Ratio then
    Ret = 1  // 符合條件
else
    Ret = 0;  // 不符合條件

// ===================================================================
// 輸出欄位（可選，用於顯示數值）
// ===================================================================
OutputField(1, ADR_Percentage, "ADR (%)");
OutputField(2, AvgUpsidePct, "平均上漲波動率 (%)");
OutputField(3, AvgDownsidePct, "平均下跌波動率 (%)");
OutputField(4, ADR_Ratio, "ADR 比率");
OutputField(5, ATR_Percentage, "ATR (%)");








