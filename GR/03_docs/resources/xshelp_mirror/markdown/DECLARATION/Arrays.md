Array 語法用來宣告一個陣列變數，同時設定陣列的大小以及陣列內儲存數值的資料型態(也可以寫成 Arrays )。

所謂陣列就是一個可以儲存 多個數值 的變數，陣列內儲存數值的個數，以及數值的資料型態可以透過Array語法來定義。

系統提供兩種控制陣列數值個數的方式。第一種方式是固定個數，語法如下:

```
Array: NumArray[10](0);
Array: StrArray[10]("");
Array: BoolArray[10](True);
```

```
Array: NumArray[10](0);
Array: StrArray[10]("");
Array: BoolArray[10](True);
```

在以上的範例設定了三個陣列變數：

以下是NumArray在宣告後的示意圖。

如果要存取NumArray的話，則使用以下的語法：

```
NumArray[1] = 5;
Value1 = NumArray[1];
```

```
NumArray[1] = 5;
Value1 = NumArray[1];
```

在中括弧[]內傳入的數值稱之為 索引值 ，索引值的範圍由1開始，一直到陣列宣告的最大個數。

如果陣列的大小無法預先知道的話，則可以使用第二種語法來宣告陣列：

```
Array: NumArray[](0);
Array: StrArray[]("");
Array: BoolArray[](True);
```

```
Array: NumArray[](0);
Array: StrArray[]("");
Array: BoolArray[](True);
```

請注意在上述語法內並未指定陣列的個數 ([] 內並沒有任何數值)。此時陣列已經被宣告，也已經定義這個陣列內可以存放的資料的格式，可以此時陣列還不可以被使用。

等到程式知道陣列的實際所需大小時，程式必須透過 Array_SetMaxIndex 函數來設定陣列的大小。

```
Var: Count(0);
Array: NumArray[](0);


If High > Highest(High,20)[1] Then Count = Count + 1;


Array_SetMaxIndex(NumArray, Count);
NumArray[Count] = High;
```

```
Var: Count(0);
Array: NumArray[](0);


If High > Highest(High,20)[1] Then Count = Count + 1;


Array_SetMaxIndex(NumArray, Count);
NumArray[Count] = High;
```

在上述範例內每當創近20期新高時 (High > Highest(High,20)[1])，NumArray就會多存放當時的新高價。由於無法預先知道所需要儲存的個數，所以使用上述語法來動態設定陣列的大小。

以上所定義的陣列變數都是屬於一維陣列，也就是說一個陣列變數內有多個數值，使用時像序列般的方式來存取。如果需要陣列內的數值可以以類似矩陣的方式來存取的話，則可以以下列語法來宣告二維陣列。

```
Array: NumArray[10,2](0);
```

```
Array: NumArray[10,2](0);
```

在上例內，中括弧[]內有兩個數值，分別是10跟2。透過這樣子的語法我們宣告了一個二維陣列，他的內容如下:

我們可以想像一個二維陣列就好像是一個Excel的表格一樣。中括弧內的第一個數值宣告這個表格的行數，第二個數字則是宣告表格的欄數。

當需要存取二維陣列時、我們使用以下的語法:

```
NumArray[5,1] = 10;
Value1 = NumArray[1,2];
```

```
NumArray[5,1] = 10;
Value1 = NumArray[1,2];
```

存取時需要傳入兩個索引值，索引值的範圍是從１開始，不能超過陣列的行數跟欄數。

※ Array 維度最多 9 個。元素數量最多 7000。例如：Array:LimitArray[a,b,c,d,e,f,g,h,i];
　則 (a+1) * (b+1) * (c+1) * (d+1) * (e+1) * (f+1) * (g+1) * (h+1) * (i+1) 所得到的元素值最多為 7000 個。
