Cross 相關的語法共有兩種：

以下是 向上穿越 均線的寫法：

```
If Close Cross Above Average(Close, 5) Then ret = 1;
```

```
If Close Cross Above Average(Close, 5) Then ret = 1;
```

當這一期的Close欄位大於等於近5期的平均值(Average(Close,5))且前一期的Close欄位小於前一期的近5期的平均值的話，則ret會被設定成1。

以下則是 向下跌破均線 的寫法：

```
If Close Cross Below Average(Close, 5) Then ret = 1;
```

```
If Close Cross Below Average(Close, 5) Then ret = 1;
```

如果這一期的Close欄位小於等於近5期的平均值(Average(Close,5))且前一期的Close欄位大於前一期的近5期的平均值的話，則ret會被設定成1。

Cross 也可以寫成 Crosses 。
