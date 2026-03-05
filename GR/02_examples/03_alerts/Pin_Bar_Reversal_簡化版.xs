{@type:sensor}
// Pin Bar Reversal 警示腳本 - 簡化版
// 基於 Nial Fuller 的定義，最簡單的 Pin Bar 偵測
//
// Pin Bar 特徵：
// 1. 長影線（至少是實體的 3 倍）
// 2. 小實體（不超過總範圍的 30%）
// 3. 影線突出於周圍 K 線

// 計算 K 線各部分
value1 = High - Low;                    // 總範圍
value2 = AbsValue(Close - Open);        // 實體大小
value3 = High - MaxList(Open, Close);   // 上影線
value4 = MinList(Open, Close) - Low;    // 下影線

// 計算比例
value5 = value2 / value1;               // 實體比例
value6 = value3 / value2;               // 上影線比例
value7 = value4 / value2;               // 下影線比例

// 檢查影線是否突出
value8 = Highest(High, 5);              // 5 期最高價
value9 = Lowest(Low, 5);                // 5 期最低價

// 看漲 Pin Bar（長下影線）
condition1 = value4 >= value2 * 3;      // 下影線至少是實體的 3 倍
condition2 = value5 <= 0.3;             // 實體不超過總範圍的 30%
condition3 = Low <= value9;             // 低點突出
condition4 = value3 <= value2;          // 上影線不超過實體

// 看跌 Pin Bar（長上影線）
condition5 = value3 >= value2 * 3;      // 上影線至少是實體的 3 倍
condition6 = value5 <= 0.3;             // 實體不超過總範圍的 30%
condition7 = High >= value8;            // 高點突出
condition8 = value4 <= value2;          // 下影線不超過實體

// 觸發警示
if (condition1 and condition2 and condition3 and condition4) or
   (condition5 and condition6 and condition7 and condition8)
then ret = 1;
