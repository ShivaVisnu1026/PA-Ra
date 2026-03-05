TRIX是在1980年代由Jack Hutson所發明的指標。TRIX指的是對股價X取TRIPLE （三次） 平滑的意思。將數值計算三次指數移動平均（EMA，也就是MACD式平滑法）之後的數列，再計算其變動率而得。

範例：

```
value1 = TRIX(Close, 9);       //計算9期TRIX指標
plot1(value1, "TRIX");
```

```
value1 = TRIX(Close, 9);       //計算9期TRIX指標
plot1(value1, "TRIX");
```
