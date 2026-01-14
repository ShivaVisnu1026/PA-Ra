{@type:sensor}

// ===================================================================
// 警示名稱：多模組組合策略警示（EMA + ATR + 內外盤 + 早盤量）
// 功能描述：組合多個技術模組的綜合策略
// 版本：1.0
// 建立日期：2025-12-19
// ===================================================================

// === 參數宣告 ===
settotalbar(250);

input: EMA_Period(20, "EMA 週期"),
       MinTicksAbove(2, "需高於 EMA 的 Ticks"),
       ATR_Period(14, "ATR 週期"),
       MinATR_Multiple(0.5, "最小 ATR 倍數"),
       MaxATR_Multiple(2.0, "最大 ATR 倍數"),
       
       // 內外盤參數
       TickLookback(5, "內外盤回顧K棒數"),
       MinBuyPressure(0.3, "最小買盤壓力（0-1）"),
       
       // 早盤成交量參數
       EarlyMinutes(10, "早盤分鐘數"),
       MinVolIncrease(0.20, "最小成交量增長（20%）"),
       BarInterval_Min(5, "K棒週期（分鐘）"),
       
       // 其他過濾
       VolumeFilter(true, "啟用平均成交量過濾"),
       MinAvgVolume(300, "最小平均成交量");

// === 變數宣告 ===
var: intrabarpersist AlertTriggered(false);

var: // EMA 模組
     EMA_Value(0),
     TickSize(0),
     IsAboveEMA(false),
     
     // ATR 模組
     ATR_Value(0),
     TrueRange(0),
     CurrentRange(0),
     ATR_Multiple(0),
     IsValidVolatility(false),
     
     // 內外盤模組
     InnerVol(0),
     OuterVol(0),
     InnerSum(0),
     OuterSum(0),
     BuyPressure(0),
     IsBuyersDominating(false),
     
     // 早盤成交量模組
     TodayVolSum(0),
     YesterdayVolSum(0),
     VolIncrease(0),
     IsEarlyVolHigh(false),
     CurrentTime(0),
     MinutesSinceOpen(0),
     IsInEarlyWindow(false),
     BarsInWindow(0),
     
     // 成交量過濾
     VolSum(0),
     VolAvg(0),
     IsVolumeOK(false),
     
     i(0);

// === 初始化 ===
ret = 0;

if CurrentBar > 20 then begin
    
    // ===== 模組 1: 檢查價格是否在 EMA 上方 =====
    EMA_Value = XAverage(Close, EMA_Period);
    
    if Close >= 1000 then
        TickSize = 5.0
    else if Close >= 500 then
        TickSize = 1.0
    else if Close >= 100 then
        TickSize = 0.5
    else if Close >= 50 then
        TickSize = 0.1
    else
        TickSize = 0.05;
    
    IsAboveEMA = (Close >= EMA_Value + (MinTicksAbove * TickSize));
    
    
    // ===== 模組 2: ATR 過濾 =====
    TrueRange = MaxList(
        High - Low,
        AbsValue(High - Close[1]),
        AbsValue(Low - Close[1])
    );
    
    if CurrentBar = 1 then
        ATR_Value = TrueRange
    else if CurrentBar <= ATR_Period then
        ATR_Value = Average(TrueRange, CurrentBar)
    else
        ATR_Value = (ATR_Value[1] * (ATR_Period - 1) + TrueRange) / ATR_Period;
    
    CurrentRange = High - Low;
    if ATR_Value > 0 then begin
        ATR_Multiple = CurrentRange / ATR_Value;
        IsValidVolatility = (ATR_Multiple >= MinATR_Multiple) and 
                            (ATR_Multiple <= MaxATR_Multiple);
    end
    else
        IsValidVolatility = false;
    
    
    // ===== 模組 3: 內外盤買賣壓力 =====
    InnerSum = 0;
    OuterSum = 0;
    
    for i = 0 to TickLookback - 1 begin
        // 內盤量（賣方主動）
        InnerVol = GetField("內盤量")[i];
        if InnerVol = Invalid then
            InnerVol = GetField("TradeVolumeAtBid")[i];
        
        // 外盤量（買方主動）
        OuterVol = GetField("外盤量")[i];
        if OuterVol = Invalid then
            OuterVol = GetField("TradeVolumeAtAsk")[i];
        
        if InnerVol <> Invalid then
            InnerSum = InnerSum + InnerVol;
        if OuterVol <> Invalid then
            OuterSum = OuterSum + OuterVol;
    end;
    
    // 計算買盤壓力（0 到 1，越高越多頭）
    if (InnerSum + OuterSum) > 0 then begin
        BuyPressure = OuterSum / (InnerSum + OuterSum);
        IsBuyersDominating = (BuyPressure >= MinBuyPressure);
    end
    else begin
        BuyPressure = 0.5;
        IsBuyersDominating = false;
    end;
    
    
    // ===== 模組 4: 早盤成交量比較 =====
    CurrentTime = Time;
    MinutesSinceOpen = 0;
    IsInEarlyWindow = false;
    
    // 計算開盤後經過的分鐘數（假設 09:00 開盤）
    if CurrentTime >= 090000 then begin
        MinutesSinceOpen = (
            ((CurrentTime / 10000) - 9) * 60 +
            ((CurrentTime mod 10000) / 100)
        );
        IsInEarlyWindow = (MinutesSinceOpen <= EarlyMinutes);
    end;
    
    IsEarlyVolHigh = false;
    if IsInEarlyWindow then begin
        BarsInWindow = MinutesSinceOpen / BarInterval_Min;
        if BarsInWindow > 0 then begin
            // 今日累計量
            TodayVolSum = 0;
            for i = 0 to MinList(BarsInWindow - 1, CurrentBar - 1) begin
                TodayVolSum = TodayVolSum + Volume[i];
            end;
            
            // 昨日同時段量（估算）
            YesterdayVolSum = 0;
            for i = BarsInWindow to (BarsInWindow * 2) - 1 begin
                if i < CurrentBar then
                    YesterdayVolSum = YesterdayVolSum + Volume[i];
            end;
            
            // 計算增長
            if YesterdayVolSum > 0 then begin
                VolIncrease = (TodayVolSum - YesterdayVolSum) / YesterdayVolSum;
                IsEarlyVolHigh = (VolIncrease >= MinVolIncrease);
            end;
        end;
    end
    else begin
        // 不在早盤窗口，預設通過
        IsEarlyVolHigh = true;
        VolIncrease = 0;
    end;
    
    
    // ===== 模組 5: 平均成交量過濾 =====
    IsVolumeOK = true;
    if VolumeFilter then begin
        VolSum = 0;
        for i = 1 to 5 begin
            VolSum = VolSum + GetField("Volume", "D")[i];
        end;
        VolAvg = VolSum / 5;
        IsVolumeOK = (VolAvg > MinAvgVolume);
    end;
    
    
    // ===== 組合所有模組條件 =====
    if IsAboveEMA and 
       IsValidVolatility and 
       IsBuyersDominating and 
       IsEarlyVolHigh and 
       IsVolumeOK and
       (Close > Open) then begin  // 額外: 陽線確認
        
        if not AlertTriggered then begin
            ret = 1;
            AlertTriggered = true;
            RetMsg = Text(
                "【多模組策略觸發】",
                " 價格: ", NumToStr(Close, 2),
                " | EMA20: ", NumToStr(EMA_Value, 2), " (+", NumToStr(MinTicksAbove, 0), "T)",
                " | ATR: ", NumToStr(ATR_Value, 2), " (", NumToStr(ATR_Multiple, 2), "x)",
                " | 買壓: ", NumToStr(BuyPressure * 100, 1), "%",
                " | 內盤: ", NumToStr(InnerSum, 0),
                " | 外盤: ", NumToStr(OuterSum, 0),
                " | 早盤量增: ", NumToStr(VolIncrease * 100, 1), "%",
                " | 5日均量: ", NumToStr(VolAvg, 0)
            );
        end
        else begin
            ret = 0;
        end;
    end
    else begin
        ret = 0;
        // 重置警示條件
        if not IsAboveEMA or not IsValidVolatility or not IsBuyersDominating then
            AlertTriggered = false;
    end;
    
end;

