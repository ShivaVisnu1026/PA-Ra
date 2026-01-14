{@type:indicator}

// ===================================================================
// 指標名稱：內外盤與早盤量監控
// 功能：即時顯示買賣壓力和早盤成交量狀況
// 版本：1.0
// 建立日期：2025-12-19
// ===================================================================

settotalbar(250);

input: TickLookback(5, "內外盤回顧K棒"),
       EarlyMinutes(10, "早盤分鐘數"),
       BarInterval_Min(5, "K棒週期");

var: InnerVol(0), OuterVol(0),
     InnerSum(0), OuterSum(0),
     BuyPressure(0),
     TodayVol(0), YestVol(0),
     VolRatio(0),
     CurrentTime(0),
     MinutesSinceOpen(0),
     IsEarlyWindow(false),
     i(0);

// === 內外盤分析 ===
InnerSum = 0;
OuterSum = 0;

for i = 0 to TickLookback - 1 begin
    InnerVol = GetField("內盤量")[i];
    if InnerVol = Invalid then
        InnerVol = GetField("TradeVolumeAtBid")[i];
    
    OuterVol = GetField("外盤量")[i];
    if OuterVol = Invalid then
        OuterVol = GetField("TradeVolumeAtAsk")[i];
    
    if InnerVol <> Invalid then InnerSum = InnerSum + InnerVol;
    if OuterVol <> Invalid then OuterSum = OuterSum + OuterVol;
end;

if (InnerSum + OuterSum) > 0 then
    BuyPressure = (OuterSum / (InnerSum + OuterSum)) * 100
else
    BuyPressure = 50;

// === 早盤成交量 ===
CurrentTime = Time;
if CurrentTime >= 090000 then begin
    MinutesSinceOpen = ((CurrentTime / 10000) - 9) * 60 + ((CurrentTime mod 10000) / 100);
    IsEarlyWindow = (MinutesSinceOpen <= EarlyMinutes);
end;

if IsEarlyWindow and CurrentBar > 10 then begin
    TodayVol = 0;
    YestVol = 0;
    for i = 0 to 5 begin
        TodayVol = TodayVol + Volume[i];
        YestVol = YestVol + Volume[i + 10];
    end;
    if YestVol > 0 then
        VolRatio = ((TodayVol / YestVol) - 1) * 100
    else
        VolRatio = 0;
end
else
    VolRatio = 0;

// === 輸出 ===
output1(BuyPressure, "買盤壓力%");       // 顯示為線圖
output2(50, "中性線");                    // 50% 參考線
output3(VolRatio, "早盤量增%");           // 顯示成交量比較

// === 顏色設定 ===
if BuyPressure >= 60 then
    SetColor(1, Green)
else if BuyPressure <= 40 then
    SetColor(1, Red)
else
    SetColor(1, Yellow);

if VolRatio >= 20 then
    SetColor(3, Cyan)
else if VolRatio < 0 then
    SetColor(3, Magenta)
else
    SetColor(3, White);

