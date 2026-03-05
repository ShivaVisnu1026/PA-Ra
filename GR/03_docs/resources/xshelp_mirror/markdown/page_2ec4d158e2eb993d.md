Return 指令用來中斷正在執行的腳本。當程式遇到這個指令時，執行將會中斷。

```
If CurrentTime < 123000 Then Return;


If Close > Close[1] and Close = High Then Ret = 1;
```

```
If CurrentTime < 123000 Then Return;


If Close > Close[1] and Close = High Then Ret = 1;
```

上述範例利用CurrentTime來判斷執行時間，如果是在12:30之前的話則不做任何動作(腳本直接中斷，等待下一根bar)。在12:30過後如果收盤價創當日新高的話則觸發。
