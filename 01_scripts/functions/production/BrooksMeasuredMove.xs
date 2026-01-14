// ===================================================================
// 函數名稱：BrooksMeasuredMove
// 功能描述：計算測量移動目標價（基於第一小時走勢）
// 作者：PriceActions Project
// 建立日期：2025-12-09
// 版本：1.0
// ===================================================================
// Description:
//   Projects target based on first-hour leg magnitude
//   Returns: MM_Up target or MM_Down target
//   Note: Returns positive value for up target, negative for down target
// ===================================================================

// === 參數定義 ===
inputs: FirstHourBars(numericsimple),  // 第一小時K棒數（預設 12，5分鐘圖）
        PullbackBars(numericsimple);    // 回調區間K棒數（預設 8，即12-20根）

// === 變數宣告 ===
variables: FirstHourHigh(0),
           FirstHourLow(0),
           FirstHourClose(0),
           FirstHourOpen(0),
           IsUptrend(false),
           FirstLeg(0),
           PullbackEndPrice(0),
           MM_Target(0);

// === 檢查是否有足夠的K棒 ===
if CurrentBarNumber >= (FirstHourBars + PullbackBars) then begin
    // === 計算第一小時的極值和收盤 ===
    FirstHourHigh = Highest(High[FirstHourBars + PullbackBars - 1], FirstHourBars);
    FirstHourLow = Lowest(Low[FirstHourBars + PullbackBars - 1], FirstHourBars);
    FirstHourClose = Close[PullbackBars];
    FirstHourOpen = Open[FirstHourBars + PullbackBars - 1];
    
    // === 判斷第一小時趨勢 ===
    IsUptrend = (FirstHourClose > FirstHourOpen);
    
    // === 計算第一段走勢幅度 ===
    if IsUptrend then
        FirstLeg = FirstHourHigh - FirstHourOpen
    else
        FirstLeg = FirstHourOpen - FirstHourLow;
    
    // === 計算回調結束點價格（簡化：使用回調區間最低/最高） ===
    if IsUptrend then
        PullbackEndPrice = Lowest(Low[PullbackBars - 1], PullbackBars)
    else
        PullbackEndPrice = Highest(High[PullbackBars - 1], PullbackBars);
    
    // === 計算目標價 ===
    if IsUptrend then
        // 上漲目標：回調結束點 + 第一段幅度
        MM_Target = PullbackEndPrice + FirstLeg
    else
        // 下跌目標：回調結束點 - 第一段幅度（返回負值）
        MM_Target = -(PullbackEndPrice - FirstLeg);
end
else
    MM_Target = 0;  // K棒不足，無法計算

// === 返回值 ===
// 正值 = 上漲目標，負值 = 下跌目標，0 = 無法計算
BrooksMeasuredMove = MM_Target;

