# Breakout Alert Sensor - Analysis & Line-by-Line Explanation

## Executive Summary

This XQScript sensor (`{@type:sensor}`) is a **15-minute timeframe breakout detection system** that identifies bullish breakout opportunities with multiple confirmation filters. The strategy looks for:

1. **Flat EMA Condition**: The 20-period EMA must be extremely flat (within 0.10% range) over the past 20 bars, indicating a potential energy buildup
2. **Bullish Trend Filter**: 20 EMA must be above 56 EMA (ensures uptrend context)
3. **Price Consolidation**: Price must be in a tight range (0.60% or less) for at least 8 of the past 10 bars
4. **Significant Breakout**: Current high must break above the prior 5 bars' maximum high by at least 0.4%
5. **Bullish Candle**: Close must be above Open (bullish bar)
6. **EMA Confirmation**: Close must be above the 20 EMA
7. **Volume Filter**: 5-day average volume must exceed 300

**Output**: Returns `ret = 1` when all conditions are met, triggering a breakout alert. Uses `intrabarpersist` to prevent multiple alerts on the same bar.

---

## Line-by-Line Explanation

### Header & Comments (Lines 1-10)
```1:10:code
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
```
**Explanation**: Documentation header describing the strategy's 8 core conditions. Emphasizes "EXTREMELY FLAT" EMA requirement (0.10% threshold) for 15-minute charts.

---

### Parameter Declaration (Lines 12-13)
```12:13:code
// ===== Parameters =====
settotalbar(250);
```
**Explanation**: 
- `settotalbar(250)`: Sets the total number of bars to load/calculate. Ensures enough historical data for EMA calculations and lookback periods.

---

### Input Parameters (Lines 15-25)
```15:25:code
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
```
**Explanation**: User-configurable parameters:
- `ema_period(20)`: Short EMA period (default 20)
- `ema_long_period(56)`: Long EMA period (default 56)
- `ema_flat_bars(20)`: How many bars to check for EMA flatness
- `ema_flat_pct(0.10)`: Maximum EMA range percentage (0.10% = extremely tight)
- `consol_bars(10)`: Bars to check for consolidation
- `consol_range_pct(0.60)`: Maximum price range percentage for consolidation
- `min_consol_bars(8)`: Minimum bars that must show consolidation
- `breakout_bars(5)`: Bars to look back for prior high
- `breakout_pct(0.4)`: Minimum breakout size as percentage
- `min_avg_volume(300)`: Minimum daily average volume threshold
- `vol_lookback(5)`: Days to average volume over

---

### Variable Declarations (Lines 27-28)
```27:28:code
// ===== Variables =====
var: intrabarpersist AlertTriggered(false);
```
**Explanation**: 
- `intrabarpersist AlertTriggered(false)`: Flag that persists within the current bar to prevent multiple alerts. `intrabarpersist` means the value persists during intrabar updates (tick-by-tick) but resets on new bar.

---

### Variable Declarations (Lines 30-50)
```30:50:code
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
```
**Explanation**: All working variables initialized:
- EMA values and flatness calculations
- Consolidation range calculations
- Breakout detection variables
- Volume calculations
- Boolean flags for each condition
- Loop counter `i`
- Timeframe check flag `is_15min`

---

### Initialize Return Value (Lines 52-53)
```52:53:code
// ===== Initialize ret =====
ret = 0;
```
**Explanation**: Default return value is 0 (no signal). Only set to 1 when all conditions are met.

---

### Timeframe Check (Lines 55-61)
```55:61:code
// ===== Timeframe Check: Must be 15-minute chart =====
is_15min = (BarInterval = 15);

if not is_15min then
begin
    ret = 0;
end
```
**Explanation**: 
- `BarInterval = 15`: Checks if current chart is 15-minute timeframe
- If not 15-minute, immediately return 0 (strategy only works on 15-min charts)
- This is a safety check to prevent misuse on wrong timeframes

---

### Main Logic Block (Lines 62-63)
```62:63:code
else
begin
    // Safety check: need enough data
    if CurrentBar > 60 then
```
**Explanation**: 
- Only proceed if chart is 15-minute
- `CurrentBar > 60`: Ensures enough historical bars exist for calculations (need at least 60 bars for EMAs and lookbacks)

---

### EMA Calculations (Lines 65-67)
```65:67:code
        // ===== Check 1: 15-min 20 EMA is flattish for past N bars =====
        ema20_val = EMA(Close, ema_period);
        ema56_val = EMA(Close, ema_long_period);
```
**Explanation**: 
- Calculate 20-period and 56-period EMAs using closing prices
- These are the trend indicators used throughout the strategy

---

### EMA Flatness Calculation - Finding Range (Lines 69-78)
```69:78:code
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
```
**Explanation**: 
- Initialize `ema_max` and `ema_min` with current EMA value
- Loop through past `ema_flat_bars - 1` bars (using `[i]` to reference historical values)
- Find the maximum and minimum EMA values over this period
- This determines the EMA's range/volatility

---

### EMA Flatness Percentage (Lines 80-85)
```80:85:code
        ema_range = ema_max - ema_min;
        if ema_max > 0 then
            ema_range_pct = (ema_range / ema_max) * 100
        else
            ema_range_pct = 0;
```
**Explanation**: 
- Calculate absolute range: `ema_max - ema_min`
- Convert to percentage: `(range / max) * 100`
- Safety check: avoid division by zero
- This percentage measures how "flat" the EMA is (lower = flatter)

---

### EMA Flatness Check (Lines 87-88)
```87:88:code
        is_ema_flat = (ema_range_pct < ema_flat_pct);
```
**Explanation**: 
- Boolean flag: EMA is considered "flat" if range percentage < 0.10%
- This is an extremely tight threshold, indicating the EMA has barely moved

---

### Bullish Trend Check (Lines 90-92)
```90:92:code
        // ===== Check 1b: 20 EMA > 56 EMA (bullish trend) =====
        is_ema_bullish = (ema20_val > ema56_val);
```
**Explanation**: 
- Ensures uptrend: short EMA (20) must be above long EMA (56)
- This filters out bearish or sideways markets

---

### Consolidation Range Calculation (Lines 94-97)
```94:97:code
        // ===== Check 2: Price consolidated for past 10 bars =====
        consol_high = Highest(High, consol_bars);
        consol_low = Lowest(Low, consol_bars);
        consol_range = consol_high - consol_low;
```
**Explanation**: 
- `Highest(High, consol_bars)`: Maximum high over past 10 bars
- `Lowest(Low, consol_bars)`: Minimum low over past 10 bars
- `consol_range`: Absolute price range during consolidation period

---

### Consolidation Percentage (Lines 99-102)
```99:102:code
        if consol_high > 0 then
            consol_range_pct_val = (consol_range / consol_high) * 100
        else
            consol_range_pct_val = 0;
```
**Explanation**: 
- Convert consolidation range to percentage
- Measures how tight the price range is (lower = tighter consolidation)
- Safety check for division by zero

---

### Consolidation Check (Lines 104-105)
```104:105:code
        is_consolidated = (consol_range_pct_val < consol_range_pct);
```
**Explanation**: 
- Boolean: Price is consolidated if range < 0.60%
- This ensures price has been trading in a tight range

---

### Minimum Consolidation Period Check (Lines 107-116)
```107:116:code
        // ===== Check 2b: Count how many bars have been in consolidation =====
        // Ensure at least min_consol_bars of tight range before breakout
        consol_count = 0;
        for i = 1 to consol_bars
        begin
            if (Highest(High[i], 3) - Lowest(Low[i], 3)) / Highest(High[i], 3) * 100 < consol_range_pct then
                consol_count = consol_count + 1;
        end;
        is_min_consol_met = (consol_count >= min_consol_bars);
```
**Explanation**: 
- Counts how many bars (out of past 10) show consolidation
- For each bar `i`, checks if a 3-bar window around it is tight (< 0.60%)
- `is_min_consol_met`: At least 8 bars must show consolidation
- This ensures sustained consolidation, not just a brief tight range

---

### Breakout Detection - Prior High (Lines 118-120)
```118:120:code
        // ===== Check 3: Current high breaks above max high of prior 5 bars =====
        prior_high = Highest(High[1], breakout_bars);
        is_breakout = (High > prior_high);
```
**Explanation**: 
- `Highest(High[1], breakout_bars)`: Maximum high of past 5 bars (excluding current bar, hence `[1]`)
- `is_breakout`: Current bar's high must exceed this prior high
- This detects the initial breakout

---

### Significant Breakout Check (Lines 122-128)
```122:128:code
        // ===== Check 3b: Breakout must be significant (at least 0.4% beyond prior high) =====
        breakout_size = High - prior_high;
        if prior_high > 0 then
            breakout_size_pct = (breakout_size / prior_high) * 100
        else
            breakout_size_pct = 0;
        is_significant_breakout = (breakout_size_pct > breakout_pct);
```
**Explanation**: 
- Calculate absolute breakout size: `High - prior_high`
- Convert to percentage
- `is_significant_breakout`: Breakout must be at least 0.4% above prior high
- Filters out weak breakouts that might be false signals

---

### Bullish Candle Check (Lines 130-131)
```130:131:code
        // ===== Check 4: Bullish close =====
        is_bullish = (Close > Open);
```
**Explanation**: 
- Simple check: Close must be above Open (green/bullish candle)
- Ensures the breakout bar itself is bullish

---

### Close Above EMA Check (Lines 133-134)
```133:134:code
        // ===== Check 5: Bull breakout bar closes ABOVE 20 EMA =====
        close_above_ema = (Close > ema20_val);
```
**Explanation**: 
- Close must be above 20 EMA
- Confirms the breakout is strong enough to close above the key moving average
- Adds momentum confirmation

---

### Volume Calculation (Lines 136-142)
```136:142:code
        // ===== Check 6: Past 5 days average volume > 300 =====
        vol_sum = 0;
        for i = 1 to vol_lookback
        begin
            vol_sum = vol_sum + GetField("Volume", "D")[i];
        end;
        vol_avg = vol_sum / vol_lookback;
        vol_ok = (vol_avg > min_avg_volume);
```
**Explanation**: 
- `GetField("Volume", "D")[i]`: Gets daily volume for day `i` ago
- Sums volume over past 5 days
- Calculates average: `vol_sum / 5`
- `vol_ok`: Average must exceed 300
- Ensures sufficient liquidity (prevents false signals on low-volume stocks)

---

### Final Signal Logic (Lines 144-145)
```144:145:code
        // ===== Final Signal =====
        // All conditions must be met + minimum consolidation + significant breakout
        if is_ema_flat and is_ema_bullish and is_consolidated and is_min_consol_met and is_breakout and is_significant_breakout and is_bullish and close_above_ema and vol_ok then
```
**Explanation**: 
- **ALL** conditions must be true simultaneously:
  1. EMA is flat (`is_ema_flat`)
  2. Bullish trend (`is_ema_bullish`)
  3. Price consolidated (`is_consolidated`)
  4. Minimum consolidation met (`is_min_consol_met`)
  5. Breakout detected (`is_breakout`)
  6. Significant breakout (`is_significant_breakout`)
  7. Bullish candle (`is_bullish`)
  8. Close above EMA (`close_above_ema`)
  9. Volume OK (`vol_ok`)

---

### Alert Trigger Logic (Lines 146-161)
```146:161:code
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
```
**Explanation**: 
- `if not AlertTriggered`: Prevents multiple alerts on same bar (intrabar persistence)
- `ret = 1`: Signal triggered
- `AlertTriggered = true`: Mark as triggered
- `RetMsg`: Detailed message with all key metrics:
  - Price, High, Breakout percentage
  - EMA values
  - EMA flatness percentage
  - Consolidation range and bar count
  - Average volume
- `else ret = 0`: If already triggered this bar, don't signal again

---

### Reset Logic (Lines 162-167)
```162:167:code
        else
        begin
            ret = 0;
            // Reset alert trigger when conditions no longer met
            if not is_ema_flat or not is_consolidated then
                AlertTriggered = false;
        end;
    end;
end;
```
**Explanation**: 
- If conditions not met: `ret = 0` (no signal)
- Reset `AlertTriggered` when EMA is no longer flat OR consolidation breaks
- This allows new alerts on future bars once conditions re-establish
- Closes the nested `if` and `else` blocks

---

## Key Strategy Insights

### Strengths
1. **Multi-layered confirmation**: 9 separate conditions reduce false signals
2. **Extremely tight EMA filter**: 0.10% flatness is very selective
3. **Volume filter**: Ensures liquidity
4. **Significant breakout requirement**: 0.4% minimum filters weak moves
5. **Timeframe-specific**: Optimized for 15-minute charts

### Potential Considerations
1. **Very selective**: May miss valid breakouts due to strict criteria
2. **15-minute only**: Won't work on other timeframes
3. **Volume threshold**: 300 may be too high/low depending on stock
4. **No stop-loss logic**: Sensor only detects entry, not exit
5. **Intrabar persistence**: Prevents multiple signals but may delay re-entry

### Trading Logic Flow
```
15-min chart? → No → ret = 0
              → Yes → Enough bars? → No → ret = 0
                              → Yes → Check all 9 conditions
                                      → All met? → Alert triggered? → No → ret = 1 + Alert
                                                                      → Yes → ret = 0
                                      → Not met → ret = 0 + Reset if needed
```
