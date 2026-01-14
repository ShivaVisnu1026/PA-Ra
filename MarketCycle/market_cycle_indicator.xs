// ===================================================================
// 腳本名稱：Market Cycle Indicator (市場週期指標)
// 腳本類型：指標（Indicator）
// 功能描述：在圖表上標示當前市場週期階段
//          - 顯示趨勢偏向和週期階段
//          - 繪製相關EMA線
//          - 輸出關鍵數據供分析
// 資料週期：週線（Weekly）建議
// 作者：Based on Al Brooks Price Action Concepts
// 建立日期：2026-01-13
// 版本：1.0
// ===================================================================

{@type:indicator}

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

// 顯示選項
input: ShowEMA(true, "顯示EMA線");
input: ShowSignals(true, "顯示階段變化信號");

// ===================================================================
// === 變數宣告 ===
// ===================================================================
var: i(0),
     
     // EMA相關
     EMA_Short(0),
     EMA_Long(0),
     
     // ATR相關
     ATR_Val(0),
     
     // 趨勢分析
     TrendBias(0),
     HH_Count(0),
     HL_Count(0),
     LH_Count(0),
     LL_Count(0),
     TrendScore(0),
     
     // 突破分析
     IsBreakout(false),
     BreakoutStrength(0),
     BarOverlapPct(0),
     ClosePosition(0),
     StrongBarsCount(0),
     
     // 回撤分析
     PullbackBars(0),
     MaxPullbackBars(0),
     
     // 盤整區分析
     RangeHigh(0),
     RangeLow(0),
     RangeWidth(0),
     RangeWidthATR(0),
     IsInRange(false),
     RangeBarsCount(0),
     
     // 最終分類
     MarketPhase(0),
     PrevPhase(0),
     PhaseConfidence(0),
     
     // 輔助變數
     BarRange(0),
     TempSum(0);

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
    
    // ===================================================================
    // === 趨勢偏向分析 ===
    // ===================================================================
    
    HH_Count = 0;
    HL_Count = 0;
    LH_Count = 0;
    LL_Count = 0;
    
    for i = 1 to TrendLookback - 1
    begin
        if High[i] > High[i+1] then
            HH_Count = HH_Count + 1;
        if Low[i] > Low[i+1] then
            HL_Count = HL_Count + 1;
        if High[i] < High[i+1] then
            LH_Count = LH_Count + 1;
        if Low[i] < Low[i+1] then
            LL_Count = LL_Count + 1;
    end;
    
    TrendScore = (HH_Count + HL_Count) - (LH_Count + LL_Count);
    
    if TrendScore > 5 and EMA_Short > EMA_Long then
        TrendBias = 1
    else if TrendScore < -5 and EMA_Short < EMA_Long then
        TrendBias = -1
    else
        TrendBias = 0;
    
    // ===================================================================
    // === 突破分析 ===
    // ===================================================================
    
    TempSum = 0;
    for i = 0 to BreakoutBars - 2
    begin
        if High[i] > Low[i+1] and Low[i] < High[i+1] then
        begin
            BarRange = MinList(High[i], High[i+1]) - MaxList(Low[i], Low[i+1]);
            if (High[i] - Low[i]) > 0 then
                TempSum = TempSum + (BarRange / (High[i] - Low[i])) * 100;
        end;
    end;
    if BreakoutBars > 1 then
        BarOverlapPct = TempSum / (BreakoutBars - 1)
    else
        BarOverlapPct = 0;
    
    TempSum = 0;
    StrongBarsCount = 0;
    for i = 0 to BreakoutBars - 1
    begin
        BarRange = High[i] - Low[i];
        if BarRange > 0 then
        begin
            ClosePosition = (Close[i] - Low[i]) / BarRange;
            TempSum = TempSum + ClosePosition;
            
            if (TrendBias >= 0 and ClosePosition > BreakoutCloseThreshold) or
               (TrendBias <= 0 and ClosePosition < (1 - BreakoutCloseThreshold)) then
                StrongBarsCount = StrongBarsCount + 1;
        end;
    end;
    
    IsBreakout = (BarOverlapPct < BreakoutOverlapMax) and 
                 (StrongBarsCount >= BreakoutBars * 0.6);
    
    if IsBreakout then
    begin
        if BarOverlapPct < 10 and StrongBarsCount = BreakoutBars then
            BreakoutStrength = 3
        else if BarOverlapPct < 15 then
            BreakoutStrength = 2
        else
            BreakoutStrength = 1;
    end
    else
        BreakoutStrength = 0;
    
    // ===================================================================
    // === 回撤分析 ===
    // ===================================================================
    
    MaxPullbackBars = 0;
    PullbackBars = 0;
    
    for i = 0 to TrendLookback - 1
    begin
        if TrendBias = 1 then
        begin
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
    
    // ===================================================================
    // === 盤整區分析 ===
    // ===================================================================
    
    RangeHigh = Highest(High, RangeBars);
    RangeLow = Lowest(Low, RangeBars);
    RangeWidth = RangeHigh - RangeLow;
    
    if ATR_Val > 0 then
        RangeWidthATR = (RangeWidth / ATR_Val)
    else
        RangeWidthATR = 0;
    
    IsInRange = (RangeWidthATR < RangeThreshold) and (AbsValue(TrendScore) < 5);
    
    RangeBarsCount = 0;
    for i = 0 to RangeBars - 1
    begin
        if High[i] <= RangeHigh * 1.02 and Low[i] >= RangeLow * 0.98 then
            RangeBarsCount = RangeBarsCount + 1;
    end;
    
    // ===================================================================
    // === 市場週期分類 ===
    // ===================================================================
    
    PrevPhase = MarketPhase[1];
    
    if IsBreakout and AbsValue(TrendBias) = 1 then
    begin
        MarketPhase = 1;
        PhaseConfidence = BreakoutStrength;
    end
    else if AbsValue(TrendBias) = 1 and MaxPullbackBars <= NarrowPullbackMax then
    begin
        MarketPhase = 2;
        if MaxPullbackBars <= 1 then
            PhaseConfidence = 3
        else if MaxPullbackBars <= 2 then
            PhaseConfidence = 2
        else
            PhaseConfidence = 1;
    end
    else if AbsValue(TrendBias) = 1 and 
            MaxPullbackBars >= WidePullbackMin and 
            MaxPullbackBars <= WidePullbackMax then
    begin
        MarketPhase = 3;
        if MaxPullbackBars <= 8 then
            PhaseConfidence = 3
        else if MaxPullbackBars <= 12 then
            PhaseConfidence = 2
        else
            PhaseConfidence = 1;
    end
    else if IsInRange or (MaxPullbackBars > WidePullbackMax) then
    begin
        MarketPhase = 4;
        if RangeBarsCount >= RangeBars * 0.9 then
            PhaseConfidence = 3
        else if RangeBarsCount >= RangeBars * 0.7 then
            PhaseConfidence = 2
        else
            PhaseConfidence = 1;
    end
    else
    begin
        MarketPhase = 0;
        PhaseConfidence = 0;
    end;

end;

// ===================================================================
// === 繪製圖形 ===
// ===================================================================

// 繪製EMA線
if ShowEMA then
begin
    Plot1(EMA_Short > 0, EMA_Short, "EMA20");
    Plot2(EMA_Long > 0, EMA_Long, "EMA50");
end;

// 繪製階段變化信號
if ShowSignals then
begin
    // 進入突破階段
    if MarketPhase = 1 and PrevPhase <> 1 then
    begin
        if TrendBias = 1 then
            Plot3(High * 1.01, "突破↑")
        else
            Plot4(Low * 0.99, "突破↓");
    end;
    
    // 進入盤整區
    if MarketPhase = 4 and PrevPhase <> 4 then
        Plot5(Close, "盤整");
end;

// ===================================================================
// === 輸出欄位 ===
// ===================================================================

SetOutputName1("週期階段");
OutputField1(MarketPhase);

SetOutputName2("趨勢偏向");
OutputField2(TrendBias);

SetOutputName3("信心度");
OutputField3(PhaseConfidence);

SetOutputName4("趨勢分數");
OutputField4(TrendScore);

SetOutputName5("回撤棒數");
OutputField5(MaxPullbackBars);

SetOutputName6("重疊%");
OutputField6(BarOverlapPct);

SetOutputName7("區間ATR");
OutputField7(RangeWidthATR);

// ===================================================================
// === 使用說明 ===
// ===================================================================
// 【指標說明】
// 本指標在圖表上顯示當前市場週期階段，幫助交易者
// 快速判斷應採用的交易策略。
//
// 【週期階段】
// - 1 = 突破 (Breakout)
// - 2 = 窄通道 (Narrow Channel)
// - 3 = 寬通道 (Wide Channel)
// - 4 = 盤整區 (Trading Range)
//
// 【趨勢偏向】
// - 1 = 多頭 (Bull)
// - -1 = 空頭 (Bear)
// - 0 = 中性
//
// 【建議用法】
// 1. 將此指標添加到週線圖
// 2. 觀察輸出欄位判斷當前階段
// 3. 根據階段選擇適當的交易策略
// 4. 搭配選股器使用效果更佳
// ===================================================================

