Begin / End 語法用在 If , While , For 等控制指令內。當需要輸入超過一行的程式碼時，就必須使用 Begin / End 來把程式碼 包圍 起來。

```
If Close >= Close[1] Then ret = 1;  // 計算漲跌
```

```
If Close >= Close[1] Then ret = 1;  // 計算漲跌
```

上述範例內當Close >= Close[1]時因為只需要執行一行指令，所以可以把指令直接寫出來。

可是在以下的範例內，由於當Close >= Close[1]時我們希望要執行兩個指令，所以透過 Begin / End 把這兩個指令包圍起來。

```
If Close >= Close[1] Then
Begin
   Value1 = Close - Close[1];  // 計算漲跌
   Value2 = Value1 / Close[1]; // 計算漲跌幅
End;
```

```
If Close >= Close[1] Then
Begin
   Value1 = Close - Close[1];  // 計算漲跌
   Value2 = Value1 / Close[1]; // 計算漲跌幅
End;
```
