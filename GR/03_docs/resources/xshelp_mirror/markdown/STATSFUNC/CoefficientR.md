以最新一筆資料為基準點，輸入要計算的期數，然後計算過去期數的相關係數。

回傳數值會介於-1到1之間。如果無法計算，會傳回-2。

範例：

```
value1 = GetField("外資買賣超金額");
value2 = rateofchange(close,1);          //計算當日漲跌幅
value3 = coefficientr(value1,value2,20); //計算外資買賣超金額與大盤漲跌幅的相關係數
plot1(value3);
```

```
value1 = GetField("外資買賣超金額");
value2 = rateofchange(close,1);          //計算當日漲跌幅
value3 = coefficientr(value1,value2,20); //計算外資買賣超金額與大盤漲跌幅的相關係數
plot1(value3);
```
