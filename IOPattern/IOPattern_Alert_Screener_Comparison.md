# Alert vs Screener - 功能比較

## 🔔 IOPattern_Alert.xs vs 🔍 IOPattern_Screener.xs

---

## 📋 基本資訊

| 項目 | Alert (警示) | Screener (選股) |
|------|--------------|-----------------|
| **腳本類型** | `{@type:sensor}` | `{@type:filter}` |
| **檔案大小** | 269 行 | 266 行 |
| **執行方式** | 即時監控 | 批次掃描 |
| **主要用途** | 發送通知 | 篩選股票 |
| **適用對象** | 已知標的監控 | 尋找交易標的 |

---

## ⚙️ 參數比較

### 共同參數

| 參數 | Alert | Screener | 說明 |
|------|-------|----------|------|
| DetectOO | ✅ | ✅ | 偵測OO型態 |
| DetectII | ✅ | ✅ | 偵測II型態 |
| DetectIOI | ✅ | ✅ | 偵測IOI型態 |
| MinStrength | ✅ | ✅ | 最小型態強度 |
| UseVolumeFilter | ✅ | ✅ | 使用成交量過濾 |
| MinVolumeRatio | ✅ | ✅ | 最小量比 |

### 專屬參數

| 參數 | Alert | Screener | 說明 |
|------|-------|----------|------|
| AlertOncePerBar | ✅ | ❌ | 每根K棒只警示一次 |
| SortByStrength | ❌ | ✅ | 依強度排序 |

---

## 💻 核心程式碼比較

### 型態偵測邏輯（相同）

```xs
// 兩個腳本使用完全相同的偵測邏輯

// K棒關係判斷
IsOutside = High >= High[1] and Low <= Low[1] and 
            (High > High[1] or Low < Low[1]);

IsInside = High <= High[1] and Low >= Low[1] and 
           (High < High[1] or Low > Low[1]);

// OO Pattern
if IsOutside and PrevIsOutside then
    PatternOO = true

// II Pattern  
if IsInside and PrevIsInside then
    PatternII = true

// IOI Pattern
if IsInside and PrevIsOutside then
    PatternIOI = true
```

### 強度計算（相同）

```xs
// OO強度：範圍擴大程度
if RangeRatio >= 1.5 then
    PatternStrength = 3  // 強
else if RangeRatio >= 1.2 then
    PatternStrength = 2  // 中
else
    PatternStrength = 1  // 弱

// II強度：範圍收縮程度
if RangeRatio <= 0.5 then
    PatternStrength = 3  // 強
else if RangeRatio <= 0.7 then
    PatternStrength = 2  // 中
else
    PatternStrength = 1  // 弱
```

---

## 🎯 輸出方式（不同）

### Alert 輸出

```xs
// 使用 ret 和 RetMsg
if 符合條件 then begin
    ret = 1;  // 觸發警示
    RetMsg = "【IO型態警示】2330 偵測到 II(內包-內包) (強度:強) 量比:1.45 時間:1330 價:585.00";
end
else begin
    ret = 0;  // 不觸發
end;
```

**輸出結果**：
- 彈窗通知
- 聲音提醒
- 推播訊息（如有設定）

---

### Screener 輸出

```xs
// 使用 ret 和 OutputField
if 符合條件 then
    ret = 1  // 通過篩選
else
    ret = 0;  // 不通過

// 輸出7個欄位
SetOutputName1("IO型態");
OutputField1(PatternType);  // 1=II, 2=OO, 3=IOI

SetOutputName2("型態強度");
OutputField2(PatternStrength, order := true);  // 排序欄位

SetOutputName3("OO型態");
OutputField3(PatternOO ? 1 : 0);

// ... 等等
```

**輸出結果**：
- 股票清單（符合條件的）
- 7個數據欄位
- 可排序、可篩選

---

## 🔍 詳細功能比較

### 1️⃣ 警示控制

| 功能 | Alert | Screener |
|------|-------|----------|
| 即時監控 | ✅ | ❌ |
| 避免重複警示 | ✅ `intrabarpersist` | N/A |
| 自訂警示訊息 | ✅ | ❌ |
| 時間顯示 | ✅ | ❌ |

**Alert 獨有**：
```xs
var: intrabarpersist AlertTriggered(false);  // 避免重複

// 組合訊息
AlertMessage = Text(
    "【IO型態警示】",
    GetSymbol(),
    " 偵測到 ", PatternName,
    " (強度:", StrengthText, ")",
    VolumeText,
    " 時間:", TimeText,
    " 價:", NumToStr(Close, 2)
);

// K棒結束後重置
if CurrentBar <> CurrentBar[1] then
    AlertTriggered = false;
```

---

### 2️⃣ 資料輸出

| 功能 | Alert | Screener |
|------|-------|----------|
| 輸出文字訊息 | ✅ | ❌ |
| 輸出數值欄位 | ❌ | ✅ (7欄) |
| 可排序 | ❌ | ✅ |
| 可批次處理 | ❌ | ✅ |

**Screener 獨有**：
```xs
// 7個輸出欄位
OutputField1(PatternType);        // 型態類型
OutputField2(PatternStrength);    // 強度（排序）
OutputField3(PatternOO ? 1 : 0);  // OO標記
OutputField4(PatternII ? 1 : 0);  // II標記
OutputField5(PatternIOI ? 1 : 0); // IOI標記
OutputField6(VolumeRatio);        // 量比
OutputField7(Close);              // 收盤價
```

---

## 🎯 使用場景

### Alert 適合：

✅ **已知標的監控**
```
場景：你已經有 10 檔觀察清單
需求：當出現 IO 型態時立即通知
操作：設定 Alert 監控這 10 檔
結果：收到通知 → 開盤觀察 → 進場
```

✅ **即時交易**
```
場景：日內交易，需要快速反應
需求：5-15分鐘出現型態立刻知道
操作：設定 Alert 在活躍標的上
結果：收到警示 → 立即查看 → 快速決策
```

✅ **多時間週期監控**
```
場景：同時監控日線和60分線
需求：任一週期出現型態都通知
操作：設定兩個 Alert（不同週期）
結果：訊號共振時進場機會大
```

---

### Screener 適合：

✅ **尋找交易標的**
```
場景：不知道該交易什麼股票
需求：從全市場找出符合型態的
操作：每日收盤後執行 Screener
結果：產生 10-30 檔候選清單
```

✅ **定期選股**
```
場景：每週選出波段交易標的
需求：找出強勢突破機會
操作：週末執行 Screener（週線）
結果：下週重點觀察名單
```

✅ **策略回測**
```
場景：想知道歷史上哪些股票出現過型態
需求：批次掃描過去資料
操作：在歷史日期執行 Screener
結果：統計型態出現頻率和後續表現
```

---

## 🔄 搭配使用流程

### 最佳工作流程

```
Step 1: 用 Screener 選股（每日/週）
   ↓
   產生候選清單（10-30檔）
   ↓
Step 2: 用 Indicator 確認（逐一查看）
   ↓
   篩選出最佳標的（3-5檔）
   ↓
Step 3: 用 Alert 監控（設定警示）
   ↓
   等待進場訊號
   ↓
Step 4: 收到 Alert → 進場
```

### 實際範例

```
週日晚上：
1. 執行 IOPattern_Screener.xs（日線）
   - DetectII = true
   - MinStrength = 2
   - 結果：選出 15 檔股票

2. 逐一查看圖表（加 Indicator）
   - 確認型態位置
   - 檢查趨勢方向
   - 結果：篩選出 5 檔

3. 設定 IOPattern_Alert.xs
   - 監控這 5 檔
   - MinStrength = 2
   - 等待突破訊號

週一到週五：
4. 收到警示
   - 【IO型態警示】2330 偵測到 II(內包-內包) (強度:強)...
   - 開盤觀察
   - 突破確認後進場
```

---

## 📊 效能比較

| 項目 | Alert | Screener |
|------|-------|----------|
| **執行頻率** | 即時（每根K棒） | 手動執行 |
| **資源消耗** | 中（持續運行） | 低（僅執行時） |
| **適合檔數** | 10-50 檔 | 全市場（數千檔） |
| **回應速度** | 極快（秒級） | 較慢（需掃描全部） |

---

## 💡 參數設定建議

### Alert 參數（依時間週期）

```
1分-5分線（當沖）：
- MinStrength = 3（只警示強型態）
- UseVolumeFilter = true
- MinVolumeRatio = 1.5
- AlertOncePerBar = true

15分-30分線（日內波段）：
- MinStrength = 2
- UseVolumeFilter = true
- MinVolumeRatio = 1.2
- AlertOncePerBar = true

60分-日線（波段）：
- MinStrength = 1（捕捉所有）
- UseVolumeFilter = false
- AlertOncePerBar = true

週線-月線（長線）：
- MinStrength = 1
- UseVolumeFilter = false
- AlertOncePerBar = true
```

### Screener 參數（依策略）

```
尋找突破機會（II型態）：
- DetectII = true, 其他 = false
- MinStrength = 2
- UseVolumeFilter = true
- MinVolumeRatio = 1.0
- SortByStrength = true

尋找趨勢加速（OO型態）：
- DetectOO = true, 其他 = false
- MinStrength = 2
- UseVolumeFilter = true
- MinVolumeRatio = 1.5
- SortByStrength = true

尋找所有型態：
- 全部 = true
- MinStrength = 2
- UseVolumeFilter = true
- MinVolumeRatio = 1.0
- SortByStrength = true
```

---

## 🐛 常見問題

### Alert 相關

**Q: 警示太頻繁？**
```
A: 提高門檻
   - MinStrength = 3
   - MinVolumeRatio = 1.5
   - 或換到較長週期
```

**Q: 沒收到警示？**
```
A: 檢查設定
   - Alert 是否啟用
   - 參數是否過嚴
   - 股票是否有資料
```

**Q: 同一根K棒重複警示？**
```
A: 應該不會
   - AlertOncePerBar = true（預設）
   - intrabarpersist 機制防止重複
```

### Screener 相關

**Q: 選股結果為空？**
```
A: 放寬條件
   - MinStrength = 1
   - UseVolumeFilter = false
   - 檢查市場是否低波動期
```

**Q: 選股結果太多？**
```
A: 提高門檻
   - MinStrength = 3
   - MinVolumeRatio = 1.5
   - 只選單一型態
```

**Q: 如何只選 II 型態？**
```
A: 調整參數
   - DetectII = true
   - DetectOO = false
   - DetectIOI = false
```

---

## ✅ 總結

### Alert 特點
- ✅ 即時監控
- ✅ 自動通知
- ✅ 詳細訊息
- ✅ 適合已知標的
- ❌ 不能批次掃描
- ❌ 無法回測

### Screener 特點
- ✅ 批次掃描
- ✅ 全市場搜尋
- ✅ 可排序篩選
- ✅ 適合尋找標的
- ❌ 不是即時
- ❌ 需手動執行

### 搭配使用最強
```
Screener 找標的 → Indicator 確認 → Alert 監控 → 收到通知進場
```

---

**兩個腳本各有優勢，搭配使用效果最好！** 🎉

