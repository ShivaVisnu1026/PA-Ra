{@type:sensor}
// 日線 Pin Bar Reversal + 週線 EMA20 遞減（sloping down） 警示腳本
// 說明：
// - 主頻率：日線（較短週期）
// - 跨頻率引用：週線 EMA20（較長週期），以 GetField("Close","W") 計算
// 觸發條件：
// 1) 當前日K為看跌 Pin Bar（Nial Fuller 定義的簡化版）
// 2) 週線 EMA20 遞減（EMA20 < EMA20[1]）

// 參數
input: pin_tail_ratio(2.0);      // 長影線 >= 倍數 * 實體（核心條件）
input: opp_tail_ratio(0.8);      // 反側影線 <= 倍數 * 實體（放寬，避免錯殺）
input: min_body_pct(0.5);        // 最小實體比例（% of range）避免十字星；0.5% 即可
input: use_body_pos(false);      // 是否啟用「實體位於下緣」的過濾（預設關閉，避免過嚴）
input: body_pos_pct(35.0);       // 實體位於下緣的百分比門檻；僅在 use_body_pos = true 時生效
input: require_red(false);       // 是否強制為收黑K（預設關閉）
input: ema_len(20);              // 週線 EMA 期數

// 需要的歷史K棒（週線20期約等於日線>= 20*5 = 100；保守抓 200）
settotalbar(250);

// （移除強制頻率檢查，避免在跨頻率或批次掃描時被阻擋）

// 日線 Pin Bar 判定（看跌）
var:
    bodySize(0),
    candleRange(0),
    upperShadow(0),
    lowerShadow(0),
    isBearishPin(false);

bodySize    = absvalue(close - open);
candleRange = high - low;
upperShadow = high - maxlist(open, close);
lowerShadow = minlist(open, close) - low;

// 避免除以0或極小實體：以全K幅度為0時直接略過
if candleRange > 0 then
begin
    // 實體至少佔全K一定比例，排除幾乎十字的情況
    // min_body_pct 以百分比輸入，這裡換算成比例
    if bodySize >= (min_body_pct / 100.0) * candleRange then
    begin
        // 核心：上影線長、下影線相對短
        isBearishPin = (upperShadow >= pin_tail_ratio * bodySize)
                        and (lowerShadow <= opp_tail_ratio * bodySize)
                        and (require_red = false or close <= open);

        // 可選：實體需位於K棒下緣（避免過嚴，預設關閉）
        if use_body_pos then
            isBearishPin = isBearishPin and (maxlist(open, close) <= low + (body_pos_pct / 100.0) * candleRange);
    end;
end;

// 週線 EMA20 遞減（使用跨頻率週資料）
var:
    wk_close(0),
    wk_ema20(0),
    wk_ema20_prev(0),
    isWeeklyDown(false);

wk_close     = GetField("Close", "W");
// 使用跨頻率版本的 EMA：xf_XAverage("W", 序列, 期數)
wk_ema20     = xf_XAverage("W", wk_close, ema_len);
// 取上一週EMA：源序列整體往前一週再計算，避免日內位移造成的對齊誤差
wk_ema20_prev= xf_XAverage("W", wk_close[1], ema_len);
isWeeklyDown = wk_ema20 < wk_ema20_prev;  // sloping down

// 觸發：同時滿足日線看跌 Pin Bar + 週線 EMA20 遞減
if isBearishPin and isWeeklyDown then
begin
    // 輸出週EMA20與前值，供檢查
    RetMsg = Text(
        "PinBar 週EMA20下滑 | EMA20=",
        NumToStr(wk_ema20, 2),
        " prev=",
        NumToStr(wk_ema20_prev, 2),
        " diff=",
        NumToStr(wk_ema20 - wk_ema20_prev, 2)
    );
    ret = 1;
end;


