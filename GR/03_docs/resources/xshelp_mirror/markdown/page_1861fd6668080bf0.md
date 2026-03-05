在同一個頻率時，我們可以直接利用**變數[3]**取得前3期的變數值。當資料頻率不同時（跨頻率），我們就需要使用xf_GetValue或xf_GetBoolean來取得之前的變數值。若變數是數值時，要用xf_GetValue；若變數是布林值時，要用xf_GetBoolean。

```
input:Length_W(9,"跨頻率週期數");
variable:rsv_w(0),kk_w(0),dd_w(0);
xf_stochastic("W", Length_W, 3, 3, rsv_w, kk_w, dd_w);
condition1 = xf_GetBoolean("W",xf_crossover("W", kk_w, dd_w),1);	//在日線抓周KD黃金交叉
```

```
input:Length_W(9,"跨頻率週期數");
variable:rsv_w(0),kk_w(0),dd_w(0);
xf_stochastic("W", Length_W, 3, 3, rsv_w, kk_w, dd_w);
condition1 = xf_GetBoolean("W",xf_crossover("W", kk_w, dd_w),1);	//在日線抓周KD黃金交叉
```

相關函數： xf_GetValue 。
