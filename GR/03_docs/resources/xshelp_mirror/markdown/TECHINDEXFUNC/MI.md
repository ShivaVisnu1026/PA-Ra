MI指標（Mass Index）是由Donald Dorsey所發明。質量指標是觀察高低價範圍的變化，試圖找出趨勢的反轉點。

計算公式：

EMA1 = (最高價－最低價)的9日EMA
EMA2 = EMA1 的9日EMA
MI = ( EMA1 ／ EMA2 ) 的N2日簡單加總

範例：

```
value1 = MI(9,25);       //計算收盤價10期的質量指標
plot1(value1, "MI");
```

```
value1 = MI(9,25);       //計算收盤價10期的質量指標
plot1(value1, "MI");
```
