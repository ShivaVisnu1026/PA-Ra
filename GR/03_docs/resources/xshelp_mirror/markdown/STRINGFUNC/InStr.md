這個函數可以傳入參個參數：

如果欲比對的字串是原始字串的一部份的話，則回傳這個字串位於原始字串的位置。反之則回傳0。

```
Value1 = InStr("abcdefg", "bc");  // Value1 = 2
Value2 = InStr("abcdefg", "xyz"); // Value2 = 0
Value3 = InStr("Hello Hello", "Hello", 6);  //Value3 = 7
```

```
Value1 = InStr("abcdefg", "bc");  // Value1 = 2
Value2 = InStr("abcdefg", "xyz"); // Value2 = 0
Value3 = InStr("Hello Hello", "Hello", 6);  //Value3 = 7
```

在上述範例內，"bc"是"abcdefg"的一部份，所以Value1的值會是"bc"位於"abcdefg"內的位置，第2個字元。而"xzy"並不是"abcdefg"的一部份，所以Value2 = 0。
Value3 則是因為指定要從第6個位置開始找起，所以會找到第二個Hello，故回7。
