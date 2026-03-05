在指標腳本內必須使用Plot函數來產生繪圖數列。

每個指標腳本可以產生至多999個繪圖數列，實際使用時必須在Plot之後加上指定的繪圖序列編號，例如 Plot1 , Plot2 , 到 Plot999 。

Plot函數可以傳入三個參數

範例#1

```
Plot1(Average(Close, 5));
Plot2(Close, "收盤價");
```

```
Plot1(Average(Close, 5));
Plot2(Close, "收盤價");
```

在範例#1 內輸出兩個繪圖數列，第一個數列為收盤價的五日平均值，圖形名稱為 "Plot1"，第二個數列為收盤價(Close)，圖形名稱為 "收盤價"。

Plot1到Plot99除了可以是一個函數之外，也可以在腳本內被當成數列來引用。

範例#2

```
Plot1(Average(Close, 5));
Plot2(Close, "收盤價");
Value1 = Plot2 - Plot1;
Plot3(Value1, "差值");
```

```
Plot1(Average(Close, 5));
Plot2(Close, "收盤價");
Value1 = Plot2 - Plot1;
Plot3(Value1, "差值");
```

在範例#2 內Value1的數值是繪圖數列2(Plot2)與繪圖數列1(Plot1)的相減值，然後把這個差值畫在Plot3上面。

範例#3

```
//checkbox:=1，為預設顯示指標。
//checkbox:=0，為預設「不」顯示指標。
plot1(open,"開盤價",checkbox:=0);
plot2(high,"最高價",checkbox:=0);
plot3(low,"最低價",checkbox:=0);
plot4(close,"收盤價",checkbox:=1);//預設繪製出「收盤價」指標
```

```
//checkbox:=1，為預設顯示指標。
//checkbox:=0，為預設「不」顯示指標。
plot1(open,"開盤價",checkbox:=0);
plot2(high,"最高價",checkbox:=0);
plot3(low,"最低價",checkbox:=0);
plot4(close,"收盤價",checkbox:=1);//預設繪製出「收盤價」指標
```

在範例#3 中，有使用到 checkbox 參數，故將此XS指標腳本加入指標後的技術分析副圖，在滑鼠點選下拉式選單圖示如下：
