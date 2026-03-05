xf_DirectionMovement是 DirectionMovement 函數的跨頻率版本，增加了指定頻率的參數，可以計算指定頻率的DMI值。

範例：

```
value1 = xf_DirectionMovement("W",14,value2,value3,value4);       //計算14期的週DMI指標
plot1(value2, "週+DI");
plot2(value3, "週-DI");
plot3(value4, "週ADX");
```

```
value1 = xf_DirectionMovement("W",14,value2,value3,value4);       //計算14期的週DMI指標
plot1(value2, "週+DI");
plot2(value3, "週-DI");
plot3(value4, "週ADX");
```
