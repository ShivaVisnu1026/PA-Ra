xf_RSI是 RSI 函數的跨頻率版本，增加了指定頻率的參數，可以計算指定頻率的RSI值。

範例：

```
value1 = xf_RSI("W",GetField("Close","W"),6);       //計算6期的週RSI指標
plot1(value1, "週RSI");
```

```
value1 = xf_RSI("W",GetField("Close","W"),6);       //計算6期的週RSI指標
plot1(value1, "週RSI");
```
