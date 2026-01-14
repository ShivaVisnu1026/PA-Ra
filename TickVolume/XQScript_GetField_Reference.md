# XQScript GetField Reference for Volume-Based Price Movement Strategy

This document contains all GetField references for XQScript values used in strategies to detect early price movement based on volume before price moves.

## Inner/Bid Side Fields (內盤)

### Inner Tick Count (內盤成交次數)
```xqscript
Value1 = GetField("內盤成交次數");
Value1 = GetField("TotalInTicks");
```

### Inner Average Volume (內盤均量)
```xqscript
Value1 = GetField("內盤均量");
Value1 = GetField("InAvgVolume");
```

### Inner Volume (內盤量)
```xqscript
Value1 = GetField("內盤量");
Value1 = GetField("TradeVolumeAtBid");
```

### Inner Trade Amount (內盤金額)
```xqscript
Value1 = GetField("內盤金額");
```

---

## Outer/Ask Side Fields (外盤)

### Outer Tick Count (外盤成交次數)
```xqscript
Value1 = GetField("外盤成交次數");
Value1 = GetField("TotalOutTicks");
```

### Outer Average Volume (外盤均量)
```xqscript
Value1 = GetField("外盤均量");
Value1 = GetField("OutAvgVolume");
```

### Outer Volume (外盤量)
```xqscript
Value1 = GetField("外盤量");
Value1 = GetField("TradeVolumeAtAsk");
```

### Outer Trade Amount (外盤金額)
```xqscript
Value1 = GetField("外盤金額");
```

---

## Other Volume Metrics

### Estimated Volume (估計量)
```xqscript
Value1 = GetField("估計量");
Value1 = GetField("EstimateVolume");
```

### Odd Lot Volume (盤中零股成交量)
```xqscript
Value1 = GetField("盤中零股成交量");
Value1 = GetField("OddLotVolume");
```

### Board Lot Volume (盤中整股成交量)
```xqscript
Value1 = GetField("盤中整股成交量");
Value1 = GetField("BoardLotVolume");
```

### After Hours Volume (盤後量 / 盤後整股成交量)
```xqscript
Value1 = GetField("盤後量");
Value1 = GetField("OffHourVolume");
Value1 = GetField("盤後整股成交量");
```

### Total Tick Count (總成交次數)
```xqscript
Value1 = GetField("總成交次數");
Value1 = GetField("TotalTicks");
```

---

## Quick Reference Table

| Category | Chinese Field Name | English Field Name | Description |
|----------|-------------------|-------------------|-------------|
| **Inner/Bid** | 內盤成交次數 | TotalInTicks | Inner ticks count |
| **Inner/Bid** | 內盤均量 | InAvgVolume | Inner average volume |
| **Inner/Bid** | 內盤量 | TradeVolumeAtBid | Inner volume |
| **Inner/Bid** | 內盤金額 | - | Inner trade amount |
| **Outer/Ask** | 外盤成交次數 | TotalOutTicks | Outer ticks count |
| **Outer/Ask** | 外盤均量 | OutAvgVolume | Outer average volume |
| **Outer/Ask** | 外盤量 | TradeVolumeAtAsk | Outer volume |
| **Outer/Ask** | 外盤金額 | - | Outer trade amount |
| **Other** | 估計量 | EstimateVolume | Estimated volume |
| **Other** | 盤中零股成交量 | OddLotVolume | Odd lot volume |
| **Other** | 盤中整股成交量 | BoardLotVolume | Board lot volume |
| **Other** | 盤後量 / 盤後整股成交量 | OffHourVolume | After hours volume |
| **Other** | 總成交次數 | TotalTicks | Total ticks count |

---

## Strategy Usage Notes

These GetField values are useful for:

1. **Early Accumulation Detection:**
   - Monitor inner/outer volume ratios before price moves
   - Track tick count vs volume patterns
   - Detect institutional vs retail activity

2. **Volume-Based Price Movement Strategy:**
   - Compare ask/bid volume imbalances
   - Analyze volume per tick ratios
   - Track cumulative volume flows
   - Detect volume acceleration before price breakouts

3. **Key Indicators to Calculate:**
   - Ask/Bid Volume Ratio: `TradeVolumeAtAsk / TradeVolumeAtBid`
   - Volume per Tick: `Volume / TotalTicks`
   - Inner/Outer Tick Ratio: `TotalInTicks / TotalOutTicks`
   - Board Lot Ratio: `BoardLotVolume / TotalVolume`

---

**Last Updated:** December 19, 2025  
**Purpose:** Reference for volume-based price movement detection strategies
