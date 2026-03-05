LinearReg函數回傳1時，代表計算成功。斜率、弧度、X軸截距及預測值是回傳在第4、5、6、7個參數。

範例：

```
value1 = linearreg(close,20,-1,value2,value3,value4,value5); //計算收盤價20期的線性迴歸
plot1(value5);                                               //繪製明天的收盤價線性迴歸預測值連線
```

```
value1 = linearreg(close,20,-1,value2,value3,value4,value5); //計算收盤價20期的線性迴歸
plot1(value5);                                               //繪製明天的收盤價線性迴歸預測值連線
```
