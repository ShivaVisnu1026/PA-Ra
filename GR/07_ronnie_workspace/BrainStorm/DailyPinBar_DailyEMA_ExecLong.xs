{@type:autotrade}
// Daily Bullish Pin Bar + Daily EMA Up - Execution Script (Long)
// Entry: one tick above the reversal bar's high
// Stop:  one tick below the reversal bar's low

// ===== Parameters =====
settotalbar(250);

input: tail_min_pct(0.60, "Min tail ratio"),
       opp_tail_max_pct(0.15, "Max opposite tail ratio"),
       body_max_pct(0.35, "Max body ratio"),
       body_pos_pct(0.35, "Body position ratio"),
       ema_len(20, "Daily EMA length"),
       min_volume(500, "Min daily volume");

// ===== Daily Pin Bar Detection (Bullish) =====
var: bodySize(0), candleRange(0),
     upperShadow(0), lowerShadow(0),
     isBullishPin(false);

bodySize    = absvalue(close - open);
candleRange = high - low;
upperShadow = high - maxlist(open, close);
lowerShadow = minlist(open, close) - low;

if candleRange > 0 then
begin
    isBullishPin =
        (lowerShadow >= tail_min_pct * candleRange)
        and (upperShadow <= opp_tail_max_pct * candleRange)
        and (bodySize    <= body_max_pct * candleRange)
        and (minlist(open, close) >= high - body_pos_pct * candleRange);
end;

// ===== Daily Volume Filter =====
var: vol_ok(false);
vol_ok = (volume >= min_volume);

// ===== Daily EMA Slope Up =====
var: d_ema(0), d_ema_prev(0), isDailyUp(false);

d_ema       = XAverage(close, ema_len);
d_ema_prev  = XAverage(close, ema_len)[1];
isDailyUp   = d_ema > d_ema_prev;

// ===== Signal capture and order prices =====
var: intrabarpersist signal_date(0),
     intrabarpersist signal_high(0),
     intrabarpersist signal_low(0),
     intrabarpersist entry_price(0),
     intrabarpersist stop_price(0),
     intrabarpersist signal_armed(false);

// When reversal conditions occur on this bar, arm a long setup
if isBullishPin and isDailyUp and vol_ok then
begin
    signal_date  = date;
    signal_high  = high;
    signal_low   = low;
    entry_price  = AddSpread(signal_high, 1);   // one tick above high
    stop_price   = AddSpread(signal_low, -1);   // one tick below low
    signal_armed = true;
end;

// ===== Entry Execution =====
if Position = 0 and signal_armed then
begin
    // Enter long when price trades at or above the entry price
    if high >= entry_price then
    begin
        SetPosition(1, market);
    end;
end;

// ===== Stop Loss =====
if Position = 1 then
begin
    // Exit if price trades at/below stop price
    if low <= stop_price then
    begin
        SetPosition(0, market);
        signal_armed = false;
    end;
end
else
begin
    // If flat and a new bar starts after the signal bar without triggering entry,
    // keep the setup until a new signal overwrites it.
    // No additional action needed here.
end;

// Note: Execution scripts cannot use OutputField; use alerts/logging if needed.

