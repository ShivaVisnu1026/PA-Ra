OR 語法用來檢查運算式 是否有任一個成立 。

```
If Close >= Close[1] Or Close >= Close[2] Then ret = 1;
```

```
If Close >= Close[1] Or Close >= Close[2] Then ret = 1;
```

在上述範例內如果Close欄位 >= 前期值 或是 Close欄位 >= 前兩期值的話，則ret會被設定成1。

請參考 AND 語法。
