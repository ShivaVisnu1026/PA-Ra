此函數可以把第一個字串參數用第二個字串參數切割後放入的第三個參數陣列中。

範例：

```
Array: tokens[](""), tokens2[3]("");


value1 = StrSplit("A,B,C,D,E", ",", tokens);  
value2 = StrSplit("A,B,C;D,E", ",", tokens2);
```

```
Array: tokens[](""), tokens2[3]("");


value1 = StrSplit("A,B,C,D,E", ",", tokens);  
value2 = StrSplit("A,B,C;D,E", ",", tokens2);
```

value1 會是5。
tokens因為是動態陣列，所以會被自動調整成5個元素的大小。
tokens[1] = "A", tokens[2] = "B", tokens[3]="C", tokens[4]="D", tokens[5]="E"。

因為tokens2的大小已經固定，所以value2會是3。
tokens2[1] = "A", tokens2[2] = "B", tokens2[3] = "C;D"。
