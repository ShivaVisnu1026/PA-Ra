一般而言BarInterval函數會跟 BarFreq 一起搭配使用，用來判斷目前執行的分鐘頻率的分鐘間隔。

```
// 先判斷目前是分鐘線
If BarFreq = "Min" Then
Begin
	If BarInterval = 30 Then
	Begin
		// 資料為30分鐘線
	End;
End;
```

```
// 先判斷目前是分鐘線
If BarFreq = "Min" Then
Begin
	If BarInterval = 30 Then
	Begin
		// 資料為30分鐘線
	End;
End;
```
