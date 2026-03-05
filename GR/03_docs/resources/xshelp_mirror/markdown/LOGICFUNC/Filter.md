當條件成立後，過濾在指定期數內重複出現的警示。例如：當股價第一次創20日新高時，未來5天再創20日新高就不再警示。

回傳TRUE，表示過濾後仍然成立的條件，意即原始條件為TRUE且距離原始條件成立的期數大於過濾期數。
回傳FALSE，表示過濾後不成立的條件，意即原始條件為FALSE，或是距離原始條件成立的期數小於等於過濾期數。

範例：

```
//警示腳本
condition1 = high = highest(high,20);       //判斷今高是否為20期之高點
condition2 = filter(condition1,5);       //過濾未來5期內重複的創新高警示
if condition2 then ret = 1;
```

```
//警示腳本
condition1 = high = highest(high,20);       //判斷今高是否為20期之高點
condition2 = filter(condition1,5);       //過濾未來5期內重複的創新高警示
if condition2 then ret = 1;
```
