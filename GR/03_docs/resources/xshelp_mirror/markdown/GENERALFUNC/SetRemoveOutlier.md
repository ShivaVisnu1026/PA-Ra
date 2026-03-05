此語法會讓離群值商品在排行前就被排除，也不會被納入計算其他屬性，例如 avgvalue。

此語法需寫在 rank 語法內，且每一個rank只能有一個。

此語法必須在rank內的最上層，不能夠放在 if 或 for 等邏輯判斷內。

以下是簡單範例：

```
Rank myRank Begin 
    RetVal = HVolatility(Close,20);
    SetRemoveOutlier("zscore", value:=3);
    end;
```

```
Rank myRank Begin 
    RetVal = HVolatility(Close,20);
    SetRemoveOutlier("zscore", value:=3);
    end;
```

此範例會用波動率進行排行，但會先排除掉 zscore 絕對值大於3的商品。
