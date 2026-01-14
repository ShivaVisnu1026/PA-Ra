// ===================================================================
// 函數名稱：EarlyVolumeRatio
// 功能描述：比較今日早盤成交量與昨日同時段
// 說明：用於判斷今日活躍度是否異常
// 版本：1.0
// 建立日期：2025-12-19
// ===================================================================

// === 參數定義 ===
inputs: MinutesFromOpen(numericsimple),  // 開盤後幾分鐘
        BarInterval(numericsimple);      // K棒週期（分鐘）

// === 變數宣告 ===
variables: BarsToCount(0),
           TodayVolSum(0),
           YesterdayVolSum(0),
           VolumeRatio(0),
           CurrentTime(0),
           MarketOpenTime(0),
           MinutesSinceOpen(0),
           IsWithinWindow(false),
           i(0);

// === 計算需要的K棒數量 ===
BarsToCount = MinutesFromOpen / BarInterval;

// === 檢查是否在指定時間窗口內 ===
CurrentTime = Time;
MarketOpenTime = 090000;  // 09:00:00（根據市場調整）

// 計算開盤後經過的分鐘數
if CurrentTime >= MarketOpenTime then begin
    MinutesSinceOpen = (
        ((CurrentTime / 10000) - (MarketOpenTime / 10000)) * 60 +
        ((CurrentTime mod 10000) / 100) - ((MarketOpenTime mod 10000) / 100)
    );
    IsWithinWindow = (MinutesSinceOpen <= MinutesFromOpen);
end
else
    IsWithinWindow = false;

// === 只在指定時間窗口內計算 ===
if IsWithinWindow then begin
    // 累計今日成交量（從開盤到現在）
    TodayVolSum = 0;
    for i = 0 to MinList(BarsToCount, CurrentBar - 1) begin
        TodayVolSum = TodayVolSum + Volume[i];
    end;
    
    // 累計昨日同時段成交量
    YesterdayVolSum = 0;
    for i = 0 to BarsToCount - 1 begin
        // 使用日線資料的前一日成交量比例估算
        // 或使用分鐘資料的歷史同時段
        YesterdayVolSum = YesterdayVolSum + Volume[i + BarsToCount];
    end;
    
    // 計算比率
    if YesterdayVolSum > 0 then
        VolumeRatio = (TodayVolSum / YesterdayVolSum) - 1  // 返回增長百分比
    else
        VolumeRatio = 0;
end
else
    VolumeRatio = 0;

// === 返回值（百分比，例如 0.20 = 20%） ===
EarlyVolumeRatio = VolumeRatio;

