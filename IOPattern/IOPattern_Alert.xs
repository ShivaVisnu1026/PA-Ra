// ===================================================================
// 腳本名稱：IO Pattern Alert (IO型態警示)
// 腳本類型：警示（Alert）
// 功能描述：偵測 IO 型態並發出警示
//          - II (Inside-Inside): 連續內包K棒
//          - OO (Outside-Outside): 連續外包K棒
//          - IOI (Inside-Outside-Inside): 內外內組合
// 資料週期：適用所有時間週期（分鐘/日/週/月）
// 作者：Extracted from Price Action All In One
// 建立日期：2024-12-17
// 版本：1.0
// ===================================================================

{@type:sensor}

settotalbar(10);  // 只需要3根K棒歷史資料

// ===================================================================
// === 參數設定 ===
// ===================================================================
input: DetectOO(true, "警示OO型態(外包-外包)");
input: DetectII(true, "警示II型態(內包-內包)");
input: DetectIOI(true, "警示IOI型態(內-外-內)");

// 強度過濾
input: MinStrength(1, "最小型態強度(1=弱/2=中/3=強)");

// 警示控制
input: AlertOncePerBar(true, "每根K棒只警示一次");

// 成交量過濾（可選）
input: UseVolumeFilter(false, "使用成交量過濾");
input: MinVolumeRatio(1.0, "最小量比(相對20日均量)");

// ===================================================================
// === 變數宣告 ===
// ===================================================================
var: PatternOO(false),              // OO型態偵測結果
     PatternII(false),              // II型態偵測結果
     PatternIOI(false),             // IOI型態偵測結果
     
     PatternType(0),                // 型態類型編碼
     PatternName(""),               // 型態名稱
     PatternStrength(0),            // 型態強度
     
     // K棒關係判斷
     IsOutside(false),
     IsInside(false),
     PrevIsOutside(false),
     PrevIsInside(false),
     
     // 警示控制
     intrabarpersist AlertTriggered(false),  // 避免重複警示
     LastBarDate(0),                // 上一根K棒的日期
     LastBarTime(0),                // 上一根K棒的時間
     
     // 成交量相關
     VolumeAvg(0),
     VolumeRatio(0),
     VolumeCondition(true),
     
     // 型態強度計算用（共用變數，避免重複宣告）
     CurrentRange(0),
     PrevRange(0),
     RangeRatio(0),
     
     // 訊息內容
     AlertMessage("");

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
end;

// ===================================================================
// === IO 型態偵測 ===
// ===================================================================
// 重置所有型態標記
PatternOO = false;
PatternII = false;
PatternIOI = false;
PatternType = 0;
PatternName = "";
PatternStrength = 0;

// OO Pattern - Outside-Outside (連續外包)
if DetectOO then begin
    if IsOutside and PrevIsOutside then begin
        PatternOO = true;
        PatternType = 2;
        PatternName = "OO(外包-外包)";
        
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
        PatternName = "II(內包-內包)";
        
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
        PatternName = "IOI(內-外-內)";
        PatternStrength = 2;  // IOI一律視為中等強度
    end;
end;

// ===================================================================
// === 觸發警示 ===
// ===================================================================
// 檢查是否符合警示條件
if PatternType > 0 and PatternStrength >= MinStrength and VolumeCondition then begin
    // 檢查是否已經警示過（如果啟用每根K棒只警示一次）
    if not AlertOncePerBar or (AlertOncePerBar and not AlertTriggered) then begin
        
        // 建立警示訊息
        var: StrengthText(""), VolumeText(""), TimeText("");
        
        // 強度文字
        if PatternStrength = 3 then
            StrengthText = "強"
        else if PatternStrength = 2 then
            StrengthText = "中"
        else
            StrengthText = "弱";
        
        // 成交量文字
        if UseVolumeFilter then begin
            VolumeText = Text(", 量比:", NumToStr(VolumeRatio, 2));
        end
        else begin
            VolumeText = "";
        end;
        
        // 時間文字
        TimeText = Text(leftstr(NumToStr(CurrentTime, 0), 4));
        
        // 組合警示訊息
        AlertMessage = Text(
            "【IO型態警示】偵測到 ", PatternName,
            " (強度:", StrengthText, ")",
            VolumeText,
            " 時間:", TimeText,
            " 價:", NumToStr(Close, 2)
        );
        
        // 發送警示
        ret = 1;
        RetMsg = AlertMessage;
        
        // 標記已警示
        AlertTriggered = true;
    end;
end
else begin
    ret = 0;
end;

// ===================================================================
// === 重置警示標記 ===
// ===================================================================
// 當K棒收盤後重置（準備下一根K棒）
// 使用 Date 變化來偵測新K棒（變數已在上方宣告）
if Date <> LastBarDate or CurrentTime <> LastBarTime then begin
    AlertTriggered = false;
    LastBarDate = Date;
    LastBarTime = CurrentTime;
end;

// ===================================================================
// === 使用說明 ===
// ===================================================================
// 【警示條件】
// 1. 偵測到選定的 IO 型態（OO/II/IOI）
// 2. 型態強度達到設定的最小值
// 3. （可選）成交量達到設定的最小量比
//
// 【型態說明】
// - OO: 連續外包，波動擴大
//   → 可能是趨勢加速或即將反轉
//   → 建議觀察突破方向
//
// - II: 連續內包，盤整收斂
//   → 通常預示即將突破
//   → 建議等待突破確認
//
// - IOI: 內外內組合
//   → 可能是假突破或洗盤
//   → 建議謹慎對待
//
// 【參數設定建議】
// - 分鐘線：MinStrength=2（中等強度），避免過多雜訊
// - 日線：MinStrength=1（所有強度），訊號較少較重要
// - 使用成交量過濾：MinVolumeRatio=1.2（量增20%）
//
// 【搭配使用】
// 1. 配合趨勢指標確認方向
// 2. 在關鍵支撐/壓力位置特別注意
// 3. 搭配 IOPattern_Indicator.xs 視覺化型態
// 4. 可設定多個時間週期同時監控
//
// 【警示訊息格式】
// 【IO型態警示】偵測到 型態名稱 (強度:X) 量比:X.XX 時間:HHMM 價:XX.XX
// 註：XQ 會自動顯示觸發警示的股票代碼
//
// 範例：
// 【IO型態警示】偵測到 II(內包-內包) (強度:強) 量比:1.45 時間:1330 價:585.00
// ===================================================================

