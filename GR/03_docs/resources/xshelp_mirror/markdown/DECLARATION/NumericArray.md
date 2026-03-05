(僅適用於函數腳本內)

NumericArray 語法用來定義函數腳本的參數為數值陣列型態。

```
Input: MyNumericArray[X](NumericArray);


For Value1 = 1 to X
  Value2 = Value2 + MyNumericArray[Value1];
```

```
Input: MyNumericArray[X](NumericArray);


For Value1 = 1 to X
  Value2 = Value2 + MyNumericArray[Value1];
```

NumericArray 與 Numeric 最大的差異是在Input語法內陣列變數名稱之後還需要定義*[陣列大小變數] 。在上例內 [X]*就宣告了一個變數 X ，他的數值會是傳入的陣列的大小( 陣列內有多少數值 )。

透過這個機制，函數內就可以知道傳入的陣列的大小，然後利用這個資訊來正確的判斷可以讀取哪些數值。
上述範例內使用一個 For迴圈來加總傳入陣列的每個數值，迴圈的範圍是從1開始，直到 X 結束。

如果需要傳入的陣列是二維的，則語法如下:

```
Input: MyNumericArray[X,Y](NumericArray);
```

```
Input: MyNumericArray[X,Y](NumericArray);
```

在上例內中括弧內必須填入兩個變數( X , Y )，這兩個變數的數值將會分別是傳入的陣列的行數跟欄數。
