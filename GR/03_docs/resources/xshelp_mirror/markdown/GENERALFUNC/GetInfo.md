依傳入的參數回傳相關資訊。

當參數為"Instance"時，可以取得腳本執行的功能：

當參數為"IsRealTime"時，可以取得K棒的狀態：

當參數為"IsTimerMode"時，可以判斷該次洗價是否因為自動洗價所觸發，只支援警示腳本和交易腳本：

當參數為"FilterMode"時，可以取得XS選股的模式：

當參數為"TradeMode"時，可以交易策略目前執行的K棒是否處於資料讀取區間：

當參數為"AT_EnableTrade"時，可以取得目前交易策略是否有啟動帳號：

當參數為"AT_BID"時，可以取得券商的字串代碼：

當參數為"AT_AccType"時，可以取得策略運作的業務類別:

當參數為"AT_AID"時，可以取得目前策略運作的帳號:

關於AT的EnableTrade、BID、AccType以及AID的進一步說明，可以參考 自動交易語法 取得「交易帳號」使用說明

範例：

```
value1 = getinfo("IsRealTime"); //若value1為1，則代表目前計算的是即時資料
plot1(value1);
```

```
value1 = getinfo("IsRealTime"); //若value1為1，則代表目前計算的是即時資料
plot1(value1);
```
