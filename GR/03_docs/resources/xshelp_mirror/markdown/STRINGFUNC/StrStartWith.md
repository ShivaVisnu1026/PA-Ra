此函數可以用來比較傳入的第一個字串開頭字母是否和第二個字串相同。
預設的比對方是不區分字母大小寫，但可以透過傳入第三個參數來改變。

範例：

```
condition1 = StrStartWith(“ABCDEFG”, “ABC”);
//回傳 True。


condition1 = StrStartWith(“ABCDEFG”, “DEF”);
//回傳 False。


condition1 = StrStartWith(“ABCDEFG”, “abc”);
//回傳 True。(預設是不區分大小寫)


condition1 = StrStartWith(“ABCDEFG”, “abc”, false);
//回傳 False。
```

```
condition1 = StrStartWith(“ABCDEFG”, “ABC”);
//回傳 True。


condition1 = StrStartWith(“ABCDEFG”, “DEF”);
//回傳 False。


condition1 = StrStartWith(“ABCDEFG”, “abc”);
//回傳 True。(預設是不區分大小寫)


condition1 = StrStartWith(“ABCDEFG”, “abc”, false);
//回傳 False。
```
