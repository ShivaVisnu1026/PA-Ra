{@type:indicator}
// Highest函數差異測試腳本
// 用於理解 Highest(High[1], N) 和 Highest(High, N)[1] 的差異

input: lookback_bars(5);

// 方法1：Highest(High[1], lookback_bars)
value1 = Highest(High[1], lookback_bars);

// 方法2：Highest(High, lookback_bars)[1]  
value2 = Highest(High, lookback_bars)[1];

// 方法3：Highest(High, lookback_bars) - 對照組
value3 = Highest(High, lookback_bars);

// 輸出結果
SetOutputName1("Highest(High[1], N)");
OutputField1(value1);

SetOutputName2("Highest(High, N)[1]");
OutputField2(value2);

SetOutputName3("Highest(High, N)");
OutputField3(value3);

SetOutputName4("當前High");
OutputField4(High);

SetOutputName5("前一根High");
OutputField5(High[1]);

