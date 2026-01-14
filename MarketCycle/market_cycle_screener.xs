// ===================================================================
// 腳本名稱：Market Cycle Screener (市場週期選股)
// 腳本類型：選股（Screener/Filter）
// 功能描述：根據價格行為理論分類股票所處市場週期階段
//          - Breakout (突破): 強勢趨勢棒，收盤近極值，低重疊
//          - Narrow Channel (窄通道): 明確趨勢方向，短暫回撤(1-3棒)
//          - Wide Channel (寬通道): 趨勢仍在但弱化，較深回撤(5-20棒)
//          - Trading Range (盤整區): 橫盤走勢，通常持續20+棒
// 資料週期：週線（Weekly）
// 作者：Based on Al Brooks Price Action Concepts
// 建立日期：2026-01-13
// 版本：1.0
// ===================================================================

{@type:filter}

settotalbar(100);

// ===================================================================
// === 參數設定 ===
// ===================================================================

// 趨勢判斷參數
input: TrendLookback(20, "趨勢判斷回溯週數");
input: EMA_Period(20, "EMA週期");
input: EMA_Long_Period(50, "長EMA週期");

// 突破判斷參數
input: BreakoutBars(5, "突破判斷回溯棒數");
input: BreakoutCloseThreshold(0.7, "突破收盤位置閾值(0-1)");
input: BreakoutOverlapMax(20, "突破最大重疊%(0-100)");

// 通道判斷參數
input: NarrowPullbackMax(3, "窄通道最大回撤棒數");
input: WidePullbackMin(5, "寬通道最小回撤棒數");
input: WidePullbackMax(20, "寬通道最大回撤棒數");

// 盤整區判斷參數
input: RangeBars(20, "盤整區最小棒數");
input: RangeThreshold(15, "盤整區最大範圍%(相對ATR)");

// 過濾參數
input: MinVolume(100, "最小週成交量");

// 輸出選項
input: FilterPhase(0, "過濾階段(0=全部/1=突破/2=窄通道/3=寬通道/4=盤整)");

// ===================================================================
// === 變數宣告 ===
// ===================================================================
var: i(0),
     j(0),
     
     // EMA相關
     EMA_Short(0),
     EMA_Long(0),
     EMA_Slope(0),
     EMA_Diff_Pct(0),
     
     // ATR相關
     ATR_Val(0),
     
     // 趨勢分析
     TrendBias(0),           // 1=多頭, -1=空頭, 0=中性
     HH_Count(0),            // Higher High 計數
     HL_Count(0),            // Higher Low 計數
     LH_Count(0),            // Lower High 計數
     LL_Count(0),            // Lower Low 計數
     TrendScore(0),
     
     // 突破分析
     IsBreakout(false),
     BreakoutStrength(0),
     BarOverlapPct(0),
     ClosePosition(0),       // 收盤在高低點範圍的位置
     AvgClosePosition(0),
     StrongBarsCount(0),
     
     // 回撤分析
     PullbackBars(0),
     PullbackDepth(0),
     MaxPullbackBars(0),
     InPullback(false),
     PullbackStartBar(0),
     
     // 盤整區分析
     RangeHigh(0),
     RangeLow(0),
     RangeWidth(0),
     RangeWidthATR(0),
     IsInRange(false),
     RangeBarsCount(0),
     
     // 最終分類
     MarketPhase(0),         // 1=突破, 2=窄通道, 3=寬通道, 4=盤整區
     PhaseConfidence(0),     // 信心度 1-3
     
     // 輔助變數
     HighestHigh(0),
     LowestLow(0),
     PrevHigh(0),
     PrevLow(0),
     BarRange(0),
     TempSum(0),
     VolumeOK(false),
     IsWeekly(false),
     PassFilter(false);

// ===================================================================
// === 初始化 ===
// ===================================================================
ret = 0;
MarketPhase = 0;
PhaseConfidence = 0;
TrendBias = 0;

// ===================================================================
// === 週線檢查 ===
// ===================================================================
IsWeekly = (BarFreq = "W");

if not IsWeekly then
begin
    ret = 0;
end
else
begin

// ===================================================================
// === 基礎數據計算 ===
// ===================================================================
if CurrentBar > TrendLookback + 10 then
begin
    // 計算EMA
    EMA_Short = XAverage(Close, EMA_Period);
    EMA_Long = XAverage(Close, EMA_Long_Period);
    
    // 計算ATR
    ATR_Val = AvgTrueRange(14);
    
    // 成交量檢查
    VolumeOK = (Volume >= MinVolume);
    
    // ===================================================================
    // === 趨勢偏向分析 ===
    // ===================================================================
    
    // EMA斜率（最近5週的變化）
    if EMA_Short[5] > 0 then
        EMA_Slope = ((EMA_Short - EMA_Short[5]) / EMA_Short[5]) * 100
    else
        EMA_Slope = 0;
    
    // EMA差異百分比
    if EMA_Long > 0 then
        EMA_Diff_Pct = ((EMA_Short - EMA_Long) / EMA_Long) * 100
    else
        EMA_Diff_Pct = 0;
    
    // 計算HH/HL/LH/LL序列
    HH_Count = 0;
    HL_Count = 0;
    LH_Count = 0;
    LL_Count = 0;
    
    for i = 1 to TrendLookback - 1
    begin
        // Higher High
        if High[i] > High[i+1] then
            HH_Count = HH_Count + 1;
        // Higher Low
        if Low[i] > Low[i+1] then
            HL_Count = HL_Count + 1;
        // Lower High
        if High[i] < High[i+1] then
            LH_Count = LH_Count + 1;
        // Lower Low
        if Low[i] < Low[i+1] then
            LL_Count = LL_Count + 1;
    end;
    
    // 計算趨勢分數
    TrendScore = (HH_Count + HL_Count) - (LH_Count + LL_Count);
    
    // 判斷趨勢偏向
    if TrendScore > 5 and EMA_Short > EMA_Long then
        TrendBias = 1      // 多頭
    else if TrendScore < -5 and EMA_Short < EMA_Long then
        TrendBias = -1     // 空頭
    else
        TrendBias = 0;     // 中性
    
    // ===================================================================
    // === 突破分析 ===
    // ===================================================================
    
    // 計算棒線重疊百分比
    TempSum = 0;
    for i = 0 to BreakoutBars - 2
    begin
        // 計算相鄰兩棒的重疊
        if High[i] > Low[i+1] and Low[i] < High[i+1] then
        begin
            // 有重疊
            BarRange = MinList(High[i], High[i+1]) - MaxList(Low[i], Low[i+1]);
            if (High[i] - Low[i]) > 0 then
                TempSum = TempSum + (BarRange / (High[i] - Low[i])) * 100;
        end;
    end;
    if BreakoutBars > 1 then
        BarOverlapPct = TempSum / (BreakoutBars - 1)
    else
        BarOverlapPct = 0;
    
    // 計算平均收盤位置（收在棒線的上部還是下部）
    TempSum = 0;
    StrongBarsCount = 0;
    for i = 0 to BreakoutBars - 1
    begin
        BarRange = High[i] - Low[i];
        if BarRange > 0 then
        begin
            ClosePosition = (Close[i] - Low[i]) / BarRange;
            TempSum = TempSum + ClosePosition;
            
            // 計算強勢棒數量（收盤在上70%或下30%）
            if (TrendBias >= 0 and ClosePosition > BreakoutCloseThreshold) or
               (TrendBias <= 0 and ClosePosition < (1 - BreakoutCloseThreshold)) then
                StrongBarsCount = StrongBarsCount + 1;
        end;
    end;
    AvgClosePosition = TempSum / BreakoutBars;
    
    // 判斷是否為突破
    IsBreakout = (BarOverlapPct < BreakoutOverlapMax) and 
                 (StrongBarsCount >= BreakoutBars * 0.6);
    
    // 突破強度
    if IsBreakout then
    begin
        if BarOverlapPct < 10 and StrongBarsCount = BreakoutBars then
            BreakoutStrength = 3
        else if BarOverlapPct < 15 and StrongBarsCount >= BreakoutBars * 0.8 then
            BreakoutStrength = 2
        else
            BreakoutStrength = 1;
    end
    else
        BreakoutStrength = 0;
    
    // ===================================================================
    // === 回撤分析 ===
    // ===================================================================
    
    // 計算最大連續回撤棒數
    MaxPullbackBars = 0;
    PullbackBars = 0;
    
    for i = 0 to TrendLookback - 1
    begin
        if TrendBias = 1 then
        begin
            // 多頭趨勢中，低點下破前低為回撤
            if Low[i] < Low[i+1] then
            begin
                PullbackBars = PullbackBars + 1;
                if PullbackBars > MaxPullbackBars then
                    MaxPullbackBars = PullbackBars;
            end
            else
                PullbackBars = 0;
        end
        else if TrendBias = -1 then
        begin
            // 空頭趨勢中，高點上破前高為回撤
            if High[i] > High[i+1] then
            begin
                PullbackBars = PullbackBars + 1;
                if PullbackBars > MaxPullbackBars then
                    MaxPullbackBars = PullbackBars;
            end
            else
                PullbackBars = 0;
        end;
    end;
    
    // 計算回撤深度（相對ATR）
    if ATR_Val > 0 then
    begin
        HighestHigh = Highest(High, TrendLookback);
        LowestLow = Lowest(Low, TrendLookback);
        
        if TrendBias = 1 then
            PullbackDepth = (HighestHigh - Low) / ATR_Val
        else if TrendBias = -1 then
            PullbackDepth = (High - LowestLow) / ATR_Val
        else
            PullbackDepth = 0;
    end;
    
    // ===================================================================
    // === 盤整區分析 ===
    // ===================================================================
    
    // 計算區間高低點
    RangeHigh = Highest(High, RangeBars);
    RangeLow = Lowest(Low, RangeBars);
    RangeWidth = RangeHigh - RangeLow;
    
    // 區間寬度相對ATR
    if ATR_Val > 0 then
        RangeWidthATR = (RangeWidth / ATR_Val)
    else
        RangeWidthATR = 0;
    
    // 判斷是否在盤整區
    // 條件：區間寬度小且趨勢分數接近0
    IsInRange = (RangeWidthATR < RangeThreshold) and 
                (AbsValue(TrendScore) < 5);
    
    // 計算盤整區內的棒數
    RangeBarsCount = 0;
    for i = 0 to RangeBars - 1
    begin
        if High[i] <= RangeHigh * 1.02 and Low[i] >= RangeLow * 0.98 then
            RangeBarsCount = RangeBarsCount + 1;
    end;
    
    // ===================================================================
    // === 市場週期分類 ===
    // ===================================================================
    
    // 優先順序: 突破 > 窄通道 > 寬通道 > 盤整區
    
    // 1. 突破階段判斷
    if IsBreakout and AbsValue(TrendBias) = 1 then
    begin
        MarketPhase = 1;  // 突破
        PhaseConfidence = BreakoutStrength;
    end
    // 2. 窄通道判斷
    else if AbsValue(TrendBias) = 1 and MaxPullbackBars <= NarrowPullbackMax then
    begin
        MarketPhase = 2;  // 窄通道
        if MaxPullbackBars <= 1 then
            PhaseConfidence = 3
        else if MaxPullbackBars <= 2 then
            PhaseConfidence = 2
        else
            PhaseConfidence = 1;
    end
    // 3. 寬通道判斷
    else if AbsValue(TrendBias) = 1 and 
            MaxPullbackBars >= WidePullbackMin and 
            MaxPullbackBars <= WidePullbackMax then
    begin
        MarketPhase = 3;  // 寬通道
        if MaxPullbackBars <= 8 then
            PhaseConfidence = 3
        else if MaxPullbackBars <= 12 then
            PhaseConfidence = 2
        else
            PhaseConfidence = 1;
    end
    // 4. 盤整區判斷
    else if IsInRange or (MaxPullbackBars > WidePullbackMax) then
    begin
        MarketPhase = 4;  // 盤整區
        if RangeBarsCount >= RangeBars * 0.9 then
            PhaseConfidence = 3
        else if RangeBarsCount >= RangeBars * 0.7 then
            PhaseConfidence = 2
        else
            PhaseConfidence = 1;
    end
    // 5. 無法明確分類
    else
    begin
        MarketPhase = 0;  // 未分類
        PhaseConfidence = 0;
    end;
    
    // ===================================================================
    // === 選股判斷 ===
    // ===================================================================
    
    // 過濾條件
    if FilterPhase = 0 then
        PassFilter = (MarketPhase > 0 and VolumeOK)
    else
        PassFilter = (MarketPhase = FilterPhase and VolumeOK);
    
    // 輸出結果
    if PassFilter then
        ret = 1
    else
        ret = 0;

end;  // CurrentBar check

end;  // IsWeekly check

// ===================================================================
// === 輸出欄位 ===
// ===================================================================

// 1. 市場週期階段
SetOutputName1("週期階段");
OutputField1(MarketPhase, 1);  // 降序排列，突破優先

// 2. 階段信心度
SetOutputName2("信心度");
OutputField2(PhaseConfidence, 1);

// 3. 趨勢偏向
SetOutputName3("趨勢偏向");
OutputField3(TrendBias);

// 4. 趨勢分數
SetOutputName4("趨勢分數");
OutputField4(TrendScore);

// 5. 最大回撤棒數
SetOutputName5("回撤棒數");
OutputField5(MaxPullbackBars);

// 6. 棒線重疊%
SetOutputName6("重疊%");
OutputField6(BarOverlapPct);

// 7. 區間寬度(ATR)
SetOutputName7("區間ATR");
OutputField7(RangeWidthATR);

// 8. 收盤價
SetOutputName8("收盤價");
OutputField8(Close);

// ===================================================================
// === 使用說明 ===
// ===================================================================
// 【市場週期階段說明】
// - 1 = 突破 (Breakout): 強勢趨勢棒，最佳趨勢交易機會
// - 2 = 窄通道 (Narrow Channel): 回撤短暫，仍適合趨勢交易
// - 3 = 寬通道 (Wide Channel): 回撤較深，可考慮逆勢剝頭皮
// - 4 = 盤整區 (Trading Range): 橫盤走勢，買低賣高策略
//
// 【趨勢偏向說明】
// - 1 = 多頭偏向 (Bull)
// - -1 = 空頭偏向 (Bear)
// - 0 = 中性/無明確偏向
//
// 【信心度說明】
// - 3 = 高信心度，型態明確
// - 2 = 中等信心度
// - 1 = 低信心度，型態較弱
//
// 【交易策略建議】
// 
// 1. 突破階段 (Phase=1):
//    - 只做順勢交易
//    - 高機率但高風險
//    - 偏好擺動交易
//
// 2. 窄通道階段 (Phase=2):
//    - 維持順勢交易
//    - Always-in狀態
//    - 只做趨勢方向
//
// 3. 寬通道階段 (Phase=3):
//    - 仍以順勢為主
//    - 可做逆勢剝頭皮（進階）
//    - 加快獲利了結
//
// 4. 盤整區階段 (Phase=4):
//    - 買低賣高策略
//    - 使用剝頭皮戰術
//    - 無方向性偏見
//
// 【注意事項】
// - 本選股器專為週線設計
// - 建議搭配其他技術指標確認進場時機
// - 選出的股票仍需人工判斷
// - 市場週期會隨時間演變
// ===================================================================

