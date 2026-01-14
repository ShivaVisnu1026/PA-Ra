# IO Pattern Scripts - 完整解決方案

## ✅ 已修正的問題

### 問題 1: Plot 函數語法錯誤
**錯誤訊息**: "3rd variable cannot be String"

**原因**: XQScript 的 `plot()` 函數不接受字串參數作為第三個參數

**修正前**:
```xs
plot1(PatternType > 0, PatternType, "IO型態類型");  // ❌ 錯誤
```

**修正後**:
```xs
plot1(PatternType > 0, PatternType);  // ✅ 正確
```

### 問題 2: Indicator 不能使用 OutputField
**錯誤訊息**: "Indicator cannot use SetOutputName, OutputField"

**原因**: 
- `{@type:indicator}` (指標) 只能使用 `plot()` 函數繪圖
- `{@type:filter}` (選股) 才能使用 `SetOutputName()` 和 `OutputField()` 函數

**解決方案**: 創建獨立的選股腳本 `IOPattern_Screener.xs`

---

## 📦 完整解決方案：三個腳本

### 1️⃣ IOPattern_Indicator.xs
**類型**: `{@type:indicator}` 指標  
**用途**: 在圖表上視覺化顯示 IO 型態  

**功能**:
- ✅ Plot1: 型態類型數值 (0/1/2/3)
- ✅ Plot2: 型態強度數值 (0/1/2/3)
- ✅ Plot3-5: 在K棒上方標記型態
- ✅ 計算型態強度（弱/中/強）
- ✅ 適用所有時間週期

**使用場景**: 
- 技術分析圖表
- 視覺化確認型態
- 配合其他指標判斷

---

### 2️⃣ IOPattern_Alert.xs
**類型**: `{@type:sensor}` 警示  
**用途**: 偵測到 IO 型態時發送警示通知  

**功能**:
- ✅ 即時監控 OO/II/IOI 型態
- ✅ 型態強度過濾（MinStrength）
- ✅ 成交量過濾（可選）
- ✅ 每根K棒只警示一次
- ✅ 詳細的警示訊息

**警示訊息範例**:
```
【IO型態警示】2330 偵測到 II(內包-內包) (強度:強) 量比:1.45 時間:1330 價:585.00
```

**使用場景**:
- 監控持倉股票
- 捕捉交易機會
- 多檔股票即時監控

---

### 3️⃣ IOPattern_Screener.xs
**類型**: `{@type:filter}` 選股  
**用途**: 批次掃描全市場，篩選符合 IO 型態的股票  

**功能**:
- ✅ 批次掃描全市場
- ✅ 篩選符合條件的股票
- ✅ 7 個輸出欄位供排序
- ✅ 依強度或類型排序
- ✅ 成交量過濾選項

**輸出欄位**:
1. IO型態 (1=II, 2=OO, 3=IOI)
2. 型態強度 (1=弱, 2=中, 3=強)
3. OO型態 (0/1)
4. II型態 (0/1)
5. IOI型態 (0/1)
6. 量比
7. 收盤價

**使用場景**:
- 每日收盤後選股
- 尋找交易標的
- 建立觀察清單

---

## 🎯 IO 型態快速參考

### OO (Outside-Outside) 連續外包
```
特徵: 連續兩根K棒，後者包住前者
意義: 波動擴大，趨勢加速或即將反轉
策略: 觀察突破方向，順勢交易
```

### II (Inside-Inside) 連續內包
```
特徵: 連續兩根K棒，後者被前者包住
意義: 盤整收斂，通常預示突破
策略: 等待突破確認，窄止損
```

### IOI (Inside-Outside-Inside) 內外內
```
特徵: 內包→外包→內包的組合
意義: 假突破或洗盤
策略: 謹慎對待，等待更多確認
```

---

## 💻 安裝與使用

### 快速安裝
```
1. 指標：技術分析 → 新增指標 → 匯入 IOPattern_Indicator.xs
2. 警示：警示系統 → 新增警示 → 匯入 IOPattern_Alert.xs
3. 選股：選股中心 → 新增選股 → 匯入 IOPattern_Screener.xs
```

### 建議工作流程

#### 🔍 步驟 1: 選股（每日收盤後）
```
使用 IOPattern_Screener.xs
- DetectII = true（尋找突破機會）
- MinStrength = 2（中等以上）
- UseVolumeFilter = true
- MinVolumeRatio = 1.2
→ 產生觀察清單
```

#### 📊 步驟 2: 確認（查看圖表）
```
使用 IOPattern_Indicator.xs
- 在選出的股票圖表上加入指標
- 確認型態位置和強度
- 配合趨勢、支撐壓力判斷
→ 確定潛在交易標的
```

#### 🔔 步驟 3: 監控（設定警示）
```
使用 IOPattern_Alert.xs
- 對確定的標的設定警示
- MinStrength = 2
- UseVolumeFilter = true
→ 等待進場訊號
```

---

## ⚙️ 不同時間週期的參數建議

### 1-5 分鐘線（當沖）
```
Indicator: 啟用所有型態
Alert: MinStrength=3, UseVolumeFilter=true, MinVolumeRatio=1.5
Screener: 不建議（雜訊太多）
```

### 15-30 分鐘線（日內波段）
```
Indicator: 啟用所有型態
Alert: MinStrength=2, UseVolumeFilter=true, MinVolumeRatio=1.2
Screener: MinStrength=2, UseVolumeFilter=true
```

### 60 分鐘線（短波段）
```
Indicator: 啟用所有型態
Alert: MinStrength=2, UseVolumeFilter=false
Screener: MinStrength=2, UseVolumeFilter=true
```

### 日線（波段交易）⭐ 最推薦
```
Indicator: 啟用所有型態
Alert: MinStrength=1, UseVolumeFilter=false
Screener: MinStrength=2, UseVolumeFilter=true, MinVolumeRatio=1.0
```

### 週線/月線（長線投資）
```
Indicator: 啟用所有型態
Alert: MinStrength=1, UseVolumeFilter=false
Screener: MinStrength=1, UseVolumeFilter=false
```

---

## 📈 實戰策略範例

### 策略 1: II 型態突破交易（成功率高）
```
1. 選股條件:
   - DetectII = true
   - MinStrength = 2
   - UseVolumeFilter = true
   
2. 進場條件:
   - II 型態形成
   - 在支撐位或趨勢中出現
   - 第 4 根 K 棒突破型態高/低點
   - 突破伴隨放量
   
3. 出場條件:
   - 止損: 型態另一端
   - 停利: 2 倍型態高度
   
4. 風險: 突破失敗
```

### 策略 2: OO 型態趨勢加速（大波段）
```
1. 選股條件:
   - DetectOO = true
   - MinStrength = 2
   - MinVolumeRatio = 1.5
   
2. 進場條件:
   - 明確趨勢中出現 OO
   - 第 3 根 K 棒確認方向
   - 順勢進場
   
3. 出場條件:
   - 移動止損
   - 趨勢反轉訊號
   
4. 風險: 可能是反轉前兆
```

### 策略 3: IOI 型態反轉交易（進階）
```
1. 選股條件:
   - DetectIOI = true
   - MinStrength = 2
   
2. 進場條件:
   - 在關鍵支撐/壓力出現 IOI
   - 判斷為假突破
   - 反向進場
   
3. 出場條件:
   - 嚴格止損（型態突破端）
   - 快速獲利了結
   
4. 風險: 較高，需經驗
```

---

## 🔧 語法變更說明（技術細節）

### Plot 函數修正
```xs
// ❌ 修正前（錯誤）
plot1(PatternType > 0, PatternType, "IO型態類型");

// ✅ 修正後（正確）
plot1(PatternType > 0, PatternType);
```

**原因**: XQScript 的 plot 函數語法為 `plot(條件, 值)`，不接受第三個字串參數。

### OutputField 功能分離
```xs
// ❌ 在 Indicator 中（錯誤）
{@type:indicator}
SetOutputName1("IO型態");
OutputField1(PatternType);

// ✅ 創建獨立的 Screener（正確）
{@type:filter}
SetOutputName1("IO型態");
OutputField1(PatternType);
```

**原因**: 
- Indicator 類型只能使用 `plot()` 繪圖
- Filter/Screener 類型才能使用 `OutputField()` 輸出數據

---

## 📚 檔案清單

| 檔案 | 類型 | 大小 | 用途 |
|------|------|------|------|
| IOPattern_Indicator.xs | 指標 | ~7KB | 圖表視覺化 |
| IOPattern_Alert.xs | 警示 | ~8KB | 即時通知 |
| IOPattern_Screener.xs | 選股 | ~7KB | 批次掃描 |
| IOPattern_README.md | 文檔 | ~25KB | 完整使用說明 |
| IOPattern_SUMMARY.md | 文檔 | ~6KB | 快速參考（本檔） |

---

## ✅ 語法檢查清單

### IOPattern_Indicator.xs
- ✅ 腳本類型: `{@type:indicator}` 
- ✅ Plot 函數: 無第三參數
- ✅ 移除所有 OutputField 函數
- ✅ 變數宣告: `var:` 語法正確
- ✅ 無保留字衝突
- ✅ settotalbar 位置正確

### IOPattern_Alert.xs
- ✅ 腳本類型: `{@type:sensor}`
- ✅ 使用 `ret` 和 `RetMsg`
- ✅ intrabarpersist 使用正確
- ✅ 無 OutputField 函數
- ✅ 警示訊息格式正確

### IOPattern_Screener.xs
- ✅ 腳本類型: `{@type:filter}`
- ✅ 使用 `ret` 返回選股結果
- ✅ 正確使用 SetOutputName 和 OutputField
- ✅ order 參數語法正確
- ✅ 所有邏輯完整

---

## 🎓 學習資源

### 推薦閱讀順序
1. **IOPattern_README.md** - 完整使用說明（必讀）
2. **本檔案** - 快速參考
3. **腳本源碼** - 學習實作細節
4. **Price Action 相關文檔** - 深入理解理論

### 延伸學習
- Al Brooks - Reading Price Charts Bar by Bar
- 本專案的 Price Action 系列文檔
- XQScript 語法參考（GR 資料夾）

---

## 🐛 故障排除

### 問題: 指標顯示但沒有標記
**原因**: 可能沒有符合型態條件  
**解決**: 檢查參數設定，或換個時間週期/股票測試

### 問題: 警示太多或太少
**調整**:
- 太多 → 提高 MinStrength，啟用 UseVolumeFilter
- 太少 → 降低 MinStrength，關閉過濾器

### 問題: 選股結果為空
**檢查**:
- 是否設定了過於嚴格的條件
- 市場是否處於低波動期間
- 試著降低 MinStrength 或關閉成交量過濾

### 問題: 編譯錯誤
**確認**:
- 使用最新版本的腳本
- 檢查是否完整複製代碼
- 確認 XQ 全球贏家版本支援

---

## 📞 支援與回饋

如有問題或建議，請參考：
- **IOPattern_README.md** 的常見問題章節
- **GR 資料夾** 的語法參考文檔
- **專案主 README** 了解專案架構

---

## 📝 版本資訊

**版本**: v1.0  
**日期**: 2024-12-17  
**狀態**: ✅ 生產就緒（Production Ready）

**變更記錄**:
- ✅ 從 PriceAction_AllInOne 提取 IO 型態功能
- ✅ 創建三個獨立腳本（指標/警示/選股）
- ✅ 修正 XQScript 語法錯誤
- ✅ 支援所有時間週期
- ✅ 完整文檔和使用範例

---

**祝交易順利！** 📈✨

記住：
1. 🎯 型態只是工具，不是聖杯
2. 🛡️ 永遠設定止損
3. 📊 配合趨勢和支撐壓力判斷
4. 💰 控制倉位和風險
5. 📚 持續學習和優化

