// ===================================================================
// 腳本名稱：EMA 接觸反彈選股腳本（改良版）
// 腳本類型：選股（Screener）
// 功能描述：偵測價格接觸上升均線後反彈的看漲訊號（放寬 Virgin 條件）
// 資料週期：日線
// 作者：Auto (根據 Python 邏輯轉換並改良)
// 建立日期：2025-01-27
// 版本：2.0
// 
// 策略邏輯說明（改良版）：
// 1. 趨勢確認: EMA 趨勢向上（當前 EMA > 前一根 EMA）
// 2. 接觸反彈: 當前 Low 跌破 EMA，但 Close 站回 EMA 之上
// 3. Pinbar 型態: 下引線長度 >= K 棒總長度的指定比例
// 4. 近期強勢（可選）: 最近 N 根 K 棒內沒有跌破 EMA（放寬的 Virgin 條件）
// 
// 檢查三條 EMA：8、20、56（任一觸發即可）
// 
// 改良重點：
// - 移除嚴格的「過去全部 N 根都沒有跌破」條件
// - 改為檢查「最近 N 根內沒有跌破」（更靈活）
// - 或完全移除 Virgin 條件，專注於接觸反彈形態
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
     ClosedAbove1(false), ClosedAbove2(false), ClosedAbove3(false),
     CandleRange(0), LowerShadow(0), LowerShadowRatio(0),
     IsPinbar(false), HasRange(false),
     Signal1(false), Signal2(false), Signal3(false),
     FinalSignal(false),
     TriggerPeriod(0),  // 觸發的 EMA 週期
     i(0), RecentAllAbove(true);

// === 計算三條 EMA ===
EMA1 = XAverage(Close, EMA_Period1);
EMA1_Prev = EMA1[1];

EMA2 = XAverage(Close, EMA_Period2);
EMA2_Prev = EMA2[1];

EMA3 = XAverage(Close, EMA_Period3);
EMA3_Prev = EMA3[1];

// === 計算 K 棒型態（Pin Bar 檢查）===
CandleRange = High - Low;
LowerShadow = MinList(Open, Close) - Low;

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

// 接觸與反彈：當前 Low 跌破 EMA，但 Close 站回 EMA 之上
TouchedEMA1 = Low < EMA1;
ClosedAbove1 = Close > EMA1;

// 綜合判斷 EMA 1（移除嚴格的 Virgin 條件）
Signal1 = IsRecentStrong1 and IsTrendUp1 and TouchedEMA1 and ClosedAbove1 and IsPinbar and HasRange;

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
TouchedEMA2 = Low < EMA2;
ClosedAbove2 = Close > EMA2;

Signal2 = IsRecentStrong2 and IsTrendUp2 and TouchedEMA2 and ClosedAbove2 and IsPinbar and HasRange;

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
TouchedEMA3 = Low < EMA3;
ClosedAbove3 = Close > EMA3;

Signal3 = IsRecentStrong3 and IsTrendUp3 and TouchedEMA3 and ClosedAbove3 and IsPinbar and HasRange;

// === 最終輸出 ===
// 任一 EMA 觸發訊號即可
FinalSignal = Signal1 or Signal2 or Signal3;

// 判斷觸發的 EMA 週期（優先順序：Signal1 > Signal2 > Signal3）
if Signal1 then
    TriggerPeriod = EMA_Period1
else if Signal2 then
    TriggerPeriod = EMA_Period2
else if Signal3 then
    TriggerPeriod = EMA_Period3
else
    TriggerPeriod = 0;

if FinalSignal then
    Ret = 1
else
    Ret = 0;

// === 輸出數值（用於排序或顯示）===
OutputField(1, TriggerPeriod, "觸發EMA週期");
OutputField(2, EMA1, "EMA_8");
OutputField(3, EMA2, "EMA_20");
OutputField(4, EMA3, "EMA_56");
OutputField(5, LowerShadowRatio, "下引線比例");
