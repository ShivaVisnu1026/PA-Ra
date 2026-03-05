時間數值是一個5~6碼的數字，格式是HHMMSS:

時間數值通常是透過CurrentTime，Time(資料的時間欄位)，或是其他時間相關函數所產生的時間數值。

```
Value1 = CurrentTime;
If Hour(Value1) = 13 And Minute(Value1) = 05 And Second(Value1) >= 30 Then
Begin
	// 目前時間 >= 13:05:30
End;
```

```
Value1 = CurrentTime;
If Hour(Value1) = 13 And Minute(Value1) = 05 And Second(Value1) >= 30 Then
Begin
	// 目前時間 >= 13:05:30
End;
```

時間數值也可以是一個含有毫秒的 8~9 碼的數字，格式是HHMMSS.fff：

含有毫秒的時間數值，通常是透過CurrentTimeMS， FilledRecordTimeMS ，或是其他時間相關函數所產生的時間數值。

以下的範例是用 CurrentTimeMS 傳入的時間數值

```
Value2 = CurrentTimeMS;
If Hour(Value2) = 13 And Minute(Value2) = 05 And Second(Value2) >= 30 Then
Begin
	// 目前時間 >= 13:05:30
End;
```

```
Value2 = CurrentTimeMS;
If Hour(Value2) = 13 And Minute(Value2) = 05 And Second(Value2) >= 30 Then
Begin
	// 目前時間 >= 13:05:30
End;
```

時間相關的的函數請參考 Hour函數 ， Minute函數 ， Second函數 ，以及 MilliSecond
