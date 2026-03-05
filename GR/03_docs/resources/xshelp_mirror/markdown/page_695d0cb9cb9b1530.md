在同一個頻率時，我們可以直接利用**變數[3]**取得前3期的變數值。當資料頻率不同時（跨頻率），我們就需要使用xfMin_GetValue或xfMin_GetBoolean來取得之前的變數值。若變數是數值時，要用xfMin_GetValue；若變數是布林值時，要用xfMin_GetBoolean。支援跨分鐘頻率。

```
input:Length_Min(9,"跨分鐘頻率期數");
variable:rsv_w(0),kk_w(0),dd_w(0);
xfMin_stochastic("30", Length_Min, 3, 3, rsv_w, kk_w, dd_w);
condition1 = xfMin_GetBoolean("30",xfMin_crossover("30", kk_w, dd_w),1);	//在15分鐘線抓30分鐘線KD黃金交叉
```

```
input:Length_Min(9,"跨分鐘頻率期數");
variable:rsv_w(0),kk_w(0),dd_w(0);
xfMin_stochastic("30", Length_Min, 3, 3, rsv_w, kk_w, dd_w);
condition1 = xfMin_GetBoolean("30",xfMin_crossover("30", kk_w, dd_w),1);	//在15分鐘線抓30分鐘線KD黃金交叉
```

相關函數： xfMin_GetValue 。
