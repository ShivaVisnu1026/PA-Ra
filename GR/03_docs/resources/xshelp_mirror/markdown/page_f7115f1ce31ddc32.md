加權平均價給予收盤價較大的權重，著名的MACD指標即是利用加權平均價做計算。

計算公式：

WeightedClose = (當期最高價 + 當期最低價 + 2*當期收盤價)/4

範例：

```
plot1(WeightedClose);    //繪製當期加權平均收盤價的連線
plot2(WeightedClose[1]); //繪製前一期加權平均收盤價的連線
```

```
plot1(WeightedClose);    //繪製當期加權平均收盤價的連線
plot2(WeightedClose[1]); //繪製前一期加權平均收盤價的連線
```
