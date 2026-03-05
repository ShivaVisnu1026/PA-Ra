時間數值是一個8~9碼的數字，格式是HHMMSS.fff:

時間數值通常是透過CurrentTime，CurrentTimeMS，Time(資料的時間欄位)，或是其他時間相關函數所產生的時間數值。

```
Value1 = CurrentTimeMS;
If Hour(Value1) = 13 And Minute(Value1) = 05 And Second(Value1) >= 30 And MilliSecond(Value1) >= 500 Then
Begin
	// 目前時間 >= 13:05:30.500
End;
```

```
Value1 = CurrentTimeMS;
If Hour(Value1) = 13 And Minute(Value1) = 05 And Second(Value1) >= 30 And MilliSecond(Value1) >= 500 Then
Begin
	// 目前時間 >= 13:05:30.500
End;
```

時間相關的的函數請參考 Hour函數 ， Minute函數 ， Second函數 ，以及 MilliSecond
