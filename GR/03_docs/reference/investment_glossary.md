# 投資術語表

> XScript 開發中常用的投資和交易術語

---

## 📋 使用說明

本術語表收錄 XScript 開發和投資交易中常見的術語。當你遇到不熟悉的概念時，可以在此查詢。

---

## A-C

### ATR (Average True Range，真實波動幅度均值)
**定義**：衡量價格波動程度的指標。

**用途**：
- 設定停損停利位置
- 評估市場波動性
- 調整部位大小

**相關腳本**：
- 指標腳本可計算和顯示 ATR
- 交易腳本可用 ATR 設定動態停損

### Bollinger Bands（布林通道）
**定義**：由移動平均線和標準差構成的通道指標。

**組成**：
- 中軌：移動平均線（通常20日）
- 上軌：中軌 + 2倍標準差
- 下軌：中軌 - 2倍標準差

**交易含義**：
- 價格觸及上軌：可能超買
- 價格觸及下軌：可能超賣
- 通道寬度：波動程度

### Breakout（突破）
**定義**：價格突破重要的支撐或壓力位。

**類型**：
- 向上突破：突破壓力位，看漲訊號
- 向下突破：跌破支撐位，看跌訊號
- 假突破：突破後又回到原區間

**XScript 應用**：
```xscript
// 突破偵測範例
HighestHigh = Highest(High, 20);
if Close > HighestHigh[1] then
    Alert("向上突破");
```

---

## D-F

### Divergence（背離）
**定義**：價格走勢與指標走勢不一致。

**類型**：
- 看漲背離：價格新低，指標未創新低
- 看跌背離：價格新高，指標未創新高

**交易含義**：
可能的反轉訊號

### EMA (Exponential Moving Average，指數移動平均)
**定義**：對近期價格給予較高權重的移動平均。

**特點**：
- 對價格變化反應較快
- 較 SMA 更靈敏

**XScript 函數**：
```xscript
MyEMA = XAverage(Close, 20);
```

### Engulfing Pattern（吞噬型態）
**定義**：一根 K 棒完全吞噬前一根 K 棒的實體。

**類型**：
- 看漲吞噬：大陽線吞噬小陰線
- 看跌吞噬：大陰線吞噬小陽線

**識別條件**：
```xscript
// 看漲吞噬簡化條件
BullishEngulfing = Close > Open          // 當根為陽線
                   and Close[1] < Open[1]  // 前根為陰線
                   and Close > Open[1]     // 當根收盤 > 前根開盤
                   and Open < Close[1];    // 當根開盤 < 前根收盤
```

---

## G-I

### Golden Cross（黃金交叉）
**定義**：短期均線向上穿越長期均線。

**常見組合**：
- 5MA 向上穿越 20MA
- 50MA 向上穿越 200MA（長期看漲）

**XScript 範例**：
```xscript
GoldenCross = Average(Close, 5) crosses over Average(Close, 20);
```

### Inside Bar（內包線）
**定義**：K 棒的高低點都在前一根 K 棒範圍內。

**特徵**：
- High < High[1]
- Low > Low[1]

**交易含義**：
盤整、蓄勢待發

---

## K-M

### KD 隨機指標 (Stochastic Oscillator)
**定義**：比較收盤價與一段時間內價格區間的相對位置。

**數值範圍**：0-100

**交易訊號**：
- KD > 80：超買區
- KD < 20：超賣區
- K 線向上穿越 D 線：買進訊號
- K 線向下穿越 D 線：賣出訊號

### MACD (Moving Average Convergence Divergence)
**定義**：由快慢指數移動平均的差值構成的指標。

**組成**：
- DIF：12EMA - 26EMA
- MACD：DIF 的 9 日 EMA
- 柱狀圖：DIF - MACD

**交易訊號**：
- DIF 向上穿越 MACD：買進訊號（黃金交叉）
- DIF 向下穿越 MACD：賣出訊號（死亡交叉）
- 柱狀圖由負轉正：多頭力道增強

### Moving Average（移動平均線，MA）
**定義**：一段時間內價格的平均值。

**類型**：
- SMA：簡單移動平均
- EMA：指數移動平均
- WMA：加權移動平均

**用途**：
- 判斷趨勢方向
- 支撐壓力參考
- 交叉訊號

---

## O-R

### OHLCV
**定義**：K 棒的五個基本資料。

- **O**pen：開盤價
- **H**igh：最高價
- **L**ow：最低價
- **C**lose：收盤價
- **V**olume：成交量

**XScript 使用**：
```xscript
vars: O(0), H(0), L(0), C(0), V(0);
O = Open;
H = High;
L = Low;
C = Close;
V = Volume;
```

### Overbought / Oversold（超買/超賣）
**定義**：價格或指標達到極端水平。

**判斷標準**：
- RSI > 70：超買
- RSI < 30：超賣
- KD > 80：超買
- KD < 20：超賣

**交易含義**：
- 超買：價格可能回檔
- 超賣：價格可能反彈

### Pin Bar（針型燭台）
**定義**：具有長影線、小實體的 K 棒型態。

**特徵**：
- 看漲 Pin Bar：長下影線
- 看跌 Pin Bar：長上影線
- 影線長度 > 實體的 2-3 倍

**交易含義**：
價格試探後遭到拒絕，可能反轉

**XScript 偵測**：
```xscript
BodySize = AbsValue(Close - Open);
LowerShadow = MinList(Open, Close) - Low;
PinBar = LowerShadow > BodySize * 2;
```

### RSI (Relative Strength Index，相對強弱指標)
**定義**：衡量價格變動速度和幅度的動量指標。

**數值範圍**：0-100

**交易訊號**：
- RSI > 70：超買，可能回檔
- RSI < 30：超賣，可能反彈
- RSI 背離：可能反轉訊號

**XScript 函數**：
```xscript
MyRSI = RSI(Close, 14);
```

---

## S-T

### SMA (Simple Moving Average，簡單移動平均)
**定義**：一段時間內價格的簡單平均。

**計算**：
SMA = (P1 + P2 + ... + Pn) / n

**XScript 函數**：
```xscript
MySMA = Average(Close, 20);
```

### Stop Loss（停損）
**定義**：預設的最大可接受虧損點。

**類型**：
- 固定金額停損
- 百分比停損
- 技術位停損（支撐、均線等）
- 跟蹤停損（Trailing Stop）

**XScript 範例**：
```xscript
// 百分比停損
StopLossPrice = EntryPrice * (1 - StopLossPercent / 100);
if Close <= StopLossPrice then
    Sell("停損出場");
```

### Support / Resistance（支撐/壓力）
**定義**：價格較難突破的關鍵價位。

**類型**：
- 水平支撐壓力
- 趨勢線支撐壓力
- 均線支撐壓力
- 心理價位

**識別方法**：
- 前波高低點
- 密集成交區
- 整數關口

### Take Profit（停利）
**定義**：預設的獲利了結點。

**類型**：
- 固定金額停利
- 百分比停利
- 風險報酬比停利（如 1:2）
- 技術位停利

**XScript 範例**：
```xscript
// 百分比停利
TakeProfitPrice = EntryPrice * (1 + TakeProfitPercent / 100);
if Close >= TakeProfitPrice then
    Sell("停利出場");
```

### Trend（趨勢）
**定義**：價格的主要運動方向。

**類型**：
- 上升趨勢：高點和低點不斷墊高
- 下降趨勢：高點和低點不斷走低
- 橫向整理：價格在區間內震盪

**判斷方法**：
- 均線排列
- 趨勢線
- 高低點關係

---

## V-Z

### Volume（成交量）
**定義**：特定時間內的交易數量。

**單位**：
- 股票：股、張（1張 = 1000股）
- 期貨：口

**分析意義**：
- 量價配合：趨勢可靠
- 量價背離：趨勢可疑
- 爆量：關鍵轉折點

**XScript 使用**：
```xscript
// 計算平均量
VolumeAvg = Average(Volume, 20);

// 檢查是否爆量
if Volume > VolumeAvg * 2 then
    Alert("成交量異常放大");
```

### Volatility（波動率）
**定義**：價格變動的劇烈程度。

**衡量方法**：
- 標準差
- ATR（真實波動幅度）
- 布林通道寬度

**交易意義**：
- 高波動：風險和機會都大
- 低波動：市場平靜

---

## 🔍 快速查詢

### 按分類查找

#### 技術指標
- [ATR](#atr-average-true-range真實波動幅度均值)
- [Bollinger Bands](#bollinger-bands布林通道)
- [EMA](#ema-exponential-moving-average指數移動平均)
- [KD](#kd-隨機指標-stochastic-oscillator)
- [MACD](#macd-moving-average-convergence-divergence)
- [Moving Average](#moving-average移動平均線ma)
- [RSI](#rsi-relative-strength-index相對強弱指標)
- [SMA](#sma-simple-moving-average簡單移動平均)

#### 價格型態
- [Engulfing Pattern](#engulfing-pattern吞噬型態)
- [Inside Bar](#inside-bar內包線)
- [Pin Bar](#pin-bar針型燭台)

#### 交易概念
- [Breakout](#breakout突破)
- [Golden Cross](#golden-cross黃金交叉)
- [Overbought / Oversold](#overbought--oversold超買超賣)
- [Stop Loss](#stop-loss停損)
- [Support / Resistance](#support--resistance支撐壓力)
- [Take Profit](#take-profit停利)
- [Trend](#trend趨勢)

#### 市場資料
- [OHLCV](#ohlcv)
- [Volume](#volume成交量)
- [Volatility](#volatility波動率)

---

## 📝 貢獻說明

### 新增術語
遇到未收錄的術語時，請按照以下格式添加：

```markdown
### 術語名稱（中文翻譯）
**定義**：簡短定義

**詳細說明**：（可選）
[詳細說明內容]

**XScript 應用**：（如適用）
\`\`\`xscript
[程式碼範例]
\`\`\`

**相關概念**：（可選）
- [相關術語1](#連結)
- [相關術語2](#連結)
```

---

## 🔗 相關資源

- [XScript 官方說明](../resources/xshelp_mirror/)
- [學習資料](../learning/)
- [範例程式碼](../../examples/)

---

**最後更新**：2025-10-20  
**維護者**：Gordon, Ronnie  
**術語數量**：30+

