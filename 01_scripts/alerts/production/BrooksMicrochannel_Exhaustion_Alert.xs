// ===================================================================
// 腳本名稱：Brooks 微通道耗盡警示
// 腳本類型：警示（Alert）
// 功能描述：當微通道長度達到或超過6根K棒時觸發警示
// 資料週期：5分鐘（建議）
// 作者：PriceActions Project
// 建立日期：2025-12-09
// 版本：1.0
// ===================================================================
// Description:
//   Alerts when microchannel length reaches or exceeds 6 bars
//   Indicates potential trend exhaustion
// ===================================================================

// === 參數宣告 ===
settotalbar(250);

input: ExhaustionLevel(6, "耗盡門檻（微通道長度）");

// === 變數宣告 ===
var: BullRunLength(0),
     BearRunLength(0),
     PrevBullRun(0),
     PrevBearRun(0),
     intrabarpersist AlertTriggeredBull(false),
     intrabarpersist AlertTriggeredBear(false);

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
    
    // === 觸發多頭微通道耗盡警示 ===
    if (BullRunLength >= ExhaustionLevel) and not AlertTriggeredBull then begin
        Alert("多頭微通道耗盡警告！長度: " + Text(BullRunLength) + " 根K棒");
        AlertTriggeredBull = true;
    end;
    
    // === 觸發空頭微通道耗盡警示 ===
    if (BearRunLength >= ExhaustionLevel) and not AlertTriggeredBear then begin
        Alert("空頭微通道耗盡警告！長度: " + Text(BearRunLength) + " 根K棒");
        AlertTriggeredBear = true;
    end;
end
else begin
    BullRunLength = 0;
    BearRunLength = 0;
end;

// === 重置機制：當微通道中斷時重置 ===
if BullRunLength < ExhaustionLevel then
    AlertTriggeredBull = false;
if BearRunLength < ExhaustionLevel then
    AlertTriggeredBear = false;

