# Brooks Price Action XQScript Collection

## Overview

This collection implements Al Brooks' price action trading methodology in XQScript format, based on the comprehensive analysis in `PROJECT_ANALYSIS.md`. All scripts follow the structure and style patterns from the GR reference folder.

## Structure

```
01_scripts/
├── functions/
│   └── production/
│       ├── BrooksAlwaysIn.xs          # Always-In direction detection
│       ├── BrooksOverlapScore.xs      # Trading range vs trend indicator
│       ├── BrooksMicrochannel.xs      # Bull/bear run counters
│       ├── BrooksBar18Flag.xs         # Morning extreme detection
│       ├── BrooksOpeningRange.xs      # Opening range analysis
│       └── BrooksMeasuredMove.xs      # Target calculation
├── indicators/
│   └── production/
│       ├── BrooksAlwaysIn_Indicator.xs
│       ├── BrooksOverlapScore_Indicator.xs
│       ├── BrooksMicrochannel_Indicator.xs
│       ├── BrooksBar18_Indicator.xs
│       ├── BrooksOpeningRange_Indicator.xs
│       └── BrooksPriceAction_AllInOne_Indicator.xs
├── alerts/
│   └── production/
│       ├── BrooksAlwaysIn_Bull_Alert.xs
│       ├── BrooksAlwaysIn_Bear_Alert.xs
│       ├── BrooksOpeningRange_Breakout_Alert.xs
│       ├── BrooksBar18_Extreme_Alert.xs
│       ├── BrooksMicrochannel_Exhaustion_Alert.xs
│       ├── BrooksTrendPullback_Alert.xs
│       └── BrooksFailedBreakout_Alert.xs
└── screeners/
    └── production/
        ├── BrooksAlwaysIn_Bull_Screener.xs
        ├── BrooksAlwaysIn_Bear_Screener.xs
        ├── BrooksOpeningRange_Breakout_Screener.xs
        ├── BrooksTrendDay_Screener.xs
        ├── BrooksRangeDay_Screener.xs
        └── BrooksMicrochannel_Exhaustion_Screener.xs
```

## Key Concepts

### Always-In Direction
- Determines market bias (Bull/Bear/Neutral) using EMA20/EMA50
- Uses two-bar breakout logic
- Returns: 1=Bull, -1=Bear, 0=Neutral

### Overlap Score
- Measures trading range vs trend (0-1 scale)
- 0 = strong trend day
- 1 = strong range day
- Combines mid-time positioning (70%) and failed breakouts (30%)

### Microchannel Lengths
- Counts consecutive higher lows (bull run)
- Counts consecutive lower highs (bear run)
- Identifies trend exhaustion (≥6 bars)

### Bar-18 Flag
- Brooks heuristic: by bar 18, the day usually prints its high or low
- Flags when morning extremes hold as day extremes

### Opening Range
- First 6 bars (30 minutes) define opening range
- Calculates OR high, low, mid
- Detects breakouts and follow-through

### Measured Move
- Projects target based on first-hour leg magnitude
- Used for exhaustion analysis and profit targets

## Usage

### Indicators
Load indicators on 5-minute charts to visualize Brooks metrics:
- `BrooksPriceAction_AllInOne_Indicator.xs` - Comprehensive all-in-one indicator
- Individual indicators for specific metrics

### Alerts
Set up alerts to monitor:
- Always-In direction changes
- Opening range breakouts
- Bar-18 extreme holds
- Microchannel exhaustion
- Trend pullbacks
- Failed breakouts

### Screeners
Use screeners to find stocks meeting Brooks criteria:
- Always-In bullish/bearish stocks
- Opening range breakouts
- Strong trend days (low overlap)
- Range days (high overlap)
- Microchannel exhaustion

## Parameters

### Common Parameters
- **EMA20_Period**: Default 20 (EMA20 calculation period)
- **EMA50_Period**: Default 50 (EMA50 calculation period)
- **OR_Bars**: Default 6 (Opening range bars, 30 minutes on 5-min chart)
- **Window**: Default 24 (Overlap score calculation window)
- **MinVolume**: Default 500 (Minimum volume in lots for screeners)

### Alert-Specific Parameters
- **ExhaustionLevel**: Default 6 (Microchannel exhaustion threshold)
- **PullbackThreshold**: Default 0.25 (Pullback threshold as % of OR range)

### Screener-Specific Parameters
- **MaxOverlapScore**: Default 0.25 (Maximum overlap for trend days)
- **MinOverlapScore**: Default 0.75 (Minimum overlap for range days)
- **BreakoutDirection**: 1=Up, -1=Down, 0=Both
- **Direction**: 1=Bull, -1=Bear, 0=Both

## Notes

1. **Frequency**: Most scripts are designed for 5-minute charts (Brooks' default timeframe)
2. **Data Requirements**: Need sufficient historical bars (settotalbar(250) recommended)
3. **State Management**: Functions have limitations in XQScript, so stateful logic is embedded directly in indicators/alerts/screeners
4. **Performance**: Scripts are optimized for real-time calculation

## Implementation Details

### Always-In Detection
- Uses EMA20 and EMA50
- Two-bar breakout: `close > high[1] AND close[1] > high[2]` for bull
- Two-bar breakout: `close < low[1] AND close[1] < low[2]` for bear
- Price must be above/below EMA50 to maintain state

### Overlap Score Calculation
- Rolling high/low over window (default 20-24 bars)
- Measures how often price stays near middle of range
- Counts failed breakouts
- Combines mid-time positioning (70%) and failed breakouts (30%)

### Microchannel Lengths
- Counts consecutive higher lows (bull run)
- Counts consecutive lower highs (bear run)
- Resets when condition breaks

## References

- **Source Material**: Al Brooks' 26,000-word "How to Trade Price Action Manual"
- **Analysis Document**: `PROJECT_ANALYSIS.md`
- **Style Guide**: Based on `D:\OneDrive\Xscript\GR\03_docs\guides\STYLE_GUIDE.md`
- **Script Types**: See `D:\OneDrive\Xscript\GR\03_docs\guides\SCRIPT_TYPES.md`

## Version

- **Version**: 1.0
- **Date**: 2025-12-09
- **Author**: PriceActions Project

