{@type:sensor}
// 5分K 空方策略：
// - 僅保留空方邏輯
// - 5分K頻率
// - 加入「日頻率」股價與5MA乖離率 > 門檻（不取絕對值，須為正值）

// { Inputs }
settotalBar(1000);
input: diff_limit(50, "最大價差"),
       ma_long_len(240, "長均線期數"),
       day_ma_len(5, "日MA期數"),
       day_dev_thresh(5.0, "日乖離門檻(%)");

// 僅允許5分K
if barfreq <> "Min" or barinterval <> 5 then
    raiseruntimeerror("請設定為 5 分鐘K棒");

// { Vars }
var: ma_long(0), trigger_short(false);
var: price_diff(0);
var: day_close(0), day_close_sync(0), day_ma(0), day_dev(0);

// === 計算長均線（以5分K計） ===
ma_long = average(close, ma_long_len);

// === 計算價格差距 ===
price_diff = absvalue(close - ma_long);

// === 日頻率條件：股價與5MA乖離率（須為正且 > 門檻） ===
day_close = GetField("Close", "D");
// 方式二：先用 xf_GetValue 將日頻率值對齊到 5 分，再用 Average 計算
day_close_sync = xf_GetValue("D", day_close, 0);
day_ma         = Average(day_close_sync, day_ma_len);
if day_ma <> 0 then
    day_dev = (day_close - day_ma) / day_ma * 100;

// === 空方邏輯 ===
trigger_short = 
    ma_long < ma_long[1] and                            // 均線遞減
    close < ma_long and price_diff <= diff_limit and    // 股價 < 均線且在允許價差內
    close < open and                                    // 收黑
    absvalue(close - open) > absvalue(low - close) and  // 實體 > 下影線
    (day_dev > day_dev_thresh);                         // 日乖離%為正且大於門檻

// === 畫出訊號 ===
if trigger_short then
begin
    RetMsg = Text("Short | 日乖離% = ", NumToStr(day_dev, 2));
    ret = 1;
end;


