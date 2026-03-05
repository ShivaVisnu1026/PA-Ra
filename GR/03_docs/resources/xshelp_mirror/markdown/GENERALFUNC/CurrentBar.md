傳回執行腳本時的K棒序列編號，由1開始，第一筆K棒編號為1，第二筆K棒編號為2，依序遞增。

可以使用這個函數來判斷目前腳本執行的時機點

```
if CurrentBar = 1 then
	value1 = Close
else
	value1 = value1[1] + value2 * (Close - value1[1]);
```

```
if CurrentBar = 1 then
	value1 = Close
else
	value1 = value1[1] + value2 * (Close - value1[1]);
```

上述範例利用CurrentBar來判斷目前是否是第一筆K棒。如果是的話則回傳XAverage的初始數值。
