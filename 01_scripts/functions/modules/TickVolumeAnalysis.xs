// ===================================================================
// 函數名稱：TickVolumeAnalysis
// 功能描述：綜合分析內外盤成交次數和成交量
// 版本：1.0
// 建立日期：2025-12-19
// ===================================================================

// === 參數定義 ===
inputs: LookbackBars(numericsimple);

// === 變數宣告 ===
variables: InnerTicks(0),       // 內盤成交次數
           OuterTicks(0),       // 外盤成交次數
           InnerVol(0),         // 內盤成交量
           OuterVol(0),         // 外盤成交量
           InnerTicksSum(0),
           OuterTicksSum(0),
           InnerVolSum(0),
           OuterVolSum(0),
           TickRatio(0),        // 成交次數比率
           VolRatio(0),         // 成交量比率
           AvgInnerSize(0),     // 內盤平均單量
           AvgOuterSize(0),     // 外盤平均單量
           PressureScore(0),    // 綜合壓力分數
           i(0);

// === 累計數據 ===
InnerTicksSum = 0;
OuterTicksSum = 0;
InnerVolSum = 0;
OuterVolSum = 0;

for i = 0 to LookbackBars - 1 begin
    // 內盤成交次數
    InnerTicks = GetField("內盤成交次數")[i];
    if InnerTicks = Invalid then
        InnerTicks = GetField("TotalInTicks")[i];
    
    // 外盤成交次數
    OuterTicks = GetField("外盤成交次數")[i];
    if OuterTicks = Invalid then
        OuterTicks = GetField("TotalOutTicks")[i];
    
    // 內盤成交量
    InnerVol = GetField("內盤量")[i];
    if InnerVol = Invalid then
        InnerVol = GetField("TradeVolumeAtBid")[i];
    
    // 外盤成交量
    OuterVol = GetField("外盤量")[i];
    if OuterVol = Invalid then
        OuterVol = GetField("TradeVolumeAtAsk")[i];
    
    if InnerTicks <> Invalid then
        InnerTicksSum = InnerTicksSum + InnerTicks;
    if OuterTicks <> Invalid then
        OuterTicksSum = OuterTicksSum + OuterTicks;
    if InnerVol <> Invalid then
        InnerVolSum = InnerVolSum + InnerVol;
    if OuterVol <> Invalid then
        OuterVolSum = OuterVolSum + OuterVol;
end;

// === 計算比率 ===
// 成交次數比率（外/內）
if InnerTicksSum > 0 then
    TickRatio = OuterTicksSum / InnerTicksSum
else
    TickRatio = 999;

// 成交量比率（外/內）
if InnerVolSum > 0 then
    VolRatio = OuterVolSum / InnerVolSum
else
    VolRatio = 999;

// 平均單量
if InnerTicksSum > 0 then
    AvgInnerSize = InnerVolSum / InnerTicksSum
else
    AvgInnerSize = 0;

if OuterTicksSum > 0 then
    AvgOuterSize = OuterVolSum / OuterTicksSum
else
    AvgOuterSize = 0;

// === 綜合壓力分數（-1 到 +1） ===
// 正值 = 買盤強，負值 = 賣盤強
if (InnerVolSum + OuterVolSum) > 0 then
    PressureScore = (OuterVolSum - InnerVolSum) / (OuterVolSum + InnerVolSum)
else
    PressureScore = 0;

// === 返回壓力分數 ===
TickVolumeAnalysis = PressureScore;

