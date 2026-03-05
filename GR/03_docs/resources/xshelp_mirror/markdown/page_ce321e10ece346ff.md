Input 語法用來宣告腳本參數的名稱以及資料類型(也可以寫成 Inputs )。

Input 的語法依照腳本類型而有差異。

如果是指標腳本，警示腳本，或是選股腳本的話，則使用以下語法。以下是一個指標的範例：

```
Input: Length(10);


Plot1(Average(Close, Length));
```

```
Input: Length(10);


Plot1(Average(Close, Length));
```

在上述的指標範例內宣告了一個名為 Length 的參數，用來存放計算收盤價平均值的天期。這個參數的預設值為10，資料類型為數字。

一旦宣告之後，程式內則可以像 變數 Var 一樣的使用這個參數。可是跟變數不同的是，使用者在使用這個腳本時，可以透過參數設定的畫面來動態控制這個參數的數值。以下是設定指標時的參數設定畫面:

由於使用者可以在引用腳本時動態控制參數的數值，腳本的應用上會更有彈性。

在上面的參數設定畫面內看到參數名稱顯示為 Length ，也就是Input語法內設定的變數名稱。如果希望畫面上看到的參數名稱是中文的話，則可以在Input語法內傳入參數名稱:

以下是修改後的範例:

```
Input: Length(10, "天期");


Plot1(Average(Close, Length));
```

```
Input: Length(10, "天期");


Plot1(Average(Close, Length));
```

底下是設定參數畫面:

注意到畫面上出現的參數名稱已經變成 "天期"了。這樣子的作法可以讓腳本的使用上更為清楚。

Input語法如果應用在函數腳本內的話，則必須使用不同的語法:

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

在上述範例內宣告了兩個參數，第一個參數叫做 Price ，他的資料格式是一個數字序列，第二個參數叫做 Length ，他的資料格式是一個數字( 不是序列 )。

```
Input: Price(NumericSeries,"價格");
Input: Length(NumericSimple,"天期");
```

```
Input: Price(NumericSeries,"價格");
Input: Length(NumericSimple,"天期");
```

在上述範例內宣告了兩個參數，第一個參數叫做 Price ，他的資料格式是一個數字序列，且參數名稱為 價格 ；第二個參數叫做 Length ，他的資料格式是一個數字( 不是序列 )，且參數名稱為 天期 。

```
Input: Price(close,NumericSeries,"價格");
Input: Length(10,NumericSimple,"天期");
```

```
Input: Price(close,NumericSeries,"價格");
Input: Length(10,NumericSimple,"天期");
```

在上述範例內宣告了兩個參數，第一個參數叫做 Price ，預設值為 Close ，他的資料格式是一個數字序列，參數名稱為 價格 ；第二個參數叫做 Length ，預設值為 10 ，他的資料格式是一個數字( 不是序列 )，參數名稱為 天期 。

關於函數所支援的各種不同的參數類型，請參考以下章節:
