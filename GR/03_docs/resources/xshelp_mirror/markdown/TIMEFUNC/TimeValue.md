時間數值是一個5~6碼的數字，格式是HHMMSS：

時間數值通常是透過CurrentTime，Time(資料的時間欄位)，或是其他時間相關函數所產生的時間數值。

回傳數值依照指定欄位分別定義:

時間數值也可以是一個含有毫秒的 8~9碼 的數字，格式為HHMMSS.fff：

含有毫秒的時間數值通常是透過CurrentTimeMS， FilledRecordTimeMS ，或是其他時間相關函數所產生的時間數值。

回傳數值依照指定欄位分別定義:

以下是一個範例:

```
Value1 = TimeValue(CurrentTime, "H");
Value2 = TimeValue(CurrentTimeMS, "MS");


If Value1 >= 12 Then Begin
	// 目前時間是中午12點過後
End;


if Value2 >= 500 Then Begin
	// 目前時間是 500 毫秒過後
End;
```

```
Value1 = TimeValue(CurrentTime, "H");
Value2 = TimeValue(CurrentTimeMS, "MS");


If Value1 >= 12 Then Begin
	// 目前時間是中午12點過後
End;


if Value2 >= 500 Then Begin
	// 目前時間是 500 毫秒過後
End;
```

這個函數可以看成是 Hour , Minute , Second , 以及 MilliSecond 還有的綜合體。
