// ===================================================================
// 腳本名稱：Brooks Bar-18 極值保持警示
// 腳本類型：警示（Alert）
// 功能描述：當 Bar-18 極值仍保持為日內極值時觸發警示
// 資料週期：5分鐘（建議）
// 作者：PriceActions Project
// 建立日期：2025-12-09
// 版本：1.0
// ===================================================================
// Description:
//   Alerts when bar-18 extreme (high or low) still holds as day extreme
//   Brooks heuristic: by bar 18, the day usually prints its high or low
// ===================================================================

// === 參數宣告 ===
settotalbar(250);

input: StartBar(16, "開始K棒（Bar 16）"),
       EndBar(20, "結束K棒（Bar 20）");

// === 變數宣告 ===
var: HighAtBar18(0),
     LowAtBar18(0),
     CurrentDayHigh(0),
     CurrentDayLow(0),
     HighStillHolds(false),
     LowStillHolds(false),
     intrabarpersist AlertTriggeredHigh(false),
     intrabarpersist AlertTriggeredLow(false);

// === 計算 Bar-18 標記 ===
if CurrentBarNumber >= EndBar then begin
    // 計算 Bar 16-20 的極值
    HighAtBar18 = Highest(High[EndBar - StartBar], EndBar - StartBar + 1);
    LowAtBar18 = Lowest(Low[EndBar - StartBar], EndBar - StartBar + 1);
    
    // 計算當前日內極值
    CurrentDayHigh = Highest(High, CurrentBarNumber);
    CurrentDayLow = Lowest(Low, CurrentBarNumber);
    
    // 檢查早盤極值是否仍為日內極值
    if AbsValue(HighAtBar18 - CurrentDayHigh) < 0.01 then
        HighStillHolds = true
    else
        HighStillHolds = false;
    
    if AbsValue(LowAtBar18 - CurrentDayLow) < 0.01 then
        LowStillHolds = true
    else
        LowStillHolds = false;
    
    // === 觸發高點保持警示 ===
    if HighStillHolds and not AlertTriggeredHigh then begin
        Alert("Bar-18 高點仍保持為日內最高！高點: " + Text(HighAtBar18));
        AlertTriggeredHigh = true;
    end;
    
    // === 觸發低點保持警示 ===
    if LowStillHolds and not AlertTriggeredLow then begin
        Alert("Bar-18 低點仍保持為日內最低！低點: " + Text(LowAtBar18));
        AlertTriggeredLow = true;
    end;
end;

// === 重置機制：當極值被突破時重置 ===
if CurrentBarNumber >= EndBar then begin
    if not HighStillHolds then
        AlertTriggeredHigh = false;
    if not LowStillHolds then
        AlertTriggeredLow = false;
end;

