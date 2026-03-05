排名位置 從1開始，1表示是回傳排名第一(最小)的數字，2表示回傳排名第二(次小)的數字，以下類推。在 排名位置 之後可以傳入任意個數值，使用逗號分開。

舉例:

```
Value1 = NthMinList(1, 50, 50, 40, 30);  // Value1 = 30
Value2 = NthMinList(2, 50, 50, 40, 30);  // Value2 = 40
Value3 = NthMinList(3, 50, 50, 40, 30);  // Value3 = 50
Value4 = NthMinList(4, 50, 50, 40, 30);  // Value4 = 50
```

```
Value1 = NthMinList(1, 50, 50, 40, 30);  // Value1 = 30
Value2 = NthMinList(2, 50, 50, 40, 30);  // Value2 = 40
Value3 = NthMinList(3, 50, 50, 40, 30);  // Value3 = 50
Value4 = NthMinList(4, 50, 50, 40, 30);  // Value4 = 50
```

上述計算 50, 50, 40, 30 這四個數字由小到大的排名數字。請注意傳入的數值內有兩個50，分居排名3跟4。

請參考 NthMaxList函數 。
