Once 語法用來定義某些 只需要執行一次的程式碼 。

舉例而言：

```
Once(High = Highest(High, 5))
Begin
    HighDate = Date;
    HighPrice = High;
End;
```

```
Once(High = Highest(High, 5))
Begin
    HighDate = Date;
    HighPrice = High;
End;
```

Once 語法之後必須填入一個判斷式，以上例而言，這個判斷式是 High = Highest(High, 5) ，在判斷式之後，可以填入當判斷式成立時要執行的指令，如果有多行指令的話則可以使用 Begin/End 來包圍。

所以上面這個範例執行的邏輯是，當創5日新高時，執行HighDate = Date，以及HighPrice = High這兩個指令， 而且一旦出現創5日新高的情形之後，就不再執行HighDate = Date, 以及HighPrice = High這兩個指令 。

如果要達到同樣的目的，也可以使用IF指令，搭配一個紀錄是否曾經執行過的變數：

```
Var: FirstTime(False);
If High = Highest(High, 5) And Not FirstTime Then
Begin
    HighDate = Date;
    HighPrice = High;
    FirstTime = True;
End;
```

```
Var: FirstTime(False);
If High = Highest(High, 5) And Not FirstTime Then
Begin
    HighDate = Date;
    HighPrice = High;
    FirstTime = True;
End;
```

在上述範例內，程式使用 FirstTime 這個變數來紀錄這個IF狀態是否曾經發生過，以確保只會執行一次。

可是由於系統會根據執行的設定方式在每一筆bar甚至每一筆tick更新時都會執行完整的程式碼，所以如果是使用If的寫法的話，每一次執行時還是會去判斷 High是否等於Highest(High, 5)！反之，如果是使用Once的寫法的話，一旦Once的運算式成立之後，未來不管執行任意bar，系統都會 自動跳過Once的判斷式以及程式碼 。由於在這個例子內，IF內所需要執行的指令比較複雜且費時，所以就可以使用 Once 的語法來提升執行的速度。
