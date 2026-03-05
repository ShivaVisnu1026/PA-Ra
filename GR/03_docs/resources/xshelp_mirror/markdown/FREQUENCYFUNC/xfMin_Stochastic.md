xfMin_Stochastic是 xf_Stochastic 函數的跨頻率加強版本，增加了指定分鐘頻率的參數，可以計算指定分鐘頻率的Stochastic值。

範例：

```
value1 = xfMin_Stochastic("30",9,3,3,value2,value3,value4);       //計算30分鐘線KD指標
plot1(value3, "30分K");
plot2(value4, "30分D");
```

```
value1 = xfMin_Stochastic("30",9,3,3,value2,value3,value4);       //計算30分鐘線KD指標
plot1(value3, "30分K");
plot2(value4, "30分D");
```
