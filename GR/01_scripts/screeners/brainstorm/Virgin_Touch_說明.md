# Virgin Touch 策略說明

## Python 程式邏輯解析

### 策略核心概念
Virgin Touch 是一個看漲反轉策略，尋找價格首次接觸上升趨勢均線並反彈的機會。

### 策略規則詳解

#### 規則 A & B: Virgin Setup（處女接觸設定）
- **邏輯**：過去 N 根 K 棒（不含當前）的所有 Low 都大於對應時期的 EMA
- **意義**：價格從未跌破過這條均線，這是第一次接觸
- **Python 實作**：
  ```python
  is_above_ema = df['Low'] > df[ema_col]
  is_virgin = is_above_ema.rolling(window=lookback).min().shift(1) == 1
  ```
- **XScript 實作**：使用迴圈檢查過去 N 根的 `Low[i] > EMA[i]`

#### 規則 C: Trend Direction（趨勢方向）
- **邏輯**：EMA 趨勢向上（當前 EMA > 前一根 EMA）
- **意義**：確保是在上升趨勢中
- **Python 實作**：
  ```python
  is_trend_up = df[ema_col] > df[ema_col].shift(1)
  ```
- **XScript 實作**：`EMA > EMA[1]`

#### 規則 D & E: Touch & Rebound（接觸與反彈）
- **邏輯**：
  - 當前 K 棒的 Low 跌破 EMA（接觸均線）
  - 當前 K 棒的 Close 站回 EMA 之上（反彈確認）
- **意義**：價格觸及支撐線後立即反彈，證明支撐有效
- **Python 實作**：
  ```python
  touched_ema = df['Low'] < df[ema_col]
  closed_above = df['Close'] > df[ema_col]
  ```
- **XScript 實作**：`Low < EMA` 且 `Close > EMA`

#### 規則 F: Pinbar Pattern（Pin Bar 型態）
- **邏輯**：下引線長度佔 K 棒總長度的比例 >= pinbar_ratio（預設 0.35）
- **意義**：確認這是一個有效的反轉型態
- **Python 實作**：
  ```python
  total_range = df['High'] - df['Low']
  lower_shadow = df[['Open', 'Close']].min(axis=1) - df['Low']
  is_pinbar = (lower_shadow / total_range) >= pinbar_ratio
  ```
- **XScript 實作**：
  ```xscript
  CandleRange = High - Low;
  LowerShadow = MinList(Open, Close) - Low;
  LowerShadowRatio = LowerShadow / CandleRange;
  IsPinbar = LowerShadowRatio >= PinbarRatio;
  ```

### 多重 EMA 檢查
策略同時檢查三條 EMA（8、20、56），任一觸發訊號即可。

## Python 到 XScript 的轉換對照

| Python 語法 | XScript 語法 | 說明 |
|------------|-------------|------|
| `df['Close'].ewm(span=period).mean()` | `XAverage(Close, period)` | EMA 計算 |
| `df['Low'] > df[ema_col]` | `Low > EMA` | 價格比較 |
| `df[ema_col].shift(1)` | `EMA[1]` | 前一根值 |
| `df[['Open', 'Close']].min(axis=1)` | `MinList(Open, Close)` | 取最小值 |
| `.rolling(window=N).min()` | `for i = 1 to N` 迴圈 | 滾動窗口檢查 |
| `df['Low'] < df[ema_col]` | `Low < EMA` | 跌破判斷 |
| `df['Close'] > df[ema_col]` | `Close > EMA` | 站回判斷 |

## 邏輯差異說明

### Python 的實作方式
Python 使用向量化運算，對於每一根 K 棒：
1. 計算該根 K 棒的 `is_above_ema`（Low 是否大於該根對應的 EMA）
2. 使用 `.rolling().min()` 檢查過去 N 根是否全部為 True
3. `.shift(1)` 讓結果對應到當前 K 棒

### XScript 的實作方式
XScript 使用迴圈：
1. 對於過去 N 根 K 棒（i = 1 to N）
2. 檢查每一根的 `Low[i] > XAverage(Close[i], period)`
3. 如果所有都符合，則標記為 Virgin

**注意**：XScript 的實作會重新計算每一根過去的 EMA，這在邏輯上更精確，但計算量較大。對於選股腳本來說，這是可以接受的。

## 版本 2.0 改良重點

### 問題分析
原版本（v1.0）的「Virgin Setup」條件過於嚴格，要求過去全部 N 根 K 棒都沒有跌破 EMA。這導致像群聯 (8299) 在 2026/01/09 這樣的情況無法被偵測到，因為雖然當天符合其他所有條件（EMA 向上、接觸反彈、Pinbar 型態），但在更早之前（如 12/20-12/22）曾有過跌破。

### 改良方案
1. **新增參數 `UseVirginFilter`**：
   - 設為 `true`：啟用近期強勢過濾（檢查最近 N 根）
   - 設為 `false`：完全移除 Virgin 條件，專注於接觸反彈形態

2. **縮短回溯期**：
   - 將 `LookbackPeriod` 改為 `RecentLookback`，預設從 20 根縮短為 5 根
   - 只檢查「最近 5 根」而非「過去全部 20 根」

3. **更靈活的邏輯**：
   - 允許之前有過接觸，只要最近一段時間保持強勢即可
   - 或完全移除此條件，專注於「接觸反彈」的核心邏輯

### 使用建議

1. **資料頻率**：建議使用日線資料

2. **參數調整**：
   - **`UseVirginFilter`**：
     - `false`：完全移除 Virgin 條件，最寬鬆（推薦用於捕捉圖中案例）
     - `true`：啟用近期強勢過濾，較嚴格
   - **`RecentLookback`**：預設 5，如果啟用過濾，可調整為 3-10
   - **`PinbarRatio`**：預設 0.35（35%），可調整以過濾更多或更少的訊號
   - **EMA 週期**：預設 8、20、56，可根據策略需求調整

3. **針對圖中案例（群聯 8299 2026/01/09）的建議設定**：
   - `UseVirginFilter = false`（完全移除 Virgin 條件）
   - `PinbarRatio = 0.35`（76.9% 遠大於此值，符合）
   - 其他參數保持預設

4. **訊號解讀**：
   - 訊號出現表示價格接觸上升趨勢均線並反彈
   - 這是潛在的買入機會，但建議結合其他技術分析確認

5. **風險提醒**：
   - 任何技術指標都不保證獲利
   - 建議結合風險管理機制
   - 充分回測後再使用

## 版本歷史

- **v2.0 (2025-01-27)**：放寬 Virgin 條件，新增可選的近期強勢過濾
- **v1.0 (2025-01-27)**：初始版本，嚴格的 Virgin Setup 條件
