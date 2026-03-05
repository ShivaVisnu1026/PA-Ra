{@type:sensor}
// Pin Bar Reversal 警示腳本
// 基於 Nial Fuller (Learn To Trade The Market) 的定義
//
// Pin Bar 定義：
// 1. 具有長影線（至少是實體的 3 倍長度）
// 2. 小實體（開盤價與收盤價接近）
// 3. 長影線突出於其他 K 線之外
// 4. 影線方向表示價格被拒絕的方向
//
// 參考官方範例：
// - XScript_Preset/警示/酒田戰法/鎚頭.xs
// - XS_Blocks/警示腳本/即時/R0005-K線型態/[R0005-012-A]長下影線.xs

// 宣告參數
input: MinTailRatio(3.0);        // 最小影線與實體比例（預設 3 倍）
input: MaxBodyRatio(0.3);        // 最大實體與總範圍比例（預設 30%）
input: MinTailPercent(2.0);      // 最小影線幅度百分比（預設 2%）
input: LookbackPeriod(5);        // 比較周圍 K 線的期數（預設 5 期）

// 設定參數中文名稱
SetInputName(1, "最小影線比例");
SetInputName(2, "最大實體比例");
SetInputName(3, "最小影線幅度%");
SetInputName(4, "比較期數");

// 設定所需的最大 K 棒數量
SetTotalBar(LookbackPeriod + 2);

// 計算 K 線的各個部分
value1 = High - Low;                    // 總範圍
value2 = AbsValue(Close - Open);        // 實體大小
value3 = High - MaxList(Open, Close);   // 上影線
value4 = MinList(Open, Close) - Low;    // 下影線

// 計算實體與總範圍的比例
value5 = value2 / value1;

// 計算影線與實體的比例
value6 = value3 / value2;  // 上影線比例
value7 = value4 / value2;  // 下影線比例

// 計算影線幅度百分比（相對於前一日收盤價）
value8 = value3 / Close[1] * 100;  // 上影線幅度%
value9 = value4 / Close[1] * 100;  // 下影線幅度%

// 檢查影線是否突出於周圍 K 線
value10 = Highest(High, LookbackPeriod);  // 周圍最高價
value11 = Lowest(Low, LookbackPeriod);    // 周圍最低價

// 判斷是否為看漲 Pin Bar（長下影線）
condition1 = value4 >= value2 * MinTailRatio;           // 下影線至少是實體的 3 倍
condition2 = value5 <= MaxBodyRatio;                    // 實體不超過總範圍的 30%
condition3 = value9 >= MinTailPercent;                  // 下影線幅度至少 2%
condition4 = Low <= value11;                            // 低點突出於周圍 K 線
condition5 = value3 <= value2;                          // 上影線不超過實體

// 判斷是否為看跌 Pin Bar（長上影線）
condition6 = value3 >= value2 * MinTailRatio;           // 上影線至少是實體的 3 倍
condition7 = value5 <= MaxBodyRatio;                    // 實體不超過總範圍的 30%
condition8 = value8 >= MinTailPercent;                  // 上影線幅度至少 2%
condition9 = High >= value10;                           // 高點突出於周圍 K 線
condition10 = value4 <= value2;                         // 下影線不超過實體

// 設定警示條件
if (condition1 and condition2 and condition3 and condition4 and condition5) or
   (condition6 and condition7 and condition8 and condition9 and condition10)
then ret = 1;

// 顯示相關數值（用於除錯和監控）
SetOutputName1("實體比例");
OutputField1(value5);

SetOutputName2("上影線比例");
OutputField2(value6);

SetOutputName3("下影線比例");
OutputField3(value7);

SetOutputName4("影線幅度%");
if value3 > value4 then
    OutputField4(value8)
else
    OutputField4(value9);
