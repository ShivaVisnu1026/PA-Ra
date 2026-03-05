以最新一筆資料為基準點，輸入要計算的期數，然後計算過去期數的R平方值。

範例：

```
value1 = GetField("外資買賣超金額");
value2 = rateofchange(close,1);          //計算當日漲跌幅
value3 = RSquare(value1,value2,20); //計算外資買賣超金額與大盤漲跌幅的R平方值
plot1(value3);
```

```
value1 = GetField("外資買賣超金額");
value2 = rateofchange(close,1);          //計算當日漲跌幅
value3 = RSquare(value1,value2,20); //計算外資買賣超金額與大盤漲跌幅的R平方值
plot1(value3);
```
