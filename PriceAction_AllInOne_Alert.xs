// ===================================================================
// 腳本名稱：Price Action All In One - 警示版
// 腳本類型：警示（Alert）
// 功能描述：價格行為綜合警示 - 跳空、IO型態、H/L計數
// 資料週期：5分鐘（建議）或任意週期
// 作者：Translated from Pine Script by fengyangsi
// 建立日期：2024-12-17
// 版本：1.0
// ===================================================================
// 原始指標：Price Action All In One by fengyangsi
// https://tw.tradingview.com/script/n78QYp0G-Price-Action-All-In-One/
// ===================================================================

{@type:sensor}

settotalbar(100);

// ===================================================================
// === 參數設定 ===
// ===================================================================
// Gap Detection
input: alertTraditionalGap(true, "警示傳統跳空");
input: alertTailGap(true, "警示影線跳空");
input: alertBodyGap(false, "警示實體跳空");

// IO Pattern Detection  
input: alertOO(true, "警示OO型態");
input: alertII(true, "警示II型態");
input: alertIOI(true, "警示IOI型態");

// H/L Count
input: alertHL(false, "警示H/L計數");
input: hlInterval(1.0, "H/L區間係數");

// ===================================================================
// === 變數宣告 ===
// ===================================================================
var: 
    // Gap flags
    tradGapUp(false),
    tradGapDown(false),
    tailGapUp(false),
    tailGapDown(false),
    bodyGapUp(false),
    bodyGapDown(false),
    
    // IO Pattern flags
    patternOO(false),
    patternII(false),
    patternIOI(false),
    
    // H/L Count
    intrabarpersist HCount(0),
    intrabarpersist LCount(0),
    intrabarpersist HLastL(0),
    intrabarpersist LLastH(0),
    intrabarpersist BullPB(false),
    intrabarpersist BearPB(false),
    intrabarpersist BullPBL(0),
    intrabarpersist BearPBH(0),
    
    // Helper
    secondHigh(0),
    secondLow(0),
    alertMsg(0);

// ===================================================================
// === Gap Detection 跳空偵測 ===
// ===================================================================
// Traditional Gap - 傳統跳空
if alertTraditionalGap then begin
    if Low > High[1] then begin
        tradGapUp = true;
        RetMsg = Text("傳統跳空向上 @", NumToStr(Low, 2));
        ret = 1;
    end
    else if High < Low[1] then begin
        tradGapDown = true;
        RetMsg = Text("傳統跳空向下 @", NumToStr(High, 2));
        ret = 1;
    end;
end;

// Tail Gap - 影線跳空（需3根K棒）
if alertTailGap and ret = 0 then begin
    if Low > High[2] and Low <= High[1] and Low[1] <= High[2] then begin
        tailGapUp = true;
        RetMsg = Text("影線跳空向上 @", NumToStr(Low, 2));
        ret = 1;
    end
    else if High < Low[2] and High >= Low[1] and High[1] >= Low[2] then begin
        tailGapDown = true;
        RetMsg = Text("影線跳空向下 @", NumToStr(High, 2));
        ret = 1;
    end;
end;

// Body Gap - 實體跳空
if alertBodyGap and ret = 0 then begin
    secondHigh = MaxList(Open, Close);
    secondLow = MinList(Open, Close);
    
    if secondLow > MaxList(Open[2], Close[2]) and 
       Low <= High[1] and Low[1] <= High[2] then begin
        bodyGapUp = true;
        RetMsg = Text("實體跳空向上 @", NumToStr(secondLow, 2));
        ret = 1;
    end
    else if secondHigh < MinList(Open[2], Close[2]) and 
            High >= Low[1] and High[1] >= Low[2] then begin
        bodyGapDown = true;
        RetMsg = Text("實體跳空向下 @", NumToStr(secondHigh, 2));
        ret = 1;
    end;
end;

// ===================================================================
// === IO Pattern Detection 型態偵測 ===
// ===================================================================
// OO Pattern - Outside Bar（外包）
if alertOO and ret = 0 then begin
    patternOO = High >= High[1] and Low <= Low[1] and 
                High[1] >= High[2] and Low[1] <= Low[2] and 
                (High <> High[1] or Low <> Low[1]);
    
    if patternOO then begin
        RetMsg = "OO型態（連續外包）";
        ret = 1;
    end;
end;

// II Pattern - Inside Bar（內包）
if alertII and ret = 0 then begin
    patternII = High <= High[1] and Low >= Low[1] and 
                High[1] <= High[2] and Low[1] >= Low[2] and 
                (High <> High[1] or Low <> Low[1]);
    
    if patternII then begin
        RetMsg = "II型態（連續內包）";
        ret = 1;
    end;
end;

// IOI Pattern - Inside-Outside-Inside（內外內）
if alertIOI and ret = 0 then begin
    patternIOI = High <= High[1] and Low >= Low[1] and 
                 High[1] >= High[2] and Low[1] <= Low[2];
    
    if patternIOI then begin
        RetMsg = "IOI型態（內外內突破型態）";
        ret = 1;
    end;
end;

// ===================================================================
// === H/L Count 高低點計數 ===
// ===================================================================
// 計算平均K棒範圍作為區間
value1 = Average(High - Low, 100) * hlInterval;

// 多頭回檔追蹤
if Low < Low[1] then begin
    BullPB = true;
    if BullPBL > Low or BullPBL = 0 then
        BullPBL = Low;
end;

// 多頭新高確認
if High > High[1] and BullPB and alertHL and ret = 0 then begin
    HCount = HCount + 1;
    
    // 重置計數：如果回檔低點高於上次低點
    if BullPBL > HLastL or HLastL = 0 then
        HCount = 1;
    
    HLastL = BullPBL;
    BullPBL = 0;
    BullPB = false;
    
    RetMsg = Text("多頭新高 H", NumToStr(HCount, 0), " @", NumToStr(High, 2));
    ret = 1;
end;

// 空頭反彈追蹤
if High > High[1] then begin
    BearPB = true;
    if BearPBH < High or BearPBH = 0 then
        BearPBH = High;
end;

// 空頭新低確認
if Low < Low[1] and BearPB and alertHL and ret = 0 then begin
    LCount = LCount + 1;
    
    // 重置計數：如果反彈高點低於上次高點
    if BearPBH < LLastH or LLastH = 0 then
        LCount = 1;
    
    LLastH = BearPBH;
    BearPBH = 0;
    BearPB = false;
    
    RetMsg = Text("空頭新低 L", NumToStr(LCount, 0), " @", NumToStr(Low, 2));
    ret = 1;
end;

// ===================================================================
// === 輸出資訊 ===
// ===================================================================
// 輸出偵測結果供監控使用
SetOutputName1("跳空類型");
if tradGapUp then
    OutputField1(1)        // 傳統向上
else if tradGapDown then
    OutputField1(-1)       // 傳統向下
else if tailGapUp then
    OutputField1(2)        // 影線向上
else if tailGapDown then
    OutputField1(-2)       // 影線向下
else if bodyGapUp then
    OutputField1(3)        // 實體向上
else if bodyGapDown then
    OutputField1(-3)       // 實體向下
else
    OutputField1(0);

SetOutputName2("IO型態");
if patternOO then
    OutputField2(1)        // OO
else if patternII then
    OutputField2(2)        // II
else if patternIOI then
    OutputField2(3)        // IOI
else
    OutputField2(0);

SetOutputName3("H計數");
OutputField3(HCount);

SetOutputName4("L計數");
OutputField4(LCount);

// ===================================================================
// 使用說明：
// 1. 將此腳本加入警示清單，當偵測到型態時會發送通知
// 2. 跳空類型：
//    - 傳統跳空：K棒之間有明顯空隙
//    - 影線跳空：影線之間有跳空（更常見）
//    - 實體跳空：實體之間有跳空
// 3. IO 型態：
//    - II：連續內包（收斂型態）
//    - OO：連續外包（擴張型態）
//    - IOI：內外內（突破型態）
// 4. H/L 計數：
//    - H1, H2, H3... 追蹤多頭推進
//    - L1, L2, L3... 追蹤空頭推進
// 5. 建議搭配指標版本一起使用
// ===================================================================

