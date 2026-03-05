KD指標為美國交易員George Lane所創，原名為Stochastic Oscillator。

Stochastic函數可計算KD指標的RSV、K及D三個數值。Stochastic函數回傳1時，代表計算成功。RSV、K及D的值是回傳在第4、5、6個參數。

範例：

```
value1 = Stochastic(9,3,3,value2,value3,value4);       //計算KD指標
plot1(value3, "K");
plot2(value4, "D");
```

```
value1 = Stochastic(9,3,3,value2,value3,value4);       //計算KD指標
plot1(value3, "K");
plot2(value4, "D");
```
