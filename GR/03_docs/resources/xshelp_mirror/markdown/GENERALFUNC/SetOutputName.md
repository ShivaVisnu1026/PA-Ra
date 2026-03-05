在XS語法內可以使用 OutputField指令 來產生選股時的輸出欄位。

預設的輸出欄位的標題為 "欄位"加上"序號"，例如"欄位1", "欄位2"等。為了讓輸出報表更清楚，可以使用SetOutputName指令來設定輸出欄位的名稱。

SetOutputName必須傳入兩個參數:

例如:

```
OutputField1(GetField("月營收年增率","M"));
SetOutputName(1, "月營收年增率");
```

```
OutputField1(GetField("月營收年增率","M"));
SetOutputName(1, "月營收年增率");
```

在上面範例內指定第一個輸出欄位的標題為"月營收年增率"。

SetOutputField指令也可以在函數名稱之後直接加上序號，例如SetOutputName1, SetOutputName2等。如果函數名稱內就包含序號的話，則就不需要傳入序號參數。

上面的範例可以改寫成:

```
OutputField1(GetField("月營收年增率","M"));
SetOutputName1("月營收年增率");
```

```
OutputField1(GetField("月營收年增率","M"));
SetOutputName1("月營收年增率");
```

在XQ 5.60版之後， OutputField指令 也增加了可以直接傳入欄位標題的功能。
