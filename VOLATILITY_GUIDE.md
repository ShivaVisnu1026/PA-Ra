# Trading Range and Volatility Calculation Guide

This guide explains various strategies, formulas, and technical indicators for calculating average daily trading range and volatility for stocks and indices.

## Overview

Understanding a stock's average daily trading range helps traders:
- Set realistic profit targets
- Determine appropriate stop-loss levels
- Assess whether current volatility is above or below normal
- Plan position sizing based on expected price movement

## Key Indicators

### 1. Average Daily Range (ADR)

**Formula:**
```
ADR = Average(High - Low) over N days
```

**Calculation:**
- Take the daily range (High - Low) for each day
- Average these ranges over the specified period (typically 14-20 days)
- Can be expressed in absolute terms ($) or as a percentage

**Usage:**
- Compare today's range to ADR to see if volatility is elevated
- Use ADR to set profit targets (e.g., 1x ADR, 2x ADR)
- Use ADR to set stop-losses (e.g., 0.5x ADR away from entry)

**Example:**
If AAPL has an ADR of $3.50 over 20 days:
- A day with a $5.00 range is above average (1.43x ADR)
- A day with a $2.00 range is below average (0.57x ADR)

### 2. Average True Range (ATR)

**Formula:**
```
True Range = Max of:
  - Current High - Current Low
  - |Current High - Previous Close|
  - |Current Low - Previous Close|

ATR = Exponential Moving Average of True Range (typically 14 periods)
```

**Why ATR?**
- Accounts for gaps between trading sessions
- More accurate for stocks that gap up/down frequently
- Smoothed using exponential moving average (Wilder's method)

**Usage:**
- Similar to ADR but accounts for overnight gaps
- Popular in position sizing formulas (e.g., risk 1% of account per 1 ATR)
- Used in many trading systems for stop-loss placement

### 3. Average Upside/Downside Volatility

**Formula:**
```
Average Upside = Average(High - Open) over N days
Average Downside = Average(Open - Low) over N days

Or as percentages:
Average Upside % = Average((High - Open) / Open * 100)
Average Downside % = Average((Open - Low) / Open * 100)
```

**This answers your question directly!**

If you want to know "the average upside or downside volatility is +3% or -3% for the past 20 days":

1. **Range-based approach:**
   - Calculate (High - Open) / Open * 100 for each day
   - Average the positive values → Average Upside %
   - Calculate (Open - Low) / Open * 100 for each day
   - Average these values → Average Downside %

2. **Net move approach:**
   - Calculate (Close - Open) / Open * 100 for each day
   - Average positive days → Average gain on up days
   - Average negative days → Average loss on down days

**Example Output:**
```
Average Upside Move: +3.2% ($4.50)
Average Downside Move: -2.8% ($3.90)
```

This tells you:
- On average, the stock moves up 3.2% from open to high
- On average, the stock moves down 2.8% from open to low
- The stock is slightly more volatile to the upside

## Common Periods

Different timeframes serve different purposes:

- **14 days**: Standard ATR period, captures recent volatility
- **20 days**: Common ADR period, balances recent vs. historical
- **30 days**: Longer-term average, smoother but less responsive
- **60 days**: Long-term average, very smooth but may miss recent changes

## Practical Applications

### Setting Profit Targets

**Method 1: ADR-based targets**
```
Target = Entry Price ± (ADR × Multiplier)
```
- Conservative: 0.5x ADR
- Moderate: 1x ADR
- Aggressive: 2x ADR

**Method 2: Upside/Downside volatility**
```
Long Target = Entry Price × (1 + Average Upside %)
Short Target = Entry Price × (1 - Average Downside %)
```

### Setting Stop Losses

**Method 1: ADR-based stops**
```
Stop Loss = Entry Price ± (ADR × 0.5)
```

**Method 2: ATR-based stops**
```
Stop Loss = Entry Price ± (ATR × 1.5)
```

**Method 3: Percentage-based**
```
Stop Loss = Entry Price × (1 - Average Downside % × 0.5)
```

### Position Sizing

**ATR-based position sizing:**
```
Position Size = (Account Risk %) / (ATR / Price)
```

Example:
- Account: $10,000
- Risk per trade: 1% = $100
- Stock price: $150
- ATR: $3.00
- ATR %: 2%
- Position size: $100 / 0.02 = $5,000 worth of stock

## Implementation

See `volatility_indicators.py` for complete implementations of all these methods.

### Quick Start

```python
import yfinance as yf
from volatility_indicators import calculate_volatility_metrics, format_volatility_report

# Fetch data
ticker = yf.Ticker("AAPL")
df = ticker.history(period="3mo")
df = df.reset_index()
df['Datetime'] = pd.to_datetime(df['Date'])

# Calculate metrics
metrics = calculate_volatility_metrics(df, period=20)

# Print report
print(format_volatility_report(metrics))
```

## Advanced Techniques

### 1. Rolling Volatility Windows

Calculate ADR over multiple periods to see volatility trends:
- 10-day ADR (short-term)
- 20-day ADR (medium-term)
- 60-day ADR (long-term)

Compare them to see if volatility is increasing or decreasing.

### 2. Volatility Percentiles

Instead of just average, calculate:
- 25th percentile (low volatility days)
- 50th percentile (median)
- 75th percentile (high volatility days)
- 90th percentile (extreme volatility)

This helps identify when current volatility is in the "extreme" range.

### 3. Relative Volatility

Compare a stock's volatility to:
- Its own historical average
- Market volatility (e.g., SPY)
- Sector average

Formula:
```
Relative Volatility = Stock ADR / Market ADR
```

### 4. Intraday vs. Daily Volatility

Some stocks have high intraday volatility but close near the open:
- Calculate intraday range (High - Low)
- Calculate net move (Close - Open)
- Compare to see if moves are being reversed

## Common Trading Strategies Using Volatility

### 1. Mean Reversion in Low Volatility

When ADR ratio < 0.7 (below average volatility):
- Expect potential breakout
- Range may expand soon
- Consider breakout strategies

### 2. Range Expansion After Compression

When recent ADR < 0.5x long-term ADR:
- Volatility compression often precedes expansion
- Prepare for larger moves
- Adjust position sizes accordingly

### 3. Volatility Breakout

When today's range > 1.5x ADR:
- Unusual volatility
- May indicate news or major move
- Consider if move will continue or reverse

## Best Practices

1. **Use multiple periods**: Don't rely on just one timeframe
2. **Compare to market**: Is this stock's volatility normal for the market?
3. **Update regularly**: Volatility changes, recalculate weekly
4. **Consider context**: Earnings, news, and events affect volatility
5. **Combine with other indicators**: Use volatility with trend, volume, etc.

## References

- **ADR (Average Daily Range)**: Popularized by day traders, measures typical daily movement
- **ATR (Average True Range)**: Developed by J. Welles Wilder, accounts for gaps
- **Volatility Clustering**: Volatility tends to cluster (high vol days followed by high vol days)

## Example Output

```
============================================================
VOLATILITY METRICS (Period: 20 days)
============================================================

📊 AVERAGE DAILY RANGE (ADR):
  • ADR (Absolute): $3.45
  • ADR (Percentage): 2.30%
  • Today's Range: $4.20 (2.80%)
  • Today vs ADR: 1.22x (ABOVE AVERAGE)

📈 AVERAGE TRUE RANGE (ATR):
  • ATR (Absolute): $3.52
  • ATR (Percentage): 2.35%

⬆️⬇️ UPSIDE / DOWNSIDE VOLATILITY:
  • Average Upside Move: +3.20% ($4.50)
  • Average Downside Move: -2.80% ($3.90)
  • Average Range Upside: +2.15%
  • Average Range Downside: -1.85%
  • Avg Positive Days: +1.45%
  • Avg Negative Days: -1.32%

============================================================
```

This tells you:
- The stock typically moves $3.45 per day (2.30%)
- Today is more volatile than average (1.22x)
- On average, it moves up 3.20% from open to high
- On average, it moves down 2.80% from open to low
- The stock is slightly more volatile to the upside



