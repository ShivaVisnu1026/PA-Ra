// ===================================================================
// 腳本名稱：Brooks 微通道耗盡選股
// 腳本類型：選股（Screener）
// 功能描述：篩選微通道長度達到或超過門檻的股票
// 資料週期：5分鐘（建議）
// 作者：PriceActions Project
// 建立日期：2025-12-09
// 版本：1.0
// ===================================================================
// Description:
//   Screens for stocks with microchannel exhaustion
//   Microchannel length >= threshold indicates potential reversal
// ===================================================================

// === 參數宣告 ===
settotalbar(250);

input: ExhaustionLevel(6, "耗盡門檻（微通道長度）"),
       MinVolume(500, "最小成交量(張)"),
       Direction(0, "方向（1=多頭, -1=空頭, 0=雙向）");

// === 變數宣告 ===
var: BullRunLength(0),
     BearRunLength(0),
     PrevBullRun(0),
     PrevBearRun(0),
     VolumeOK(false),
     BullExhaustion(false),
     BearExhaustion(false),
     ConditionMet(false);

// === 成交量過濾 ===
VolumeOK = (Volume / 1000) >= MinVolume;

// === 計算微通道長度 ===
if CurrentBarNumber > 1 then begin
    PrevBullRun = BullRunLength[1];
    PrevBearRun = BearRunLength[1];
    
    // 計算多頭微通道長度（連續更高低點）
    if Low > Low[1] then
        BullRunLength = PrevBullRun + 1
    else
        BullRunLength = 0;
    
    // 計算空頭微通道長度（連續更低高點）
    if High < High[1] then
        BearRunLength = PrevBearRun + 1
    else
        BearRunLength = 0;
    
    // === 耗盡判斷 ===
    BullExhaustion = BullRunLength >= ExhaustionLevel;
    BearExhaustion = BearRunLength >= ExhaustionLevel;
    
    // === 根據方向參數判斷條件 ===
    if Direction = 1 then
        // 只選多頭微通道耗盡
        ConditionMet = BullExhaustion and VolumeOK
    else if Direction = -1 then
        // 只選空頭微通道耗盡
        ConditionMet = BearExhaustion and VolumeOK
    else
        // 雙向
        ConditionMet = (BullExhaustion or BearExhaustion) and VolumeOK;
end
else begin
    BullRunLength = 0;
    BearRunLength = 0;
    ConditionMet = false;
end;

// === 輸出結果 ===
if ConditionMet then
    Ret = 1  // 符合條件
else
    Ret = 0;  // 不符合

// === 輸出數值供排序 ===
OutputField(1, BullRunLength, "Bull MC Length");
OutputField(2, BearRunLength, "Bear MC Length");
OutputField(3, Volume / 1000, "Volume (Lots)");
if BullExhaustion then
    OutputField(4, 1, "Exhaustion Type")
else if BearExhaustion then
    OutputField(4, -1, "Exhaustion Type")
else
    OutputField(4, 0, "Exhaustion Type");

