```
Value1 = GetField("TW50紅K家數");
Value1 = GetField("TW50BullKSecurities");
```

```
Value1 = GetField("TW50紅K家數");
Value1 = GetField("TW50BullKSecurities");
```

統計台灣50成分股內，目前這1分鐘是紅K棒的家數。

僅支援TSE50.SJ 商品。

系統每分鐘會統計符合的家數，而腳本端則依照執行頻率(支援分鐘/日頻率)來取得當分鐘最後的符合家數。

建議撰寫方式：
value1 = getsymbolfield("TSE50.SJ","TW50紅K家數");
