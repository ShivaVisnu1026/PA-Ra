{@type:filter}
// Daily Pin Bar Reversal + Weekly EMA20 Sloping Down (Filter Script)
// Description:
//   - Primary Frequency: Daily
//   - Cross-Frequency: Weekly EMA20 calculated via xf_XAverage("W", ...)
//   - Output: OutputField displays 1) Weekly EMA20 2) Previous value 3) Difference

// ===== Parameters =====
settotalbar(250);

input: tail_min_pct(0.60, "Min tail ratio"),
       opp_tail_max_pct(0.15, "Max opposite tail ratio"),
       body_max_pct(0.35, "Max body ratio"),
       body_pos_pct(0.35, "Body position ratio"),
       ema_len(20, "Weekly EMA length"),
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

// ===== Weekly EMA20 Sloping Down (Cross-Frequency) =====
var: wk_close(0), wk_ema20(0), wk_ema20_prev(0),
     isWeeklyDown(false), ema_diff(0);

wk_close      = GetField("Close", "W");
wk_ema20      = xf_XAverage("W", wk_close, ema_len);
// Important: To get "previous week" EMA, shift the source series by 1 week
wk_ema20_prev = xf_XAverage("W", wk_close[1], ema_len);
ema_diff      = wk_ema20 - wk_ema20_prev;
isWeeklyDown  = wk_ema20 < wk_ema20_prev;

// ===== Filter Condition =====
if isBearishPin and isWeeklyDown and vol_ok then
    ret = 1
else
    ret = 0;

// ===== Output Fields (Weekly EMA20 / Previous / Difference) =====
outputfield(1, wk_ema20,      2, "W_EMA20",      order := 1);
outputfield(2, wk_ema20_prev, 2, "W_EMA20_prev");
outputfield(3, ema_diff,      3, "W_EMA20_diff");