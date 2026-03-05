此函數可以用來刪除字串中的開頭和結尾的空白字元，預設是將開頭與結尾的空白都刪除，但可以透過傳入參數的方式來指定只刪除開頭或結尾。

範例：

```
str1 = StrTrim("  hello world "); 
//回傳的字串會是"hello world"。


str1 = StrTrim("  hello world ", 0); 
//回傳的字串會是 "hello world"。


str1 = StrTrim("  hello world ", 1); 
//回傳的字會是 "hello world "。


str1 = StrTrim("  hello world ", 2);
//回傳的字串會是"  hello world"。
```

```
str1 = StrTrim("  hello world "); 
//回傳的字串會是"hello world"。


str1 = StrTrim("  hello world ", 0); 
//回傳的字串會是 "hello world"。


str1 = StrTrim("  hello world ", 1); 
//回傳的字會是 "hello world "。


str1 = StrTrim("  hello world ", 2);
//回傳的字串會是"  hello world"。
```
