{@type:sensor}
// 5分K：KD達門檻且跌破SMA，並且「日頻率」股價與5MA乖離率 > 門檻

// === 參數 ===
settotalbar(1000);
input: k_len(90, "K計算期數"),
       k_smooth(3, "K平滑期數"),
       d_smooth(3, "D平滑期數"),
       ma_len(5, "SMA期數(5分)"),
       k_threshold(90, "K門檻"),
       day_ma_len(5, "日MA期數"),
       day_dev_thresh(5.0, "日乖離率門檻(%)");

// === 頻率限制：只允許 5 分K ===
if barfreq <> "Min" or barinterval <> 5 then
    raiseruntimeerror("請設定為 5 分鐘K棒");

// === 變數 ===
var: rsv_val(0), k_val(0), d_val(0);
var: ma_val(0), trigger(false);
var: day_close(0), day_ma(0), day_dev(0), day_dev_abs(0);

// === KD (built-in Stochastic) ===
// 返回值=1 代表計算成功；第4/5/6參數回傳 RSV/K/D
value1 = Stochastic(k_len, k_smooth, d_smooth, rsv_val, k_val, d_val);

// === 5分K SMA ===
ma_val = average(close, ma_len);

// === 日頻率條件：股價與MA乖離率 ===
day_close = GetField("Close", "D");
day_ma    = Average(day_close, day_ma_len);
if day_ma <> 0 then
begin
    day_dev     = (day_close - day_ma) / day_ma * 100; // 正負皆可
    day_dev_abs = absvalue(day_dev);
end;

// === 合成條件 ===
// 1) K >= 門檻
// 2) 跌破 5分K SMA（向下穿越）
// 3) 日頻率乖離率絕對值 >= 門檻
trigger = (k_val >= k_threshold)
          and (close < ma_val and close[1] >= ma_val[1])
          and (day_dev_abs >= day_dev_thresh);

// === 訊號 ===
if trigger then
begin
    RetMsg = Text(
        "KD>=", NumToStr(k_threshold,0),
        " 且跌破SMA | 日乖離% = ", NumToStr(day_dev,2)
    );
    ret = 1;
end;


