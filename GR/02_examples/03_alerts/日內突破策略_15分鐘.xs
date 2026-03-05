{@type:autotrade}
// 日內突破策略 - 15分鐘K棒
// 策略說明：
// 1. 每天第一根15分鐘K棒判斷是否為多頭啟動棒
// 2. 符合條件時記錄信號棒的高低點
// 3. 突破信號棒高點時進場做多
// 4. 設定固定停損停利，風報比1:1
// 5. 收盤前自動平倉
// 
// 修正記錄：
// - 簡化進場條件：改為 High >= entry_price（避免錯過跳空高開）
// - 加強平倉邏輯：K棒16後強制平倉，並增加隔日持倉保險
// - 進場條件優化：改為 Close crosses above entry_price（確保由下往上突破）
// - 進場方式：改為市價進場 SetPosition(1, market)
// - 新增條件：日成交量大於1000張 GetField("Volume", "D") >= min_daily_volume
// - 修正突破邏輯：condition5 改為 High > value4（信號棒必須突破過去20根最高點）

// 參數設定
input: min_gain_percent(3.0);        // 最小漲幅百分比
input: max_upper_shadow(2.0);        // 最大上影線百分比
input: min_body_percent(3.0);        // 最小實體漲幅百分比
input: lookback_bars(20);            // 回顧期數（檢查是否創新高）
input: risk_reward_ratio(1.0);       // 風報比
input: min_daily_volume(1000);       // 最小日成交量（張）
// 使用 AddSpread 函數處理 tick 計算，不需要 min_tick 參數

// 設定所需K棒數量（必須在變數宣告前）
settotalbar(lookback_bars + 10);

// 變數宣告
var: 
    KBarOfDay(0),                          // 當日K棒計數器
    intrabarpersist signal_bar_found(false), // 是否找到信號棒
    intrabarpersist signal_high(0),        // 信號棒高點
    intrabarpersist signal_low(0),         // 信號棒低點
    intrabarpersist signal_date(0),        // 信號棒日期
    intrabarpersist entry_price(0),        // 進場價格
    intrabarpersist stop_loss(0),          // 停損價格
    intrabarpersist take_profit(0),        // 停利價格
    intrabarpersist hasTradedToday(false); // 當日是否已交易

// 檢查週期設定（必須在邏輯開始前）
if barfreq <> "Min" or barinterval <> 15 then
    raiseruntimeerror("請設定為15分鐘K棒");

// 每日重置和K棒計數
if Date <> Date[1] then
begin
    KBarOfDay = 1;                    // 重置K棒計數器
    signal_bar_found = false;         // 重置信號棒狀態
    signal_high = 0;                  // 重置信號棒高點
    signal_low = 0;                   // 重置信號棒低點
    signal_date = 0;                  // 重置信號棒日期
    entry_price = 0;                  // 重置進場價格
    stop_loss = 0;                    // 重置停損價格
    take_profit = 0;                  // 重置停利價格
    hasTradedToday = false;           // 重置交易狀態
end
else
begin
    KBarOfDay = KBarOfDay + 1;        // 增加K棒計數
end;

// 信號棒識別：只在第一根K棒檢查
if KBarOfDay = 1 and signal_bar_found = false then
begin
    // 計算各項條件
    value1 = (Close - Open) / Open * 100;           // 實體漲幅百分比
    value2 = (Close - Close[1]) / Close[1] * 100;   // 相對前一根收盤價漲幅
    value3 = (High - Close) / Close * 100;          // 上影線百分比
    
    // 檢查是否創新高（過去20根K棒，不含當前）
    value4 = Highest(High[1], lookback_bars);
    condition1 = Close > Open;                      // 收紅
    condition2 = value2 >= min_gain_percent;        // 相對前一根漲幅超過3%
    condition3 = value3 <= max_upper_shadow;        // 上影線不超過2%
    condition4 = value1 >= min_body_percent;        // 實體漲幅超過3%
    condition5 = High > value4;                     // 突破過去20根K棒的最高點
    condition6 = GetField("Volume", "D") >= min_daily_volume;  // 日成交量大於1000張
    
    // 如果符合所有條件，記錄為信號棒
    if condition1 and condition2 and condition3 and condition4 and condition5 and condition6 then
    begin
        signal_high = High;
        signal_low = Low;
        signal_date = Date;
        signal_bar_found = true;
        entry_price = AddSpread(High, 1);           // 預先計算進場價格
    end;
end;

// 進場邏輯：限制在K棒2-16之間，且當日未交易
if signal_date = Date and KBarOfDay > 1 and KBarOfDay < 17 and Position = 0 and not hasTradedToday then
begin
    // 進場條件：收盤價由下往上突破進場價（確保是由下往上的突破）
    if Close crosses above entry_price then
    begin
        // 進場做多（使用市價）
        SetPosition(1, market);
        
        // 設定停損停利
        stop_loss = signal_low;
        take_profit = entry_price + (entry_price - stop_loss) * risk_reward_ratio;
        
        // 標記已交易，避免重複進場
        hasTradedToday = true;
    end;
end;

// 出場邏輯
if Position > 0 then
begin
    // 優先級1：強制平倉 - 時間到期（K棒16後，約下午1:00後）
    if KBarOfDay >= 16 then
    begin
        SetPosition(0, market);
    end
    // 優先級2：停損 - 跌破信號棒低點
    else if Close <= stop_loss then
    begin
        SetPosition(0, market);
    end
    // 優先級3：停利 - 達到目標價位
    else if Close >= take_profit then
    begin
        SetPosition(0, market);
    end;
end;

// 額外保險：每日收盤前強制平倉（防止隔日持倉）
if Date <> Date[1] and Position > 0 then
    SetPosition(0, market);

// 注意：自動交易腳本無法使用 OutputField 函數
// 如需監控數值，請使用 Alert 函數或記錄到外部檔案
