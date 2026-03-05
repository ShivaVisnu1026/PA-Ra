MinList可以傳入多個數值，數值之間使用逗號分開。

以下是一個腳本範例:

```
Value1 = Average(Close, 5);
Value2 = Average(Close, 10);
Value3 = Average(Close, 20);
If Open < MinList(Value1, Value2, Value3) And
   Close > MaxList(Value1, Value2, Value3) 
Then Ret = 1;
```

```
Value1 = Average(Close, 5);
Value2 = Average(Close, 10);
Value3 = Average(Close, 20);
If Open < MinList(Value1, Value2, Value3) And
   Close > MaxList(Value1, Value2, Value3) 
Then Ret = 1;
```

在這個腳本內使用MinList來算出5日/10日/20日均線的最小值。當開盤價低於均線且收盤價站上均線時觸發訊號。

腳本內同時使用到 MaxList函數 ，這個函數的用法類似MinList，傳入多個數值後回傳這些數值的最大值。
