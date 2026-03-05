{@type:sensor}
// 15分 漲多拉回 放空訊號（警示腳本）
// 條件：
// 1) 短區間（15分K）：當前量 > 前N根平均量、黑K、且向下跌破5MA
// 2) 長區間（日K）：價格與5MA的乖離率 > 門檻（正值）

// ===== 參數 =====
settotalbar(600);
input: short_ma_len(5, "短均線期數(分K)"),
       vol_lookback(5, "分K平均量回看根數"),
       vol_mult(1.2, "量增倍數"),
       day_ma_len(5, "日MA期數"),
       day_dev_thresh(5.0, "日乖離門檻(%)"),
       k_len(9, "K計算期數"),
       k_smooth(3, "K平滑期數"),
       d_smooth(3, "D平滑期數"),
       k_threshold(80, "K門檻");

// 僅允許 15 分K（測試不同頻率時暫時關閉）
// if barfreq <> "Min" or barinterval <> 15 then
//     raiseruntimeerror("請設定為 15 分鐘K棒");

// ===== 分K邏輯 =====
var: ma_short(0), avg_vol(0), is_cross_down(false), shot_ok(false);
var: rsv_val(0), k_val(0), d_val(0);

ma_short = Average(close, short_ma_len);
// 前N根平均量（不含當根）
avg_vol  = Average(volume[1], vol_lookback);
is_cross_down = (close < ma_short and close[1] >= ma_short[1]);

// KD 指標
value1 = Stochastic(k_len, k_smooth, d_smooth, rsv_val, k_val, d_val);

// 黑K + 量增(倍率) + 跌破MA + K值達門檻
shot_ok = (close < open)
          and (volume > avg_vol * vol_mult)
          and is_cross_down
          and (k_val > k_threshold);

// ===== 日K條件（跨頻率） =====
var: d_close(0), d_close_sync(0), d_ma(0), d_dev(0);

d_close = GetField("Close", "D");
// 將日收盤價對齊到15分，再用Average計算日MA
d_close_sync = xf_GetValue("D", d_close, 0);
d_ma         = Average(d_close_sync, day_ma_len);
if d_ma <> 0 then
    d_dev = (d_close_sync - d_ma) / d_ma * 100;

// ===== 觸發 =====
if shot_ok and (d_dev > day_dev_thresh) then
    ret = 1;


