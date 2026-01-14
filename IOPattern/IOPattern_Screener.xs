// ===================================================================
// 腳本名稱：IO Pattern Screener (IO型態選股)
// 腳本類型：選股（Screener/Filter）
// 功能描述：篩選符合 IO 型態的股票
//          - II (Inside-Inside): 連續內包K棒
//          - OO (Outside-Outside): 連續外包K棒
//          - IOI (Inside-Outside-Inside): 內外內組合
// 資料週期：適用所有時間週期（分鐘/日/週/月）
// 作者：Extracted from Price Action All In One
// 建立日期：2024-12-17
// 版本：1.0
// ===================================================================

{@type:filter}

settotalbar(10);  // 只需要3根K棒歷史資料

// ===================================================================
// === 參數設定 ===
// ===================================================================
input: DetectOO(true, "選出OO型態(外包-外包)");
input: DetectII(true, "選出II型態(內包-內包)");
input: DetectIOI(true, "選出IOI型態(內-外-內)");

// 強度過濾
input: MinStrength(1, "最小型態強度(1=弱/2=中/3=強)");

// 成交量過濾
input: UseVolumeFilter(false, "使用成交量過濾");
input: MinVolumeRatio(1.0, "最小量比(相對20日均量)");

// 排序選項
input: SortByStrength(true, "依型態強度排序");

// ===================================================================
// === 變數宣告 ===
// ===================================================================
var: PatternOO(false),      // OO型態偵測結果
     PatternII(false),      // II型態偵測結果
     PatternIOI(false),     // IOI型態偵測結果
     
     PatternType(0),        // 型態類型編碼: 0=無, 1=II, 2=OO, 3=IOI
     PatternStrength(0),    // 型態強度: 0=無, 1=弱, 2=中, 3=強
     
     // K棒關係判斷
     IsOutside(false),
     IsInside(false),
     PrevIsOutside(false),
     PrevIsInside(false),
     
     // 成交量相關
     VolumeAvg(0),
     VolumeRatio(0),
     VolumeCondition(true),
     
     // 型態強度計算用（共用變數，避免重複宣告）
     CurrentRange(0),
     PrevRange(0),
     RangeRatio(0),
     
     // 選股結果
     PassFilter(false);

// ===================================================================
// === 計算 K 棒關係 ===
// ===================================================================
// 當前K棒與前一根的關係
IsOutside = High >= High[1] and Low <= Low[1] and 
            (High > High[1] or Low < Low[1]);

IsInside = High <= High[1] and Low >= Low[1] and 
           (High < High[1] or Low > Low[1]);

// 前一根K棒與前前根的關係
PrevIsOutside = High[1] >= High[2] and Low[1] <= Low[2] and 
                (High[1] > High[2] or Low[1] < Low[2]);

PrevIsInside = High[1] <= High[2] and Low[1] >= Low[2] and 
               (High[1] < High[2] or Low[1] > Low[2]);

// ===================================================================
// === 成交量過濾 ===
// ===================================================================
if UseVolumeFilter then begin
    VolumeAvg = Average(Volume, 20);
    if VolumeAvg > 0 then
        VolumeRatio = Volume / VolumeAvg
    else
        VolumeRatio = 1;
    
    VolumeCondition = VolumeRatio >= MinVolumeRatio;
end
else begin
    VolumeCondition = true;
    VolumeRatio = 0;
end;

// ===================================================================
// === IO 型態偵測 ===
// ===================================================================
// 重置所有型態標記
PatternOO = false;
PatternII = false;
PatternIOI = false;
PatternType = 0;
PatternStrength = 0;

// OO Pattern - Outside-Outside (連續外包)
if DetectOO then begin
    if IsOutside and PrevIsOutside then begin
        PatternOO = true;
        PatternType = 2;
        
        // 計算強度
        CurrentRange = High - Low;
        PrevRange = High[1] - Low[1];
        
        if PrevRange > 0 then
            RangeRatio = CurrentRange / PrevRange
        else
            RangeRatio = 1;
        
        if RangeRatio >= 1.5 then
            PatternStrength = 3
        else if RangeRatio >= 1.2 then
            PatternStrength = 2
        else
            PatternStrength = 1;
    end;
end;

// II Pattern - Inside-Inside (連續內包)
if DetectII and PatternType = 0 then begin
    if IsInside and PrevIsInside then begin
        PatternII = true;
        PatternType = 1;
        
        // 計算強度
        CurrentRange = High - Low;
        PrevRange = High[1] - Low[1];
        
        if PrevRange > 0 then
            RangeRatio = CurrentRange / PrevRange
        else
            RangeRatio = 1;
        
        if RangeRatio <= 0.5 then
            PatternStrength = 3
        else if RangeRatio <= 0.7 then
            PatternStrength = 2
        else
            PatternStrength = 1;
    end;
end;

// IOI Pattern - Inside-Outside-Inside
if DetectIOI and PatternType = 0 then begin
    if IsInside and PrevIsOutside then begin
        PatternIOI = true;
        PatternType = 3;
        PatternStrength = 2;  // IOI一律視為中等強度
    end;
end;

// ===================================================================
// === 選股判斷 ===
// ===================================================================
PassFilter = PatternType > 0 and 
             PatternStrength >= MinStrength and 
             VolumeCondition;

// ===================================================================
// === 輸出選股結果 ===
// ===================================================================
if PassFilter then
    ret = 1
else
    ret = 0;

// ===================================================================
// === 輸出欄位（供排序和進階篩選）===
// ===================================================================
SetOutputName1("IO型態");
if SortByStrength then
    OutputField1(PatternType)
else
    OutputField1(PatternType, 1);

SetOutputName2("型態強度");
if SortByStrength then
    OutputField2(PatternStrength, 1)
else
    OutputField2(PatternStrength);

SetOutputName3("OO型態");
if PatternOO then
    OutputField3(1)
else
    OutputField3(0);

SetOutputName4("II型態");
if PatternII then
    OutputField4(1)
else
    OutputField4(0);

SetOutputName5("IOI型態");
if PatternIOI then
    OutputField5(1)
else
    OutputField5(0);

SetOutputName6("量比");
OutputField6(VolumeRatio);

SetOutputName7("收盤價");
OutputField7(Close);

// ===================================================================
// === 使用說明 ===
// ===================================================================
// 【選股條件】
// 1. 符合選定的 IO 型態（OO/II/IOI）
// 2. 型態強度達到設定的最小值
// 3. （可選）成交量達到設定的最小量比
//
// 【輸出欄位說明】
// - IO型態: 1=II, 2=OO, 3=IOI
// - 型態強度: 1=弱, 2=中, 3=強
// - OO型態: 1=是, 0=否
// - II型態: 1=是, 0=否
// - IOI型態: 1=是, 0=否
// - 量比: 當日成交量 / 20日平均成交量
// - 收盤價: 最新收盤價
//
// 【參數設定建議】
// 
// 1. 尋找突破機會（II型態）：
//    - DetectII = true, DetectOO = false, DetectIOI = false
//    - MinStrength = 2 (中等以上)
//    - UseVolumeFilter = true, MinVolumeRatio = 1.0
//
// 2. 尋找趨勢加速（OO型態）：
//    - DetectOO = true, DetectII = false, DetectIOI = false
//    - MinStrength = 2 (中等以上)
//    - UseVolumeFilter = true, MinVolumeRatio = 1.2
//
// 3. 尋找假突破（IOI型態）：
//    - DetectIOI = true, DetectOO = false, DetectII = false
//    - MinStrength = 1 (所有強度，IOI較少見)
//    - UseVolumeFilter = false
//
// 4. 尋找所有型態：
//    - DetectOO = true, DetectII = true, DetectIOI = true
//    - MinStrength = 2 (中等以上，減少雜訊)
//    - UseVolumeFilter = true, MinVolumeRatio = 1.0
//
// 【排序說明】
// - SortByStrength = true: 依型態強度排序（強→弱）
// - SortByStrength = false: 依型態類型排序（OO→IOI→II）
//
// 【使用技巧】
// 1. 先用選股找出符合型態的股票
// 2. 再用 IOPattern_Indicator.xs 在圖表上確認型態
// 3. 搭配其他技術指標確認進場時機
// 4. 設定 IOPattern_Alert.xs 監控選出的股票
//
// 【注意事項】
// - 選股結果是最新一根K棒的型態
// - 建議在收盤後或K棒確定後執行選股
// - 盤中選股可能因K棒未完成而變動
// - 選出的股票仍需人工判斷是否進場
// ===================================================================

