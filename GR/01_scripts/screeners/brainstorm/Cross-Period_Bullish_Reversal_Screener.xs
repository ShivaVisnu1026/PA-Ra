// ============================================================
// Cross-Period Bullish Reversal Screener
// ============================================================
// 描述：
//   基於 Nail Fuller 的 price action 定義，偵測最新 1、2、3 期 K 棒
//   合併後是否呈現 bullish reversal bar。符合任一條件即觸發。
//
// 條件：
//   1. 最新 1 期 K 棒是 bullish reversal（且必須是紅K：close > open）
//   2. 最新 2 期 K 棒合併起來是 Bullish reversal（且合併後必須是紅K）
//   3. 最新 3 期 K 棒合併起來是 Bullish reversal（且合併後必須是紅K）
//   4. 最新 3 期成交量的平均 > 門檻值（可調整參數）
//
// 輸出：
//   - 觸發類型：1=單根、2=2根合併、3=3根合併
//   - 上引線與實體比率：上引線／實體
//   - 下引線與實體比率：下引線／實體
// ============================================================

{@type:filter}

// ===== 參數設定 =====
settotalbar(250);

// --- Reversal Bar 型態參數 ---
input: tail_min_pct(0.45, "下影線最小佔比"),
       opp_tail_max_pct(0.25, "上影線最大佔比"),
       body_max_pct(0.45, "最大實體佔比"),
       body_pos_pct(0.45, "實體位置比例"),
       tail_prominence_bars(5, "影線突出比較期數");

// --- 成交量過濾參數 ---
input: volume_period(3, "成交量平均期數"),
       volume_threshold(1000, "成交量門檻");

// ===== 變數宣告 =====

// --- 單根 K 棒變數（最新1期）---
var: singleRange(0),
     singleBodySize(0),
     singleUpperShadow(0),
     singleLowerShadow(0),
     singleLowerShadowPct(0),
     singleUpperShadowPct(0),
     singleBodyPct(0),
     singleBodyPosition(0),
     singleLowestInRange(0),
     isSingleReversal(false),
     isSingleRedK(false);

// --- 合併 2 根 K 棒變數（最新2期）---
var: combo2Open(0),
     combo2Close(0),
     combo2High(0),
     combo2Low(0),
     combo2Range(0),
     combo2BodySize(0),
     combo2UpperShadow(0),
     combo2LowerShadow(0),
     combo2LowerShadowPct(0),
     combo2UpperShadowPct(0),
     combo2BodyPct(0),
     combo2BodyPosition(0),
     combo2LowestInRange(0),
     isCombo2Reversal(false),
     isCombo2RedK(false);

// --- 合併 3 根 K 棒變數（最新3期）---
var: combo3Open(0),
     combo3Close(0),
     combo3High(0),
     combo3Low(0),
     combo3Range(0),
     combo3BodySize(0),
     combo3UpperShadow(0),
     combo3LowerShadow(0),
     combo3LowerShadowPct(0),
     combo3UpperShadowPct(0),
     combo3BodyPct(0),
     combo3BodyPosition(0),
     combo3LowestInRange(0),
     isCombo3Reversal(false),
     isCombo3RedK(false);

// --- 成交量與觸發相關 ---
var: avgVolume(0),
     volumeOK(false),
     trigger(false),
     triggerType(0),
     finalUpperShadowRatio(0),
     finalLowerShadowRatio(0);

// ============================================================
// 條件 1：最新 1 期為 Bullish Reversal Bar（必須是紅K）
// ============================================================

singleRange      = high - low;
singleBodySize   = absvalue(close - open);
singleUpperShadow = high - maxlist(open, close);
singleLowerShadow = minlist(open, close) - low;
isSingleRedK     = (close > open);  // 必須是紅K

if singleRange > 0 then
begin
    singleLowerShadowPct = singleLowerShadow / singleRange;
    singleUpperShadowPct = singleUpperShadow / singleRange;
    singleBodyPct        = singleBodySize / singleRange;
    singleBodyPosition   = (minlist(open, close) - low) / singleRange;
    singleLowestInRange  = lowest(low, tail_prominence_bars);

    isSingleReversal =
        isSingleRedK  // 必須是紅K
        and (singleLowerShadowPct >= tail_min_pct)
        and (singleUpperShadowPct <= opp_tail_max_pct)
        and (singleBodyPct <= body_max_pct)
        and (singleBodyPosition >= 1 - body_pos_pct)
        and (low <= singleLowestInRange);
end
else
    isSingleReversal = false;

// ============================================================
// 條件 2：最新 2 期合併為 Bullish Reversal Bar（必須是紅K）
// ============================================================

combo2Open  = open[1];
combo2Close = close;
combo2High  = maxlist(high, high[1]);
combo2Low   = minlist(low, low[1]);
isCombo2RedK = (combo2Close > combo2Open);  // 合併後必須是紅K

combo2Range       = combo2High - combo2Low;
combo2BodySize    = absvalue(combo2Close - combo2Open);
combo2UpperShadow = combo2High - maxlist(combo2Open, combo2Close);
combo2LowerShadow = minlist(combo2Open, combo2Close) - combo2Low;

if combo2Range > 0 then
begin
    combo2LowerShadowPct = combo2LowerShadow / combo2Range;
    combo2UpperShadowPct = combo2UpperShadow / combo2Range;
    combo2BodyPct        = combo2BodySize / combo2Range;
    combo2BodyPosition   = (minlist(combo2Open, combo2Close) - combo2Low) / combo2Range;
    combo2LowestInRange  = lowest(low, tail_prominence_bars + 1);

    isCombo2Reversal =
        isCombo2RedK  // 合併後必須是紅K
        and (combo2LowerShadowPct >= tail_min_pct)
        and (combo2UpperShadowPct <= opp_tail_max_pct)
        and (combo2BodyPct <= body_max_pct)
        and (combo2BodyPosition >= 1 - body_pos_pct)
        and (combo2Low <= combo2LowestInRange);
end
else
    isCombo2Reversal = false;

// ============================================================
// 條件 3：最新 3 期合併為 Bullish Reversal Bar（必須是紅K）
// ============================================================

combo3Open  = open[2];
combo3Close = close;
combo3High  = maxlist(high, high[1], high[2]);
combo3Low   = minlist(low, low[1], low[2]);
isCombo3RedK = (combo3Close > combo3Open);  // 合併後必須是紅K

combo3Range       = combo3High - combo3Low;
combo3BodySize    = absvalue(combo3Close - combo3Open);
combo3UpperShadow = combo3High - maxlist(combo3Open, combo3Close);
combo3LowerShadow = minlist(combo3Open, combo3Close) - combo3Low;

if combo3Range > 0 then
begin
    combo3LowerShadowPct = combo3LowerShadow / combo3Range;
    combo3UpperShadowPct = combo3UpperShadow / combo3Range;
    combo3BodyPct        = combo3BodySize / combo3Range;
    combo3BodyPosition   = (minlist(combo3Open, combo3Close) - combo3Low) / combo3Range;
    combo3LowestInRange  = lowest(low, tail_prominence_bars + 2);

    isCombo3Reversal =
        isCombo3RedK  // 合併後必須是紅K
        and (combo3LowerShadowPct >= tail_min_pct)
        and (combo3UpperShadowPct <= opp_tail_max_pct)
        and (combo3BodyPct <= body_max_pct)
        and (combo3BodyPosition >= 1 - body_pos_pct)
        and (combo3Low <= combo3LowestInRange);
end
else
    isCombo3Reversal = false;

// ============================================================
// 成交量過濾條件
// ============================================================

avgVolume = average(volume, volume_period);
volumeOK = (avgVolume > volume_threshold);

// ============================================================
// 綜合條件判斷
// ============================================================

trigger = (isSingleReversal or isCombo2Reversal or isCombo3Reversal) and volumeOK;

if trigger then
begin
    // 決定觸發類型（優先順序：單根 > 2根合併 > 3根合併）
    if isSingleReversal then
    begin
        triggerType = 1;
        if singleBodySize > 0 then
        begin
            finalUpperShadowRatio = singleUpperShadow / singleBodySize;
            finalLowerShadowRatio = singleLowerShadow / singleBodySize;
        end
        else
        begin
            finalUpperShadowRatio = 0;
            finalLowerShadowRatio = 0;
        end;
    end
    else if isCombo2Reversal then
    begin
        triggerType = 2;
        if combo2BodySize > 0 then
        begin
            finalUpperShadowRatio = combo2UpperShadow / combo2BodySize;
            finalLowerShadowRatio = combo2LowerShadow / combo2BodySize;
        end
        else
        begin
            finalUpperShadowRatio = 0;
            finalLowerShadowRatio = 0;
        end;
    end
    else  // isCombo3Reversal
    begin
        triggerType = 3;
        if combo3BodySize > 0 then
        begin
            finalUpperShadowRatio = combo3UpperShadow / combo3BodySize;
            finalLowerShadowRatio = combo3LowerShadow / combo3BodySize;
        end
        else
        begin
            finalUpperShadowRatio = 0;
            finalLowerShadowRatio = 0;
        end;
    end;
    
    ret = 1;
end
else
begin
    triggerType = 0;
    finalUpperShadowRatio = 0;
    finalLowerShadowRatio = 0;
    ret = 0;
end;

// ============================================================
// 輸出欄位
// ============================================================

// --- 主要輸出欄位（依需求）---
outputfield(1, triggerType, "觸發(1/2/3)");
outputfield(2, finalUpperShadowRatio, "上引線與實體比率");
outputfield(3, finalLowerShadowRatio, "下引線與實體比率");

// --- 除錯欄位（可選）---
outputfield(4, isSingleReversal, "單根符合1");
outputfield(5, isCombo2Reversal, "2根合併符合2");
outputfield(6, isCombo3Reversal, "3根合併符合3");
outputfield(7, volumeOK, "成交量OK");
outputfield(8, avgVolume, "平均成交量");

