// ===================================================================
// 函數名稱：BrooksMicrochannel
// 功能描述：計算微通道長度（連續更高低點或更低高點）
// 作者：PriceActions Project
// 建立日期：2025-12-09
// 版本：1.0
// ===================================================================
// Description:
//   Counts consecutive higher lows (bull run) or lower highs (bear run)
//   Returns: bull_run_length, bear_run_length
// ===================================================================

// === 參數定義 ===
// 此函數不需要輸入參數，直接計算當前K棒的微通道長度

// === 變數宣告 ===
variables: BullRunLength(0),
           BearRunLength(0),
           CurrentLow(0),
           PrevLow(0),
           CurrentHigh(0),
           PrevHigh(0);

// === 取得當前和前一根K棒的價格 ===
CurrentLow = Low;
PrevLow = Low[1];
CurrentHigh = High;
PrevHigh = High[1];

// === 計算多頭微通道長度（連續更高低點） ===
if CurrentBarNumber > 1 then begin
    if CurrentLow > PrevLow then
        // 如果當前低點 > 前一根低點，延續多頭微通道
        BullRunLength = BullRunLength[1] + 1
    else
        // 否則重置計數器
        BullRunLength = 0;
end
else
    BullRunLength = 0;

// === 計算空頭微通道長度（連續更低高點） ===
if CurrentBarNumber > 1 then begin
    if CurrentHigh < PrevHigh then
        // 如果當前高點 < 前一根高點，延續空頭微通道
        BearRunLength = BearRunLength[1] + 1
    else
        // 否則重置計數器
        BearRunLength = 0;
end
else
    BearRunLength = 0;

// === 返回值（使用陣列返回兩個值） ===
// 注意：XQScript 函數只能返回一個值
// 因此返回多頭長度，空頭長度需要通過另一個函數或變數取得
BrooksMicrochannel = BullRunLength;

// === 說明 ===
// 由於 XQScript 函數限制，此函數只返回多頭微通道長度
// 空頭微通道長度需要使用變數 BearRunLength 在調用腳本中取得
// 建議在指標/警示/選股腳本中直接實現此邏輯以獲得兩個值

