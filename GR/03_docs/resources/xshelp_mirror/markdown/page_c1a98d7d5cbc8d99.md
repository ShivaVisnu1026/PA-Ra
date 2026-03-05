時間數值是一個5~6碼的數字，格式是HHMMSS:

時間數值通常是透過CurrentTime，CurrentTimeMS，Time(資料的時間欄位)，或是其他時間相關函數所產生的時間數值。

回傳字串的格式是" HH:MM:SS "，其中HH(小時)的範圍從00到23 (24小時制，兩碼)，MM(分鐘)的範圍從00到59，SS(秒數)的範圍從00到59。

舉例而言，如果目前時間是9點30分00秒，以下的程式碼

```
Print(TimeToString(CurrentTime));
```

```
Print(TimeToString(CurrentTime));
```

將會印出 "09:30:00"的字串。

如果回傳字串的格式是" HH:MM:SS.fff "，其中HH(小時)的範圍從00到23 (24小時制，兩碼)，MM(分鐘)的範圍從00到59，SS(秒數)的範圍從00到59，fff(毫秒)的範圍從000到999。

例如目前時間是9點30分00秒500毫秒，以下的程式碼

```
Print(TimeToString(CurrentTimeMS));
```

```
Print(TimeToString(CurrentTimeMS));
```

將會印出 "09:30:00.500"的字串。

請參考 StringToTime函數 。
