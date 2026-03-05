xfMin_XAverage是 xf_XAverage 函數的跨頻率加強版本，增加了指定分鐘頻率的參數，可以計算指定分鐘頻率的XAverage值。

範例：

```
value1 = xfMin_XAverage("30",GetField("Close","30"),5); //計算30分鐘線5期收盤價的指數移動平均
```

```
value1 = xfMin_XAverage("30",GetField("Close","30"),5); //計算30分鐘線5期收盤價的指數移動平均
```
