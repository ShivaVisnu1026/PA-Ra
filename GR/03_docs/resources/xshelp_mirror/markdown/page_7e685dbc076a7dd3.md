While 語法是用來定義一段迴圈的執行邏輯。語法如下：

```
While 判斷式
  執行的指令;
```

```
While 判斷式
  執行的指令;
```

當判斷式成立時，While迴圈會重複的執行，一直到判斷式回傳False為止。

如果在迴圈內需要執行多個指令的話，則可以使用 Begin/End 的方式來包圍。

```
While 判斷式
Begin
  執行的指令1;
  執行的指令2;
End;
```

```
While 判斷式
Begin
  執行的指令1;
  執行的指令2;
End;
```

以下是一個範例:

```
SumValue = 0;
While i < 5
  Begin
    SumValue = SumValue + Close[i];
    i = i + 1;
  End;
AvgValue = SumValue / 5;
```

```
SumValue = 0;
While i < 5
  Begin
    SumValue = SumValue + Close[i];
    i = i + 1;
  End;
AvgValue = SumValue / 5;
```

上述範例內While的迴圈會一直執行，直到 i 的數值 >= 5時才會停止。每次執行時SumValue會累加前幾期的Close數值，同時變數i 會每次加1。以這個範例而言，SumValue的數值會變成是最近５期收盤價的加總，最後算出AvgValue為最近５期的平均收盤價。

系統內還提供不同的迴圈控制方式，請參考 Repeat/Until 以及 For 。
