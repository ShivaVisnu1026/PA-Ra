// ===================================================================
// 腳本名稱：Brooks 失敗突破警示
// 腳本類型：警示（Alert）
// 功能描述：當開盤區間突破失敗並重新回到區間內時觸發警示
// 資料週期：5分鐘（建議）
// 作者：PriceActions Project
// 建立日期：2025-12-09
// 版本：1.0
// ===================================================================
// Description:
//   Alerts when opening range breakout fails and price re-enters the range
//   Indicates mean reversion opportunity
// ===================================================================

// === 參數宣告 ===
settotalbar(250);

input: OR_Bars(6, "開盤區間K棒數");

// === 變數宣告 ===
var: OR_High(0),
     OR_Low(0),
     OR_Mid(0),
     WasAboveOR(false),
     WasBelowOR(false),
     CurrentlyInsideOR(false),
     FailedBreakoutUp(false),
     FailedBreakoutDown(false),
     intrabarpersist AlertTriggeredUp(false),
     intrabarpersist AlertTriggeredDown(false);

// === 計算開盤區間 ===
if CurrentBarNumber >= OR_Bars then begin
    OR_High = Highest(High[OR_Bars - 1], OR_Bars);
    OR_Low = Lowest(Low[OR_Bars - 1], OR_Bars);
    OR_Mid = (OR_High + OR_Low) / 2;
    
    // 檢查前一根K棒是否在開盤區間外
    WasAboveOR = Close[1] > OR_High;
    WasBelowOR = Close[1] < OR_Low;
    
    // 檢查當前K棒是否回到開盤區間內
    CurrentlyInsideOR = (Close <= OR_High) and (Close >= OR_Low);
    
    // === 失敗向上突破判斷 ===
    // 前一根在OR上方，當前回到OR內
    FailedBreakoutUp = WasAboveOR and CurrentlyInsideOR;
    
    // === 失敗向下突破判斷 ===
    // 前一根在OR下方，當前回到OR內
    FailedBreakoutDown = WasBelowOR and CurrentlyInsideOR;
    
    // === 觸發失敗向上突破警示 ===
    if FailedBreakoutUp and not AlertTriggeredUp then begin
        Alert("開盤區間向上突破失敗！價格回到區間內，價格: " + Text(Close) + ", OR Mid: " + Text(OR_Mid));
        AlertTriggeredUp = true;
    end;
    
    // === 觸發失敗向下突破警示 ===
    if FailedBreakoutDown and not AlertTriggeredDown then begin
        Alert("開盤區間向下突破失敗！價格回到區間內，價格: " + Text(Close) + ", OR Mid: " + Text(OR_Mid));
        AlertTriggeredDown = true;
    end;
end;

// === 重置機制：當價格再次突破OR時重置 ===
if CurrentBarNumber >= OR_Bars then begin
    if Close > OR_High then
        AlertTriggeredUp = false;
    if Close < OR_Low then
        AlertTriggeredDown = false;
end;

