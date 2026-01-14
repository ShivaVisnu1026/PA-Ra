// ===================================================================
// 函數名稱：BidOfferRatio
// 功能描述：計算內外盤比率（買賣力道）
// 說明：外盤(Offer) = 主動買盤，內盤(Bid) = 主動賣盤
// 版本：1.0
// 建立日期：2025-12-19
// ===================================================================

// === 參數定義 ===
inputs: LookbackBars(numericsimple);  // 回顧K棒數量

// === 變數宣告 ===
variables: InnerVolume(0),      // 內盤量（主動賣）
           OuterVolume(0),      // 外盤量（主動買）
           TotalVolume(0),
           InnerSum(0),
           OuterSum(0),
           BidOfferRatio(0),
           NetPressure(0),      // 淨壓力 (-1 to +1)
           i(0);

// === 累計指定期間的內外盤量 ===
InnerSum = 0;
OuterSum = 0;

for i = 0 to LookbackBars - 1 begin
    // 內盤量：在買價成交（賣方主動）
    InnerVolume = GetField("內盤量")[i];
    if InnerVolume = Invalid then
        InnerVolume = GetField("TradeVolumeAtBid")[i];
    
    // 外盤量：在賣價成交（買方主動）
    OuterVolume = GetField("外盤量")[i];
    if OuterVolume = Invalid then
        OuterVolume = GetField("TradeVolumeAtAsk")[i];
    
    if InnerVolume <> Invalid then
        InnerSum = InnerSum + InnerVolume;
    
    if OuterVolume <> Invalid then
        OuterSum = OuterSum + OuterVolume;
end;

// === 計算比率 ===
TotalVolume = InnerSum + OuterSum;

if TotalVolume > 0 then begin
    // 比率：外盤 / 內盤（>1 為多頭優勢，<1 為空頭優勢）
    if InnerSum > 0 then
        BidOfferRatio = OuterSum / InnerSum
    else
        BidOfferRatio = 999;  // 極端多頭
    
    // 淨壓力：(外盤 - 內盤) / 總量，範圍 -1 到 +1
    NetPressure = (OuterSum - InnerSum) / TotalVolume;
end
else begin
    BidOfferRatio = 1;
    NetPressure = 0;
end;

// === 返回值（返回淨壓力，更直觀） ===
BidOfferRatio = NetPressure;

