使用 IF / THEN / ELSE 這三個語法來判斷某個條件成立時該執行那個動作，不成立時又該執行那個動作。

如果只需要判斷某個條件成立時該執行那個動作，則使用以下的語法:

```
If Close > Open Then Ret = 1;
```

```
If Close > Open Then Ret = 1;
```

在上述範例內如果Close值大於Open值的話則 Ret 變數的數值會被設定為1。

如果當條件成立時需要執行多個指令的話，則使用 Begin / End 的語法來包圍所需要執行的指令。

```
If Close > Open Then 
Begin
	Value1 = Close - Open;
	Value2 = High - Low;
End;
```

```
If Close > Open Then 
Begin
	Value1 = Close - Open;
	Value2 = High - Low;
End;
```

如果條件成立時跟不成立時都需要執行不同的指令的話，則可以加入 ELSE 語法來定義條件不成立時該執行的動作。

```
If Close > Open Then
	Value1 = Close - Open
Else
	Value1 = Open - Close;
```

```
If Close > Open Then
	Value1 = Close - Open
Else
	Value1 = Open - Close;
```

在上述範例內當Close的數值不大於Open的數值時，程式會執行Else內的語法。以這個例子為例，Value1的數值就是這根bar的實體高度。

同樣的，Else之後也可以使用Begin/End語法來定義多個指令，範例如下:

```
If Close > Open Then 
Begin
	Value1 = Close - Open;
	Value2 = High - Low;
End
Else 
Begin
	Value1 = Open - Close;
	Value2 = High - Low;
End;
```

```
If Close > Open Then 
Begin
	Value1 = Close - Open;
	Value2 = High - Low;
End
Else 
Begin
	Value1 = Open - Close;
	Value2 = High - Low;
End;
```

Else後面也可以接if，用else if來進行多層次的條件判斷，從腳本上至下依序縮小判斷範圍，範例如下:

```
if value1 < 0 then 
	value2 = 1
else if value1 < 10 then //等同於if  0 <= value1 and value1 < 10
	value2 = 2
else if value1 < 20 then //等同於if  0 <= value1 and value1 < 10
	value2 = 3
else  //等同於if  20<= value1 
	value2 = 4;
```

```
if value1 < 0 then 
	value2 = 1
else if value1 < 10 then //等同於if  0 <= value1 and value1 < 10
	value2 = 2
else if value1 < 20 then //等同於if  0 <= value1 and value1 < 10
	value2 = 3
else  //等同於if  20<= value1 
	value2 = 4;
```
