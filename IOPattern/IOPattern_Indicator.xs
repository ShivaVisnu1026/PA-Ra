// ===================================================================
// 腳本名稱：IO Pattern Indicator (IO型態指標)
// 腳本類型：指標（Indicator）
// 功能描述：偵測並顯示 IO 型態 (Inside/Outside Bar 組合)
//          - II (Inside-Inside): 連續內包K棒
//          - OO (Outside-Outside): 連續外包K棒
//          - IOI (Inside-Outside-Inside): 內外內組合
// 資料週期：適用所有時間週期（分鐘/日/週/月）
// 作者：Extracted from Price Action All In One
// 建立日期：2024-12-17
// 版本：1.0
// ===================================================================

{@type:indicator}

settotalbar(10);  // 只需要3根K棒歷史資料

// ===================================================================
// === 參數設定 ===
// ===================================================================
input: DetectOO(true, "偵測OO型態(外包-外包)");
input: DetectII(true, "偵測II型態(內包-內包)");
input: DetectIOI(true, "偵測IOI型態(內-外-內)");

// 顯示選項
input: ShowLabels(true, "顯示型態標籤");
input: ShowArrows(true, "顯示箭頭標記");

// ===================================================================
// === 變數宣告 ===
// ===================================================================
var: PatternOO(false),      // OO型態偵測結果
     PatternII(false),      // II型態偵測結果
     PatternIOI(false),     // IOI型態偵測結果
     
     PatternType(0),        // 型態類型編碼: 0=無, 1=II, 2=OO, 3=IOI
     PatternName(""),       // 型態名稱
     
     // 型態強度指標
     PatternStrength(0),    // 1=弱, 2=中, 3=強
     
     // K棒關係判斷
     IsOutside(false),      // 當前是否為外包
     IsInside(false),       // 當前是否為內包
     PrevIsOutside(false),  // 前一根是否為外包
     PrevIsInside(false);   // 前一根是否為內包

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
// === IO 型態偵測 ===
// ===================================================================
// 重置所有型態標記
PatternOO = false;
PatternII = false;
PatternIOI = false;
PatternType = 0;
PatternName = "";

// OO Pattern - Outside-Outside (連續外包)
// 意義：波動擴大，可能是趨勢加速或即將反轉
if DetectOO then begin
    if IsOutside and PrevIsOutside then begin
        PatternOO = true;
        PatternType = 2;
        PatternName = "OO";
    end;
end;

// II Pattern - Inside-Inside (連續內包)
// 意義：盤整收斂，通常預示即將突破
if DetectII and PatternType = 0 then begin
    if IsInside and PrevIsInside then begin
        PatternII = true;
        PatternType = 1;
        PatternName = "II";
    end;
end;

// IOI Pattern - Inside-Outside-Inside
// 意義：突破後回縮，可能是假突破或洗盤
if DetectIOI and PatternType = 0 then begin
    if IsInside and PrevIsOutside then begin
        PatternIOI = true;
        PatternType = 3;
        PatternName = "IOI";
    end;
end;

// ===================================================================
// === 計算型態強度 ===
// ===================================================================
if PatternType > 0 then begin
    // 計算K棒範圍相對於前一根的比例
    var: CurrentRange(0), PrevRange(0), RangeRatio(0);
    
    CurrentRange = High - Low;
    PrevRange = High[1] - Low[1];
    
    if PrevRange > 0 then
        RangeRatio = CurrentRange / PrevRange
    else
        RangeRatio = 1;
    
    // 強度判斷
    if PatternOO then begin
        // OO型態：範圍擴大越多，強度越高
        if RangeRatio >= 1.5 then
            PatternStrength = 3      // 強
        else if RangeRatio >= 1.2 then
            PatternStrength = 2      // 中
        else
            PatternStrength = 1;     // 弱
    end
    else if PatternII then begin
        // II型態：範圍收斂越多，強度越高
        if RangeRatio <= 0.5 then
            PatternStrength = 3      // 強
        else if RangeRatio <= 0.7 then
            PatternStrength = 2      // 中
        else
            PatternStrength = 1;     // 弱
    end
    else if PatternIOI then begin
        // IOI型態：一律視為中等強度
        PatternStrength = 2;
    end;
end
else begin
    PatternStrength = 0;
end;

// ===================================================================
// === 計算標記位置 ===
// ===================================================================
var: MarkerPosition(0);
MarkerPosition = High + (High - Low) * 0.5;

// ===================================================================
// === 繪製圖形 ===
// ===================================================================
// 方案：簡化版 - 只在型態出現時繪製標記
// Plot1: II型態標記（內包）
if PatternII then
    plot1(MarkerPosition)
else
    plot1(0);

// Plot2: OO型態標記（外包）
if PatternOO then
    plot2(MarkerPosition)
else
    plot2(0);

// Plot3: IOI型態標記（內外內）
if PatternIOI then
    plot3(MarkerPosition)
else
    plot3(0);

// Plot4: 型態強度數值線（參考用）
plot4(PatternStrength);

// Plot5: 型態類型數值線（參考用）
plot5(PatternType);

// ===================================================================
// === 繪圖說明 ===
// ===================================================================
// Plot1: 型態類型數值 - 0=無型態, 1=II, 2=OO, 3=IOI
// Plot2: 型態強度數值 - 0=無, 1=弱, 2=中, 3=強
// Plot3: II型態標記 - 出現時在K棒上方顯示點
// Plot4: OO型態標記 - 出現時在K棒上方顯示點
// Plot5: IOI型態標記 - 出現時在K棒上方顯示點
//
// ===================================================================
// === 使用說明 ===
// ===================================================================
// 【型態意義】
// 1. OO (Outside-Outside) - 連續外包
//    - 特徵：每根K棒都包住前一根
//    - 意義：波動擴大，可能是趨勢加速或即將反轉
//    - 交易策略：觀察突破方向，順勢交易
//
// 2. II (Inside-Inside) - 連續內包
//    - 特徵：每根K棒都被前一根包住
//    - 意義：盤整收斂，通常預示即將突破
//    - 交易策略：等待突破確認後進場，設定窄止損
//
// 3. IOI (Inside-Outside-Inside)
//    - 特徵：內包→外包→內包的組合
//    - 意義：突破後回縮，可能是假突破或洗盤
//    - 交易策略：謹慎對待，等待更多確認
//
// 【強度判斷】
// - 強(3): OO範圍擴大>50% / II收斂>50%
// - 中(2): OO範圍擴大20-50% / II收斂30-50% / IOI
// - 弱(1): 其他情況
//
// 【適用時間週期】
// - 分鐘線：適合日內交易，反應快速
// - 日線：適合波段交易，訊號較可靠
// - 週/月線：適合長線投資，訊號稀少但重要
//
// 【建議用法】
// 1. 搭配趨勢指標（如EMA）確認方向
// 2. 配合成交量確認型態有效性
// 3. 在關鍵支撐/壓力位置出現時特別注意
// 4. 使用 IOPattern_Alert.xs 警示腳本接收即時通知
// 5. 如需選股功能，請使用 IOPattern_Screener.xs
// ===================================================================

