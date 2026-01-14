# Measured Move Targets (Part 2): MM Based on Trading Range and Breakout Height

## 1. MM Target Based on Trading Range Height

- **Core Idea**: When price clearly breaks through an established trading range, the market often moves in the breakout direction for at least a distance equivalent to the height of that trading range itself.
- **Measurement Method**:
  1. Determine the highest and lowest points of the trading range and calculate its vertical height.
  2. Starting from the breakout point (from the top edge for upward breakouts, from the bottom edge for downward breakouts), project this height outward. The resulting price level is the MM target.
- **Trading Range as "Consensus Area" and Midpoint Reference**:
  - Trading ranges represent a temporary balance of power between buyers and sellers, forming a "value consensus area". When a breakout occurs, it means consensus is broken, and the market will seek a new equilibrium point.
  - Sometimes, the midpoint of the trading range is also viewed as the potential midpoint of the entire subsequent trend. That is, from the prior trend start to the range midpoint is considered Leg 1, then measure Leg 2 equal amplitude up/down from the range midpoint. Al Brooks considers this MM based on range midpoint to be relatively secondary.
- **Significance of "Body Gap / Negative Gap"**:
  - Even after breaking through a trading range, if price retests and the shadows of the retest bar overlap with the shadows of the range edge, as long as the **body parts of these two bars do not overlap**, this is still considered a strong signal (Al Brooks calls this a "body gap" or "negative gap").
  - When body gaps appear (even if shadows overlap), the market still has approximately a **60%** probability of reaching the MM target based on trading range height, though this probability may be slightly lower than gaps with no overlap at all.

## 2. MM Target Based on Breakout Height Itself

- **Core Idea**: A significant, strong breakout (usually consisting of one or a few consecutive large body bars, forming a so-called "breakout leg" or "buying/selling climax") can itself be used to predict the next market movement target.
- **Measurement Methods and Probabilities**:
  1. **Continuation Measured Move**:
     - Measure the height of the single bar (or breakout leg formed by consecutive bars) constituting the breakout (e.g., from the breakout bar's open to close, or from the leg's lowest to highest point, specific algorithms may vary by program).
     - Starting from the end of this breakout leg (highest point in uptrends, lowest point in downtrends), double this height in the same direction to get the continuation MM target.
     - Al Brooks mentions that after strong breakouts, the market has approximately a **60%** probability of reaching this continuation MM target.
  2. **Opposite Measured Move / Failed Breakout MM**:
     - Sometimes, a seemingly strong breakout will fail and trigger market movement in the opposite direction, with magnitude also approximately equal to the original breakout leg height.
     - That is, starting from the original breakout leg's start, project the breakout leg height in the opposite direction.
     - This situation occurs with approximately **40%** probability.
     - **Watch for Signals**: When a breakout fails to continue and instead shows strong counter-trend bars, especially when price breaks below (in upward breakouts) or above (in downward breakouts) the breakout leg's start, be alert to the possibility of an opposite MM.

## Trading Strategy and Application

- **Profit Taking for Trend-Following Trades**: After observing strong breakouts (whether breaking through trading ranges or forming strong breakout bars/legs), calculated continuation MM targets can be used as potential profit-taking areas.
- **Reference for Reversal Trades**: When identifying signs of failed breakouts and price begins moving toward opposite MM targets, this can be used as entry or target reference for reversal trades.
- **Assessing Breakout Strength**: Breakout bar body size, closing position (whether near extremes), and whether there are tight, same-direction follow-through bars are all important factors in judging breakout strength and MM target achievement probability.
- **Decision Point**: When price reaches any type of MM target, it is usually a decision point for longs to consider taking profits and shorts to consider (at least scalping-type) going short (and vice versa).

## General Considerations

- **Market Cycle Transitions**: Understanding whether the current market is in a trend or consolidation helps choose more appropriate MM measurement methods. For example, MM after trading range breakouts and "Leg 1 = Leg 2" MM in trend continuation have different application scenarios.
- **Target Confluence Enhances Effectiveness**: If multiple MM targets calculated by different methods (such as based on range height, based on breakout bar height, Leg 1 = Leg 2, etc.) happen to converge in similar price areas, the likelihood of this area being key support or resistance will greatly increase.
- **Flexibility and Market Confirmation**: MM targets provide a probabilistic expectation, not an absolute guarantee. Traders need to combine real-time price action to confirm whether targets are being "respected" by the market.
