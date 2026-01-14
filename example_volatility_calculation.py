"""
Example script demonstrating volatility calculations for stocks and indices.

This script shows how to:
1. Fetch stock data
2. Calculate various volatility metrics
3. Display results in a readable format
"""

import pandas as pd
import yfinance as yf
from volatility_indicators import (
    calculate_adr,
    calculate_atr,
    calculate_upside_downside_volatility,
    calculate_volatility_metrics,
    format_volatility_report
)


def example_single_stock(symbol: str = "AAPL", period: int = 20):
    """Example: Calculate volatility for a single stock."""
    print(f"\n{'='*70}")
    print(f"VOLATILITY ANALYSIS: {symbol} (Period: {period} days)")
    print(f"{'='*70}\n")
    
    # Fetch data
    print(f"Fetching data for {symbol}...")
    ticker = yf.Ticker(symbol)
    df = ticker.history(period="3mo")  # 3 months of daily data
    
    if df.empty:
        print(f"Error: Could not fetch data for {symbol}")
        return
    
    # Prepare dataframe
    df = df.reset_index()
    df['Datetime'] = pd.to_datetime(df['Date'])
    
    # Calculate all metrics
    metrics = calculate_volatility_metrics(df, period=period)
    
    # Print formatted report
    print(format_volatility_report(metrics))
    
    return metrics


def example_multiple_stocks(symbols: list = None, period: int = 20):
    """Example: Compare volatility across multiple stocks."""
    if symbols is None:
        symbols = ["AAPL", "MSFT", "GOOGL", "TSLA", "SPY"]
    
    print(f"\n{'='*70}")
    print(f"VOLATILITY COMPARISON (Period: {period} days)")
    print(f"{'='*70}\n")
    
    results = []
    
    for symbol in symbols:
        try:
            ticker = yf.Ticker(symbol)
            df = ticker.history(period="3mo")
            
            if df.empty:
                continue
            
            df = df.reset_index()
            df['Datetime'] = pd.to_datetime(df['Date'])
            
            # Calculate ADR and upside/downside
            adr = calculate_adr(df, period=period)
            ud = calculate_upside_downside_volatility(df, period=period)
            
            current_price = float(df['Close'].iloc[-1])
            
            results.append({
                'Symbol': symbol,
                'Price': f"${current_price:.2f}",
                'ADR ($)': f"${adr['adr_absolute']:.2f}" if adr.get('adr_absolute') else "N/A",
                'ADR (%)': f"{adr['adr_percentage']:.2f}%" if adr.get('adr_percentage') else "N/A",
                'Avg Upside': f"+{ud['avg_upside_pct']:.2f}%" if ud.get('avg_upside_pct') else "N/A",
                'Avg Downside': f"{ud['avg_downside_pct']:.2f}%" if ud.get('avg_downside_pct') else "N/A",
            })
        except Exception as e:
            print(f"Error processing {symbol}: {e}")
            continue
    
    # Display comparison table
    if results:
        df_results = pd.DataFrame(results)
        print(df_results.to_string(index=False))
        print()
    
    return results


def example_custom_calculation(symbol: str = "AAPL"):
    """Example: Custom calculation showing specific metrics."""
    print(f"\n{'='*70}")
    print(f"CUSTOM CALCULATION EXAMPLE: {symbol}")
    print(f"{'='*70}\n")
    
    # Fetch data
    ticker = yf.Ticker(symbol)
    df = ticker.history(period="3mo")
    df = df.reset_index()
    df['Datetime'] = pd.to_datetime(df['Date'])
    
    # Calculate upside/downside volatility (this answers your specific question)
    ud = calculate_upside_downside_volatility(df, period=20)
    
    print("Average Daily Volatility (Past 20 Days):")
    print("-" * 50)
    
    if ud.get('avg_upside_pct'):
        print(f"Average Upside Volatility: +{ud['avg_upside_pct']:.2f}%")
        print(f"  (Stock typically moves up {ud['avg_upside_pct']:.2f}% from open to high)")
        print()
        print(f"Average Downside Volatility: {ud['avg_downside_pct']:.2f}%")
        print(f"  (Stock typically moves down {abs(ud['avg_downside_pct']):.2f}% from open to low)")
        print()
        
        # Interpretation
        if abs(ud['avg_upside_pct']) > abs(ud['avg_downside_pct']):
            print("📈 This stock is more volatile to the UPSIDE")
        elif abs(ud['avg_downside_pct']) > abs(ud['avg_upside_pct']):
            print("📉 This stock is more volatile to the DOWNSIDE")
        else:
            print("⚖️  This stock has balanced upside/downside volatility")
        
        print()
        print("Trading Implications:")
        print(f"  • Long positions: Expect potential moves up to +{ud['avg_upside_pct']:.2f}%")
        print(f"  • Short positions: Expect potential moves down to {ud['avg_downside_pct']:.2f}%")
        print(f"  • Stop losses: Consider {abs(ud['avg_downside_pct']) * 0.5:.2f}% for longs")
        print(f"  • Profit targets: Consider {ud['avg_upside_pct'] * 0.75:.2f}% for longs")
    else:
        print("Insufficient data for calculation")
    
    return ud


def example_indices():
    """Example: Calculate volatility for major indices."""
    indices = {
        "SPY": "S&P 500",
        "QQQ": "NASDAQ 100",
        "DIA": "Dow Jones",
        "IWM": "Russell 2000"
    }
    
    print(f"\n{'='*70}")
    print("INDEX VOLATILITY ANALYSIS (Period: 20 days)")
    print(f"{'='*70}\n")
    
    for symbol, name in indices.items():
        try:
            ticker = yf.Ticker(symbol)
            df = ticker.history(period="3mo")
            
            if df.empty:
                continue
            
            df = df.reset_index()
            df['Datetime'] = pd.to_datetime(df['Date'])
            
            adr = calculate_adr(df, period=20)
            ud = calculate_upside_downside_volatility(df, period=20)
            
            print(f"{name} ({symbol}):")
            if adr.get('adr_percentage'):
                print(f"  ADR: {adr['adr_percentage']:.2f}%")
            if ud.get('avg_upside_pct'):
                print(f"  Avg Upside: +{ud['avg_upside_pct']:.2f}%")
                print(f"  Avg Downside: {ud['avg_downside_pct']:.2f}%")
            print()
        except Exception as e:
            print(f"Error processing {symbol}: {e}")
            continue


if __name__ == "__main__":
    # Example 1: Single stock analysis
    print("\n" + "="*70)
    print("EXAMPLE 1: Single Stock Analysis")
    print("="*70)
    example_single_stock("AAPL", period=20)
    
    # Example 2: Custom calculation (answers your specific question)
    print("\n" + "="*70)
    print("EXAMPLE 2: Upside/Downside Volatility (Your Question)")
    print("="*70)
    example_custom_calculation("AAPL")
    
    # Example 3: Compare multiple stocks
    print("\n" + "="*70)
    print("EXAMPLE 3: Multi-Stock Comparison")
    print("="*70)
    example_multiple_stocks(["AAPL", "MSFT", "TSLA", "SPY"], period=20)
    
    # Example 4: Index analysis
    print("\n" + "="*70)
    print("EXAMPLE 4: Index Volatility")
    print("="*70)
    example_indices()
    
    print("\n" + "="*70)
    print("All examples completed!")
    print("="*70)








