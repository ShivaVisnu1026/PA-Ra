日期數值為YYYYMMDD的8碼數字，例如CurrentDate，或是Date，或是20150601，或是其他日期相關函數所回傳的日期欄位。

DateDiff回傳的數值是第一個日期減第二個日期的差異天數，如果第一個日期小於第二個日期的話，則回傳的數值是負數。

```
Value1 = DateDiff(20160601, 20160501);  // Value1 = 31(日)
Value2 = DateDiff(20160601, 20160602);  // Value2 = -1(日)
```

```
Value1 = DateDiff(20160601, 20160501);  // Value1 = 31(日)
Value2 = DateDiff(20160601, 20160602);  // Value2 = -1(日)
```

一般可以利用這個函數來判斷價位日期之間的關係

```
if High > Highest(Close[1],60) and DateDiff(CurrentDate, Date) < 5 then ret=1;
```

```
if High > Highest(Close[1],60) and DateDiff(CurrentDate, Date) < 5 then ret=1;
```

以上的警示範例(使用日資料執行)會在近5日內創60日新高時觸發。注意到腳本內使用DateDiff來判斷創新高的日期(Date)是否與目前電腦日期(也就是執行當日)的差異是在5日之內。
