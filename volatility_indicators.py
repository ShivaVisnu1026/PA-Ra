"""
Volatility and Trading Range Indicators

This module provides various methods to calculate average daily trading range
and volatility metrics for stocks and indices.

Key Indicators:
1. ADR (Average Daily Range) - Average of daily High-Low ranges
2. ATR (Average True Range) - Smoothed volatility indicator
3. Average Upside/Downside Volatility - Separate positive and negative moves
4. Percentage-based volatility calculations
"""

import numpy as np
import pandas as pd
from typing import Dict, Optional, Tuple


def calculate_adr(df: pd.DataFrame, period: int = 20, use_percentage: bool = False) -> Dict:
    """
    Calculate Average Daily Range (ADR).
    
    ADR is the average of daily High-Low ranges over a specified period.
    This is one of the most common ways to measure average daily volatility.
    
    Parameters:
    -----------
    df : pd.DataFrame
        DataFrame with columns: 'High', 'Low', 'Close' (and optionally 'Open')
        Index should be datetime or have a datetime column
    period : int, default 20
        Number of days to average over
    use_percentage : bool, default False
        If True, returns percentage of ADR relative to closing price
        If False, returns absolute dollar/point values
    
    Returns:
    --------
    dict with keys:
        - 'adr_absolute': Average daily range in absolute terms
        - 'adr_percentage': Average daily range as percentage
        - 'current_range': Today's range
        - 'adr_ratio': Current range / ADR (shows if today is above/below average)
        - 'period': Period used
    """
    # Ensure we have daily data
    if 'Datetime' in df.columns:
        df = df.set_index('Datetime')
    
    # Resample to daily if needed (get max High and min Low per day)
    daily_high = df['High'].resample('1D').max()
    daily_low = df['Low'].resample('1D').min()
    daily_close = df['Close'].resample('1D').last()
    
    # Calculate daily ranges
    daily_ranges = daily_high - daily_low
    
    # Get last N days
    recent_ranges = daily_ranges.dropna().tail(period)
    
    if len(recent_ranges) < period:
        # Not enough data
        return {
            'adr_absolute': None,
            'adr_percentage': None,
            'current_range': float(daily_ranges.iloc[-1]) if len(daily_ranges) > 0 else None,
            'adr_ratio': None,
            'period': period,
            'error': 'Insufficient data'
        }
    
    # Calculate ADR
    adr_absolute = float(recent_ranges.mean())
    
    # Calculate percentage ADR (using average closing price)
    avg_close = float(daily_close.tail(period).mean())
    adr_percentage = (adr_absolute / avg_close * 100) if avg_close > 0 else None
    
    # Current day's range
    current_range = float(daily_ranges.iloc[-1])
    current_range_pct = (current_range / float(daily_close.iloc[-1]) * 100) if daily_close.iloc[-1] > 0 else None
    
    # ADR ratio (how today compares to average)
    adr_ratio = (current_range / adr_absolute) if adr_absolute > 0 else None
    
    result = {
        'adr_absolute': adr_absolute,
        'adr_percentage': adr_percentage,
        'current_range': current_range,
        'current_range_pct': current_range_pct,
        'adr_ratio': adr_ratio,
        'period': period
    }
    
    return result


def calculate_atr(df: pd.DataFrame, period: int = 14) -> Dict:
    """
    Calculate Average True Range (ATR).
    
    ATR is a volatility indicator that accounts for gaps between sessions.
    It uses the maximum of:
    - Current High - Current Low
    - |Current High - Previous Close|
    - |Current Low - Previous Close|
    
    Parameters:
    -----------
    df : pd.DataFrame
        DataFrame with columns: 'High', 'Low', 'Close'
    period : int, default 14
        Period for smoothing (typically 14 days)
    
    Returns:
    --------
    dict with keys:
        - 'atr': Current ATR value
        - 'atr_percentage': ATR as percentage of current price
        - 'period': Period used
    """
    if 'Datetime' in df.columns:
        df = df.set_index('Datetime')
    
    # Resample to daily
    daily_high = df['High'].resample('1D').max()
    daily_low = df['Low'].resample('1D').min()
    daily_close = df['Close'].resample('1D').last()
    
    # Calculate True Range components
    tr1 = daily_high - daily_low
    tr2 = abs(daily_high - daily_close.shift(1))
    tr3 = abs(daily_low - daily_close.shift(1))
    
    # True Range is the maximum of the three
    true_range = pd.concat([tr1, tr2, tr3], axis=1).max(axis=1)
    
    # Calculate ATR using exponential moving average (Wilder's smoothing)
    atr = true_range.ewm(alpha=1/period, adjust=False).mean()
    
    current_atr = float(atr.iloc[-1]) if len(atr) > 0 else None
    current_price = float(daily_close.iloc[-1]) if len(daily_close) > 0 else None
    atr_percentage = (current_atr / current_price * 100) if current_atr and current_price and current_price > 0 else None
    
    return {
        'atr': current_atr,
        'atr_percentage': atr_percentage,
        'period': period
    }


def calculate_upside_downside_volatility(df: pd.DataFrame, period: int = 20) -> Dict:
    """
    Calculate separate average upside and downside volatility.
    
    This calculates:
    - Average upside move: Average of positive daily moves (High - Open or Close - Open if positive)
    - Average downside move: Average of negative daily moves (Low - Open or Close - Open if negative)
    
    This gives you metrics like "+3% average upside, -3% average downside"
    
    Parameters:
    -----------
    df : pd.DataFrame
        DataFrame with columns: 'Open', 'High', 'Low', 'Close'
    period : int, default 20
        Number of days to average over
    
    Returns:
    --------
    dict with keys:
        - 'avg_upside_absolute': Average upside move in absolute terms
        - 'avg_upside_pct': Average upside move as percentage
        - 'avg_downside_absolute': Average downside move in absolute terms
        - 'avg_downside_pct': Average downside move as percentage
        - 'avg_range_upside_pct': Average % from open to high
        - 'avg_range_downside_pct': Average % from open to low
        - 'period': Period used
    """
    if 'Datetime' in df.columns:
        df = df.set_index('Datetime')
    
    # Resample to daily
    daily_open = df['Open'].resample('1D').first()
    daily_high = df['High'].resample('1D').max()
    daily_low = df['Low'].resample('1D').min()
    daily_close = df['Close'].resample('1D').last()
    
    # Calculate daily moves from open
    upside_moves = daily_high - daily_open  # Maximum upside from open
    downside_moves = daily_open - daily_low  # Maximum downside from open
    
    # Also calculate close-to-open moves (net direction)
    net_moves = daily_close - daily_open
    positive_moves = net_moves[net_moves > 0]
    negative_moves = net_moves[net_moves < 0]
    
    # Get last N days
    recent_upside = upside_moves.tail(period)
    recent_downside = downside_moves.tail(period)
    recent_positive = positive_moves.tail(period)
    recent_negative = negative_moves.tail(period)
    recent_open = daily_open.tail(period)
    
    if len(recent_upside) < period:
        return {
            'avg_upside_absolute': None,
            'avg_upside_pct': None,
            'avg_downside_absolute': None,
            'avg_downside_pct': None,
            'avg_range_upside_pct': None,
            'avg_range_downside_pct': None,
            'period': period,
            'error': 'Insufficient data'
        }
    
    # Calculate averages
    avg_upside_absolute = float(recent_upside.mean())
    avg_downside_absolute = float(recent_downside.mean())
    
    # Calculate as percentages
    avg_open = float(recent_open.mean())
    avg_upside_pct = (avg_upside_absolute / avg_open * 100) if avg_open > 0 else None
    avg_downside_pct = (avg_downside_absolute / avg_open * 100) if avg_open > 0 else None
    
    # Also calculate average range percentages
    range_upside_pct = ((daily_high - daily_open) / daily_open * 100).tail(period)
    range_downside_pct = ((daily_open - daily_low) / daily_open * 100).tail(period)
    
    avg_range_upside_pct = float(range_upside_pct.mean())
    avg_range_downside_pct = float(range_downside_pct.mean())
    
    # Average of positive/negative net moves
    avg_positive_move_pct = float((positive_moves / daily_open[positive_moves.index] * 100).tail(period).mean()) if len(positive_moves) > 0 else None
    avg_negative_move_pct = float((negative_moves / daily_open[negative_moves.index] * 100).tail(period).mean()) if len(negative_moves) > 0 else None
    
    return {
        'avg_upside_absolute': avg_upside_absolute,
        'avg_upside_pct': avg_upside_pct,
        'avg_downside_absolute': avg_downside_absolute,
        'avg_downside_pct': avg_downside_pct,
        'avg_range_upside_pct': avg_range_upside_pct,
        'avg_range_downside_pct': avg_range_downside_pct,
        'avg_positive_move_pct': avg_positive_move_pct,
        'avg_negative_move_pct': avg_negative_move_pct,
        'period': period
    }


def calculate_volatility_metrics(df: pd.DataFrame, period: int = 20) -> Dict:
    """
    Comprehensive volatility metrics calculator.
    
    This function combines all volatility indicators into a single report.
    
    Parameters:
    -----------
    df : pd.DataFrame
        DataFrame with OHLCV data
    period : int, default 20
        Period for calculations
    
    Returns:
    --------
    dict with all volatility metrics
    """
    adr = calculate_adr(df, period=period)
    atr = calculate_atr(df, period=min(period, 14))  # ATR typically uses 14
    upside_downside = calculate_upside_downside_volatility(df, period=period)
    
    return {
        'adr': adr,
        'atr': atr,
        'upside_downside': upside_downside,
        'period': period
    }


def format_volatility_report(metrics: Dict) -> str:
    """
    Format volatility metrics into a readable report string.
    
    Parameters:
    -----------
    metrics : dict
        Output from calculate_volatility_metrics()
    
    Returns:
    --------
    str: Formatted report
    """
    lines = []
    lines.append("=" * 60)
    lines.append(f"VOLATILITY METRICS (Period: {metrics['period']} days)")
    lines.append("=" * 60)
    
    # ADR Section
    adr = metrics['adr']
    lines.append("\n📊 AVERAGE DAILY RANGE (ADR):")
    if adr.get('adr_absolute'):
        lines.append(f"  • ADR (Absolute): ${adr['adr_absolute']:.2f}")
        lines.append(f"  • ADR (Percentage): {adr['adr_percentage']:.2f}%")
        lines.append(f"  • Today's Range: ${adr['current_range']:.2f} ({adr['current_range_pct']:.2f}%)")
        if adr.get('adr_ratio'):
            ratio = adr['adr_ratio']
            if ratio > 1.2:
                lines.append(f"  • Today vs ADR: {ratio:.2f}x (ABOVE AVERAGE)")
            elif ratio < 0.8:
                lines.append(f"  • Today vs ADR: {ratio:.2f}x (BELOW AVERAGE)")
            else:
                lines.append(f"  • Today vs ADR: {ratio:.2f}x (NORMAL)")
    else:
        lines.append("  • Insufficient data")
    
    # ATR Section
    atr = metrics['atr']
    lines.append("\n📈 AVERAGE TRUE RANGE (ATR):")
    if atr.get('atr'):
        lines.append(f"  • ATR (Absolute): ${atr['atr']:.2f}")
        lines.append(f"  • ATR (Percentage): {atr['atr_percentage']:.2f}%")
    else:
        lines.append("  • Insufficient data")
    
    # Upside/Downside Section
    ud = metrics['upside_downside']
    lines.append("\n⬆️⬇️ UPSIDE / DOWNSIDE VOLATILITY:")
    if ud.get('avg_upside_pct'):
        lines.append(f"  • Average Upside Move: +{ud['avg_upside_pct']:.2f}% (${ud['avg_upside_absolute']:.2f})")
        lines.append(f"  • Average Downside Move: -{ud['avg_downside_pct']:.2f}% (${ud['avg_downside_absolute']:.2f})")
        lines.append(f"  • Average Range Upside: +{ud['avg_range_upside_pct']:.2f}%")
        lines.append(f"  • Average Range Downside: -{ud['avg_range_downside_pct']:.2f}%")
        if ud.get('avg_positive_move_pct'):
            lines.append(f"  • Avg Positive Days: +{ud['avg_positive_move_pct']:.2f}%")
        if ud.get('avg_negative_move_pct'):
            lines.append(f"  • Avg Negative Days: {ud['avg_negative_move_pct']:.2f}%")
    else:
        lines.append("  • Insufficient data")
    
    lines.append("\n" + "=" * 60)
    
    return "\n".join(lines)


# Example usage function
if __name__ == "__main__":
    # Example: How to use with yfinance data
    import yfinance as yf
    
    print("Example: Calculating volatility metrics for AAPL")
    print("-" * 60)
    
    # Fetch data
    ticker = yf.Ticker("AAPL")
    df = ticker.history(period="3mo")  # 3 months of daily data
    df = df.reset_index()
    df['Datetime'] = pd.to_datetime(df['Date'])
    
    # Calculate metrics
    metrics = calculate_volatility_metrics(df, period=20)
    
    # Print report
    print(format_volatility_report(metrics))








