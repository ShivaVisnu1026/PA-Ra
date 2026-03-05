如果出現黃金交叉傳回True，其他狀況傳回False。

範例：

```
condition1 = xf_CrossOver("W",Average(GetField("收盤價","W"),5),Average(GetField("收盤價","W") ,10)); //判斷週線5期均線和10期均線是否黃金交叉
```

```
condition1 = xf_CrossOver("W",Average(GetField("收盤價","W"),5),Average(GetField("收盤價","W") ,10)); //判斷週線5期均線和10期均線是否黃金交叉
```
