在XS系統內日期的標準格式為YYYYMMDD的8碼數字。如果需要執行日期的計算時，一般可以使用 DateAdd函數 或是 DateDiff函數 。

另外一種計算方式，則是把日期轉換成 儒略日格式 後再來計算。因為儒略日格式採用 絕對天數 的方式來紀錄日期數值，所以可以直接做數值運算，然後再使用 JulianToDate函數 轉成YYYYMMDD的8碼日期格式。

```
Value1 = DateToJulian(20150601);  // 把20150601轉成Julian格式
Value1 = Value1 + 1;                        // 直接加1天
Value2 = JulianToDate(Value1);       // Value2 = 20150602
```

```
Value1 = DateToJulian(20150601);  // 把20150601轉成Julian格式
Value1 = Value1 + 1;                        // 直接加1天
Value2 = JulianToDate(Value1);       // Value2 = 20150602
```
