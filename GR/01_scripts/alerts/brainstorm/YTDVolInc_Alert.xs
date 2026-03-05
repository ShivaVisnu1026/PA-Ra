// ============================================================
// YTDVolInc Alert
// ============================================================
// 描述：
//   在 9:10am 檢查今日累計成交量是否超過昨日成交量的 20%
//   並且過去5日平均成交量 > 150
//
// 觸發條件：
//   - 時間：9:10am（僅執行一次）
//   - 今日累計成交量 > 昨日成交量 * 20%
//   - 過去5日平均成交量 > 150
//
// 資料週期：適用於日內圖表（分鐘圖、Tick圖等）
// ============================================================

{@type:sensor}

// ===== 參數設定 =====
settotalbar(100);

// --- 時間參數 ---
input: alert_time(91000, "警示時間 (HHMMSS格式，91000=9:10am)"),
       volume_threshold_percent(20, "成交量閾值百分比"),
       avg_volume_period(5, "平均成交量計算天數"),
       min_avg_volume(150, "最小平均成交量");

// ===== 變數宣告 =====
var: todayVolume(0),           // 今日累計成交量
     yesterdayVolume(0),       // 昨日成交量
     avg5DayVolume(0),         // 過去5日平均成交量
     currentTimeValue(0),      // 當前時間
     volumeThreshold(0),       // 成交量閾值（昨日成交量 * 百分比）
     isAlertTime(false),       // 是否為警示時間（9:10am）
     conditionMet(false),      // 條件是否滿足
     intrabarpersist alertTriggeredToday(false);  // 今日是否已觸發警示

// ============================================================
// 取得時間和成交量資料
// ============================================================
currentTimeValue = CurrentTime;

// 檢查是否為 9:10am（91000 到 91059 之間，確保只執行一次）
isAlertTime = (currentTimeValue >= alert_time) and (currentTimeValue < alert_time + 100);

// 取得今日累計成交量
todayVolume = GetQuote("DailyVolume");
// 也可以使用：todayVolume = q_DailyVolume;

// 取得昨日成交量
yesterdayVolume = GetQuote("PreTotalVolume");
// 也可以使用：yesterdayVolume = q_PreTotalVolume;

// 計算過去5日平均成交量（使用日線資料）
avg5DayVolume = Average(GetField("成交量", "D"), avg_volume_period);

// 計算成交量閾值（昨日成交量 * 20%）
volumeThreshold = yesterdayVolume * (volume_threshold_percent / 100);

// ============================================================
// 檢查是否為新的一天（重置警示標記）
// ============================================================
// 如果日期改變，重置警示標記
if Date <> Date[1] then
    alertTriggeredToday = false;

// ============================================================
// 檢查觸發條件
// ============================================================
// 條件1：時間為 9:10am（僅在該時間窗口內執行）
// 條件2：今日成交量 > 昨日成交量 * 20%
// 條件3：過去5日平均成交量 > 150
// 條件4：今日尚未觸發過警示
conditionMet = isAlertTime
           and (todayVolume > volumeThreshold)
           and (avg5DayVolume > min_avg_volume)
           and (yesterdayVolume > 0)  // 確保昨日有成交量資料
           and not alertTriggeredToday;

// ============================================================
// 警示觸發
// ============================================================
if conditionMet then
begin
    ret = 1;
    alertTriggeredToday = true;  // 標記今日已觸發，避免重複警示
end
else
    ret = 0;

