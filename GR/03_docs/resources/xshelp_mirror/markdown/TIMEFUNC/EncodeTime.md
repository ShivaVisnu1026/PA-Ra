傳入三個參數:

函數回傳值的格式為5至9碼的時間數字。

例如傳入HH=9, MM=30, SS=0的話，則回傳93000。如果傳入HH=12, MM=30, SS=0的話，則回傳123000。如果傳入HH=13, MM= 15, SS=0, MS=255 的話，則回傳 131500.255。

以下是應用範例:

```
Value1 = EncodeTime(12, 30, 0);
Value2 = EncodeTime(13, 15, 0, 255);


If CurrentTime >= Value1 Then Begin
	// 目前時間是中午12點30分以後
End;


if CurrentTimeMS >= Value2 Then Begin
	// 目前時間是中午13點15分00秒255毫秒 以後
End;
```

```
Value1 = EncodeTime(12, 30, 0);
Value2 = EncodeTime(13, 15, 0, 255);


If CurrentTime >= Value1 Then Begin
	// 目前時間是中午12點30分以後
End;


if CurrentTimeMS >= Value2 Then Begin
	// 目前時間是中午13點15分00秒255毫秒 以後
End;
```
