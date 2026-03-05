xfMin_RSI是 xf_RSI 函數的跨頻率加強版本，增加了指定分鐘頻率的參數，可以計算指定分鐘頻率的RSI值。

範例：

```
value1 = xfMin_RSI("30",GetField("Close","30"),6);       //計算6期的30分鐘線RSI指標
plot1(value1, "30分RSI");
```

```
value1 = xfMin_RSI("30",GetField("Close","30"),6);       //計算6期的30分鐘線RSI指標
plot1(value1, "30分RSI");
```
