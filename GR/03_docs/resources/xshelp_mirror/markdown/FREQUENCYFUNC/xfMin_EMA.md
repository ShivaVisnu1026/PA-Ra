xfMin_EMA是 xf_EMA 函數的跨頻率加強版本，增加了指定分鐘頻率的參數，可以計算指定分鐘頻率的EMA值。

範例：

```
value1 = xfMin_EMA("30", GetField("Close", "30"),5); //計算30分鐘線5期收盤價的XQ EMA
```

```
value1 = xfMin_EMA("30", GetField("Close", "30"),5); //計算30分鐘線5期收盤價的XQ EMA
```
