# 模組化策略系統 (Modular Strategy System)

## 概述 (Overview)

這個系統使用**模組化設計**，讓你可以像積木一樣組合不同的技術分析模組來創建自定義策略。

## 架構 (Architecture)

```
01_scripts/
├── functions/
│   ├── modules/                    # 可重複使用的模組函數
│   │   ├── PriceAboveEMA.xs       # 價格位置模組
│   │   ├── ATRMeasurement.xs      # ATR 計算模組
│   │   ├── ATRFilter.xs           # ATR 波動度過濾
│   │   ├── BidOfferRatio.xs       # 內外盤比率
│   │   ├── TickVolumeAnalysis.xs  # 詳細內外盤分析
│   │   └── EarlyVolumeRatio.xs    # 早盤成交量比較
│   │
│   └── production/                 # Brooks 函數庫
│       └── (現有的 Brooks 函數)
│
├── alerts/
│   └── combinations/               # 組合策略警示
│       └── MultiModule_EMA_ATR_TickVol_Alert.xs
│
└── indicators/
    └── combinations/               # 組合策略指標
        └── BidOffer_EarlyVol_Monitor_Indicator.xs
```

---

## 模組清單 (Module List)

### 1. PriceAboveEMA (價格位置模組)
**功能**: 檢查價格是否在 EMA 上方指定的 tick 數

**輸入參數**:
- `Price`: 價格序列（通常使用 Close）
- `EMA_Period`: EMA 週期（預設 20）
- `MinTicksAbove`: 必須高於 EMA 幾個 tick（預設 2）

**返回值**: 
- `1` = 價格在 EMA 上方且超過最小距離
- `0` = 不符合條件

**使用範例**:
```xqscript
IsAbove = PriceAboveEMA(Close, 20, 2);
if IsAbove = 1 then
    // 價格在 20EMA 上方至少 2 ticks
```

---

### 2. ATRMeasurement (ATR 計算模組)
**功能**: 計算 Average True Range（平均真實範圍）

**輸入參數**:
- `ATR_Period`: ATR 週期（預設 14）

**返回值**: ATR 數值

**使用範例**:
```xqscript
ATR_Val = ATRMeasurement(14);
// 用於設定止損或判斷波動度
StopLoss = Close - (2 * ATR_Val);
```

---

### 3. ATRFilter (ATR 波動度過濾)
**功能**: 檢查當前 K 棒的波動度是否在合理範圍內

**輸入參數**:
- `ATR_Period`: ATR 週期（預設 14）
- `MinATR_Multiple`: 最小 ATR 倍數（預設 0.5）
- `MaxATR_Multiple`: 最大 ATR 倍數（預設 2.0）

**返回值**: 
- `1` = 波動度在合理範圍內
- `0` = 波動度過高或過低

**說明**: 過濾掉波動過小（盤整）或過大（異常）的 K 棒

**使用範例**:
```xqscript
IsValidVol = ATRFilter(14, 0.5, 2.0);
if IsValidVol = 1 then
    // 波動度正常，可以交易
```

---

### 4. BidOfferRatio (內外盤比率)
**功能**: 計算買賣盤壓力（外盤 vs 內盤）

**輸入參數**:
- `LookbackBars`: 回顧 K 棒數量（預設 5）

**返回值**: 淨壓力分數（-1 到 +1）
- `> 0` = 買盤主導（外盤多）
- `< 0` = 賣盤主導（內盤多）
- `0.5` = 買賣平衡

**使用範例**:
```xqscript
Pressure = BidOfferRatio(5);
if Pressure > 0.3 then
    // 買盤佔 65% 以上，強勢
```

---

### 5. TickVolumeAnalysis (詳細內外盤分析)
**功能**: 綜合分析內外盤成交次數和成交量

**輸入參數**:
- `LookbackBars`: 回顧 K 棒數量（預設 5）

**返回值**: 壓力分數（-1 到 +1）
- 同時考慮成交次數和成交量
- 可分析平均單量大小

**使用範例**:
```xqscript
DetailedPressure = TickVolumeAnalysis(5);
if DetailedPressure > 0.4 then
    // 主動買盤強勁
```

---

### 6. EarlyVolumeRatio (早盤成交量比較)
**功能**: 比較今日早盤成交量與昨日同時段

**輸入參數**:
- `MinutesFromOpen`: 開盤後幾分鐘（預設 10）
- `BarInterval`: K 棒週期分鐘數（預設 5）

**返回值**: 成交量增長百分比
- `0.20` = 今日比昨日多 20%
- `-0.10` = 今日比昨日少 10%

**使用範例**:
```xqscript
VolIncrease = EarlyVolumeRatio(10, 5);
if VolIncrease > 0.20 then
    // 今日前 10 分鐘成交量比昨日高 20% 以上
```

---

## 組合策略範例 (Strategy Examples)

### 範例 1: 簡單 EMA + ATR 突破

```xqscript
{@type:sensor}
settotalbar(250);

var: IsAbove(0), IsValidVol(0);

if CurrentBar > 20 then begin
    IsAbove = PriceAboveEMA(Close, 20, 2);
    IsValidVol = ATRFilter(14, 0.5, 2.0);
    
    if (IsAbove = 1) and (IsValidVol = 1) and (Close > Open) then
        ret = 1
    else
        ret = 0;
end;
```

### 範例 2: EMA + 內外盤確認

```xqscript
{@type:sensor}
settotalbar(250);

var: IsAbove(0), BuyPressure(0);

if CurrentBar > 20 then begin
    IsAbove = PriceAboveEMA(Close, 20, 2);
    BuyPressure = BidOfferRatio(5);
    
    if (IsAbove = 1) and (BuyPressure > 0.3) then
        ret = 1  // 價格在 EMA 上方且買盤主導
    else
        ret = 0;
end;
```

### 範例 3: 早盤突破 + 高成交量

```xqscript
{@type:sensor}
settotalbar(250);

var: VolIncrease(0), IsBreakout(false);

if CurrentBar > 20 then begin
    VolIncrease = EarlyVolumeRatio(10, 5);
    IsBreakout = (High > Highest(High[1], 5));
    
    if IsBreakout and (VolIncrease > 0.20) then
        ret = 1  // 突破且早盤量放大
    else
        ret = 0;
end;
```

---

## 完整組合策略 (Full Combined Strategy)

**檔案**: `MultiModule_EMA_ATR_TickVol_Alert.xs`

這個警示結合了所有模組：

1. **價格位置**: 在 20 EMA 上方
2. **波動度**: ATR 在合理範圍內
3. **買賣壓力**: 外盤主導（買方積極）
4. **早盤成交量**: 比昨日高 20% 以上
5. **成交量過濾**: 5 日平均成交量 > 300

**觸發條件**: 所有模組都通過 + 陽線確認

---

## 即時監控指標 (Real-time Monitor)

**檔案**: `BidOffer_EarlyVol_Monitor_Indicator.xs`

這個指標顯示：
- **買盤壓力%**: 0-100%，50% 為中性
- **早盤量增%**: 今日 vs 昨日早盤成交量差異

**顏色說明**:
- 綠色: 買盤強勢（>60%）
- 紅色: 賣盤強勢（<40%）
- 黃色: 中性
- 青色: 早盤量放大（>20%）
- 洋紅: 早盤量萎縮

---

## 如何創建新策略 (How to Create New Strategies)

### 步驟 1: 選擇需要的模組
從模組庫中選擇符合你策略邏輯的模組：
- 價格位置
- 波動度
- 內外盤
- 成交量
- 等等

### 步驟 2: 在警示腳本中組合
```xqscript
{@type:sensor}
settotalbar(250);

var: Module1Result(0), Module2Result(0), Module3Result(0);

if CurrentBar > 20 then begin
    // 呼叫各個模組
    Module1Result = PriceAboveEMA(Close, 20, 2);
    Module2Result = ATRFilter(14, 0.5, 2.0);
    Module3Result = BidOfferRatio(5);
    
    // 組合邏輯
    if (Module1Result = 1) and 
       (Module2Result = 1) and 
       (Module3Result > 0.3) then
        ret = 1
    else
        ret = 0;
end;
```

### 步驟 3: 測試和優化
- 回測不同參數組合
- 調整各模組的權重
- 添加額外的過濾條件

---

## 模組開發指南 (Module Development Guide)

### 創建新模組的原則

1. **單一職責**: 每個模組只做一件事
2. **清晰輸入**: 參數明確且有預設值
3. **標準化輸出**: 
   - 布林型: 返回 0 或 1
   - 數值型: 返回標準化分數（如 -1 到 +1）
4. **錯誤處理**: 處理無效數據和邊界條件
5. **註解完整**: 說明功能、參數、返回值

### 新模組模板

```xqscript
// ===================================================================
// 函數名稱：模組名稱
// 功能描述：簡短描述
// 版本：1.0
// 建立日期：YYYY-MM-DD
// ===================================================================

// === 參數定義 ===
inputs: Parameter1(numericsimple),
        Parameter2(numericsimple);

// === 變數宣告 ===
variables: Variable1(0),
           Variable2(0),
           Result(0);

// === 計算邏輯 ===
// ... 你的計算代碼 ...

// === 返回值 ===
ModuleName = Result;
```

---

## 模組組合參考表 (Module Combination Reference)

| 策略類型 | 推薦模組組合 | 適用市況 |
|---------|------------|---------|
| **趨勢追蹤** | PriceAboveEMA + ATRFilter + BidOfferRatio | 明確趨勢 |
| **突破交易** | ATRFilter + EarlyVolumeRatio + PriceAboveEMA | 盤整後突破 |
| **反轉交易** | BidOfferRatio + TickVolumeAnalysis | 極端壓力 |
| **早盤搶進** | EarlyVolumeRatio + BidOfferRatio | 開盤前 30 分 |
| **保守進場** | 全部模組 | 低風險偏好 |

---

## 參數優化建議 (Parameter Optimization Tips)

### EMA 週期
- **5-10**: 超短線，快速反應
- **20**: 標準日內短線
- **50-60**: 中期趨勢
- **200**: 長期趨勢

### ATR 倍數
- **0.3-0.5**: 超低波動（可能不適合交易）
- **0.5-1.0**: 正常波動
- **1.0-2.0**: 較高波動
- **>2.0**: 異常波動（避免交易）

### 買盤壓力閾值
- **>0.7**: 極強買盤（70% 外盤）
- **>0.6**: 強買盤（60% 外盤）
- **>0.5**: 買盤主導（>50% 外盤）
- **0.4-0.6**: 中性
- **<0.4**: 賣盤主導

### 早盤成交量增長
- **>0.5** (50%): 異常放量，關注度極高
- **>0.3** (30%): 明顯放量
- **>0.2** (20%): 正常放量（預設值）
- **<0**: 成交量萎縮

---

## 常見問題 (FAQ)

**Q: 可以同時使用多個模組嗎？**
A: 可以！這正是模組化設計的優勢。建議從 2-3 個模組開始，逐步增加。

**Q: 模組返回值的意義？**
A: 過濾型模組返回 0/1（通過/不通過），測量型模組返回數值（如壓力分數）。

**Q: 如何測試單個模組？**
A: 將模組函數改為指標類型 `{@type:indicator}`，然後用 `output1()` 顯示返回值。

**Q: 模組執行順序重要嗎？**
A: 不重要，除非後面的模組需要前面模組的結果。建議先執行快速檢查（如價格位置），再執行複雜計算（如內外盤分析）。

**Q: 可以修改模組嗎？**
A: 可以！但建議複製一份再修改，保留原始版本。

---

## 未來擴展 (Future Enhancements)

計劃添加的模組：
- [ ] RSI 超買超賣模組
- [ ] MACD 背離模組
- [ ] 布林帶擠壓模組
- [ ] 成交量價差模組（OBV）
- [ ] 時間過濾模組（交易時段）
- [ ] 多時間週期確認模組
- [ ] 支撐阻力檢測模組

---

## 版本記錄 (Version History)

### v1.0 - 2025-12-19
- ✅ 初始版本
- ✅ 6 個基礎模組
- ✅ 1 個組合策略警示
- ✅ 1 個即時監控指標

---

## 貢獻指南 (Contributing)

如果你創建了新的模組或改進，請：
1. 遵循模組命名規範
2. 添加完整註解
3. 測試多種市況
4. 更新此 README

---

## 聯絡與支援 (Contact & Support)

有問題或建議？
- 參考 `01_scripts/README.md`
- 查看範例腳本
- 測試並實驗不同組合

**記住**: 模組化設計的目的是讓你能快速實驗不同策略，找到最適合你的交易風格！

