// ============================================================
// V Reversal Bullish Screener
// ============================================================
// 描述：
//   以3根K棒為一組判斷，偵測V型反轉看漲模式
//
// K棒編號：
//   - 1號K：最舊的K棒（2期前）
//   - 2號K：中間的K棒（1期前）
//   - 3號K：最新的K棒（當前）
//
// 條件：
//   1. 2號K最高價 < 1號K最高價及3號K最高價
//   2. 2號K最低價 < 1號K最低價及3號K最低價
//   3. 3號K最高價 > 1號K最高價
//   4. 1號K為黑K（close < open）
//   5. 3號K為紅K（close > open）
//   6. 3號K的成交量 > 2號K成交量 * 倍數（可調整參數）
//   7. 3號K實體長度 > 上引線長度
//   8. 3號K成交量 > 門檻值（可調整參數）
//
// 輸出：
//   - 觸發狀態
//   - 各項條件檢查結果
// ============================================================

{@type:filter}

// ===== 參數設定 =====
settotalbar(250);

// --- 成交量參數 ---
input: volume_multiplier(1.5, "成交量倍數"),
       volume_threshold(750, "成交量門檻");

// ===== 變數宣告 =====

// --- K棒編號定義 ---
// 1號K = [2] (最舊，2期前)
// 2號K = [1] (中間，1期前)
// 3號K = [0] (最新，當前)

var: k1_high(0),
     k1_low(0),
     k1_open(0),
     k1_close(0),
     k1_isBlackK(false),
     
     k2_high(0),
     k2_low(0),
     k2_volume(0),
     
     k3_high(0),
     k3_low(0),
     k3_open(0),
     k3_close(0),
     k3_volume(0),
     k3_isRedK(false),
     k3_bodySize(0),
     k3_upperShadow(0);

// --- 條件檢查變數 ---
var: allConditionsMet(false);

// ============================================================
// 取得各K棒數據
// ============================================================

// 1號K（最舊，2期前）
k1_high  = high[2];
k1_low   = low[2];
k1_open  = open[2];
k1_close = close[2];
k1_isBlackK = (k1_close < k1_open);

// 2號K（中間，1期前）
k2_high   = high[1];
k2_low    = low[1];
k2_volume = volume[1];

// 3號K（最新，當前）
k3_high   = high;
k3_low    = low;
k3_open   = open;
k3_close  = close;
k3_volume = volume;
k3_isRedK = (k3_close > k3_open);
k3_bodySize = absvalue(k3_close - k3_open);  // 實體長度
k3_upperShadow = k3_high - maxlist(k3_open, k3_close);  // 上引線長度

// ============================================================
// 條件檢查
// ============================================================

// 條件1：2號K最高價 < 1號K最高價及3號K最高價
condition1 = (k2_high < k1_high) and (k2_high < k3_high);

// 條件2：2號K最低價 < 1號K最低價及3號K最低價
condition2 = (k2_low < k1_low) and (k2_low < k3_low);

// 條件3：3號K最高價 > 1號K最高價
condition3 = (k3_high > k1_high);

// 條件4：1號K為黑K（close < open）
condition4 = k1_isBlackK;

// 條件5：3號K為紅K（close > open）
condition5 = k3_isRedK;

// 條件6：3號K的成交量 > 2號K成交量 * 倍數
if k2_volume > 0 then
    condition6 = (k3_volume > k2_volume * volume_multiplier)
else
    condition6 = false;

// 條件7：3號K實體長度 > 上引線長度
condition7 = (k3_bodySize > k3_upperShadow);

// 條件8：3號K成交量 > 門檻值
condition8 = (k3_volume > volume_threshold);

// ============================================================
// 綜合條件判斷
// ============================================================

allConditionsMet = condition1 and condition2 and condition3 
                   and condition4 and condition5 and condition6
                   and condition7 and condition8;

if allConditionsMet then
    ret = 1
else
    ret = 0;

// ============================================================
// 輸出欄位
// ============================================================

// --- 主要輸出欄位 ---
outputfield(1, allConditionsMet, "觸發");

// --- 條件檢查結果（除錯用）---
outputfield(2, condition1, "條件1:2號高<1號高且<3號高");
outputfield(3, condition2, "條件2:2號低<1號低且<3號低");
outputfield(4, condition3, "條件3:3號高>1號高");
outputfield(5, condition4, "條件4:1號黑K");
outputfield(6, condition5, "條件5:3號紅K");
outputfield(7, condition6, "條件6:3號量>2號量*倍數");
outputfield(8, condition7, "條件7:3號實體>上引線");
outputfield(9, condition8, "條件8:3號量>門檻");

// --- 數值資訊 ---
outputfield(10, k1_high, "1號K最高價");
outputfield(11, k2_high, "2號K最高價");
outputfield(12, k3_high, "3號K最高價");
outputfield(13, k2_volume, "2號K成交量");
outputfield(14, k3_volume, "3號K成交量");
outputfield(15, k2_volume * volume_multiplier, "2號K成交量*倍數");
outputfield(16, k3_bodySize, "3號K實體長度");
outputfield(17, k3_upperShadow, "3號K上引線長度");

