運用這個函數來判斷目前的執行頻率是否為還原頻率。

在執行頻率為「分鐘」的資料表達為：

在執行頻率為「日」以上頻率的資料表達為：

應用在指定策略執行的頻率，避免執行頻率設定錯誤的範例語法如下：

```
if BarFreq <> "D" or BarAdjusted <> True  then raiseRunTimeError("僅支援還原日頻率");
```

```
if BarFreq <> "D" or BarAdjusted <> True  then raiseRunTimeError("僅支援還原日頻率");
```

```
if BarInterval <> 5 
or barFreq <> "Min" 
or BarAdjusted <> true then raiseRunTimeError("僅支援還原5分鐘線圖");
```

```
if BarInterval <> 5 
or barFreq <> "Min" 
or BarAdjusted <> true then raiseRunTimeError("僅支援還原5分鐘線圖");
```
