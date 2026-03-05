經由傳入的日期判斷指定頻率的期別是否有異動

```
value1 = xf_getdtvalue("W",date);
if value1 <> value1[1] then plot1(1) else plot1(0);
```

```
value1 = xf_getdtvalue("W",date);
if value1 <> value1[1] then plot1(1) else plot1(0);
```

上述範例利用xf_GetDTValue來判斷目前是否為新的一週。如果是的話則在圖表上顯示為1。
