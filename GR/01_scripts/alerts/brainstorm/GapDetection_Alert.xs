// ============================================================
// Gap Detection Alert
// ============================================================
// 描述：
//   偵測向上跳空（Gap Up）和向下跳空（Gap Down）
//   在指定回看範圍內統計跳空次數，並追蹤最近兩次跳空的價格資訊
//   當當前K棒形成跳空且符合成交量條件時發出警示
//
// 觸發條件：
//   - 當前K棒形成向上跳空（Low > High[1]）或向下跳空（High < Low[1]）
//   - 過去N日平均成交量 > 成交量閾值
//
// 資料週期：適用於日線圖（Daily）
// ============================================================

{@type:sensor}

// ===== 參數設定 =====
settotalbar(200);

// --- 參數 ---
input: SearchBars(100, "Check range bars"),        // Lookback window for counting gaps
       vol_len(5, "Avg daily volume length"),       // e.g., 5 days
       vol_thresh(500, "Avg daily volume threshold"); // e.g., > 500

// ===== 變數宣告 =====

// Counters
var: up_gap_count(0),                          // # of up gaps within lookback
     down_gap_count(0),                        // # of down gaps within lookback
     i(0);                                     // loop index

// Most recent (last_*) and the previous (prev_*) UP gaps
var: last_up_low(0),                           // newer bar's Low of most recent up gap      -> low[i-1]
     last_up_high_prev(0),                     // older bar's High of most recent up gap     -> high[i]
     prev_up_low(0),                           // newer bar's Low of previous up gap         -> low[i-1]
     prev_up_high_prev(0);                     // older bar's High of previous up gap        -> high[i]

// Most recent (last_*) and the previous (prev_*) DOWN gaps
var: last_down_high(0),                        // newer bar's High of most recent down gap   -> high[i-1]
     last_down_low_prev(0),                    // older bar's Low of most recent down gap    -> low[i]
     prev_down_high(0),                        // newer bar's High of previous down gap      -> high[i-1]
     prev_down_low_prev(0);                    // older bar's Low of previous down gap       -> low[i]

// Trigger flags for CURRENT vs PREVIOUS bar boundary
var: gap_now_up(false),                        // true if current bar forms an up gap vs bar[1]
     gap_now_down(false),                      // true if current bar forms a down gap vs bar[1]
     avgDailyVolume(0);                        // Average daily volume

// ===== Scan & collect (nearest -> farthest) =====
if CurrentBar > SearchBars then
begin
    // reset
    up_gap_count       = 0;
    down_gap_count     = 0;
    last_up_low        = 0;  last_up_high_prev    = 0;
    prev_up_low        = 0;  prev_up_high_prev    = 0;
    last_down_high     = 0;  last_down_low_prev   = 0;
    prev_down_high     = 0;  prev_down_low_prev   = 0;

    // i = 1 means boundary between bar[0] (newer) and bar[1] (older)
    for i = 1 to SearchBars
    begin
        // --- Up gap (newer Low > older High): low[i-1] > high[i]
        if Low[i-1] > High[i] then
        begin
            up_gap_count = up_gap_count + 1;
            if up_gap_count = 1 then
            begin
                // most recent up gap (closest)
                last_up_low        = Low[i-1];
                last_up_high_prev  = High[i];
            end
            else if up_gap_count = 2 then
            begin
                // previous up gap (second closest)
                prev_up_low        = Low[i-1];
                prev_up_high_prev  = High[i];
            end;
        end
        // --- Down gap (newer High < older Low): high[i-1] < low[i]
        else if High[i-1] < Low[i] then
        begin
            down_gap_count = down_gap_count + 1;
            if down_gap_count = 1 then
            begin
                // most recent down gap (closest)
                last_down_high     = High[i-1];
                last_down_low_prev = Low[i];
            end
            else if down_gap_count = 2 then
            begin
                // previous down gap (second closest)
                prev_down_high     = High[i-1];
                prev_down_low_prev = Low[i];
            end;
        end;
    end;

    // ===== Current bar alert boundary =====
    gap_now_up   = Low > High[1];
    gap_now_down = High < Low[1];

    // ===== Volume condition (Daily) =====
    // Use GetField("Volume","D") directly to avoid cross-frequency state
    // Condition: Average of daily volume over 'vol_len' > 'vol_thresh'
    avgDailyVolume = Average(GetField("Volume", "D"), vol_len);

    // ===== Alert Conditions =====
    if gap_now_up and (avgDailyVolume > vol_thresh) then
    begin
        ret = 1;
        RetMsg = Text(
            "Gap Up detected: ",
            "count=",         NumToStr(up_gap_count, 0),
            ", last low=",    NumToStr(last_up_low,        2),
            ", last prev high=", NumToStr(last_up_high_prev, 2),
            ", prev low=",    NumToStr(prev_up_low,        2),
            ", prev prev high=", NumToStr(prev_up_high_prev, 2),
            " | AvgVolD(",    NumToStr(vol_len, 0), ")>",
            NumToStr(vol_thresh, 0)
        );
    end
    else if gap_now_down and (avgDailyVolume > vol_thresh) then
    begin
        ret = 1;
        RetMsg = Text(
            "Gap Down detected: ",
            "count=",          NumToStr(down_gap_count, 0),
            ", last high=",    NumToStr(last_down_high,      2),
            ", last prev low=",NumToStr(last_down_low_prev,  2),
            ", prev high=",    NumToStr(prev_down_high,      2),
            ", prev prev low=",NumToStr(prev_down_low_prev,  2),
            " | AvgVolD(",     NumToStr(vol_len, 0), ")>",
            NumToStr(vol_thresh, 0)
        );
    end
    else
        ret = 0;
end
else
    ret = 0;

