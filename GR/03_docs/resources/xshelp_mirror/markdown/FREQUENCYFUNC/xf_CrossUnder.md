如果出現死亡交叉傳回True，其他狀況傳回False。

範例：

```
condition1 = xf_CrossUnder("W",Average(GetField("close","W"),5),Average(GetField("close","W") ,10) ); //判斷週線5期均線和10期均線是否死亡交叉
```

```
condition1 = xf_CrossUnder("W",Average(GetField("close","W"),5),Average(GetField("close","W") ,10) ); //判斷週線5期均線和10期均線是否死亡交叉
```
