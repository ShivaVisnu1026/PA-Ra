xfMin_DirectionMovement是 xf_DirectionMovement 函數的跨頻率加強版本，增加了指定分鐘頻率的參數，可以計算指定分鐘頻率的DMI值。

範例：

```
value1 = xfMin_DirectionMovement("30",14,value2,value3,value4);       //計算14期的30分鐘線DMI指標
plot1(value2, "30分+DI");
plot2(value3, "30分週-DI");
plot3(value4, "30分ADX");
```

```
value1 = xfMin_DirectionMovement("30",14,value2,value3,value4);       //計算14期的30分鐘線DMI指標
plot1(value2, "30分+DI");
plot2(value3, "30分週-DI");
plot3(value4, "30分ADX");
```
