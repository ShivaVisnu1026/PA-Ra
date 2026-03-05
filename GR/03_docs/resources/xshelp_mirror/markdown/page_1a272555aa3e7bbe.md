搭配 OutputField 使用，order 是用來指定排序選股結果區的欄位數值上/下序的函數。order :=-1 為由小到大排序；order :=1 為由大到小排序。例如以下範例語法：

```
ret = 1;
value1 = average(volume,5);
outputfield1(value1,"5日均量",order:=-1);　//將「五日均量數值」由小到大排序在選股結果區。
```

```
ret = 1;
value1 = average(volume,5);
outputfield1(value1,"5日均量",order:=-1);　//將「五日均量數值」由小到大排序在選股結果區。
```
