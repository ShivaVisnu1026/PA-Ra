# EMA Definitions Reference

This document defines all EMA calculations used in trading strategies. Use this as a reference for consistent implementation across different strategies and timeframes.

---

## Moving Average Definitions

### EMA8 - Multi-Price Average (Typical Price)
- **Period**: 8
- **Source**: Typical Price = `(Close + Open + High + Low) / 4`
- **Type**: Exponential Moving Average (EMA)
- **Purpose**: Short-term trend detection with reduced noise
- **Usage**: Short-term trend identification, entry timing
- **Timeframe Application**: Use period 8 for both daily and weekly charts

**XScript Calculation:**
```xscript
var: typicalPrice(0), ema8(0);
typicalPrice = (close + open + high + low) / 4;
ema8 = XAverage(typicalPrice, 8);
```

**Characteristics:**
- Uses all OHLC values for balanced representation
- Less sensitive to individual price spikes
- Ideal for short-term trend confirmation

---

### EMA20 - Standard Trend
- **Period**: 20
- **Source**: Close prices
- **Type**: Exponential Moving Average (EMA)
- **Purpose**: Medium-term trend detection
- **Usage**: Primary trend identification, flattish detection
- **Timeframe Application**: Use period 20 for both daily and weekly charts

**XScript Calculation:**
```xscript
var: ema20(0);
ema20 = XAverage(close, 20);
// Alternative: ema20 = EMA(close, 20);
```

**Characteristics:**
- Standard EMA widely used in trading
- Good balance between responsiveness and smoothing
- Common reference for trend direction

---

### EMA56 - Low-Based Support
- **Period**: 56
- **Source**: Low prices
- **Type**: Exponential Moving Average (EMA)
- **Purpose**: Medium-term support level tracking
- **Usage**: Support identification, lower boundary in price zones
- **Timeframe Application**: Use period 56 for both daily and weekly charts

**XScript Calculation:**
```xscript
var: ema56(0);
ema56 = XAverage(low, 56);
```

**Characteristics:**
- Tracks lower price action
- Acts as dynamic support in uptrends
- Creates lower bound of consolidation zone (with SMA89)

---

### SMA89 - High-Based Resistance
- **Period**: 89
- **Source**: High prices
- **Type**: Simple Moving Average (SMA, not exponential)
- **Purpose**: Medium-term resistance level tracking
- **Usage**: Resistance identification, upper boundary in price zones
- **Timeframe Application**: Use period 89 for both daily and weekly charts

**XScript Calculation:**
```xscript
var: sma89(0);
sma89 = Average(high, 89);
```

**Characteristics:**
- Tracks upper price action
- Acts as dynamic resistance in downtrends
- Creates upper bound of consolidation zone (with EMA56)
- Uses SMA for more stable resistance levels

---

### EMA233 - Weighted Close Long-Term Filter
- **Period**: 233
- **Source**: Weighted Close = `(High + Low + Close * 2) / 4`
- **Type**: Exponential Moving Average (EMA)
- **Purpose**: Long-term trend direction filter
- **Usage**: Major trend confirmation, long-term filter
- **Timeframe Application**: Use period 233 for both daily and weekly charts

**XScript Calculation:**
```xscript
var: weightedClose(0), ema233(0);
weightedClose = (high + low + (close * 2)) / 4;
ema233 = XAverage(weightedClose, 233);
```

**Characteristics:**
- Emphasizes closing prices (weighted 2x)
- Captures long-term trend direction
- Used as major trend filter
- Very slow to react, filters noise

---

## Timeframe Application

### Daily Charts
All EMAs use their standard periods:
- EMA8: Period 8 (~8 trading days ≈ 1.6 weeks)
- EMA20: Period 20 (~20 trading days ≈ 1 month)
- EMA56: Period 56 (~56 trading days ≈ 11 weeks)
- SMA89: Period 89 (~89 trading days ≈ 4.3 months)
- EMA233: Period 233 (~233 trading days ≈ 11.7 months ≈ 1 year)

### Weekly Charts
**Keep the same periods** (do not adjust):
- EMA8: Period 8 (~8 weeks ≈ 2 months)
- EMA20: Period 20 (~20 weeks ≈ 5 months)
- EMA56: Period 56 (~56 weeks ≈ 1.1 years)
- SMA89: Period 89 (~89 weeks ≈ 1.7 years)
- EMA233: Period 233 (~233 weeks ≈ 4.5 years)

**Rationale for keeping same periods:**
- Maintains calendar lookback duration
- Preserves relationships between EMAs
- Consistent with codebase implementations
- Standard industry practice

---

## Strategy Applications

### Price Action Zones

**Bullish Territory:**
- Price above SMA89: Strong bullish zone
- Price above EMA56: Bullish zone

**Bearish Territory:**
- Price below EMA56: Strong bearish zone
- Price below SMA89: Bearish zone

**Consolidation Zone:**
- Price between EMA56 and SMA89: Neutral/consolidation zone
- Wait for breakout above SMA89 (bullish) or below EMA56 (bearish)

### Trend Confirmation

**Bullish Trend:**
- EMA8 > EMA233
- EMA20 > EMA56 (if using EMA20)
- Price above SMA89

**Bearish Trend:**
- EMA8 < EMA233
- EMA20 < EMA56 (if using EMA20)
- Price below EMA56

**Neutral/Unclear:**
- EMA8 ≈ EMA233 (converging/crossing)
- Price between EMA56 and SMA89
- Wait for clearer directional signal

### Trade Signal Patterns

**Bullish Setup:**
1. Price crosses above EMA8
2. EMA8 > EMA233 (trend confirmation)
3. Price bounces off EMA56 (support test)
4. Price above SMA89 (strong territory)

**Bearish Setup:**
1. Price crosses below EMA8
2. EMA8 < EMA233 (trend confirmation)
3. Price rejects at SMA89 (resistance test)
4. Price below EMA56 (strong territory)

**Neutral/Consolidation:**
- Price between EMA56 and SMA89
- EMA8 and EMA233 converging
- Wait for breakout direction

---

## EMA Relationships

### Short-Term vs Long-Term
- **EMA8 vs EMA233**: Primary trend filter
  - EMA8 > EMA233 = Bullish
  - EMA8 < EMA233 = Bearish
  - Divergence = Strong trend
  - Convergence = Weakening trend or range

### Support/Resistance Channel
- **EMA56 (low) + SMA89 (high)**: Dynamic price channel
  - Zone between = Consolidation/trading range
  - Price outside = Strong directional move
  - Convergence = Potential breakout setup

### Multi-Timeframe Analysis
- Use same periods across timeframes for consistency
- Higher timeframe EMAs provide trend context
- Lower timeframe EMAs provide entry timing

---

## Implementation Notes

### Code Consistency
- Always use the exact formulas specified
- Use `XAverage()` for EMAs in XScript
- Use `Average()` for SMA89 (not EMA)
- Maintain consistent variable naming

### Data Requirements
- Minimum bars needed: 233+ for EMA233
- Recommended: 300+ bars for reliable calculations
- Ensure sufficient historical data before using

### Performance Considerations
- EMA8: Fast, responsive to price changes
- EMA20: Balanced responsiveness
- EMA56/SMA89: Medium-term smoothing
- EMA233: Slow, long-term filter

### Design Philosophy
- **EMA8 (typical price)**: Reduces noise from individual OHLC spikes
- **EMA56 (low)**: Tracks support, lower price action
- **SMA89 (high)**: Tracks resistance, upper price action (SMA for stability)
- **EMA233 (weighted close)**: Long-term filter emphasizing closing strength
- **EMA20 (close)**: Standard medium-term trend reference

---

## Quick Reference Table

| EMA | Period | Source | Type | Purpose | Weekly Period |
|-----|--------|--------|------|---------|---------------|
| EMA8 | 8 | Typical Price | EMA | Short-term trend | 8 (same) |
| EMA20 | 20 | Close | EMA | Medium-term trend | 20 (same) |
| EMA56 | 56 | Low | EMA | Support level | 56 (same) |
| SMA89 | 89 | High | SMA | Resistance level | 89 (same) |
| EMA233 | 233 | Weighted Close | EMA | Long-term filter | 233 (same) |

---

## Related Documentation

- Market Cycle Classification: See `MarketCycle/Market_Cycle_Price_Action.md`
- Flattish MA Definitions: See `Flattish_MA_Definitions.md`

---

**Created**: 2025-10-19  
**Last Updated**: 2025-01-XX  
**Version**: 2.0 (Comprehensive Reference)
