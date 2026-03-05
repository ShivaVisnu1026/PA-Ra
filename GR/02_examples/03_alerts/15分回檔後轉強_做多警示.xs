{@type:sensor}
// 15分 回檔後轉強 做多訊號（由放空腳本反轉邏輯而來）
// 條件：
// 1) 短區間（15分K）：當前量 > 前N根平均量、白K、且向上突破5MA
// 2) 長區間（日K）：價格與5MA的乖離率 < -門檻（負值、距離向下過大後的反彈）

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
       k_thresh_long(20, "多方K門檻(以下)");

// 僅允許 15 分K（測試不同頻率時暫時關閉）
// if barfreq <> "Min" or barinterval <> 15 then
//     raiseruntimeerror("請設定為 15 分鐘K棒");

// ===== 分K邏輯 =====
var: ma_short(0), avg_vol(0), is_cross_up(false), long_ok(false);
var: rsv_val(0), k_val(0), d_val(0);

ma_short = Average(close, short_ma_len);
// 前N根平均量（不含當根）
avg_vol  = Average(volume[1], vol_lookback);
is_cross_up = (close > ma_short and close[1] <= ma_short[1]);

// KD 指標
value1 = Stochastic(k_len, k_smooth, d_smooth, rsv_val, k_val, d_val);

// 白K + 量增(倍率) + 突破MA + K值偏低（回檔後）
long_ok = (close > open)
          and (volume > avg_vol * vol_mult)
          and is_cross_up
          and (k_val < k_thresh_long);

// ===== 日K條件（跨頻率） =====
var: d_close(0), d_close_sync(0), d_ma(0), d_dev(0);

d_close = GetField("Close", "D");
// 將日收盤價對齊到15分，再用Average計算日MA
d_close_sync = xf_GetValue("D", d_close, 0);
d_ma         = Average(d_close_sync, day_ma_len);
if d_ma <> 0 then
    d_dev = (d_close_sync - d_ma) / d_ma * 100;

// ===== 觸發 =====
// 長區間條件反轉：要求日乖離率 < -threshold（向下過度乖離後反彈）
if long_ok and (d_dev < -day_dev_thresh) then
    ret = 1;


