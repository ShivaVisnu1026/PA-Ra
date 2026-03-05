xf_MACD是 MACD 函數的跨頻率版本，增加了指定頻率的參數，可以計算指定頻率的MACD值。

範例：

```
value1 = xf_MACD("W",xf_weightedclose("W"),12,26,9,value2,value3,value4);       //計算週線MACD
plot1(value2, "週DIF");
plot2(value3, "週MACD");
plot3(value4, "週OSC");
```

```
value1 = xf_MACD("W",xf_weightedclose("W"),12,26,9,value2,value3,value4);       //計算週線MACD
plot1(value2, "週DIF");
plot2(value3, "週MACD");
plot3(value4, "週OSC");
```
