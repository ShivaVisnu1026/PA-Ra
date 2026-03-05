# 江湖傳說解密系列(1)：多重MACD多頭交易策略？

**來源**: https://www.xq.com.tw/xstrader/%e6%b1%9f%e6%b9%96%e5%82%b3%e8%aa%aa%e8%a7%a3%e5%af%86%e7%b3%bb%e5%88%971%e5%a4%9a%e9%87%8dmacd%e5%a4%9a%e9%a0%ad%e4%ba%a4%e6%98%93%e7%ad%96%e7%95%a5/  
**抓取時間**: 2025-10-04T18:10:53.227756  
**原始日期**: 

## 內容

分享新年新氣象，先在此預祝大家有一個滿載而歸的龍年。去年同事建議我，可以挑一些市場大家常用的交易方法來分享， 接下來有機會就來跟大家討論一些江湖上流傳已久的交易手法，以及我對應寫的交易策略。今天第一篇，先來介紹多重MACD多頭交易。初次接觸這個指標的朋友可以先參考這一篇，了解這個指標的計算方式。這個策略的條件有三個：一、月線MACD多頭架構二、週線MACD多頭架構三、日線MACD出現黃金交叉我寫的腳本如下：// MACD 黃金交叉 (dif向上穿越macd)
//
input: FastLength(12), SlowLength(26), MACDLength(9);
variable: difValue(0), macdValue(0), oscValue(0);

SetTotalBar((maxlist(FastLength,SlowLength,6) + MACDLength) * 4);

SetInputName(1, "DIF短期期數");
SetInputName(2, "DIF長期期數");
SetInputName(3, "MACD期數");

MACD(weightedclose(), FastLength, SlowLength, MACDLength, difValue, macdValue, oscValue);

if difValue > macdValue

then ret=1;這裡如果difvalue> macdvalue 的話就是多頭架構，如果是：difvalue cross over  macdvalue 就是黃金交叉。我舉台積電為例，下圖是台積電日線與MACD指標的對照圖：在1/19日那天出現買進訊號。而台積電的週線，當時其MACD是多頭架構：月線的MACD也是多頭架構：所以台積電就符合多重MACD多頭策略的標準。如果以封關日為基準，最新符合這策略的共有以下11檔：以過去七年為例，所有普通股符合這策略後，如果停損停利設為7%，回測報告如下圖：表現並沒有比大盤好。市場老手在使用這個策略時，都有自己的過濾系統。我就聽到的部份加了三個過濾條件：一、低價。 收盤價低於40元。二、股本適中。 股本介於20億到200億之間。三、主力追漲。 近一日主力買超佔成交量15%以上。加上這三個條件之後的回測報告如下：我認識的每個朋友用這個策略的，都有自己的一些私房作法，有的是調整週MACD與月MACD的參數，讓電們更敏感一點，有的則是利用其他指標來作輔助。這個策略的核心精神是在中長期多頭趨勢裡，找出短期趨勢剛剛由空翻多的個股。把握這個精神，大家可以再根據自己對市場的觀察，去調整策略。===● XQ【盤後量化選股模組】($1,000) 完整介紹 ➤https://xqcom.pse.is/5m2gqx● 首次訂閱享7天鑑賞期，首次購買輸入官方優惠碼「@XQ8899」，可折抵模組費用$100！● 量化交易超值方案！購買就送：【量化積木+台股進階】(總價值$800)分享

## 程式碼範例

### 範例 1

```xs
// MACD 黃金交叉 (dif向上穿越macd)
//
input: FastLength(12), SlowLength(26), MACDLength(9);
variable: difValue(0), macdValue(0), oscValue(0);

SetTotalBar((maxlist(FastLength,SlowLength,6) + MACDLength) * 4);

SetInputName(1, "DIF短期期數");
SetInputName(2, "DIF長期期數");
SetInputName(3, "MACD期數");

MACD(weightedclose(), FastLength, SlowLength, MACDLength, difValue, macdValue, oscValue);

if difValue > macdValue

then ret=1;
```

