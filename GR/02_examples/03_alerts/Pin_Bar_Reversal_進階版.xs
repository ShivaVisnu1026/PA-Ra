{@type:sensor}
// Pin Bar Reversal 警示腳本 - 進階版
// 基於 Nial Fuller (Learn To Trade The Market) 的完整定義
//
// Nial Fuller 的 Pin Bar 定義：
// 1. 長影線（至少是實體的 3 倍長度）
// 2. 小實體（開盤價與收盤價接近）
// 3. 長影線突出於其他 K 線之外
// 4. 影線方向表示價格被拒絕的方向
// 5. 開盤價和收盤價位於前一根蠟燭的範圍內（可選條件）
// 6. 避免重複警示機制

// 宣告參數
input: MinTailRatio(3.0);        // 最小影線與實體比例
input: MaxBodyRatio(0.3);        // 最大實體與總範圍比例
input: MinTailPercent(2.0);      // 最小影線幅度百分比
input: LookbackPeriod(5);        // 比較周圍 K 線的期數
input: CheckPreviousBar(true);   // 是否檢查前一根 K 線範圍
input: MinVolumeRatio(1.2);      // 最小成交量比例（相對於平均）

// 設定參數中文名稱
SetInputName(1, "最小影線比例");
SetInputName(2, "最大實體比例");
SetInputName(3, "最小影線幅度%");
SetInputName(4, "比較期數");
SetInputName(5, "檢查前K線範圍");
SetInputName(6, "最小成交量比例");

// 宣告變數
variable: AlertTriggered(false); // 避免重複警示

// 設定所需的最大 K 棒數量
SetTotalBar(LookbackPeriod + 3);

// 計算 K 線的各個部分
value1 = High - Low;                    // 總範圍
value2 = AbsValue(Close - Open);        // 實體大小
value3 = High - MaxList(Open, Close);   // 上影線
value4 = MinList(Open, Close) - Low;    // 下影線

// 計算比例
value5 = value2 / value1;               // 實體與總範圍比例
value6 = value3 / value2;               // 上影線與實體比例
value7 = value4 / value2;               // 下影線與實體比例

// 計算影線幅度百分比
value8 = value3 / Close[1] * 100;       // 上影線幅度%
value9 = value4 / Close[1] * 100;       // 下影線幅度%

// 檢查影線是否突出於周圍 K 線
value10 = Highest(High, LookbackPeriod); // 周圍最高價
value11 = Lowest(Low, LookbackPeriod);   // 周圍最低價

// 計算成交量條件
value12 = Average(Volume, 20);          // 20 期平均成交量
value13 = Volume / value12;             // 當前成交量比例

// 檢查前一根 K 線範圍條件（Nial Fuller 的額外條件）
condition_prev = true;
if CheckPreviousBar then
begin
    // 開盤價和收盤價位於前一根蠟燭的範圍內
    condition_prev = (Open >= Low[1] and Open <= High[1]) and 
                     (Close >= Low[1] and Close <= High[1]);
end;

// 判斷是否為看漲 Pin Bar（長下影線）
condition1 = value4 >= value2 * MinTailRatio;           // 下影線至少是實體的指定倍數
condition2 = value5 <= MaxBodyRatio;                    // 實體不超過總範圍的指定比例
condition3 = value9 >= MinTailPercent;                  // 下影線幅度至少達到指定百分比
condition4 = Low <= value11;                            // 低點突出於周圍 K 線
condition5 = value3 <= value2;                          // 上影線不超過實體
condition6 = value13 >= MinVolumeRatio;                 // 成交量達到指定比例

// 判斷是否為看跌 Pin Bar（長上影線）
condition7 = value3 >= value2 * MinTailRatio;           // 上影線至少是實體的指定倍數
condition8 = value5 <= MaxBodyRatio;                    // 實體不超過總範圍的指定比例
condition9 = value8 >= MinTailPercent;                  // 上影線幅度至少達到指定百分比
condition10 = High >= value10;                          // 高點突出於周圍 K 線
condition11 = value4 <= value2;                         // 下影線不超過實體
condition12 = value13 >= MinVolumeRatio;                // 成交量達到指定比例

// 組合條件
bullish_pinbar = condition1 and condition2 and condition3 and condition4 and condition5 and condition6 and condition_prev;
bearish_pinbar = condition7 and condition8 and condition9 and condition10 and condition11 and condition12 and condition_prev;

// 避免重複警示的機制
if bullish_pinbar or bearish_pinbar then
begin
    if AlertTriggered = false then
    begin
        ret = 1;
        AlertTriggered = true;
    end;
end
else
begin
    // 當條件不再滿足時，重置警示狀態
    AlertTriggered = false;
end;

// 顯示相關數值
SetOutputName1("實體比例");
OutputField1(value5);

SetOutputName2("影線比例");
if value3 > value4 then
    OutputField2(value6)
else
    OutputField2(value7);

SetOutputName3("影線幅度%");
if value3 > value4 then
    OutputField3(value8)
else
    OutputField3(value9);

SetOutputName4("成交量比例");
OutputField4(value13);

SetOutputName5("警示狀態");
if AlertTriggered then
    OutputField5(1)
else
    OutputField5(0);
