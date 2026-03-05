取得特定頻率、特定K棒的開盤價、最高價、最低價和收盤價

計算成功時回傳值為1，結果會回傳在第3~6個參數。

範例：

```
value1 = OHLCPeriodsAgo(2,1,value2,value3,value4,value5); //計算前期週線的開高低收價
plot1(value4);                                            //繪製前期週線最低價的連線
```

```
value1 = OHLCPeriodsAgo(2,1,value2,value3,value4,value5); //計算前期週線的開高低收價
plot1(value4);                                            //繪製前期週線最低價的連線
```
