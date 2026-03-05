// ===================================================================
// 指標名稱：Upside/Downside Volatility (上漲/下跌波動率)
// 腳本類型：指標（Indicator）
// 功能描述：計算並顯示平均上漲和下跌波動率
//           例如：平均上漲波動率 +3%，平均下跌波動率 -3%
// 資料週期：日線（建議使用日線圖表）
// 作者：Auto
// 建立日期：2025-01-XX
// 版本：1.0
// ===================================================================

{@type:indicator}

// === 參數設定 ===
settotalbar(250);

// --- 波動率計算參數 ---
input: Period(20, "計算週期");

// === 變數宣告 ===
var: DailyHigh(0),              // 當日最高價
     DailyLow(0),                // 當日最低價
     DailyOpen(0),               // 當日開盤價
     DailyClose(0),              // 當日收盤價
     
     // 當日波動
     UpsideMove(0),               // 上漲幅度（高點 - 開盤）
     DownsideMove(0),            // 下跌幅度（開盤 - 低點）
     UpsideMovePct(0),           // 上漲幅度百分比
     DownsideMovePct(0),         // 下跌幅度百分比
     
     // 平均波動率
     AvgUpsidePct(0),            // 平均上漲百分比
     AvgDownsidePct(0),          // 平均下跌百分比
     AvgUpsideAbsolute(0),       // 平均上漲絕對值
     AvgDownsideAbsolute(0),     // 平均下跌絕對值
     
     // 淨波動（收盤 - 開盤）
     NetMove(0),                 // 淨波動
     NetMovePct(0),              // 淨波動百分比
     AvgPositiveMovePct(0),     // 平均正波動百分比
     AvgNegativeMovePct(0);      // 平均負波動百分比

// ===================================================================
// 取得日線資料
// ===================================================================
if barfreq = "Day" then begin
    DailyHigh = High;
    DailyLow = Low;
    DailyOpen = Open;
    DailyClose = Close;
end
else begin
    DailyHigh = GetField("High", "D");
    DailyLow = GetField("Low", "D");
    DailyOpen = GetField("Open", "D");
    DailyClose = GetField("Close", "D");
end;

// ===================================================================
// 計算當日波動
// ===================================================================
// 上漲幅度：當日最高價 - 開盤價
UpsideMove = DailyHigh - DailyOpen;

// 下跌幅度：開盤價 - 當日最低價
DownsideMove = DailyOpen - DailyLow;

// 計算百分比
if DailyOpen > 0 then begin
    UpsideMovePct = (UpsideMove / DailyOpen) * 100;
    DownsideMovePct = (DownsideMove / DailyOpen) * 100;
end
else begin
    UpsideMovePct = 0;
    DownsideMovePct = 0;
end;

// 淨波動（收盤 - 開盤）
NetMove = DailyClose - DailyOpen;
if DailyOpen > 0 then
    NetMovePct = (NetMove / DailyOpen) * 100
else
    NetMovePct = 0;

// ===================================================================
// 計算平均波動率（過去 N 日）
// ===================================================================
// 平均上漲幅度（從開盤到高點）
AvgUpsideAbsolute = Average(UpsideMove, Period);
AvgUpsidePct = Average(UpsideMovePct, Period);

// 平均下跌幅度（從開盤到低點）
AvgDownsideAbsolute = Average(DownsideMove, Period);
AvgDownsidePct = Average(DownsideMovePct, Period);

// ===================================================================
// 繪製指標
// ===================================================================
// Plot 1-2: 平均上漲/下跌波動率（百分比）
plot1(AvgUpsidePct, "平均上漲波動率 (%)");
plot2(AvgDownsidePct, "平均下跌波動率 (%)");

// Plot 3-4: 當日上漲/下跌波動率
plot3(UpsideMovePct, "當日上漲波動率 (%)");
plot4(DownsideMovePct, "當日下跌波動率 (%)");

// Plot 5-6: 平均絕對值
plot5(AvgUpsideAbsolute, "平均上漲波動 (絕對值)");
plot6(AvgDownsideAbsolute, "平均下跌波動 (絕對值)");

// Plot 7: 淨波動
plot7(NetMovePct, "淨波動 (%)");








