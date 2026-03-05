# Flattish Moving Average Definitions

This document defines the criteria for determining when moving averages are considered "flattish" or in consolidation mode, using the `IsMARangeFlatByRatio` function.

## Function Overview

```xscript
// Returns 1 if MA is flat, 0 if trending
IsMARangeFlatByRatio(MAType, RangeLength, ThresholdPct)
```

**Logic**: 
- Calculates: `(Highest(MA) - Lowest(MA)) / CurrentMA` over RangeLength bars
- Compares ratio to ThresholdPct
- Returns true if ratio < threshold

---

## Flattish MA Criteria

### EMA8 - Short-Term Flat
**Purpose**: Detect immediate price consolidation

```xscript
var: isEMA8Flat(false);
isEMA8Flat = IsMARangeFlatByRatio("EMA8", 5, 0.3);
```

- **RangeLength**: 5 bars
- **ThresholdPct**: 0.3% (0.003)
- **Rationale**: Fast MA needs tight criteria; 5 bars = short consolidation period
- **Use Case**: Entry timing, avoid choppy markets

---

### EMA20 - Primary Trend Flat
**Purpose**: Identify short-term trend pause

```xscript
var: isEMA20Flat(false);
isEMA20Flat = IsMARangeFlatByRatio("EMA20", 10, 0.5);
```

- **RangeLength**: 10 bars
- **ThresholdPct**: 0.5% (0.005)
- **Rationale**: 10 bars = half period; allows for minor fluctuation
- **Use Case**: Wait for breakout, reduce trading frequency

---

### EMA56 - Support Level Flat
**Purpose**: Stable support zone identification

```xscript
var: isEMA56Flat(false);
isEMA56Flat = IsMARangeFlatByRatio("EMA56", 20, 0.8);
```

- **RangeLength**: 20 bars
- **ThresholdPct**: 0.8% (0.008)
- **Rationale**: Medium-term MA, observe ~1/3 of period for stability
- **Use Case**: Strong horizontal support formation

---

### SMA89 - Resistance Level Flat
**Purpose**: Stable resistance zone identification

```xscript
var: isSMA89Flat(false);
isSMA89Flat = IsMARangeFlatByRatio("SMA89", 25, 1.0);
```

- **RangeLength**: 25 bars
- **ThresholdPct**: 1.0% (0.010)
- **Rationale**: SMA smoother than EMA; 25 bars = ~1/4 period observation
- **Use Case**: Strong horizontal resistance formation

---

### EMA233 - Major Trend Flat
**Purpose**: Long-term market consolidation

```xscript
var: isEMA233Flat(false);
isEMA233Flat = IsMARangeFlatByRatio("EMA233", 50, 1.5);
```

- **RangeLength**: 50 bars
- **ThresholdPct**: 1.5% (0.015)
- **Rationale**: Long-term MA; 50 bars observation for meaningful trend assessment
- **Use Case**: Market regime detection, sideways vs trending

---

## Combined Usage Examples

### Example 1: Wait for Breakout Setup
```xscript
// All MAs must be flat for sideways market
var: isSidewaysMarket(false);
isSidewaysMarket = IsMARangeFlatByRatio("EMA8", 5, 0.3)
               and IsMARangeFlatByRatio("EMA20", 10, 0.5)
               and IsMARangeFlatByRatio("EMA56", 20, 0.8);

// Wait for breakout from consolidation
if isSidewaysMarket then begin
    // Prepare for volatility expansion
    // Tighten stops, reduce position size
end;
```

### Example 2: Trend Confirmation
```xscript
// EMA233 flat = no major trend
// EMA8 not flat = short-term momentum
var: isRangebound(false), hasShortMomentum(false);

isRangebound = IsMARangeFlatByRatio("EMA233", 50, 1.5);
hasShortMomentum = not IsMARangeFlatByRatio("EMA8", 5, 0.3);

// Good for scalping in range
if isRangebound and hasShortMomentum then begin
    // Trade short-term swings
end;
```

### Example 3: Support/Resistance Quality
```xscript
// Flat EMA56 and SMA89 = strong S/R zone
var: isStrongSRZone(false);
isStrongSRZone = IsMARangeFlatByRatio("EMA56", 20, 0.8)
              and IsMARangeFlatByRatio("SMA89", 25, 1.0);

// High probability bounce/rejection expected
if isStrongSRZone then begin
    // Price approaching horizontal channel
    // Watch for reversal patterns
end;
```

---

## Threshold Guidelines

| MA Speed | Threshold Range | Typical Use |
|----------|----------------|-------------|
| **Fast** (EMA8, EMA20) | 0.3% - 0.5% | Tight consolidation detection |
| **Medium** (EMA56, SMA89) | 0.8% - 1.0% | Horizontal S/R zones |
| **Slow** (EMA233) | 1.5%+ | Market regime (trending vs sideways) |

### Adjusting Parameters

**More Sensitive** (detect slight flattening):
- Increase RangeLength
- Increase ThresholdPct

**Less Sensitive** (only detect very flat MAs):
- Decrease RangeLength
- Decrease ThresholdPct

---

## Visual Interpretation

```
Flattish MA Pattern:
Price ~~~~~~~~~~~~~~~~~~~~  (EMA8: 0.3% range over 5 bars)
      ===================   (EMA56: 0.8% range over 20 bars)
      ===================   (SMA89: 1.0% range over 25 bars)

Trending MA Pattern:
Price      ///////////////  (EMA8: >0.3% range - trending up)
      ////                  (EMA56: >0.8% range - trending)
```

---

## Notes

- **Shorter RangeLength** = More responsive to recent flattening
- **Longer RangeLength** = Confirms sustained flatness
- **Lower ThresholdPct** = Stricter flat definition
- **Higher ThresholdPct** = More lenient, catches slight consolidation
- Adjust based on:
  - Timeframe (daily vs intraday)
  - Market volatility (high vs low)
  - Trading style (scalping vs swing)

---

**Created**: 2025-10-24  
**Last Updated**: 2025-10-24  
**Related**: EMA_Definitions.md

