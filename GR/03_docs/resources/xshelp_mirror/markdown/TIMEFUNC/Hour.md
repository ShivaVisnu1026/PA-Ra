時間數值是一個5~6碼的數字，格式是HHMMSS.fff:

時間數值通常是透過CurrentTime，Time(資料的時間欄位)，或是其他時間相關函數所產生的時間數值。

```
Value1 = Hour(Time);


If Value1 = 12 Then
Begin
	// 目前分鐘K棒的資料時間是12點
End;
```

```
Value1 = Hour(Time);


If Value1 = 12 Then
Begin
	// 目前分鐘K棒的資料時間是12點
End;
```

上述範例利用Hour取得目前分鐘K棒資料時間的小時數值。

```
Value2 = Hour(CurrentTime);
If Value2 >= 12 Then
Begin
	// 目前時間是中午12點過後
End;
```

```
Value2 = Hour(CurrentTime);
If Value2 >= 12 Then
Begin
	// 目前時間是中午12點過後
End;
```

上述範例則是傳入 CurrentTime ，也就是目前電腦的時間，格視為 HHMMSS。

也可以傳入含有毫秒的時間數值 CurrentTimeMS 回傳格式為 HHMMSS.fff

```
Value3 = Hour(CurrentTimeMS);
If Value3 >= 12 Then
Begin
	// 目前時間是中午12點過後
End;
```

```
Value3 = Hour(CurrentTimeMS);
If Value3 >= 12 Then
Begin
	// 目前時間是中午12點過後
End;
```

上述範例是傳入 CurrentTimeMS ，也是目前電腦的時間，不過是含有毫秒的電腦的時間，格式為 HHMMSS.fff。

時間相關的的函數請參考 Hour函數 ， Minute函數 ，以及 Second函數 。
