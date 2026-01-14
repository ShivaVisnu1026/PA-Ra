// ===================================================================
// 腳本名稱：Market Cycle Screener - Bull Only (市場週期選股-多頭)
// 腳本類型：選股（Screener/Filter）
// 功能描述：篩選處於多頭週期階段的股票
//          - 只選出趨勢偏向為多頭的股票
//          - 適合尋找做多機會
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

// 過濾參數
input: MinVolume(100, "最小週成交量");
input: FilterPhase(0, "過濾階段(0=全部多頭/1=突破/2=窄通道/3=寬通道)");

// ===================================================================
// === 變數宣告 ===
// ===================================================================
var: i(0),
     
     // EMA相關
     EMA_Short(0),
     EMA_Long(0),
     EMA_Slope(0),
     
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
     AvgClosePosition(0),
     StrongBarsCount(0),
     
     // 回撤分析
     PullbackBars(0),
     MaxPullbackBars(0),
     
     // 最終分類
     MarketPhase(0),
     PhaseConfidence(0),
     
     // 輔助變數
     BarRange(0),
     TempSum(0),
     VolumeOK(false),
     IsWeekly(false),
     IsBullish(false),
     PassFilter(false);

// ===================================================================
// === 初始化 ===
// ===================================================================
ret = 0;
MarketPhase = 0;
PhaseConfidence = 0;
TrendBias = 0;
IsBullish = false;

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
    // === 趨勢分析（只關注多頭） ===
    // ===================================================================
    
    // 計算HH/HL/LH/LL序列
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
    
    // 計算趨勢分數
    TrendScore = (HH_Count + HL_Count) - (LH_Count + LL_Count);
    
    // 判斷是否為多頭
    IsBullish = (TrendScore > 5) and (EMA_Short > EMA_Long);
    
    if IsBullish then
        TrendBias = 1
    else
        TrendBias = 0;
    
    // ===================================================================
    // === 只在多頭時進行分類 ===
    // ===================================================================
    
    if IsBullish then
    begin
        // 突破分析
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
        
        // 收盤位置分析
        TempSum = 0;
        StrongBarsCount = 0;
        for i = 0 to BreakoutBars - 1
        begin
            BarRange = High[i] - Low[i];
            if BarRange > 0 then
            begin
                ClosePosition = (Close[i] - Low[i]) / BarRange;
                TempSum = TempSum + ClosePosition;
                if ClosePosition > BreakoutCloseThreshold then
                    StrongBarsCount = StrongBarsCount + 1;
            end;
        end;
        AvgClosePosition = TempSum / BreakoutBars;
        
        // 判斷是否為突破
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
        
        // 回撤分析
        MaxPullbackBars = 0;
        PullbackBars = 0;
        
        for i = 0 to TrendLookback - 1
        begin
            if Low[i] < Low[i+1] then
            begin
                PullbackBars = PullbackBars + 1;
                if PullbackBars > MaxPullbackBars then
                    MaxPullbackBars = PullbackBars;
            end
            else
                PullbackBars = 0;
        end;
        
        // 市場週期分類（多頭版本）
        if IsBreakout then
        begin
            MarketPhase = 1;  // 多頭突破
            PhaseConfidence = BreakoutStrength;
        end
        else if MaxPullbackBars <= NarrowPullbackMax then
        begin
            MarketPhase = 2;  // 多頭窄通道
            if MaxPullbackBars <= 1 then
                PhaseConfidence = 3
            else if MaxPullbackBars <= 2 then
                PhaseConfidence = 2
            else
                PhaseConfidence = 1;
        end
        else if MaxPullbackBars >= WidePullbackMin and MaxPullbackBars <= WidePullbackMax then
        begin
            MarketPhase = 3;  // 多頭寬通道
            if MaxPullbackBars <= 8 then
                PhaseConfidence = 3
            else if MaxPullbackBars <= 12 then
                PhaseConfidence = 2
            else
                PhaseConfidence = 1;
        end
        else
        begin
            MarketPhase = 0;  // 不符合多頭通道條件
            PhaseConfidence = 0;
        end;
    end;
    
    // ===================================================================
    // === 選股判斷 ===
    // ===================================================================
    
    if FilterPhase = 0 then
        PassFilter = (IsBullish and MarketPhase > 0 and VolumeOK)
    else
        PassFilter = (IsBullish and MarketPhase = FilterPhase and VolumeOK);
    
    if PassFilter then
        ret = 1
    else
        ret = 0;

end;

end;

// ===================================================================
// === 輸出欄位 ===
// ===================================================================

SetOutputName1("多頭階段");
OutputField1(MarketPhase, 1);

SetOutputName2("信心度");
OutputField2(PhaseConfidence, 1);

SetOutputName3("趨勢分數");
OutputField3(TrendScore);

SetOutputName4("回撤棒數");
OutputField4(MaxPullbackBars);

SetOutputName5("重疊%");
OutputField5(BarOverlapPct);

SetOutputName6("EMA差%");
if EMA_Long > 0 then
    OutputField6(((EMA_Short - EMA_Long) / EMA_Long) * 100)
else
    OutputField6(0);

SetOutputName7("收盤價");
OutputField7(Close);

// ===================================================================
// === 使用說明 ===
// ===================================================================
// 【多頭階段說明】
// - 1 = 多頭突破: 強勢上漲，最佳做多時機
// - 2 = 多頭窄通道: 穩定上升趨勢，持續做多
// - 3 = 多頭寬通道: 趨勢弱化但仍向上，可逢低做多
//
// 【交易策略】
// - 突破階段: 積極做多，設定寬止損
// - 窄通道: 回撤進場，順勢操作
// - 寬通道: 等待較深回撤再進場
// ===================================================================

