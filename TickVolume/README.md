# Tick Volume Analysis Strategies

This folder contains 8 XQScript strategies for tick volume analysis and accumulation alerts.

**Strategies 1-5:** Single daily alert, conservative approach for early accumulation detection  
**Strategies 6-8:** Tiered multi-level alerts with advanced tick-by-tick analysis

## Strategy Overview

### Strategy 1: Volume-Price Divergence Accumulation Alert
**File:** `Strategy1_VolumePriceDivergence.txt`

**Purpose:** Detect sideways consolidation with abnormal volume increases

**Key Conditions:**
- Price change < 2% (consolidation)
- Volume Z-score > 1.5 (abnormal increase)
- Ask volume ratio > 60% (buying pressure)
- Price not yet increased > 5%

**Best For:** Early accumulation detection during sideways price action

---

### Strategy 2: Smart Money Flow Accumulation Alert
**File:** `Strategy2_SmartMoneyFlow.txt`

**Purpose:** Detect institutional money flow using ask/bid analysis

**Key Conditions:**
- Ask/Bid ratio > 1.2
- Board lot volume ratio > 70% (institutional activity)
- Cumulative ask volume > 1.5x average
- Price not yet increased > 5%

**Best For:** Identifying institutional accumulation patterns

---

### Strategy 3: Statistical Volume Anomaly Alert
**File:** `Strategy3_StatisticalVolumeAnomaly.txt`

**Purpose:** Multi-dimensional statistical volume analysis

**Key Conditions:**
- Volume Z-score > 2.0
- Volume > 95th percentile
- Volume MA deviation > 50%
- Tick count Z-score > 1.5

**Best For:** Comprehensive statistical anomaly detection

---

### Strategy 4: Cumulative Volume Flow Accumulation Alert (Tightened)
**File:** `Strategy4_CumulativeVolumeFlow.txt`

**Purpose:** Track cumulative volume flow trends and acceleration

**Key Conditions:**
- Cumulative ask volume slope > threshold
- Cumulative ask volume acceleration > threshold
- Ask volume ratio trend increasing
- 5-day average volume > 300
- Price change < 2%

**Best For:** Detecting sustained accumulation with acceleration (most restrictive)

---

### Strategy 5: Multi-Timeframe Volume Convergence Alert
**File:** `Strategy5_MultiTimeframeConvergence.txt`

**Purpose:** Multi-timeframe volume convergence analysis

**Key Conditions:**
- Short-term (5) volume > 1.5x average
- Medium-term (10) volume > 1.3x average
- Long-term (20) volume > 1.2x average
- Ask volume ratio > 65%

**Best For:** Confirmation across multiple timeframes

---

### Strategy 6: Volume Per Tick Ratio (VPTR) Anomaly Detection
**File:** `Strategy6_VPTR_Analysis.txt`

**Purpose:** Detect large orders/accumulation by analyzing volume per tick ratio

**Key Metrics:**
- **VPTR Z-Score:** Statistical anomaly detection (standard deviations from mean)
- **Tick Compression Index:** Volume concentration per tick vs average
- **VPTR Trend:** Linear regression slope analysis

**Alert Levels:**
- **Warning (ret=1):** VPTR Z-Score > 2.0 OR Compression > 1.3x
- **Strong (ret=2):** VPTR Z-Score > 2.5 AND Compression > 1.5x
- **Critical (ret=3):** VPTR Z-Score > 3.0 AND Compression > 2.0x AND price flat (<1%)

**Detection Phase:** Early accumulation (before price moves)  
**Best For:** Large order detection, institutional activity tracking

---

### Strategy 7: Tick Efficiency & Volume Absorption Alert
**File:** `Strategy7_Efficiency_Absorption.txt`

**Purpose:** Measure how efficiently volume moves price and absorption rate

**Key Metrics:**
- **Tick Efficiency Ratio:** Price change / (Volume / Tick count) - Lower = accumulation
- **Volume Absorption Rate:** Volume / (Time / Tick count) - Higher = strong demand
- **Efficiency Divergence:** Efficiency dropping while volume increasing

**Alert Levels:**
- **Warning (ret=1):** Efficiency dropped 30% while volume up 50%
- **Strong (ret=2):** Efficiency dropped 50% + volume up 100% + absorption rate > 1.5x avg
- **Critical (ret=3):** Efficiency dropped 70%+ AND absorption accelerating AND ask volume > 65%

**Detection Phase:** Early accumulation (pressure building before breakout)  
**Best For:** Detecting accumulation pressure, pre-breakout conditions

---

### Strategy 8: Velocity Convergence Breakout Confirmation
**File:** `Strategy8_Velocity_Breakout.txt`

**Purpose:** Confirm breakout when volume, tick, and price velocities converge

**Key Metrics:**
- **Tick Velocity:** Ticks per minute (trading frequency)
- **Volume Velocity:** Volume per minute (capital flow speed)
- **Price Velocity:** Price change per minute (momentum)
- **Velocity Ratio:** Volume velocity / Tick velocity
- **Three-Way Convergence:** All velocities accelerating together

**Alert Levels:**
- **Warning (ret=1):** Volume velocity > tick velocity AND price moving up
- **Strong (ret=2):** Volume velocity > 2x tick velocity + price up > 1% + ask ratio > 60%
- **Critical (ret=3):** Three-way convergence + price up > 2% + volume > 2x avg

**Detection Phase:** Breakout confirmation (momentum detected, ride the move)  
**Best For:** Confirming breakouts, momentum trading, trend participation

---

## Common Features

### Strategies 1-5 (Original Series)

These strategies include:
- **Daily alert trigger limit** (prevents repeated alerts)
- **Price ceiling protection** (max 5% increase)
- **Customizable parameters** via `input` variables
- **Single-level alerts** (binary on/off)
- `{@type:sensor}` declaration for XQ platform

### Strategies 6-8 (Advanced Series)

These strategies feature:
- **Tiered alert system** (3 levels: Warning/Strong/Critical)
- **Smart cooldown logic** (5-minute minimum gap, immediate upgrade if level increases)
- **Real-time tick analysis** using `intrabarpersist` variables
- **Multiple alerts per day** with intelligent filtering
- **Advanced metrics** (velocity, efficiency, absorption, compression, historical comparison)
- `{@type:sensor}` declaration for XQ platform

## Tiered Alert System (Strategies 6-8)

### Alert Levels Explained

| Level | Return Value | Color | Meaning | Action |
|-------|--------------|-------|---------|--------|
| **Warning** | ret = 1 | Yellow | Initial signal detected | Monitor closely |
| **Strong** | ret = 2 | Orange | Significant pattern confirmed | Prepare for entry |
| **Critical** | ret = 3 | Red | Strongest signal, high probability | Consider immediate action |
| None | ret = 0 | - | No alert | Wait for signals |

### Alert Frequency Management

**Cooldown Logic:**
- Minimum 5-minute gap between same-level alerts (3 min for Strategy 8)
- Immediate re-alert if alert level increases (Warning → Strong → Critical)
- Multiple alerts possible per day when conditions persist
- Auto-reset when no alerts for cooldown period

**Example Flow:**
```
10:00 AM - Warning alert (ret=1)
10:03 AM - Warning blocked (cooldown)
10:05 AM - Warning allowed (cooldown expired)
10:06 AM - Strong alert (ret=2) - IMMEDIATE (level upgrade)
10:08 AM - Critical alert (ret=3) - IMMEDIATE (level upgrade)
```

## Strategy Comparison Matrix

| Strategy | Phase | Primary Focus | Alert Type | Frequency | Best Use Case |
|----------|-------|---------------|------------|-----------|---------------|
| **1: Volume-Price Divergence** | Early | Z-score analysis | Single | Daily | Conservative accumulation |
| **2: Smart Money Flow** | Early | Ask/Bid ratio | Single | Daily | Institutional tracking |
| **3: Statistical Anomaly** | Early | Multi-dimensional stats | Single | Daily | Statistical outliers |
| **4: Cumulative Flow** | Early | Slope acceleration | Single | Daily | Sustained accumulation |
| **5: Multi-Timeframe** | Early | Timeframe convergence | Single | Daily | Cross-timeframe confirmation |
| **6: VPTR Analysis** | Early | Volume/Tick ratio | Tiered | Multiple | Large order detection |
| **7: Efficiency & Absorption** | Early | Price efficiency | Tiered | Multiple | Pressure buildup |
| **8: Velocity Breakout** | Breakout | Multi-velocity | Tiered | Multiple | Momentum confirmation |

## Usage Notes

### Getting Started

1. **Data Period:** All strategies designed for intraday charts (1-min, 5-min bars, tick charts)
2. **Parameter Tuning:** Adjust input parameters based on your specific market and timeframe
3. **Combination Approach:** Use multiple strategies together for stronger confirmation

### Recommended Strategy Combinations

**Conservative (Early Detection):**
- Strategy 1 (Volume-Price Divergence) 
- Strategy 3 (Statistical Anomaly)
- Strategy 6 (VPTR Analysis - Warning level only)

**Aggressive (Breakout Trading):**
- Strategy 5 (Multi-Timeframe)
- Strategy 7 (Efficiency - Strong/Critical levels)
- Strategy 8 (Velocity - All levels)

**Institutional Tracking:**
- Strategy 2 (Smart Money Flow)
- Strategy 4 (Cumulative Flow)
- Strategy 6 (VPTR Analysis)

**Comprehensive (Maximum Coverage):**
- Use all 8 strategies
- Weight Critical alerts highest
- Require 2+ Strong alerts for confirmation
- Use Warning alerts for monitoring only

**Institutional Monitoring:**
- Strategy 2 (Smart Money Flow) - Primary monitoring
- Strategy 6 (VPTR Analysis) - Large order detection
- Strategy 4 (Cumulative Flow) - Sustained accumulation

### Alert Interpretation Guide

**Single Alert (Strategies 1-5):**
- Binary signal: Alert or no alert
- Wait for daily signal
- Use for swing trading, longer holds
- Conservative entry strategy

**Tiered Alerts (Strategies 6-8):**

**Warning Level (ret=1):**
- Early indication, not actionable alone
- Add to watchlist
- Monitor for level increase
- Prepare analysis

**Strong Level (ret=2):**
- Significant pattern confirmed
- Consider partial position
- Set alerts for Critical level
- Review risk management

**Critical Level (ret=3):**
- Highest probability signal
- Consider full position entry
- Tight stop-loss recommended
- Monitor for continuation or reversal

### Integration Workflow

**General Workflow:**
```
Step 1: Run Strategies 1-5 (Early Detection)
   ↓
   Alert? → Add to watchlist
   ↓
Step 2: Monitor Strategies 6-7 (Pressure Building)
   ↓
   Warning/Strong? → Prepare for entry
   ↓
Step 3: Wait for Strategy 8 (Breakout Confirmation)
   ↓
   Strong/Critical? → Execute trade
   ↓
Step 4: Manage position with trailing stops
```

## XQScript GetField Reference

Key fields used across all strategies:

### Volume Metrics
- `GetField("成交量")` - Total volume (總成交量)
- `GetField("TradeVolumeAtAsk")` / `GetField("外盤量")` - Ask side volume (buying pressure)
- `GetField("TradeVolumeAtBid")` / `GetField("內盤量")` - Bid side volume (selling pressure)
- `GetField("BoardLotVolume")` / `GetField("盤中整股成交量")` - Board lot volume (institutional)
- `GetField("OddLotVolume")` / `GetField("盤中零股成交量")` - Odd lot volume (retail)

### Tick Metrics
- `GetField("TotalTicks")` / `GetField("總成交次數")` - Total tick count (all trades)
- `GetField("TotalInTicks")` / `GetField("內盤成交次數")` - Inner ticks count
- `GetField("TotalOutTicks")` / `GetField("外盤成交次數")` - Outer ticks count

### Additional Fields
- `GetField("InAvgVolume")` / `GetField("內盤均量")` - Inner average volume
- `GetField("OutAvgVolume")` / `GetField("外盤均量")` - Outer average volume
- `GetField("EstimateVolume")` / `GetField("估計量")` - Estimated volume

## Advanced Concepts Implemented

### From cursor_real_time_volume_change_alert.md

The new strategies (6-8) implement these advanced concepts:

1. **Volume Per Tick Ratio (VPTR)** - Strategy 6
   - Detects large orders by analyzing volume concentration per tick
   - Uses Z-score for statistical significance

2. **Tick Compression Index** - Strategy 6
   - Measures how volume is compressed into fewer ticks
   - Identifies institutional activity patterns

3. **Tick Efficiency Ratio** - Strategy 7
   - Measures price movement efficiency relative to volume
   - Lower efficiency = accumulation building

4. **Volume Absorption Rate** - Strategy 7
   - Tracks how quickly volume is being absorbed
   - Higher rate = strong demand

5. **Velocity Analysis** - Strategy 8
   - Tick Velocity: Trading frequency (ticks per minute)
   - Volume Velocity: Capital flow speed (volume per minute)
   - Price Velocity: Momentum (price change per minute)

6. **Three-Way Convergence** - Strategy 8
   - All three velocities accelerating together
   - Strongest breakout confirmation signal

## Testing & Optimization

### Recommended Testing Approach

1. **Backtest on Historical Data:**
   - Test each strategy independently
   - Identify optimal parameters for your market
   - Measure win rate, false positive rate

2. **Forward Test (Paper Trading):**
   - Run strategies in real-time without capital
   - Track all alert levels
   - Refine entry/exit rules

3. **Parameter Optimization:**
   - Start with default parameters
   - Adjust based on market volatility
   - Document optimal settings per timeframe

4. **Alert Validation:**
   - Track which alert levels are most accurate
   - Measure time from alert to price move
   - Calculate risk/reward ratios

### Performance Metrics to Track

- **True Positive Rate:** Correct signals / Total signals
- **False Positive Rate:** Incorrect signals / Total signals
- **Signal Lead Time:** Time from alert to price move
- **Average Price Move:** After each alert level
- **Optimal Holding Period:** Per alert level

---

**Created:** December 19, 2025  
**Updated:** December 19, 2025 (Added Strategies 6-8)  
**For:** Advanced tick volume analysis and real-time accumulation detection

## References

- Original concepts: `cursor_real_time_volume_change_alert.md`
- XQScript documentation: XQ Global platform
- GetField Reference: `XQScript_GetField_Reference.md`
- Strategies 1-5: Conservative daily alerts
- Strategies 6-8: Advanced tiered real-time alerts

