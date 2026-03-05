{@type:sensor}
// ===================================================================
// 腳本名稱：EMA 接觸反彈警示腳本
// 腳本類型：警示（Alert）
// 功能描述：偵測價格接觸上升均線後反彈，在從下往上穿越均線的下一個tick觸發
// 資料週期：日線（可監控多檔股票）
// 作者：Auto (根據選股腳本轉換)
// 建立日期：2025-01-27
// 版本：1.0
// 
// 策略邏輯說明：
// 1. 趨勢確認: EMA 趨勢向上（當前 EMA > 前一根 EMA）
// 2. 接觸反彈: 前一根 K 棒 Low 跌破 EMA，當前價格從下往上穿越 EMA
// 3. Pinbar 型態: 前一根 K 棒下引線長度 >= K 棒總長度的指定比例
// 4. 近期強勢（可選）: 最近 N 根 K 棒內沒有跌破 EMA（放寬的 Virgin 條件）
// 
// 檢查三條 EMA：8、20、56（任一觸發即可）
// 
// 觸發時機：價格從下往上穿越均線的下一個tick
// ===================================================================

// === 參數宣告 ===
settotalbar(250);

input: UseVirginFilter(true, "啟用近期強勢過濾"),
       RecentLookback(5, "近期回溯期數（僅檢查最近 N 根）"),
       PinbarRatio(0.35, "下引線最小比例"),
       EMA_Period1(8, "EMA 週期 1"),
       EMA_Period2(20, "EMA 週期 2"),
       EMA_Period3(56, "EMA 週期 3");

// === 變數宣告 ===
var: EMA1(0), EMA1_Prev(0),
     EMA2(0), EMA2_Prev(0),
     EMA3(0), EMA3_Prev(0),
     IsRecentStrong1(false), IsRecentStrong2(false), IsRecentStrong3(false),
     IsTrendUp1(false), IsTrendUp2(false), IsTrendUp3(false),
     TouchedEMA1(false), TouchedEMA2(false), TouchedEMA3(false),
     CrossAbove1(false), CrossAbove2(false), CrossAbove3(false),
     CandleRange(0), LowerShadow(0), LowerShadowRatio(0),
     IsPinbar(false), HasRange(false),
     Signal1(false), Signal2(false), Signal3(false),
     FinalSignal(false),
     i(0), RecentAllAbove(true);

// 避免重複觸發的標記（使用 intrabarpersist 在同一根K棒內保持狀態）
// 註：intrabarpersist 變數會在新K棒開始時自動重置
var: intrabarpersist AlertTriggered1(false),
     intrabarpersist AlertTriggered2(false),
     intrabarpersist AlertTriggered3(false);

// === 計算三條 EMA ===
EMA1 = XAverage(Close, EMA_Period1);
EMA1_Prev = EMA1[1];

EMA2 = XAverage(Close, EMA_Period2);
EMA2_Prev = EMA2[1];

EMA3 = XAverage(Close, EMA_Period3);
EMA3_Prev = EMA3[1];

// === 計算前一根 K 棒的型態（Pin Bar 檢查）===
// 使用前一根 K 棒的資料來判斷型態
CandleRange = High[1] - Low[1];
LowerShadow = MinList(Open[1], Close[1]) - Low[1];

HasRange = CandleRange > 0;
if HasRange then
    LowerShadowRatio = LowerShadow / CandleRange
else
    LowerShadowRatio = 0;

IsPinbar = LowerShadowRatio >= PinbarRatio;

// === EMA 1 的條件檢查 ===
// 改良的近期強勢檢查：只檢查最近 N 根（而非全部過去 N 根）
// 如果 UseVirginFilter = false，則跳過此檢查
if UseVirginFilter then begin
    RecentAllAbove = true;
    for i = 1 to RecentLookback begin
        if Low[i] <= XAverage(Close[i], EMA_Period1) then
            RecentAllAbove = false;
    end;
    IsRecentStrong1 = RecentAllAbove;
end
else
    IsRecentStrong1 = true;  // 不啟用過濾時，視為符合條件

// 趨勢方向：EMA 趨勢向上
IsTrendUp1 = EMA1 > EMA1_Prev;

// 接觸檢查：前一根 K 棒的 Low 跌破 EMA
TouchedEMA1 = Low[1] < EMA1[1];

// 穿越檢查：當前價格從下往上穿越 EMA（前一根 Close < EMA，當前 Close > EMA）
CrossAbove1 = (Close[1] < EMA1[1]) and (Close > EMA1);

// 綜合判斷 EMA 1
Signal1 = IsRecentStrong1 and IsTrendUp1 and TouchedEMA1 and CrossAbove1 and IsPinbar and HasRange;

// === EMA 2 的條件檢查 ===
if UseVirginFilter then begin
    RecentAllAbove = true;
    for i = 1 to RecentLookback begin
        if Low[i] <= XAverage(Close[i], EMA_Period2) then
            RecentAllAbove = false;
    end;
    IsRecentStrong2 = RecentAllAbove;
end
else
    IsRecentStrong2 = true;

IsTrendUp2 = EMA2 > EMA2_Prev;
TouchedEMA2 = Low[1] < EMA2[1];
CrossAbove2 = (Close[1] < EMA2[1]) and (Close > EMA2);

Signal2 = IsRecentStrong2 and IsTrendUp2 and TouchedEMA2 and CrossAbove2 and IsPinbar and HasRange;

// === EMA 3 的條件檢查 ===
if UseVirginFilter then begin
    RecentAllAbove = true;
    for i = 1 to RecentLookback begin
        if Low[i] <= XAverage(Close[i], EMA_Period3) then
            RecentAllAbove = false;
    end;
    IsRecentStrong3 = RecentAllAbove;
end
else
    IsRecentStrong3 = true;

IsTrendUp3 = EMA3 > EMA3_Prev;
TouchedEMA3 = Low[1] < EMA3[1];
CrossAbove3 = (Close[1] < EMA3[1]) and (Close > EMA3);

Signal3 = IsRecentStrong3 and IsTrendUp3 and TouchedEMA3 and CrossAbove3 and IsPinbar and HasRange;

// === 觸發警示 ===
// 任一 EMA 觸發訊號即可，且避免重複觸發（使用 intrabarpersist 變數）
// 註：intrabarpersist 變數會在新K棒開始時自動重置

FinalSignal = Signal1 or Signal2 or Signal3;

// 標記觸發狀態（避免重複觸發）
if Signal1 and not AlertTriggered1 then
    AlertTriggered1 = true;

if Signal2 and not AlertTriggered2 then
    AlertTriggered2 = true;

if Signal3 and not AlertTriggered3 then
    AlertTriggered3 = true;

// 輸出結果（Ret = 1 表示觸發警示）
if FinalSignal then
    Ret = 1
else
    Ret = 0;
