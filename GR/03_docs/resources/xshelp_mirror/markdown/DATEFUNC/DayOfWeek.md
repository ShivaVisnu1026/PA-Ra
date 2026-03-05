日期數值是一個8碼的數字，格式為YYYYMMDD:

日期數值通常是透過CurrentDate，或是Date(資料的日期欄位)，或是其他日期相關函數所產生的日期數值。

回傳的數值則是這個日期是這個星期的第幾天，可能的數值從0(星期日)到6(星期六)。

範例:

```
If DayOfWeek(Date) = 1 Then
Begin
	// 目前K棒資料日期是星期一
End;
```

```
If DayOfWeek(Date) = 1 Then
Begin
	// 目前K棒資料日期是星期一
End;
```

日期相關的函數請參考 Year函數 ， Month函數 ， DayOfMonth函數 ， DayOfWeek函數 ， WeekOfMonth函數 ，以及 WeekOfYear函數 。
