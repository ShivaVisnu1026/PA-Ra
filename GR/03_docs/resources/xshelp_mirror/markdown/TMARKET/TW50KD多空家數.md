```
Value1 = GetField("TW50KD多空家數");
Value1 = GetField("TW50KDLongShortSecurities");
```

```
Value1 = GetField("TW50KD多空家數");
Value1 = GetField("TW50KDLongShortSecurities");
```

統計台灣50成分股內，目前K > D的家數。
KD指標計算參數為：資料期數為9，K值平滑期數為3，D值平滑期數為3。使用1分鐘資料來做計算。

僅支援TSE50.SJ 商品。

系統每分鐘會統計符合的家數，而腳本端則依照執行頻率(支援分鐘/日頻率)來取得當分鐘最後的符合家數。

建議撰寫方式：
value1 = getsymbolfield("TSE50.SJ","TW50KD多空家數");
