// Daily Pin Bar Reversal + Daily EMA Sloping Down (Filter Script)
// Description:
//   - Primary Frequency: Daily only
//   - Daily EMA calculated on daily closes
//   - Output: OutputField displays 1) Daily EMA 2) Previous value 3) Difference

// ===== Parameters =====
settotalbar(250);

input: tail_min_pct(0.60, "Min tail ratio"),
       opp_tail_max_pct(0.15, "Max opposite tail ratio"),
       body_max_pct(0.35, "Max body ratio"),
       body_pos_pct(0.35, "Body position ratio"),
       ema_len(20, "Daily EMA length"),
       min_volume(500, "Min daily volume");

// ===== Daily Pin Bar Detection (Bearish) =====
var: bodySize(0), candleRange(0),
     upperShadow(0), lowerShadow(0),
     isBearishPin(false);

bodySize    = absvalue(close - open);
candleRange = high - low;
upperShadow = high - maxlist(open, close);
lowerShadow = minlist(open, close) - low;

if candleRange > 0 then
begin
    isBearishPin =
        (upperShadow >= tail_min_pct * candleRange)
        and (lowerShadow <= opp_tail_max_pct * candleRange)
        and (bodySize    <= body_max_pct * candleRange)
        and (maxlist(open, close) <= low + body_pos_pct * candleRange);
end;

// ===== Daily Volume Filter =====
var: vol_ok(false);
vol_ok = (volume >= min_volume);

// ===== Daily EMA Sloping Down =====
var: d_ema(0), d_ema_prev(0), ema_diff(0), isDailyDown(false);

d_ema      = XAverage(close, ema_len);
d_ema_prev = XAverage(close, ema_len)[1];
ema_diff   = d_ema - d_ema_prev;
isDailyDown = d_ema < d_ema_prev;

// ===== Filter Condition =====
if isBearishPin and isDailyDown and vol_ok then
    ret = 1
else
    ret = 0;

// ===== OutputField (optional display) =====
// OutputField(1, d_ema, "D_EMA");
// OutputField(2, d_ema_prev, "D_EMA_prev");
// OutputField(3, ema_diff, "D_EMA_diff");


