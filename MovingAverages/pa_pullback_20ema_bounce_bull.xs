{@type:sensor}

// BULL Pullback to 20EMA Bounce Alert - Mean Reversion Strategy
// Signals (ret = 1) when:
// 1) Price had a recent swing high (was well above 20 EMA)
// 2) Price pulls back to near 20 EMA for the FIRST time
// 3) Price bounces back and is now 2 ticks above 20 EMA
// 4) Confirms bullish momentum continuation after EMA test
// Optimized for 15-minute timeframe

// ===== Parameters =====
settotalbar(250);

input: ema_period(20, "EMA Period"),
       swing_lookback(20, "Swing high lookback bars"),
       swing_distance_pct(1.5, "Minimum distance above EMA for swing (%)"),
       ema_test_distance_ticks(3, "Max distance from EMA to count as test (ticks)"),
       bounce_ticks(2, "Ticks above EMA for bounce confirmation"),
       min_bars_above_ema(5, "Min bars price was above EMA before pullback"),
       pullback_lookback(15, "Max bars to look for first pullback"),
       min_avg_volume(300, "Minimum 5-day average volume"),
       vol_lookback(5, "Volume lookback days");

// ===== Variables =====
var: intrabarpersist AlertTriggered(false);

var: ema20_val(0),
     ema20_val_i(0),
     tick_size(0),
     bounce_threshold(0),
     ema_test_threshold(0),
     had_swing_high(false),
     swing_high_price(0),
     swing_distance(0),
     swing_distance_pct_val(0),
     bars_above_ema(false),
     tested_ema(false),
     is_near_ema(false),
     is_bouncing(false),
     is_bullish(false),
     is_first_test(false),
     bars_since_swing(0),
     current_distance(0),
     prev_distance(0),
     ema_at_i(0),
     distance_to_ema(0),
     vol_sum(0),
     vol_avg(0),
     vol_ok(false),
     i(0),
     is_15min(false),
     price_above_ema_count(0);

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
        // ===== Calculate 20 EMA =====
        ema20_val = Average(Close, ema_period);
        
        // ===== Determine tick size (estimate based on price level) =====
        // For stocks around 100-200: tick = 0.5, adjust based on actual instrument
        if Close >= 1000 then
            tick_size = 5.0
        else if Close >= 500 then
            tick_size = 1.0
        else if Close >= 100 then
            tick_size = 0.5
        else if Close >= 50 then
            tick_size = 0.1
        else
            tick_size = 0.05;
        
        bounce_threshold = ema20_val + (bounce_ticks * tick_size);
        ema_test_threshold = ema_test_distance_ticks * tick_size;
        
        // ===== Check 1: Look for recent swing high (price was well above 20 EMA) =====
        had_swing_high = false;
        swing_high_price = 0;
        bars_since_swing = 0;
        
        for i = 1 to swing_lookback
        begin
            ema20_val_i = Average(Close[i], ema_period);
            swing_distance = High[i] - ema20_val_i;
            
            if ema20_val_i > 0 then
                swing_distance_pct_val = (swing_distance / ema20_val_i) * 100
            else
                swing_distance_pct_val = 0;
            
            // Found a swing high if price was significantly above EMA
            if swing_distance_pct_val >= swing_distance_pct and Close[i] > ema20_val_i then
            begin
                had_swing_high = true;
                swing_high_price = High[i];
                bars_since_swing = i;
                // Exit loop after finding most recent swing
                i = swing_lookback + 1;
            end;
        end;
        
        // ===== Check 2: Count how many bars were above EMA before pullback =====
        price_above_ema_count = 0;
        if had_swing_high then
        begin
            for i = bars_since_swing to 1
            begin
                if Close[i] > Average(Close[i], ema_period) then
                    price_above_ema_count = price_above_ema_count + 1;
            end;
        end;
        
        bars_above_ema = (price_above_ema_count >= min_bars_above_ema);
        
        // ===== Check 3: Verify this is FIRST TIME testing EMA after swing =====
        is_first_test = false;
        if had_swing_high and bars_above_ema then
        begin
            is_first_test = true;
            // Check if price touched or came near EMA between swing and now
            for i = bars_since_swing - 1 to 1
            begin
                ema_at_i = Average(Close[i], ema_period);
                distance_to_ema = AbsValue(Low[i] - ema_at_i);
                
                // If price was near or below EMA before current bar, it's not first test
                if distance_to_ema <= ema_test_threshold or Low[i] < ema_at_i then
                begin
                    is_first_test = false;
                    i = 1; // Exit loop
                end;
            end;
        end;
        
        // ===== Check 4: Current bar or previous bar tested near EMA =====
        tested_ema = false;
        current_distance = AbsValue(Low - ema20_val);
        
        if current_distance <= ema_test_threshold and Low <= ema20_val + ema_test_threshold then
            tested_ema = true;
        
        // Also check previous bar
        if not tested_ema then
        begin
            prev_distance = AbsValue(Low[1] - Average(Close[1], ema_period));
            if prev_distance <= ema_test_threshold and Low[1] <= Average(Close[1], ema_period) + ema_test_threshold then
                tested_ema = true;
        end;
        
        // ===== Check 5: Price is bouncing (2 ticks above 20 EMA) =====
        is_bouncing = (Close >= bounce_threshold);
        
        // ===== Check 6: Volume filter =====
        vol_sum = 0;
        for i = 1 to vol_lookback
        begin
            vol_sum = vol_sum + GetField("Volume", "D")[i];
        end;
        vol_avg = vol_sum / vol_lookback;
        vol_ok = (vol_avg > min_avg_volume);
        
        // ===== Check 7: Bullish close =====
        is_bullish = (Close > Open);
        
        // ===== Final Signal =====
        // All conditions must be met for first-time pullback and bounce
        if had_swing_high and bars_above_ema and is_first_test and tested_ema and is_bouncing and is_bullish and vol_ok then
        begin
            if not AlertTriggered then
            begin
                ret = 1;
                AlertTriggered = true;
                RetMsg = Text(
                    "BULL EMA Bounce! ",
                    "Price: ", NumToStr(Close, 2),
                    " | EMA20: ", NumToStr(ema20_val, 2),
                    " | Above EMA: +", NumToStr(bounce_ticks, 0), " ticks",
                    " | Swing High: ", NumToStr(swing_high_price, 2),
                    " | Bars Since Swing: ", NumToStr(bars_since_swing, 0),
                    " | First Test: YES",
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
            // Reset alert trigger when price moves away from EMA or conditions no longer met
            if not is_bouncing or not tested_ema then
                AlertTriggered = false;
        end;
    end;
end;

