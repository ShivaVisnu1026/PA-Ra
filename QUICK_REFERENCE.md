# Quick Reference: Volatility Calculations

## Your Question Answered

**Q: How to calculate average upside or downside volatility like +3% or -3% for the past 20 days?**

**A: Use the `calculate_upside_downside_volatility()` function:**

```python
from volatility_indicators import calculate_upside_downside_volatility
import yfinance as yf

# Fetch data
ticker = yf.Ticker("AAPL")
df = ticker.history(period="3mo")
df = df.reset_index()
df['Datetime'] = pd.to_datetime(df['Date'])

# Calculate
result = calculate_upside_downside_volatility(df, period=20)

# Results
print(f"Average Upside: +{result['avg_upside_pct']:.2f}%")
print(f"Average Downside: {result['avg_downside_pct']:.2f}%")
```

## Quick Start

### 1. Install dependencies (if needed)
```bash
pip install pandas numpy yfinance
```

### 2. Basic usage
```python
from volatility_indicators import calculate_volatility_metrics, format_volatility_report
import yfinance as yf

# Get stock data
ticker = yf.Ticker("AAPL")
df = ticker.history(period="3mo")
df = df.reset_index()
df['Datetime'] = pd.to_datetime(df['Date'])

# Calculate all metrics
metrics = calculate_volatility_metrics(df, period=20)

# Print report
print(format_volatility_report(metrics))
```

### 3. Run example
```bash
python example_volatility_calculation.py
```

## Available Functions

### `calculate_adr(df, period=20, use_percentage=False)`
- Calculates Average Daily Range
- Returns: ADR in $ and %, current range, ADR ratio

### `calculate_atr(df, period=14)`
- Calculates Average True Range (accounts for gaps)
- Returns: ATR in $ and %

### `calculate_upside_downside_volatility(df, period=20)`
- **This answers your question!**
- Calculates separate upside and downside volatility
- Returns: Average upside %, downside %, and absolute values

### `calculate_volatility_metrics(df, period=20)`
- Calculates all metrics at once
- Returns: Combined dictionary with ADR, ATR, and upside/downside

## Key Metrics Explained

| Metric | What It Means | Example |
|--------|---------------|---------|
| **ADR** | Average daily High-Low range | $3.50 or 2.3% |
| **ATR** | Average True Range (with gaps) | $3.52 or 2.35% |
| **Avg Upside** | Average move from Open to High | +3.2% |
| **Avg Downside** | Average move from Open to Low | -2.8% |
| **ADR Ratio** | Today's range / ADR | 1.22x (above average) |

## Common Use Cases

### "What's the average daily range?"
```python
adr = calculate_adr(df, period=20)
print(f"ADR: ${adr['adr_absolute']:.2f} ({adr['adr_percentage']:.2f}%)")
```

### "What's the average upside/downside move?"
```python
ud = calculate_upside_downside_volatility(df, period=20)
print(f"Upside: +{ud['avg_upside_pct']:.2f}%")
print(f"Downside: {ud['avg_downside_pct']:.2f}%")
```

### "Is today more volatile than average?"
```python
adr = calculate_adr(df, period=20)
if adr['adr_ratio'] > 1.2:
    print("Today is ABOVE average volatility")
elif adr['adr_ratio'] < 0.8:
    print("Today is BELOW average volatility")
```

## Files Created

1. **`volatility_indicators.py`** - Main module with all calculation functions
2. **`VOLATILITY_GUIDE.md`** - Comprehensive guide with formulas and strategies
3. **`example_volatility_calculation.py`** - Working examples
4. **`QUICK_REFERENCE.md`** - This file

## Integration with Existing Code

Your existing `app.py` already has a basic `range_vs_adr()` function. You can enhance it by:

```python
from volatility_indicators import calculate_volatility_metrics

# In your analysis section:
metrics = calculate_volatility_metrics(df_all.set_index("Datetime"), period=20)
adr_info = metrics['adr']
upside_downside = metrics['upside_downside']

# Use in your UI
st.metric("ADR", f"${adr_info['adr_absolute']:.2f} ({adr_info['adr_percentage']:.2f}%)")
st.metric("Avg Upside/Downside", 
          f"+{upside_downside['avg_upside_pct']:.2f}% / {upside_downside['avg_downside_pct']:.2f}%")
```

## Next Steps

1. Read `VOLATILITY_GUIDE.md` for detailed explanations
2. Run `example_volatility_calculation.py` to see it in action
3. Integrate into your existing `app.py` if desired
4. Customize periods and calculations for your needs








