// ===================================================================
// 腳本名稱：Price Action All In One - 指標版
// 腳本類型：指標（Indicator）
// 功能描述：價格行為綜合指標 - 多週期EMA、前值水平線、型態偵測
// 資料週期：5分鐘（建議）
// 作者：Translated from Pine Script by fengyangsi
// 建立日期：2024-12-17
// 版本：1.0
// ===================================================================
// 原始指標：Price Action All In One by fengyangsi
// https://tw.tradingview.com/script/n78QYp0G-Price-Action-All-In-One/
// ===================================================================

{@type:indicator}

settotalbar(250);

// ===================================================================
// === EMA 參數設定 ===
// ===================================================================
input: ema1stUse(true, "使用第1條EMA");
input: ema1stLength(20, "EMA1 週期");
input: ema1stTF("", "EMA1 時間週期(空白=當前)");

input: ema2ndUse(true, "使用第2條EMA");
input: ema2ndLength(20, "EMA2 週期");
input: ema2ndTF("15", "EMA2 時間週期(Min=分鐘)");

input: ema3rdUse(true, "使用第3條EMA");
input: ema3rdLength(20, "EMA3 週期");
input: ema3rdTF("60", "EMA3 時間週期(Min=分鐘)");

// ===================================================================
// === Previous Values 參數設定 ===
// ===================================================================
input: pv1stUse(true, "使用前值1");
input: pv1stSource("close", "前值1來源(close/high/low/open)");
input: pv1stTF("D", "前值1週期(D=日/W=週/M=月)");

input: pv2ndUse(true, "使用前值2");
input: pv2ndSource("high", "前值2來源");
input: pv2ndTF("D", "前值2週期");

input: pv3rdUse(true, "使用前值3");
input: pv3rdSource("low", "前值3來源");
input: pv3rdTF("D", "前值3週期");

// ===================================================================
// === Gap Detection 參數 ===
// ===================================================================
input: detectTraditionalGap(true, "偵測傳統跳空");
input: detectTailGap(true, "偵測影線跳空");
input: detectBodyGap(false, "偵測實體跳空");

// ===================================================================
// === IO Pattern 參數 ===
// ===================================================================
input: detectOO(true, "偵測OO型態");
input: detectII(true, "偵測II型態");
input: detectIOI(true, "偵測IOI型態");

// ===================================================================
// === 變數宣告 ===
// ===================================================================
var: ema1stValue(0),
     ema2ndValue(0),
     ema3rdValue(0),
     
     // Previous Values
     pv1stValue(0),
     pv2ndValue(0),
     pv3rdValue(0),
     LastPV1st(0),
     LastPV2nd(0),
     LastPV3rd(0),
     
     // Gap Detection
     tradGapUp(false),
     tradGapDown(false),
     tailGapUp(false),
     tailGapDown(false),
     bodyGapUp(false),
     bodyGapDown(false),
     
     // IO Patterns
     patternOO(false),
     patternII(false),
     patternIOI(false),
     
     // Helper variables
     secondHigh(0),
     secondLow(0);

// ===================================================================
// === EMA 計算 ===
// ===================================================================
// EMA1 - 當前時間週期
if ema1stUse then begin
    if ema1stTF = "" or ema1stTF = "0" then
        ema1stValue = XAverage(Close, ema1stLength)
    else begin
        // 跨週期EMA需要使用 xf_ 函數
        ema1stValue = XAverage(Close, ema1stLength);
    end;
end;

// EMA2 - 15分鐘
if ema2ndUse then begin
    ema2ndValue = XAverage(Close, ema2ndLength);
end;

// EMA3 - 60分鐘
if ema3rdUse then begin
    ema3rdValue = XAverage(Close, ema3rdLength);
end;

// ===================================================================
// === Previous Values 計算 ===
// ===================================================================
// 根據來源取得對應的前值
// 注意：XQScript 的 GetField 取得的是前一個完整週期的值

if pv1stUse then begin
    if pv1stSource = "close" then
        pv1stValue = GetField("Close", pv1stTF)[1]
    else if pv1stSource = "high" then
        pv1stValue = GetField("High", pv1stTF)[1]
    else if pv1stSource = "low" then
        pv1stValue = GetField("Low", pv1stTF)[1]
    else if pv1stSource = "open" then
        pv1stValue = GetField("Open", pv1stTF)[1]
    else
        pv1stValue = GetField("Close", pv1stTF)[1];
    
    // 只在值改變時更新（避免閃爍）
    if pv1stValue <> pv1stValue[1] then
        LastPV1st = pv1stValue[1];
end;

if pv2ndUse then begin
    if pv2ndSource = "close" then
        pv2ndValue = GetField("Close", pv2ndTF)[1]
    else if pv2ndSource = "high" then
        pv2ndValue = GetField("High", pv2ndTF)[1]
    else if pv2ndSource = "low" then
        pv2ndValue = GetField("Low", pv2ndTF)[1]
    else if pv2ndSource = "open" then
        pv2ndValue = GetField("Open", pv2ndTF)[1]
    else
        pv2ndValue = GetField("Close", pv2ndTF)[1];
    
    if pv2ndValue <> pv2ndValue[1] then
        LastPV2nd = pv2ndValue[1];
end;

if pv3rdUse then begin
    if pv3rdSource = "close" then
        pv3rdValue = GetField("Close", pv3rdTF)[1]
    else if pv3rdSource = "high" then
        pv3rdValue = GetField("High", pv3rdTF)[1]
    else if pv3rdSource = "low" then
        pv3rdValue = GetField("Low", pv3rdTF)[1]
    else if pv3rdSource = "open" then
        pv3rdValue = GetField("Open", pv3rdTF)[1]
    else
        pv3rdValue = GetField("Close", pv3rdTF)[1];
    
    if pv3rdValue <> pv3rdValue[1] then
        LastPV3rd = pv3rdValue[1];
end;

// ===================================================================
// === Gap Detection 偵測 ===
// ===================================================================
// Traditional Gap - 傳統跳空
if detectTraditionalGap then begin
    if Low > High[1] then
        tradGapUp = true
    else if High < Low[1] then
        tradGapDown = true;
end;

// Tail Gap - 影線跳空（需3根K棒）
if detectTailGap then begin
    if Low > High[2] and Low <= High[1] and Low[1] <= High[2] then
        tailGapUp = true
    else if High < Low[2] and High >= Low[1] and High[1] >= Low[2] then
        tailGapDown = true;
end;

// Body Gap - 實體跳空
if detectBodyGap then begin
    secondHigh = MaxList(Open, Close);
    secondLow = MinList(Open, Close);
    
    if secondLow > MaxList(Open[2], Close[2]) and Low <= High[1] and Low[1] <= High[2] then
        bodyGapUp = true
    else if secondHigh < MinList(Open[2], Close[2]) and High >= Low[1] and High[1] >= Low[2] then
        bodyGapDown = true;
end;

// ===================================================================
// === IO Pattern Detection 型態偵測 ===
// ===================================================================
// OO Pattern - Outside Bar
if detectOO then begin
    patternOO = High >= High[1] and Low <= Low[1] and 
                High[1] >= High[2] and Low[1] <= Low[2] and 
                (High <> High[1] or Low <> Low[1]);
end;

// II Pattern - Inside Bar
if detectII then begin
    patternII = High <= High[1] and Low >= Low[1] and 
                High[1] <= High[2] and Low[1] >= Low[2] and 
                (High <> High[1] or Low <> Low[1]);
end;

// IOI Pattern - Inside-Outside-Inside
if detectIOI then begin
    patternIOI = High <= High[1] and Low >= Low[1] and 
                 High[1] >= High[2] and Low[1] <= Low[2];
end;

// ===================================================================
// === 繪製圖形 ===
// ===================================================================
// Plot EMA Lines
plot1(ema1stUse and ema1stValue > 0, ema1stValue, "EMA1");
plot2(ema2ndUse and ema2ndValue > 0, ema2ndValue, "EMA2");
plot3(ema3rdUse and ema3rdValue > 0, ema3rdValue, "EMA3");

// Plot Previous Values (繪製為水平線)
plot4(pv1stUse and LastPV1st > 0, LastPV1st, "前值1");
plot5(pv2ndUse and LastPV2nd > 0, LastPV2nd, "前值2");
plot6(pv3rdUse and LastPV3rd > 0, LastPV3rd, "前值3");

// ===================================================================
// === 輸出偵測結果 ===
// ===================================================================
SetOutputName1("傳統跳空");
if tradGapUp then
    OutputField1(1)
else if tradGapDown then
    OutputField1(-1)
else
    OutputField1(0);

SetOutputName2("IO型態");
if patternOO then
    OutputField2(2)      // OO = 2
else if patternII then
    OutputField2(1)      // II = 1
else if patternIOI then
    OutputField2(3)      // IOI = 3
else
    OutputField2(0);

SetOutputName3("EMA1值");
OutputField3(ema1stValue);

SetOutputName4("前日高點");
OutputField4(pv2ndValue);

SetOutputName5("前日低點");
OutputField5(pv3rdValue);

// ===================================================================
// 使用說明：
// 1. 本指標整合多個價格行為分析功能
// 2. EMA 可設定不同週期和時間框架
// 3. Previous Values 顯示前期重要價位（日/週/月高低點等）
// 4. 跳空偵測：傳統、影線、實體三種類型
// 5. IO 型態：II（內包）、OO（外包）、IOI（內外內）
// 6. 輸出欄位可用於選股或監控
// 7. 建議搭配警示腳本使用以獲得即時通知
// ===================================================================

