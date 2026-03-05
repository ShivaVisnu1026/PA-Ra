# 波動率指標快速參考

## 您的問題解答

**Q: 如何計算過去 20 日的平均上漲或下跌波動率，例如 +3% 或 -3%？**

**A: 使用 `UpsideDownside_Volatility.xs` 指標：**

1. 開啟圖表，選擇日線週期
2. 載入 `UpsideDownside_Volatility.xs`
3. 查看 Plot1（平均上漲波動率 %）和 Plot2（平均下跌波動率 %）

## 快速開始

### 1. 基本使用

**查看 ADR：**
- 載入 `ADR_Indicator.xs` 到日線圖表
- 查看 Plot1（ADR 絕對值）和 Plot2（ADR 百分比）

**查看上漲/下跌波動率：**
- 載入 `UpsideDownside_Volatility.xs` 到日線圖表
- 查看 Plot1（平均上漲 %）和 Plot2（平均下跌 %）

**完整波動率分析：**
- 載入 `Volatility_Indicators.xs` 到日線圖表
- 顯示所有波動率指標

### 2. 選股使用

**根據波動率篩選：**
- 開啟選股功能
- 載入 `Volatility_Screener.xs`
- 設定篩選條件並執行

## 可用函數

### `ADR_Indicator.xs`
- 計算平均每日波動範圍（ADR）
- 返回：ADR 絕對值、百分比、當日範圍、ADR 比率

### `UpsideDownside_Volatility.xs`
- **這直接回答您的問題！**
- 計算分離的上漲和下跌波動率
- 返回：平均上漲 %、下跌 %、絕對值

### `Volatility_Indicators.xs`
- 計算所有波動率指標
- 返回：ADR、ATR、上漲/下跌波動率

### `Volatility_Screener.xs`
- 根據波動率條件篩選股票
- 可設定 ADR、上漲/下跌波動率等條件

## 關鍵指標說明

| 指標 | 意義 | 範例 |
|------|------|------|
| **ADR** | 平均每日 High-Low 範圍 | $3.50 或 2.3% |
| **ATR** | 平均真實波動範圍（含跳空） | $3.52 或 2.35% |
| **平均上漲** | 平均從開盤到高點的漲幅 | +3.2% |
| **平均下跌** | 平均從開盤到低點的跌幅 | -2.8% |
| **ADR 比率** | 當日範圍 / ADR | 1.22x（高於平均） |

## 常見使用情境

### "平均每日波動範圍是多少？"
```xscript
// 載入 ADR_Indicator.xs
// 查看 Plot2（ADR 百分比）
```

### "平均上漲/下跌波動是多少？"
```xscript
// 載入 UpsideDownside_Volatility.xs
// 查看 Plot1（平均上漲 %）和 Plot2（平均下跌 %）
```

### "當日波動是否高於平均？"
```xscript
// 載入 ADR_Indicator.xs
// 查看 Plot5（ADR 比率）
// > 1.2 = 高於平均
// < 0.8 = 低於平均
```

## 檔案位置

1. **`GR/01_scripts/indicators/production/Volatility_Indicators.xs`** - 完整波動率指標
2. **`GR/01_scripts/indicators/production/ADR_Indicator.xs`** - ADR 專用指標
3. **`GR/01_scripts/indicators/production/UpsideDownside_Volatility.xs`** - 上漲/下跌波動率指標
4. **`GR/01_scripts/screeners/production/Volatility_Screener.xs`** - 波動率選股腳本
5. **`GR/03_docs/guides/VOLATILITY_INDICATORS_GUIDE.md`** - 完整使用指南

## 與現有程式碼整合

您的 `app.py` 已有基本的 `range_vs_adr()` 函數。您可以在 XQScript 中使用這些指標來：

1. 在圖表上顯示波動率指標
2. 使用選股腳本篩選符合條件的股票
3. 在自動交易策略中參考波動率設定停損停利

## 下一步

1. 閱讀 `VOLATILITY_INDICATORS_GUIDE.md` 了解詳細說明
2. 載入指標到圖表測試
3. 根據需要調整參數
4. 整合到您的交易策略中








