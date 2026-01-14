{@type:sensor}

// Breakout Alert - Flat EMA + Consolidation + Volume Filter (Weekly Timeframe)
// Signals (ret = 1) when:
// 1) Weekly 20 EMA is flattish for the past N bars
// 2) 20 EMA > 56 EMA (bullish trend)
// 3) Price consolidated for past 8 bars
// 4) Current high breaks above max high of prior 5 bars
// 5) Bullish close (Close > Open)
// 6) Past 5 weeks average volume > 300
// Optimized for weekly timeframe

// ===== Parameters =====
settotalbar(250);

input: ema_period(20, "EMA Period"),
       ema_long_period(56, "Long EMA Period"),
       ema_flat_bars(4, "EMA flat lookback bars (weekly)"),
       ema_flat_pct(0.5, "EMA flatness threshold (%)"),
       consol_bars(8, "Consolidation lookback bars"),
       consol_range_pct(2.0, "Consolidation range threshold (%)"),
       breakout_bars(5, "Breakout lookback bars"),
       min_avg_volume(300, "Minimum 5-week average volume"),
       vol_lookback(5, "Volume lookback weeks");

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
     prior_high(0),
     is_breakout(false),
     is_bullish(false),
     vol_sum(0),
     vol_avg(0),
     vol_ok(false),
     i(0),
     is_weekly(false);

// ===== Initialize ret =====
ret = 0;

// ===== Timeframe Check: Must be weekly chart =====
is_weekly = (BarFreq = "W");

if not is_weekly then
begin
    ret = 0;
end
else
begin
    // Safety check: need enough data
    if CurrentBar > 60 then
    begin
        // ===== Check 1: Weekly 20 EMA is flattish for past N bars =====
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
        
        // ===== Check 2: Price consolidated for past 8 bars =====
        consol_high = Highest(High, consol_bars);
        consol_low = Lowest(Low, consol_bars);
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
        
        // ===== Check 5: Past 5 weeks average volume > 300 =====
        vol_sum = 0;
        for i = 1 to vol_lookback
        begin
            vol_sum = vol_sum + Volume[i];
        end;
        vol_avg = vol_sum / vol_lookback;
        vol_ok = (vol_avg > min_avg_volume);
        
        // ===== Final Signal =====
        if is_ema_flat and is_ema_bullish and is_consolidated and is_breakout and is_bullish and vol_ok then
        begin
            if not AlertTriggered then
            begin
                ret = 1;
                AlertTriggered = true;
                RetMsg = Text(
                    "Breakout Alert (Weekly)! ",
                    "Price: ", NumToStr(Close, 2),
                    " | High: ", NumToStr(High, 2),
                    " | EMA20: ", NumToStr(ema20_val, 2),
                    " | EMA56: ", NumToStr(ema56_val, 2),
                    " | EMA Flat: ", NumToStr(ema_range_pct, 2), "%",
                    " | Consol Range: ", NumToStr(consol_range_pct_val, 2), "%",
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
end;

