歷史區間為當時 的意思是，例如回溯、回測，都是腳本執行在歷史的時間範圍中，這時的CurrentDate就會是歷史當天，而非今天。

即時區間為當日 的意思是，腳本執行在當下，因此CurrentDate就會是今天。

回傳的日期格式是一個8碼的數字 YYYYMMDD :

舉例而言，如果執行日期是2015年6月1日，則CurrentDate回傳 20150601。

```
Print("CurrentDate=", CurrentDate);
```

```
Print("CurrentDate=", CurrentDate);
```
