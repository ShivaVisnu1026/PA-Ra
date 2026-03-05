在同一個頻率時，我們可以直接利用**變數[3]**取得前3期的變數值。當資料頻率不同時（跨頻率），我們就需要使用xf_GetValue或xf_GetBoolean來取得之前的變數值。若變數是數值時，要用xf_GetValue；若變數是布林值時，要用xf_GetBoolean。

```
value1 = xf_WeightedClose("W");            //計算週線的加權平均價
value2 = xf_GetValue("W",value1,1);        //取得上一週的加權平均價
plot1(value2);
plot2(value1[1]);                        //可以比較一下和value2的差異
```

```
value1 = xf_WeightedClose("W");            //計算週線的加權平均價
value2 = xf_GetValue("W",value1,1);        //取得上一週的加權平均價
plot1(value2);
plot2(value1[1]);                        //可以比較一下和value2的差異
```

相關函數： xf_GetBoolean 。
