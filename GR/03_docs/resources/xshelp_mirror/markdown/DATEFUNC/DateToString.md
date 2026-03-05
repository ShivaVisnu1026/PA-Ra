日期數值是一個8碼的數字，格式為YYYYMMDD:

日期數值通常是透過CurrentDate，或是Date(資料的日期欄位)，或是其他日期相關函數所產生的日期數值。

回傳字串的格式是" YYYY/MM/DD "，其中YYYY為４位年份，MM為月份，從01到12，DD則是日期，從01到31。

舉例而言，如果目前日期是20150601的話，以下的程式碼

```
Print(DateToString(CurrentDate));
```

```
Print(DateToString(CurrentDate));
```

將會印出 "2015/06/01"的字串。

請參考 StringToDate函數 。
