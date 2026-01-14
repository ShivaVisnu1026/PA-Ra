// ===================================================================
// 腳本名稱：Brooks 開盤區間突破警示
// 腳本類型：警示（Alert）
// 功能描述：當價格突破開盤區間時觸發警示
// 資料週期：5分鐘（建議）
// 作者：PriceActions Project
// 建立日期：2025-12-09
// 版本：1.0
// ===================================================================
// Description:
//   Alerts when price breaks out of opening range (first 6 bars)
//   Detects upward or downward breakouts with follow-through
// ===================================================================

// === 參數宣告 ===
settotalbar(250);

input: OR_Bars(6, "開盤區間K棒數（預設6，即前30分鐘）");

// === 變數宣告 ===
var: OR_High(0),
     OR_Low(0),
     OR_Mid(0),
     WasInsideOR(false),
     BreakoutUp(false),
     BreakoutDown(false),
     intrabarpersist AlertTriggeredUp(false),
     intrabarpersist AlertTriggeredDown(false);

// === 計算開盤區間 ===
if CurrentBarNumber >= OR_Bars then begin
    OR_High = Highest(High[OR_Bars - 1], OR_Bars);
    OR_Low = Lowest(Low[OR_Bars - 1], OR_Bars);
    OR_Mid = (OR_High + OR_Low) / 2;
    
    // 檢查前一根K棒是否在開盤區間內
    WasInsideOR = (Close[1] <= OR_High) and (Close[1] >= OR_Low);
    
    // === 向上突破判斷 ===
    BreakoutUp = (Close > OR_High) and WasInsideOR;
    
    // === 向下突破判斷 ===
    BreakoutDown = (Close < OR_Low) and WasInsideOR;
    
    // === 觸發向上突破警示 ===
    if BreakoutUp and not AlertTriggeredUp then begin
        Alert("開盤區間向上突破！價格: " + Text(Close) + ", OR High: " + Text(OR_High));
        AlertTriggeredUp = true;
    end;
    
    // === 觸發向下突破警示 ===
    if BreakoutDown and not AlertTriggeredDown then begin
        Alert("開盤區間向下突破！價格: " + Text(Close) + ", OR Low: " + Text(OR_Low));
        AlertTriggeredDown = true;
    end;
end;

// === 重置機制：當價格回到開盤區間內時重置 ===
if CurrentBarNumber >= OR_Bars then begin
    if (Close <= OR_High) and (Close >= OR_Low) then begin
        AlertTriggeredUp = false;
        AlertTriggeredDown = false;
    end;
end;

