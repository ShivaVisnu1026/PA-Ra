日期數值是一個8碼的數字，格式為YYYYMMDD:

日期數值通常是透過CurrentDate，或是Date(資料的日期欄位)，或是其他日期相關函數所產生的日期數值。

回傳的數值則是這個日期是這個月的第幾天，可能的數值從1到31。

舉例：

```
Value1 = DayOfMonth(20150601);	// Value1 = 1
Value2 = DayOfMonth(20150630);  // Value2 = 30
```

```
Value1 = DayOfMonth(20150601);	// Value1 = 1
Value2 = DayOfMonth(20150630);  // Value2 = 30
```

日期相關的函數請參考 Year函數 ， Month函數 ， DayOfMonth函數 ， DayOfWeek函數 ， WeekOfMonth函數 ，以及 WeekOfYear函數 。
