{@type:sensor}

// Breakout Alert - Flat EMA + Consolidation + Volume Filter (15 Min Timeframe)
// Signals (ret = 1) when:
// 1) 15-min 20 EMA is flattish for the past 20 bars (0.10% threshold - EXTREMELY FLAT)
// 2) 20 EMA > 56 EMA (bullish trend)
// 3) Price consolidated for past 10 bars (0.60% tight range)
// 4) Current high breaks above max high of prior 5 bars by at least 0.4%
// 5) Bullish close (Close > Open)
// 6) Bull breakout bar closes ABOVE 20 EMA
// 7) Past 5 days average volume > 300
// 8) Minimum 8 bars of consolidation maintained
// Optimized for 15-minute timeframe - EXTRA TIGHT EMA FLATNESS

// ===== Parameters =====
settotalbar(250);

input: ema_period(20, "EMA Period"),
       ema_long_period(56, "Long EMA Period"),
       ema_flat_bars(20, "EMA flat lookback bars (15-min)"),
       ema_flat_pct(0.10, "EMA flatness threshold (%)"),
       consol_bars(10, "Consolidation lookback bars"),
       consol_range_pct(0.60, "Consolidation range threshold (%)"),
       min_consol_bars(8, "Minimum consolidation period"),
       breakout_bars(5, "Breakout lookback bars"),
       breakout_pct(0.4, "Minimum breakout size (%)"),
       min_avg_volume(300, "Minimum 5-day average volume"),
       vol_lookback(5, "Volume lookback days");

// ===== Variables =====
var: intrabarpersist AlertTriggered(false);

var: ema20_val(0),
     ema56_val(0),
     ema_max(0),
     ema_min(0),
     ema_range(0),
     ema_range_pct(0),
     is_ema_flat(false),
     is_ema_bullish(false),
     consol_high(0),
     consol_low(0),
     consol_range(0),
     consol_range_pct_val(0),
     is_consolidated(false),
     consol_count(0),
     is_min_consol_met(false),
     prior_high(0),
     breakout_size(0),
     breakout_size_pct(0),
     is_breakout(false),
     is_significant_breakout(false),
     is_bullish(false),
     close_above_ema(false),
     vol_sum(0),
     vol_avg(0),
     vol_ok(false),
     i(0),
     is_15min(false);

// ===== Initialize ret =====
ret = 0;

// ===== Timeframe Check: Must be 15-minute chart =====
is_15min = (BarInterval = 15);

if not is_15min then
begin
    ret = 0;
end
else
begin
    // Safety check: need enough data
    if CurrentBar > 60 then
    begin
        // ===== Check 1: 15-min 20 EMA is flattish for past N bars =====
        ema20_val = EMA(Close, ema_period);
        ema56_val = EMA(Close, ema_long_period);
        
        // Find max and min of 20 EMA over the past ema_flat_bars periods
        ema_max = ema20_val;
        ema_min = ema20_val;
        
        for i = 1 to ema_flat_bars - 1
        begin
            if ema20_val[i] > ema_max then
                ema_max = ema20_val[i];
            if ema20_val[i] < ema_min then
                ema_min = ema20_val[i];
        end;
        
        ema_range = ema_max - ema_min;
        if ema_max > 0 then
            ema_range_pct = (ema_range / ema_max) * 100
        else
            ema_range_pct = 0;
        
        is_ema_flat = (ema_range_pct < ema_flat_pct);
        
        // ===== Check 1b: 20 EMA > 56 EMA (bullish trend) =====
        is_ema_bullish = (ema20_val > ema56_val);
        
        // ===== Check 2: Price consolidated for past 10 bars =====
        consol_high = Highest(High, consol_bars);
        consol_low = Lowest(Low, consol_bars);
        consol_range = consol_high - consol_low;
        
        if consol_high > 0 then
            consol_range_pct_val = (consol_range / consol_high) * 100
        else
            consol_range_pct_val = 0;
        
        is_consolidated = (consol_range_pct_val < consol_range_pct);
        
        // ===== Check 2b: Count how many bars have been in consolidation =====
        // Ensure at least min_consol_bars of tight range before breakout
        consol_count = 0;
        for i = 1 to consol_bars
        begin
            if (Highest(High[i], 3) - Lowest(Low[i], 3)) / Highest(High[i], 3) * 100 < consol_range_pct then
                consol_count = consol_count + 1;
        end;
        is_min_consol_met = (consol_count >= min_consol_bars);
        
        // ===== Check 3: Current high breaks above max high of prior 5 bars =====
        prior_high = Highest(High[1], breakout_bars);
        is_breakout = (High > prior_high);
        
        // ===== Check 3b: Breakout must be significant (at least 0.4% beyond prior high) =====
        breakout_size = High - prior_high;
        if prior_high > 0 then
            breakout_size_pct = (breakout_size / prior_high) * 100
        else
            breakout_size_pct = 0;
        is_significant_breakout = (breakout_size_pct > breakout_pct);
        
        // ===== Check 4: Bullish close =====
        is_bullish = (Close > Open);
        
        // ===== Check 5: Bull breakout bar closes ABOVE 20 EMA =====
        close_above_ema = (Close > ema20_val);
        
        // ===== Check 6: Past 5 days average volume > 300 =====
        vol_sum = 0;
        for i = 1 to vol_lookback
        begin
            vol_sum = vol_sum + GetField("Volume", "D")[i];
        end;
        vol_avg = vol_sum / vol_lookback;
        vol_ok = (vol_avg > min_avg_volume);
        
        // ===== Final Signal =====
        // All conditions must be met + minimum consolidation + significant breakout
        if is_ema_flat and is_ema_bullish and is_consolidated and is_min_consol_met and is_breakout and is_significant_breakout and is_bullish and close_above_ema and vol_ok then
        begin
            if not AlertTriggered then
            begin
                ret = 1;
                AlertTriggered = true;
                RetMsg = Text(
                    "BULL Breakout (15min)! ",
                    "Price: ", NumToStr(Close, 2),
                    " | High: ", NumToStr(High, 2),
                    " | Breakout: +", NumToStr(breakout_size_pct, 2), "%",
                    " | EMA20: ", NumToStr(ema20_val, 2),
                    " | EMA56: ", NumToStr(ema56_val, 2),
                    " | EMA Flat: ", NumToStr(ema_range_pct, 2), "%",
                    " | Consol: ", NumToStr(consol_range_pct_val, 2), "%",
                    " | Consol Bars: ", NumToStr(consol_count, 0),
                    " | Vol: ", NumToStr(vol_avg, 0)
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
end;
