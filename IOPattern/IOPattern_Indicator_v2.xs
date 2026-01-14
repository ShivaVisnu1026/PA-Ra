// ===================================================================
// 腳本名稱：IO Pattern Indicator (IO型態指標) v2 - Simplified
// 腳本類型：指標（Indicator）
// 功能描述：偵測並顯示 IO 型態 - 簡化版，只顯示標記
//          - II (Inside-Inside): 連續內包K棒
//          - OO (Outside-Outside): 連續外包K棒
//          - IOI (Inside-Outside-Inside): 內外內組合
// 資料週期：適用所有時間週期（分鐘/日/週/月）
// 作者：Extracted from Price Action All In One
// 建立日期：2024-12-17
// 版本：2.0 - Simplified
// ===================================================================

{@type:indicator}

settotalbar(10);  // 只需要3根K棒歷史資料

// ===================================================================
// === 參數設定 ===
// ===================================================================
input: DetectOO(true, "偵測OO型態(外包-外包)");
input: DetectII(true, "偵測II型態(內包-內包)");
input: DetectIOI(true, "偵測IOI型態(內-外-內)");

input: MarkerHeight(0.5, "標記高度(K棒高度的倍數)");

// ===================================================================
// === 變數宣告 ===
// ===================================================================
var: PatternOO(false),      // OO型態偵測結果
     PatternII(false),      // II型態偵測結果
     PatternIOI(false),     // IOI型態偵測結果
     
     // K棒關係判斷
     IsOutside(false),      // 當前是否為外包
     IsInside(false),       // 當前是否為內包
     PrevIsOutside(false),  // 前一根是否為外包
     PrevIsInside(false),   // 前一根是否為內包
     
     // 標記位置
     MarkerPosition(0);

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

// OO Pattern - Outside-Outside (連續外包)
if DetectOO then begin
    if IsOutside and PrevIsOutside then begin
        PatternOO = true;
    end;
end;

// II Pattern - Inside-Inside (連續內包)
if DetectII then begin
    if IsInside and PrevIsInside then begin
        PatternII = true;
    end;
end;

// IOI Pattern - Inside-Outside-Inside
if DetectIOI then begin
    if IsInside and PrevIsOutside then begin
        PatternIOI = true;
    end;
end;

// ===================================================================
// === 計算標記位置 ===
// ===================================================================
MarkerPosition = High + (High - Low) * MarkerHeight;

// ===================================================================
// === 繪製圖形 - 方案1：簡單標記 ===
// ===================================================================
// 只在型態出現時繪製標記點
if PatternII then
    plot1(MarkerPosition)
else
    plot1(0);

if PatternOO then
    plot2(MarkerPosition)
else
    plot2(0);

if PatternIOI then
    plot3(MarkerPosition)
else
    plot3(0);

// ===================================================================
// === 使用說明 ===
// ===================================================================
// 【繪圖說明】
// Plot1 (藍色): II型態標記 - 連續內包
// Plot2 (紅色): OO型態標記 - 連續外包
// Plot3 (黃色): IOI型態標記 - 內外內組合
//
// 【型態意義】
// 1. OO (Outside-Outside) - 連續外包
//    - 波動擴大，可能是趨勢加速或即將反轉
//    - 觀察突破方向，順勢交易
//
// 2. II (Inside-Inside) - 連續內包
//    - 盤整收斂，通常預示即將突破
//    - 等待突破確認後進場，設定窄止損
//
// 3. IOI (Inside-Outside-Inside)
//    - 突破後回縮，可能是假突破或洗盤
//    - 謹慎對待，等待更多確認
//
// 【適用時間週期】
// - 分鐘線：適合日內交易
// - 日線：適合波段交易（最推薦）
// - 週/月線：適合長線投資
//
// 【建議用法】
// 1. 搭配趨勢指標（如EMA）確認方向
// 2. 配合成交量確認型態有效性
// 3. 在關鍵支撐/壓力位置出現時特別注意
// 4. 使用 IOPattern_Alert.xs 接收即時通知
// 5. 使用 IOPattern_Screener.xs 進行選股
// ===================================================================

