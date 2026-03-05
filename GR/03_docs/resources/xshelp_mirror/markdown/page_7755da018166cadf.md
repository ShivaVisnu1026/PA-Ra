For 語法是用來定義一段迴圈的執行邏輯。

For 迴圈語法內必須使用一個變數，指定這個變數的 初始值 跟 結束值 ，同時指定這個迴圈內要執行的指令:

```
For 變數 = 初始值 to 結束值
  執行的指令;
```

```
For 變數 = 初始值 to 結束值
  執行的指令;
```

如果要執行的指定超過一行的話則使用 Begin/End 語法來包裝需要執行的指定

```
For 變數 = 初始值 to 結束值
Begin
  執行的指令1;
  執行的指令2;
End;
```

```
For 變數 = 初始值 to 結束值
Begin
  執行的指令1;
  執行的指令2;
End;
```

迴圈內的指令總共會被執行**(結束值 -  初始值 + 1) 次，在期間每次執行時，變數的值會從 初始值 一一遞增到 結束值**為止。

以下是一個實例:

```
SumValue = 0;
For i = 0 to 4
Begin
	SumValue = SumValue + Close[i];
End;
AvgValue = SumValue / 5;
```

```
SumValue = 0;
For i = 0 to 4
Begin
	SumValue = SumValue + Close[i];
End;
AvgValue = SumValue / 5;
```

上述的範例是一個累加的用法，透過For迴圈總共執行了5次(4 - 0 + 1)，第一次執行時i = 0(初始值), 第二次執行時i = 1(遞增), 最後一次執行時i = 4(結束值)。所以執行完For迴圈後SumValue的數值是最近５期Close欄位的累加值，把SumValue的值除以5之後就可以得到Close值的平均數值。

如果迴圈的控制方式希望是從 初始值 一直減少直到 結束值 為止的話，則可以使用 DownTo 指令。

```
SumValue = 0;
For i = 4 downto 0
Begin
	SumValue = SumValue + Close[i];
End;
AvgValue = SumValue / 5;
```

```
SumValue = 0;
For i = 4 downto 0
Begin
	SumValue = SumValue + Close[i];
End;
AvgValue = SumValue / 5;
```

上述範例執行的結果與先前相同，唯一的差異是 DownTo 語法，所以迴圈執行的方式是第一次i = 4, 第二次 i = 3(遞減), 第三次 i = 2, 第四次 i = 1, 最後一次 i = 0。

一般而言迴圈的執行次數是透過初始值跟結束值來控制的，可是如果需要在執行過程內 提前跳出 的話，則可以使用 Break 指令。

系統內還提供不同的迴圈控制方式，請參考 Repeat/Until 以及 While 。
