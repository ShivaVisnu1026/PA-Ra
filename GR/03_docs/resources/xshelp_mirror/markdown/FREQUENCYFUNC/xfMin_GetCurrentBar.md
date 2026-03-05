傳回指定頻率（支援分鐘）的K棒序列編號，由1開始，第一筆K棒編號為1，第二筆K棒編號為2，依序遞增。

可以使用這個函數來判斷目前腳本執行的時機點

```
value1 = xfMin_GetCurrentBar(FreqType);


if Length + 1 = 0 then Factor = 1 else Factor = 2 / (Length + 1);


if value1 = 1 then
    xfMin_XAverage = Series
else
    xfMin_XAverage = lastXAverage + Factor * (Series - lastXAverage);
```

```
value1 = xfMin_GetCurrentBar(FreqType);


if Length + 1 = 0 then Factor = 1 else Factor = 2 / (Length + 1);


if value1 = 1 then
    xfMin_XAverage = Series
else
    xfMin_XAverage = lastXAverage + Factor * (Series - lastXAverage);
```

上述範例利用xfMin_GetCurrentBar來判斷目前是否是第一筆K棒。如果是的話則回傳xfMin_XAverage的初始數值。
