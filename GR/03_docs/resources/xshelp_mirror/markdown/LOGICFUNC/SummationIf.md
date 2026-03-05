當某期資料符合某項判斷準則時，才將該期資料計入加總。

範例：

```
value1 = SummationIf(open>close[1],rateofchange(close,1),5); //計算近5期開高時的漲跌幅總和
```

```
value1 = SummationIf(open>close[1],rateofchange(close,1),5); //計算近5期開高時的漲跌幅總和
```
