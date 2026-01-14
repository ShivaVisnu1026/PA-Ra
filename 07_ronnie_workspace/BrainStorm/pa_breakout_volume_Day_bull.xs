{@type:sensor}

// Breakout Alert - Flat EMA + Consolidation + Volume Filter
// Signals (ret = 1) when:
// 1) 20 EMA is flattish for the past 4 sessions (daily)
// 2) Price consolidated for past 8 bars
// 3) Current high breaks above max high of prior 5 bars
// 4) Bullish close (Close > Open)
// 5) Past 5 days average volume > 300
// 6) Lower wick > 30% of body
// 7) Price breaks above 20 EMA (using EMA flatness as breakout level)

// ===== Parameters =====
settotalbar(250);

input: ema_period(20, "EMA Period"),
       ema_flat_sessions(5, "EMA flat lookback sessions (days)"),
       ema_flat_pct(0.40, "EMA flatness threshold (%)"),
       consol_bars(8, "Consolidation lookback bars"),
       consol_range_pct(2.0, "Consolidation range threshold (%) - Daily"),
       breakout_bars(5, "Breakout lookback bars"),
       min_avg_volume(300, "Minimum 5-day average volume"),
       vol_lookback(5, "Volume lookback days"),
       min_wick_pct(30.0, "Minimum wick percentage of body (%)");

// ===== Variables =====
var: intrabarpersist AlertTriggered(false);

var: d_ema20(0),
     d_close(0),
     ema_max(0),
     ema_min(0),
     ema_range(0),
     ema_range_pct(0),
     is_ema_flat(false),
     ema20_val(0),
     consol_high(0),
     consol_low(0),
     consol_range(0),
     consol_range_pct_val(0),
     is_consolidated(false),
     prior_high(0),
     is_breakout(false),
     is_bullish(false),
     body_size(0),
     lower_wick(0),
     wick_pct(0),
     wick_ok(false),
     breaks_above_ema(false),
     vol_sum(0),
     vol_avg(0),
     vol_ok(false),
     i(0);

// ===== Initialize ret =====
ret = 0;

// Safety check: need enough data
if CurrentBar > 20 then
begin
    // ===== Check 1: Daily 20 EMA is flattish for past 4 sessions =====
    d_close = GetField("Close", "D");
    d_ema20 = Average(d_close, ema_period);
    
    // Find max and min of daily EMA20 over the past ema_flat_sessions days
    ema_max = d_ema20;
    ema_min = d_ema20;
    
    for i = 1 to ema_flat_sessions - 1
    begin
        if d_ema20[i] > ema_max then
            ema_max = d_ema20[i];
        if d_ema20[i] < ema_min then
            ema_min = d_ema20[i];
    end;
    
    ema_range = ema_max - ema_min;
    if ema_max > 0 then
        ema_range_pct = (ema_range / ema_max) * 100
    else
        ema_range_pct = 0;
    
    is_ema_flat = (ema_range_pct < ema_flat_pct);
    
    // ===== Get current 20 EMA value =====
    ema20_val = EMA(Close, ema_period);
    
    // ===== Check 2: Price consolidated for past 8 bars =====
    consol_high = Highest(High[1], consol_bars);
    consol_low = Lowest(Low[1], consol_bars);
    consol_range = consol_high - consol_low;
    
    if consol_high > 0 then
        consol_range_pct_val = (consol_range / consol_high) * 100
    else
        consol_range_pct_val = 0;
    
    is_consolidated = (consol_range_pct_val < consol_range_pct);
    
    // ===== Check 3: Current high breaks above max high of prior 5 bars =====
    prior_high = Highest(High[1], breakout_bars);
    is_breakout = (High > prior_high);
    
    // ===== Check 4: Bullish close =====
    is_bullish = (Close > Open);
    
    // ===== Check 5: Lower wick > 30% of body =====
    body_size = Close - Open;
    if body_size > 0 then
    begin
        lower_wick = Open - Low;
        wick_pct = (lower_wick / body_size) * 100;
        wick_ok = (wick_pct > min_wick_pct);
    end
    else
    begin
        wick_ok = false;
    end;
    
    // ===== Check 6: Price breaks above 20 EMA (using EMA flatness as breakout level) =====
    breaks_above_ema = (Close > ema20_val);
    
    // ===== Check 7: Past 5 days average volume > 300 =====
    vol_sum = 0;
    for i = 1 to vol_lookback
    begin
        vol_sum = vol_sum + GetField("Volume", "D")[i];
    end;
    vol_avg = vol_sum / vol_lookback;
    vol_ok = (vol_avg > min_avg_volume);
    
    // ===== Final Signal =====
    if is_ema_flat and is_consolidated and is_breakout and is_bullish and wick_ok and breaks_above_ema and vol_ok then
    begin
        if not AlertTriggered then
        begin
            ret = 1;
            AlertTriggered = true;
            RetMsg = Text(
                "Breakout Alert! ",
                "Price: ", NumToStr(Close, 2),
                " | High: ", NumToStr(High, 2),
                " | EMA20: ", NumToStr(ema20_val, 2),
                " | EMA Flat: ", NumToStr(ema_range_pct, 2), "%",
                " | Consol Range: ", NumToStr(consol_range_pct_val, 2), "%",
                " | Wick: ", NumToStr(wick_pct, 2), "%",
                " | Avg Vol: ", NumToStr(vol_avg, 0)
            );
        end
        else
        begin
            ret = 0;
        end;
    end
    else
    begin
        ret = 0;
        // Reset alert trigger when conditions no longer met
        if not is_ema_flat or not is_consolidated then
            AlertTriggered = false;
    end;
end;
