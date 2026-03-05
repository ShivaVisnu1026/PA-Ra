// ============================================================
// Intraday Reversal Bar Multi-Timeframe Alert
// ============================================================
// 描述：
//   在5分鐘、15分鐘、60分鐘時間框架中偵測反轉棒（Reversal Bar）
//   當任一時間框架出現反轉棒時發出警示
//
// 條件：
//   1. 偵測5分鐘、15分鐘、60分鐘的反轉棒（看漲和看跌）
//   2. 影線必須 > 50% 的實體大小
//   3. 實體不能是十字星（Doji）
//   4. 當前K棒成交量 > 前一根K棒成交量
//
// 策略邏輯：
//   - 使用多時間框架分析，捕捉不同週期的反轉訊號
//   - 適合日內交易者監控多個時間框架的反轉機會
// ============================================================

{@type:sensor}

// ===== 參數設定 =====
settotalbar(250);

// --- 時間框架選擇 ---
input: check_5min(true, "監控5分鐘"),
       check_15min(true, "監控15分鐘"),
       check_60min(true, "監控60分鐘");

// --- Reversal Bar 型態參數 ---
input: tail_to_body_ratio(0.50, "影線與實體最小比例（>50%）"),
       min_body_pct(0.01, "最小實體佔比（避免Doji，建議0.01=1%）");

// ===== 變數宣告 =====

// --- 時間框架資料變數 ---
var: 
    // 5分鐘資料
    h5(0), l5(0), o5(0), c5(0), v5(0), v5_prev(0),
    // 15分鐘資料
    h15(0), l15(0), o15(0), c15(0), v15(0), v15_prev(0),
    // 60分鐘資料
    h60(0), l60(0), o60(0), c60(0), v60(0), v60_prev(0);

// --- Reversal Bar 偵測結果 ---
var: 
    bullish_5min(false), bearish_5min(false),
    bullish_15min(false), bearish_15min(false),
    bullish_60min(false), bearish_60min(false);

// --- 訊息變數 ---
var: alert_msg("");

// --- 計算用變數（共用） ---
var: candleRange(0), bodySize(0), upperShadow(0), lowerShadow(0);
var: bodyPct(0), tailToBodyRatio(0);

// ============================================================
// 主邏輯：取得各時間框架資料並偵測反轉棒
// ============================================================

// --- 取得5分鐘資料 ---
if check_5min then
begin
    h5 = GetField("High", "5");
    l5 = GetField("Low", "5");
    o5 = GetField("Open", "5");
    c5 = GetField("Close", "5");
    v5 = GetField("Volume", "5");
    v5_prev = GetField("Volume", "5")[1];
    
    // 偵測5分鐘反轉棒
    if h5 > 0 and l5 > 0 then
    begin
        candleRange = h5 - l5;
        if candleRange > 0 then
        begin
            bodySize = absvalue(c5 - o5);
            upperShadow = h5 - maxlist(o5, c5);
            lowerShadow = minlist(o5, c5) - l5;
            
            // 計算實體佔總範圍的比例（用於檢查Doji）
            bodyPct = bodySize / candleRange;
            
            // 檢查看漲反轉棒（長下影線）
            if bodySize > 0 and v5_prev > 0 then
            begin
                tailToBodyRatio = lowerShadow / bodySize;
                
                bullish_5min = 
                    (tailToBodyRatio > tail_to_body_ratio)  // 下影線 > 50% 實體
                    and (bodyPct >= min_body_pct)           // 實體不能是Doji
                    and (v5 > v5_prev);                      // 成交量 > 前一根
            end
            else
                bullish_5min = false;
            
            // 檢查看跌反轉棒（長上影線）
            if bodySize > 0 and v5_prev > 0 then
            begin
                tailToBodyRatio = upperShadow / bodySize;
                
                bearish_5min = 
                    (tailToBodyRatio > tail_to_body_ratio)  // 上影線 > 50% 實體
                    and (bodyPct >= min_body_pct)           // 實體不能是Doji
                    and (v5 > v5_prev);                      // 成交量 > 前一根
            end
            else
                bearish_5min = false;
        end;
    end;
end;

// --- 取得15分鐘資料 ---
if check_15min then
begin
    h15 = GetField("High", "15");
    l15 = GetField("Low", "15");
    o15 = GetField("Open", "15");
    c15 = GetField("Close", "15");
    v15 = GetField("Volume", "15");
    v15_prev = GetField("Volume", "15")[1];
    
    // 偵測15分鐘反轉棒
    if h15 > 0 and l15 > 0 then
    begin
        candleRange = h15 - l15;
        if candleRange > 0 then
        begin
            bodySize = absvalue(c15 - o15);
            upperShadow = h15 - maxlist(o15, c15);
            lowerShadow = minlist(o15, c15) - l15;
            
            // 計算實體佔總範圍的比例（用於檢查Doji）
            bodyPct = bodySize / candleRange;
            
            // 檢查看漲反轉棒（長下影線）
            if bodySize > 0 and v15_prev > 0 then
            begin
                tailToBodyRatio = lowerShadow / bodySize;
                
                bullish_15min = 
                    (tailToBodyRatio > tail_to_body_ratio)  // 下影線 > 50% 實體
                    and (bodyPct >= min_body_pct)           // 實體不能是Doji
                    and (v15 > v15_prev);                    // 成交量 > 前一根
            end
            else
                bullish_15min = false;
            
            // 檢查看跌反轉棒（長上影線）
            if bodySize > 0 and v15_prev > 0 then
            begin
                tailToBodyRatio = upperShadow / bodySize;
                
                bearish_15min = 
                    (tailToBodyRatio > tail_to_body_ratio)  // 上影線 > 50% 實體
                    and (bodyPct >= min_body_pct)           // 實體不能是Doji
                    and (v15 > v15_prev);                    // 成交量 > 前一根
            end
            else
                bearish_15min = false;
        end;
    end;
end;

// --- 取得60分鐘資料 ---
if check_60min then
begin
    h60 = GetField("High", "60");
    l60 = GetField("Low", "60");
    o60 = GetField("Open", "60");
    c60 = GetField("Close", "60");
    v60 = GetField("Volume", "60");
    v60_prev = GetField("Volume", "60")[1];
    
    // 偵測60分鐘反轉棒
    if h60 > 0 and l60 > 0 then
    begin
        candleRange = h60 - l60;
        if candleRange > 0 then
        begin
            bodySize = absvalue(c60 - o60);
            upperShadow = h60 - maxlist(o60, c60);
            lowerShadow = minlist(o60, c60) - l60;
            
            // 計算實體佔總範圍的比例（用於檢查Doji）
            bodyPct = bodySize / candleRange;
            
            // 檢查看漲反轉棒（長下影線）
            if bodySize > 0 and v60_prev > 0 then
            begin
                tailToBodyRatio = lowerShadow / bodySize;
                
                bullish_60min = 
                    (tailToBodyRatio > tail_to_body_ratio)  // 下影線 > 50% 實體
                    and (bodyPct >= min_body_pct)           // 實體不能是Doji
                    and (v60 > v60_prev);                    // 成交量 > 前一根
            end
            else
                bullish_60min = false;
            
            // 檢查看跌反轉棒（長上影線）
            if bodySize > 0 and v60_prev > 0 then
            begin
                tailToBodyRatio = upperShadow / bodySize;
                
                bearish_60min = 
                    (tailToBodyRatio > tail_to_body_ratio)  // 上影線 > 50% 實體
                    and (bodyPct >= min_body_pct)           // 實體不能是Doji
                    and (v60 > v60_prev);                    // 成交量 > 前一根
            end
            else
                bearish_60min = false;
        end;
    end;
end;

// ============================================================
// 綜合條件判斷與警示訊息
// ============================================================

alert_msg = "";

// 檢查5分鐘
if bullish_5min then
    alert_msg = alert_msg + "5分看漲反轉 | ";
if bearish_5min then
    alert_msg = alert_msg + "5分看跌反轉 | ";

// 檢查15分鐘
if bullish_15min then
    alert_msg = alert_msg + "15分看漲反轉 | ";
if bearish_15min then
    alert_msg = alert_msg + "15分看跌反轉 | ";

// 檢查60分鐘
if bullish_60min then
    alert_msg = alert_msg + "60分看漲反轉 | ";
if bearish_60min then
    alert_msg = alert_msg + "60分看跌反轉 | ";

// 如果有任何反轉棒，發出警示
if bullish_5min or bearish_5min or 
   bullish_15min or bearish_15min or 
   bullish_60min or bearish_60min then
begin
    if alert_msg <> "" then
        RetMsg = alert_msg;
    ret = 1;
end
else
    ret = 0;

