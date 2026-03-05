時間數值是一個5~6碼的數字，格式是HHMMSS:

時間數值通常是透過CurrentTime，Time(資料的時間欄位)，或是其他時間相關函數所產生的時間數值。

時間數值也可以是一個含有毫秒的 8~9 碼的數字，格式是HHMMSS.fff：

通常是透過CurrentTimeMS， FilledRecordTimeMS ，或是其他含有毫秒的時間相關函數所產生的時間數值。

TimeDiff回傳的數值是第一個時間減第二個時間的差異:

如果第一個時間小於第二個時間的話，則回傳的數值是負數。

```
Value1 = TimeDiff(130000, 120000, "H"); // Value1 = 1(小時)
Value2 = TimeDiff(133000, 123000, "M"); // Value2 = 60(分鐘)
Value3 = TimeDiff(133000, 090000, "M"); // Value3 = 270(分鐘)
Value4 = TimeDiff(123000, 130000, "H"); // Value4 = -0.5(小時)
Value5 = TimeDiff(120000.123, 120000, "MS"); // Value5 = 123(毫秒)
```

```
Value1 = TimeDiff(130000, 120000, "H"); // Value1 = 1(小時)
Value2 = TimeDiff(133000, 123000, "M"); // Value2 = 60(分鐘)
Value3 = TimeDiff(133000, 090000, "M"); // Value3 = 270(分鐘)
Value4 = TimeDiff(123000, 130000, "H"); // Value4 = -0.5(小時)
Value5 = TimeDiff(120000.123, 120000, "MS"); // Value5 = 123(毫秒)
```

底下是一個應用範例，使用１分鐘資料。利用TimeDiff來計算大單成交的時間間隔，如果發生的很密集的話則觸發。

```
Var: vTime(0); 
if getfielddate("Date") <> getfielddate("Date")[1] then vTime = 0;
If Volume*Close > 10000 then vTime =Time; // 紀錄交易金額大於1000萬的K棒時間
If vTime <> vTime[1] and absValue(TimeDiff(vTime, vTime[1], "M")) < 5 Then begin
	ret = 1;
	print(vTime, vTime[1], absvalue(TimeDiff(vTime, vTime[1], "M")));
end;
```

```
Var: vTime(0); 
if getfielddate("Date") <> getfielddate("Date")[1] then vTime = 0;
If Volume*Close > 10000 then vTime =Time; // 紀錄交易金額大於1000萬的K棒時間
If vTime <> vTime[1] and absValue(TimeDiff(vTime, vTime[1], "M")) < 5 Then begin
	ret = 1;
	print(vTime, vTime[1], absvalue(TimeDiff(vTime, vTime[1], "M")));
end;
```
