時間數值是一個5~6碼的數字，格式是HHMMSS.fff：

時間數值通常是透過CurrentTime，Time(資料的時間欄位)，或是其他時間相關函數所產生的時間數值。

```
Value1 = Minute(Time);
If Value1 = 0 Then
Begin
	// 目前分鐘K棒資料時間是0分
End;
```

```
Value1 = Minute(Time);
If Value1 = 0 Then
Begin
	// 目前分鐘K棒資料時間是0分
End;
```

上述範例取得目前分鐘K棒資料時間的分鐘數值。

時間數值也可以是一個8~9碼，含有毫秒的數字，格式是HHMMSS.fff：

含有毫秒的時間數值，通常是透過CurrentTimeMS， FilledRecordTimeMS ，或是其他時間相關函數所產生的時間數值。

```
Value1 = Minute(CurrentTimeMS);
If Value1 = 0 Then
Begin
	// 目前分鐘K棒資料時間是0分
End;
```

```
Value1 = Minute(CurrentTimeMS);
If Value1 = 0 Then
Begin
	// 目前分鐘K棒資料時間是0分
End;
```

上述範例，也是取得目前分鐘K棒資料時間的分鐘數值，不過是傳入含有毫秒的目前電腦時間。

時間相關的的函數請參考 Hour函數 ， Minute函數 ，以及 Second函數 。
