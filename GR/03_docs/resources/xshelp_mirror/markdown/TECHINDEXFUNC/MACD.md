MACD是由Gerald Appel於1970年代所發明的指標。利用二條快速與慢速指數移動平均線的收斂或發散來判斷價格走勢。

MACD指標包含了DIF、MACD及OSC三個數值。MACD函數回傳1時，代表計算成功。DIF、MACD及OSC的值是回傳在第5、6、7個參數。

範例：

```
value1 = MACD(WeightedClose,12,26,9,value2,value3,value4);       //計算MACD
plot1(value2, "DIF");
plot2(value3, "MACD");
plot3(value4, "OSC");
```

```
value1 = MACD(WeightedClose,12,26,9,value2,value3,value4);       //計算MACD
plot1(value2, "DIF");
plot2(value3, "MACD");
plot3(value4, "OSC");
```
