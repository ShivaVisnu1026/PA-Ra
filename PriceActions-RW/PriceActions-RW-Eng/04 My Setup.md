# Al Brooks' Personal Chart Setup

## Trading Environment & Philosophy

-   **Focus Above All**: When trading, eliminate all external distractions like news, phone calls, TV "experts," focusing only on price action on the candlestick chart itself.
-   **Zero-Sum Game View**: View trading as a game with a clear objective—transferring funds from others' accounts into your own.

## Core Chart Setup: 5-Minute Chart

-   **Primary Chart**: Primarily trade throughout the day using the **5-minute candlestick chart**.
-   **Chart Data Configuration**:
    -   **Trading Session**: Only display bars during regular trading hours (RTH, like US stock market 9:30-16:15), excluding pre-market and after-hours data. This significantly affects the moving average calculation values during the opening session, which may differ from charts showing 24-hour activity.
    -   **Contract Type**: When trading futures, use price-adjusted **continuous contract charts** to ensure historical data continuity.
-   **Key Indicators & Analysis Focus**:
    -   **5-Minute EMA20**: The standard 20-period exponential moving average for the current chart.
    -   **Higher Timeframe Averages**: Overlay 15-minute and 60-minute EMA20 on the 5-minute chart, with special emphasis on the **60-minute EMA20** (shown as blue dashed line).
    -   **Analysis Focus**: Besides moving averages, closely monitor trend lines, prior highs/lows, and measured move targets.

## Multi-Timeframe Moving Averages

### Implementation Method
-   **Custom Code**: Al Brooks uses custom indicators he coded in TradeStation to precisely transplant higher timeframe EMAs onto the 5-minute chart.
-   **Approximation Method**: Provides a no-code alternative solution for users of other platforms.
    -   **Simulating 60-Minute EMA20**: Use **EMA220** on the 5-minute chart.
        -   *Rationale*: Theoretical calculation is `(60 min / 5 min) * 20 periods = 240`, but to correct for data overlap deviations, using a slightly smaller period (like 220) is more accurate.
    -   **Simulating 15-Minute EMA20**: Use **EMA50** on the 5-minute chart.
        -   *Rationale*: Theoretical calculation is `(15 min / 5 min) * 20 periods = 60`, similarly, using a slightly smaller period (like 50) works better.

## Daily Chart & Other Market Considerations

-   **Daily Chart Analysis**: Will review the daily chart and pay attention to the daily **EMA20**.
-   **Stock Trading**: When trading stocks, will additionally add **Simple Moving Averages (SMA)** because they are widely used by stock traders.
    -   **Common SMAs**: MA50, MA100, MA150, MA200 (yearly average).
-   **Forex Trading**: These longer-period SMAs are less important in forex markets compared to stock markets.

## Summary Principles
-   **Focus is First Priority**: Establish a distraction-free trading environment.
-   **5-Minute Chart as Core**: Use the 5-minute chart as the primary trading chart, but must combine with higher timeframe perspectives.
-   **Value 60-Minute EMA20**: Overlaying the 60-minute EMA20 on the 5-minute chart is an important multi-timeframe analysis reference.
-   **Configure Charts Correctly**: Use regular trading hours data and continuous contracts (if applicable) to get a view consistent with professional traders.
-   **Adapt to Markets**: Different markets (stocks vs. forex) emphasize different indicators; for example, SMAs are more important in stock analysis.
