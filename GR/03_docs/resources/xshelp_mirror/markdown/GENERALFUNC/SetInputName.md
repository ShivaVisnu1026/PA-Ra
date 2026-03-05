在XS語法內可以使用 Input語法 來設定腳本輸入的參數。

```
Input: Length(10);


Plot1(Average(Close, Length));
```

```
Input: Length(10);


Plot1(Average(Close, Length));
```

例如上面範例內定義了一個輸入參數，名稱為Length，初始值為10。在腳本內可以直接使用 Length 這個變數，而在腳本執行時則可以利用參數設定畫面來動態修改 Length 的數值，以便讓程式的設計更有彈性。

如果希望在設定畫面上可以看到中文名稱，而不是英文的變數名稱的話，則可以使用SetInputName這個函數。

```
Input: Length(10);


SetInputName(1, "天期");
Plot1(Average(Close, Length));
```

```
Input: Length(10);


SetInputName(1, "天期");
Plot1(Average(Close, Length));
```

SetInputName必須傳入兩個參數

以下是指標設定的畫面，標示處內可以看到透過SetInputName所指定的參數的名稱

SetInputField指令也可以在函數名稱之後直接加上序號，例如SetInputName1, SetInputName2等。如果函數名稱內就包含序號的話，則就不需要傳入序號參數。

上面的範例可以改寫成:

```
Input: Length(10);


SetInputName1("天期");
Plot1(Average(Close, Length));
```

```
Input: Length(10);


SetInputName1("天期");
Plot1(Average(Close, Length));
```

在XQ 5.60版之後，為了讓這個動作更簡單，使用者可以直接在Input語法內指定輸入參數的顯示名稱，上面的範例可以改寫成:

```
Input: Length(10, "天期");


Plot1(Average(Close, Length));
```

```
Input: Length(10, "天期");


Plot1(Average(Close, Length));
```

新的Input的語法可以讓程式變的更短，而且由於顯示名稱跟Input可以寫在同一行內，使用者不需要再去記憶每個Input的序號，建議大家以後直接使用Input語法來指定輸入參數的顯示名稱。
