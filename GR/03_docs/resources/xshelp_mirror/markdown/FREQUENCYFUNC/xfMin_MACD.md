xfMin_MACD是 xf_MACD 函數的跨頻率加強版本，增加了指定分鐘頻率的參數，可以計算指定分鐘頻率的MACD值。

範例：

```
value1 = xfMin_MACD("30",xfMin_weightedclose("30"),12,26,9,value2,value3,value4);    //計算30分鐘線MACD
plot1(value2, "30分鐘DIF");
plot2(value3, "30分鐘MACD");
plot3(value4, "30分鐘OSC");
```

```
value1 = xfMin_MACD("30",xfMin_weightedclose("30"),12,26,9,value2,value3,value4);    //計算30分鐘線MACD
plot1(value2, "30分鐘DIF");
plot2(value3, "30分鐘MACD");
plot3(value4, "30分鐘OSC");
```
