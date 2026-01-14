// ===================================================================
// 函數名稱：BrooksBar18Flag
// 功能描述：Bar-18 標記（早盤極值檢測）
// 作者：PriceActions Project
// 建立日期：2025-12-09
// 版本：1.0
// ===================================================================
// Description:
//   Brooks heuristic: by bar 18, the day usually prints its high or low
//   Checks if morning high/low still holds as day high/low
//   Returns: 1 if flag is set, 0 otherwise
// ===================================================================

// === 參數定義 ===
inputs: StartBar(numericsimple),  // 開始K棒（預設 16，即第16根）
        EndBar(numericsimple);     // 結束K棒（預設 20，即第20根）

// === 變數宣告 ===
variables: HighAtBar18(0),
           LowAtBar18(0),
           CurrentDayHigh(0),
           CurrentDayLow(0),
           HighStillHolds(false),
           LowStillHolds(false),
           Bar18Flag(0);

// === 檢查是否有足夠的K棒 ===
if CurrentBarNumber >= EndBar then begin
    // === 計算 Bar 16-20 的極值 ===
    HighAtBar18 = Highest(High[EndBar - StartBar], EndBar - StartBar + 1);
    LowAtBar18 = Lowest(Low[EndBar - StartBar], EndBar - StartBar + 1);
    
    // === 計算當前日內極值 ===
    CurrentDayHigh = Highest(High, CurrentBarNumber);
    CurrentDayLow = Lowest(Low, CurrentBarNumber);
    
    // === 檢查早盤極值是否仍為日內極值 ===
    // 允許小的浮點誤差
    HighStillHolds = (AbsValue(HighAtBar18 - CurrentDayHigh) < 0.01);
    LowStillHolds = (AbsValue(LowAtBar18 - CurrentDayLow) < 0.01);
    
    // === 設定標記 ===
    if HighStillHolds or LowStillHolds then
        Bar18Flag = 1
    else
        Bar18Flag = 0;
end
else
    Bar18Flag = 0;  // K棒不足，無法判斷

// === 返回值 ===
BrooksBar18Flag = Bar18Flag;

