# Trading Order Basics

## Four Core Order Types

-   **Core Components**: Most traders only need to master four order types: stop orders, limit orders, bracket orders, and market orders.
-   **Beginner Path**: Beginners should only use **stop orders** for entry and can use **limit orders** for profit-taking.
-   **Expert Strategy**: Experienced traders can utilize limit orders for counter-trend entries.

## Stop Orders — Trading with the Trend

-   **Trigger Mechanism**: When the market price **touches** the preset price, a stop order immediately converts to a market order and executes at the then-available market price.
-   **Primary Uses**:
    -   **With-Trend Entry**: Place buy stop orders above bars or sell stop orders below bars. This is an entry method after confirming price is moving in the expected direction, especially friendly for beginners.
    -   **Protective Stop (Most Important)**: After opening a position, immediately set a stop to limit losses. This is the most important order type, protecting traders from psychological biases (such as hope, denial) and avoiding catastrophic losses.
-   **Slippage Risk**: Actual fill price may be worse than the preset price, especially in illiquid markets or during extreme volatility. However, in high-liquidity mainstream markets, slippage is usually minimal.

## Stop Orders, Black Swans, and Extreme Risk

-   **Limitations of Stops**: Stop orders cannot completely avoid risks from **"black swan" events** (unpredictable extreme market conditions, such as earnings reports, major news, system crashes).
-   **Large Gaps**: In extreme events, markets may gap significantly, opening or trading directly through stop levels. In such cases, stop orders will fill at prices far worse than expected stop levels, causing losses far exceeding planned amounts. Stop orders provide almost no protection in such situations.
-   **Risk Management Implications**:
    -   **Always Set Stops**: Despite this risk, **always set protective stops** when trading.
    -   **Control Position Size**: Position size must be small enough to withstand black swan impacts without being eliminated.
    -   **Alternative Protection**: For predictable major events (such as earnings), using options hedging is a better protection method than stop orders.

## Limit Orders — Counter-Trend and Profit-Taking

-   **Trigger Mechanism**: Price typically needs to **trade through** the preset price to ensure execution (about 90% of cases). Merely touching the level may not guarantee execution.
-   **Primary Uses**:
    -   **Profit-Taking**: All traders should use limit orders to take profits at preset target levels.
    -   **Counter-Trend Entry (Expert Use)**: Place limit sell orders at prior highs (betting on breakout failure) or limit buy orders at prior lows (betting on support holding). This requires traders to be comfortable placing orders when price moves against them.
-   **Market Game**: At key price levels, limit order traders (betting on reversal) are direct counterparties to stop order traders (betting on continuation).

## Bracket Orders (OCO Orders) — Automated Trade Management

-   **Definition**: An order combination containing a **protective stop order (stop order)** and a **profit-taking order (limit order)**. Also called OCO orders (One-Cancels-the-Other).
-   **Mechanism**: When either the stop or profit order fills, the other order automatically cancels.
-   **Core Advantages**:
    -   **Automation**: Can be set to automatically attach after entry order fills, achieving automated trade management.
    -   **Avoid Mistakes**: Prevents accidentally opening new positions due to forgetting to cancel the other side order.
    -   **Enforce Discipline**: Helps enforce stop and profit-taking in trading plans.
-   **Scaling Out**: Brokers typically support setting multiple profit-taking limit orders, automatically adjusting remaining position stop quantities after partial profit-taking.

## Market Orders — Pursuing Speed and Decisiveness

-   **Mechanism**: Execute immediately at current best market price (buy at ask, sell at bid). Traders bear the cost of the bid-ask spread.
-   **Usage Scenarios (Uncommon but Critical)**:
    -   **Emergency Exit**: When discovering the trading premise is wrong, hoping to exit immediately before the stop is hit to reduce losses.
    -   **Quick Entry**: During very strong and fast breakouts, to avoid missing opportunities, directly chase with market orders rather than waiting for price pullbacks.

## Summary Principles and Important Notes

-   **Stick to Core**: Focus on the above four core order types; ignore other complex order types offered by brokers, as they provide almost no additional advantage.
-   **Forex Market Specificity**: Forex charts may be based on bid or ask prices rather than actual trade prices, which may cause order fills to differ from chart displays.
-   **Disclaimer**: Any order execution issues encountered in trading (non-fills, slippage, etc.), according to broker agreements, the ultimate responsibility lies with the trader. This is one of the trading costs that must be accepted.
