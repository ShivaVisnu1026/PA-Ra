日期數值是一個8碼的數字，格式為YYYYMMDD:

日期數值通常是透過CurrentDate，或是Date(資料的日期欄位)，或是其他日期相關函數所產生的日期數值。

回傳的數值則是這個日期是這個月的第幾個星期，可能的數值從1到6。

```
Value1 = WeekOfMonth(20150601);   // Value1 = 1 (第一週)
```

```
Value1 = WeekOfMonth(20150601);   // Value1 = 1 (第一週)
```

日期相關的函數請參考 Year函數 ， Month函數 ， DayOfMonth函數 ， DayOfWeek函數 ， WeekOfMonth函數 ，以及 WeekOfYear函數 。
