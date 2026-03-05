日期數值是一個8碼的數字，格式為YYYYMMDD:

日期數值通常是透過CurrentDate，或是Date(資料的日期欄位)，或是其他日期相關函數所產生的日期數值。

回傳數值依照指定欄位而有不同:

以下是一個範例:

```
Value1 = DateValue(20150601, "Y");  // Value1 = 2015
Value2 = DateValue(20150601, "M");  // Value2 = 6
Value3 = DateValue(20150601, "D");  // Value3 = 1
Value4 = DateValue(20150601, "DW"); // Value4 = 1 (星期一)
Value5 = DateValue(20150601, "WM"); // Value5 = 1 (6月第一週)
Value6 = DateValue(20150601, "WY"); // Value6 = 23 (2015年第23週)
```

```
Value1 = DateValue(20150601, "Y");  // Value1 = 2015
Value2 = DateValue(20150601, "M");  // Value2 = 6
Value3 = DateValue(20150601, "D");  // Value3 = 1
Value4 = DateValue(20150601, "DW"); // Value4 = 1 (星期一)
Value5 = DateValue(20150601, "WM"); // Value5 = 1 (6月第一週)
Value6 = DateValue(20150601, "WY"); // Value6 = 23 (2015年第23週)
```

這個函數可以看成是 Year函數 ， Month函數 ， DayOfMonth函數 ， DayOfWeek函數 ， WeekOfMonth函數 ，以及 WeekOfYear函數 等函數的綜合體。
