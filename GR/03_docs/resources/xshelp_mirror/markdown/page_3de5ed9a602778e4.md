(僅適用於函數腳本內)

Numeric 語法是用來定義函數腳本的參數為數值型態。

```
Input: Price(Numeric);
Input: Length(Numeric);


Value1 = Summation(Price, Length) / Length;
```

```
Input: Price(Numeric);
Input: Length(Numeric);


Value1 = Summation(Price, Length) / Length;
```

假設上例是一個名稱為 MyFunction 的函數, 在此 Price 參數跟 Length 參數都被定義成 Numeric , 表示使用這個函數的腳本必須傳遞數值型態的參數，否則腳本編譯時會產生錯誤。

以下是使用這個函數的腳本的範例:

```
Value1 = MyFunction(Close, 5);
```

```
Value1 = MyFunction(Close, 5);
```

在上例內呼叫MyFunction時傳入了 Close (收盤價序列)，以及數值5。

Numeric 型態還有以下兩個變形:

這兩種變形的用意是要幫忙系統可以更精確的處理腳本跟函數之間的運作關係。所以上述MyFunction可以被改寫成:

```
Input: Price(NumericSeries);
Input: Length(NumericSimple);


Value1 = Summation(Price, Length) / Length;
```

```
Input: Price(NumericSeries);
Input: Length(NumericSimple);


Value1 = Summation(Price, Length) / Length;
```

在這個函數內，由於 Price 是被當成序列來使用(計算加總時會用到前期值)，所以可以宣告成 NumericSeries 。而 Length 因為只會用到當下的數值，所以可以宣告成 NumericSimple 。

目前XS系統內，只要是數值參數，腳本內可以混用 Numeric , NumericSimple , 以及 NumericSeries 這三種宣告方式，不影響腳本執行的結果。
