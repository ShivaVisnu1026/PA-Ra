經由傳入的日期判斷指定頻率的期別是否有異動，支援指定分鐘頻率。

```
value1 = xfMin_getdtvalue("30",date);
if value1 <> value1[1] then plot1(1) else plot1(0);
```

```
value1 = xfMin_getdtvalue("30",date);
if value1 <> value1[1] then plot1(1) else plot1(0);
```

上述範例利用xfMin_GetDTValue來判斷目前是否為新的30分鐘。如果是的話則在圖表上顯示為1。
