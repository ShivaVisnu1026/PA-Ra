# Tick Volume / Intraday Data Syntax (GR vs TickVolume Reference)

This document summarizes **tick volume and intraday GetField/GetQuote syntax** as found in the **GR** folder, and compares it to the **TickVolume** project reference. Use it to decide which fields are safe to use before implementing early bear/bull alerts.

---

## 1. What GR Actually Uses (Verified in GR Scripts)

### GetField (bar-level, 1-min or chart frequency)

| Field | GR Usage | Script |
|-------|----------|--------|
| `GetField("成交量")` | Bar volume | CumulativeVolumeFlow_Alert.xs |
| `GetField("TradeVolumeAtAsk")` | 外盤量 (ask-side volume) | CumulativeVolumeFlow_Alert.xs, VolumeFields_Blueprint.xs |
| `GetField("成交量", "D")` | Daily volume | CumulativeVolumeFlow_Alert.xs, YTDVolInc_Alert.xs, BreakHighWithOutsideBidAlert.xs |
| `GetField("收盤價", "D")` | Daily close | BreakHighWithOutsideBidAlert.xs |
| `GetField("High","D")` / `GetField("Low","D")` etc. | Daily OHLC | ADR_Indicator, Volatility_Indicators, etc. |
| `GetField("Volume", "5")` / `"15"` / `"60"` | Multi-timeframe volume | Intraday_ReversalBar_MultiTimeframe_Alert.xs |

### GetQuote (quote/tick-level)

| Field | GR Usage | Script |
|-------|----------|--------|
| `GetQuote("內外盤")` | 1=外盤, -1=內盤, 0=無法判斷 (current tick side) | BreakHighWithOutsideBidAlert.xs (production + brainstorm) |
| `GetQuote("當日漲幅%")` | Daily change % | BreakHighWithOutsideBidAlert.xs |
| `GetQuote("漲停價")` | Limit-up price | BreakHighWithOutsideBidAlert.xs |

### Other (Tick-level)

| Symbol | GR Usage | Script |
|--------|----------|--------|
| `q_TickVolume` | Single-tick volume | BreakHighWithOutsideBidAlert.xs |

---

## 2. GR VolumeFields_Blueprint.xs (Documented GetField List)

From `01_scripts/functions/brainstorm/VolumeFields_Blueprint.xs`:

- **外盤:** `GetField("外盤量")`, `GetField("TradeVolumeAtAsk")`, `GetField("外盤金額")`
- **估計量:** `GetField("估計量")`, `GetField("EstimateVolume")`
- **盤中零股/整股:** `GetField("盤中零股成交量")`, `GetField("OddLotVolume")`, `GetField("盤中整股成交量")`, `GetField("BoardLotVolume")`
- **盤後:** `GetField("盤後量")`, `GetField("OffHourVolume")`, `GetField("盤後整股成交量")`
- **成交次數:** `GetField("總成交次數")`, `GetField("TotalTicks")` (note: 總成 交次數 with space is also in blueprint as alternate)

**Not in GR blueprint:** 內盤量, TradeVolumeAtBid, 內盤成交次數, TotalInTicks, 外盤成交次數, TotalOutTicks, 內盤均量, InAvgVolume, 外盤均量, OutAvgVolume.

---

## 3. TickVolume Reference (TickVolume/XQScript_GetField_Reference.md)

The TickVolume project reference documents **additional** fields used for early bear/bull detection:

| Category | Chinese | English | In GR? |
|----------|---------|---------|--------|
| Inner/Bid | 內盤成交次數 | TotalInTicks | ❌ Not in GR scripts or blueprint |
| Inner/Bid | 內盤均量 | InAvgVolume | ❌ Not in GR scripts or blueprint |
| Inner/Bid | 內盤量 | TradeVolumeAtBid | ❌ Not in GR scripts or blueprint |
| Outer/Ask | 外盤成交次數 | TotalOutTicks | ❌ Not in GR scripts or blueprint |
| Outer/Ask | 外盤均量 | OutAvgVolume | ❌ Not in GR scripts or blueprint |
| Outer/Ask | 外盤量 | TradeVolumeAtAsk | ✅ In GR (CumulativeVolumeFlow, Blueprint) |
| Other | 總成交次數 | TotalTicks | ✅ In GR (Blueprint) |

---

## 4. Implications for Early Bear Sell-Off Detection

- **Safe to use in GR (verified):**
  - `GetField("成交量")` – bar volume
  - `GetField("TradeVolumeAtAsk")` – ask-side volume (for bull/outer flow)
  - `GetField("TotalTicks")` or `GetField("總成交次數")` – total tick count (no inner/outer split in GR)
  - `GetQuote("內外盤")` – current tick is 外盤(1) or 內盤(-1)
  - `q_TickVolume` – single-tick volume

- **Not verified in GR (use only after confirming on target platform):**
  - `GetField("TradeVolumeAtBid")` – 內盤量 (needed for bid% and seller-aggressive logic)
  - `GetField("TotalInTicks")` – 內盤成交次數
  - `GetField("TotalOutTicks")` – 外盤成交次數
  - `GetField("InAvgVolume")` – 內盤均量
  - `GetField("OutAvgVolume")` – 外盤均量

**Recommendation:** Before implementing early bear logic that uses **TotalInTicks, TotalOutTicks, InAvgVolume, OutAvgVolume, or TradeVolumeAtBid**, verify on the **actual XQ/GR runtime** that these GetField names are supported. If not, restrict logic to:

- **TradeVolumeAtAsk** (and derive or approximate bid from 成交量 − Ask if supported),
- **TotalTicks**,
- **GetQuote("內外盤")** and **q_TickVolume** for tick-level sell/buy and size.

---

## 5. Where to Add New Syntax (When Verified)

When a field is confirmed on the platform:

1. Add it to **GR** `01_scripts/functions/brainstorm/VolumeFields_Blueprint.xs` with a short comment.
2. Keep **TickVolume/XQScript_GetField_Reference.md** in sync.
3. Update this file’s tables and the “In GR?” column.

---

**Last Updated:** 2026.02.09  
**Purpose:** Ensure tick volume intraday logic uses only syntax verified in GR (or explicitly marked as platform-dependent) before execution.
