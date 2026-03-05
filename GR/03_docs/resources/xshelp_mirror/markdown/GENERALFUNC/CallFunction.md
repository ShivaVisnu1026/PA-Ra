從 v6.20 開始，我們開放函數使用中文名稱，更方便大家使用。不過中文函數在被其他腳本呼叫時，會需要透過CallFunction這個函數來執行。

CallFunction的用法很簡單，第一個參數固定是要被呼叫的函數名稱，其餘的參數就是看被呼叫函數需要幾個參數，依序填入即可。

範例：

```
plot1(average(c,5));
plot2(callfunction("average",c,5));
//以上二個寫法效果是一樣的
```

```
plot1(average(c,5));
plot2(callfunction("average",c,5));
//以上二個寫法效果是一樣的
```
