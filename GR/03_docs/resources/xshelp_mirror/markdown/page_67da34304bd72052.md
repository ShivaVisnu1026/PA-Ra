xf_Stochastic是 Stochastic 函數的跨頻率版本，增加了指定頻率的參數，可以計算指定頻率的Stochastic值。

範例：

```
value1 = xf_Stochastic("W",9,3,3,value2,value3,value4);       //計算週KD指標
plot1(value3, "週K");
plot2(value4, "週D");
```

```
value1 = xf_Stochastic("W",9,3,3,value2,value3,value4);       //計算週KD指標
plot1(value3, "週K");
plot2(value4, "週D");
```
