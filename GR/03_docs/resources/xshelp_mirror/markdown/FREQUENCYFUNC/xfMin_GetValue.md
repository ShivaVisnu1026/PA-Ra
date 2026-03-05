在同一個頻率時，我們可以直接利用**變數[3]**取得前3期的變數值。當資料頻率不同時（跨頻率），我們就需要使用xfMin_GetValue或xfMin_GetBoolean來取得之前的變數值。若變數是數值時，要用xfMin_GetValue；若變數是布林值時，要用xfMin_GetBoolean。支援跨分鐘頻率。

```
value1 = xfMin_WeightedClose("30");            //計算30分鐘線的加權平均價
value2 = xfMin_GetValue("30",value1,1);        //取得上一期30分鐘線的加權平均價
plot1(value2);
plot2(value1[1]);                        //可以比較一下和value2的差異
```

```
value1 = xfMin_WeightedClose("30");            //計算30分鐘線的加權平均價
value2 = xfMin_GetValue("30",value1,1);        //取得上一期30分鐘線的加權平均價
plot1(value2);
plot2(value1[1]);                        //可以比較一下和value2的差異
```

相關函數： xfMin_GetBoolean 。
