# IO Pattern Scripts - 快速入門指南

## 🚀 立即開始使用

你已經有 **5 個腳本** 可以使用！

---

## 📦 腳本清單

| # | 檔案 | 類型 | 用途 |
|---|------|------|------|
| 1 | IOPattern_Indicator_v2.xs | 指標 | 📊 圖表標記（推薦） |
| 2 | IOPattern_Indicator.xs | 指標 | 📊 圖表標記+數值 |
| 3 | **IOPattern_Alert.xs** | 警示 | 🔔 **即時通知** |
| 4 | **IOPattern_Screener.xs** | 選股 | 🔍 **批次掃描** |
| 5 | IOPattern_README.md | 文檔 | 📖 完整說明 |

---

## ⚡ 3分鐘快速設定

### Step 1: 安裝腳本（1分鐘）

```
在 XQ 全球贏家中：

1. 載入指標
   技術分析 → 新增指標 → 選擇檔案 → IOPattern_Indicator_v2.xs

2. 載入警示
   警示系統 → 新增警示 → 選擇檔案 → IOPattern_Alert.xs

3. 載入選股
   選股中心 → 新增選股 → 選擇檔案 → IOPattern_Screener.xs
```

### Step 2: 測試指標（30秒）

```
1. 打開任一股票日線圖
2. 加入 IOPattern_Indicator_v2.xs
3. 應該會看到藍/紅/黃色點標記在某些K棒上方
```

### Step 3: 設定警示（1分鐘）

```
1. 選擇要監控的股票（或全市場）
2. 設定 IOPattern_Alert.xs
3. 參數設定：
   - MinStrength = 2（中等強度以上）
   - UseVolumeFilter = true
   - MinVolumeRatio = 1.2
4. 儲存並啟用
```

### Step 4: 執行選股（30秒）

```
1. 選股中心 → IOPattern_Screener.xs
2. 參數設定：
   - DetectII = true（尋找突破機會）
   - MinStrength = 2
   - UseVolumeFilter = true
3. 執行選股
4. 查看結果清單
```

---

## 🎯 使用場景示例

### 場景 1: 每日選股策略（波段交易）⭐ 推薦

**時間**: 每日收盤後  
**目標**: 找出即將突破的股票

#### 步驟：
```
1. 執行 IOPattern_Screener.xs（日線）
   設定：
   ✓ DetectII = true, DetectOO = false, DetectIOI = false
   ✓ MinStrength = 2
   ✓ UseVolumeFilter = true
   ✓ MinVolumeRatio = 1.0
   
2. 檢視選股結果（通常 10-30 檔）
   - 依強度排序
   - 量比 > 1.2 的優先
   
3. 逐一查看圖表
   - 加入 IOPattern_Indicator_v2.xs
   - 確認 II 型態位置
   - 檢查是否在趨勢中或支撐位
   
4. 設定警示
   - 對看好的 5-10 檔設定 IOPattern_Alert.xs
   - MinStrength = 2
   - 等待突破訊號
   
5. 進場時機
   - 收到警示 → 開盤觀察
   - 突破型態高點 → 進場
   - 止損：型態低點
```

**預期結果**: 每週 2-5 個交易機會

---

### 場景 2: 日內交易監控

**時間**: 盤中即時  
**目標**: 捕捉日內波段

#### 步驟：
```
1. 早盤執行 IOPattern_Screener.xs（15分線）
   設定：
   ✓ DetectII = true
   ✓ MinStrength = 2
   ✓ UseVolumeFilter = true
   ✓ MinVolumeRatio = 1.5
   
2. 選出 5-10 檔活躍股票
   
3. 多視窗監控
   - 每檔都掛 IOPattern_Indicator_v2.xs
   - 設定 IOPattern_Alert.xs
   
4. 等待警示
   - 收到 II 型態警示
   - 下一根K棒突破 → 進場
   - 當日收盤前出場
```

**預期結果**: 每日 1-3 個短線機會

---

### 場景 3: 長線選股

**時間**: 每週/每月  
**目標**: 找出重要轉折點

#### 步驟：
```
1. 週末執行 IOPattern_Screener.xs（週線）
   設定：
   ✓ 所有型態都選（DetectOO/II/IOI = true）
   ✓ MinStrength = 1（捕捉所有訊號）
   ✓ UseVolumeFilter = false
   
2. 檢視結果（通常 5-15 檔）
   - 週線型態較少但重要
   
3. 深入研究
   - 查看基本面
   - 檢查產業位置
   - 確認長期趨勢
   
4. 建立觀察清單
   - 設定 IOPattern_Alert.xs（週線）
   - 耐心等待進場點
```

**預期結果**: 每月 1-2 個長線機會

---

## 🔔 IOPattern_Alert.xs - 警示腳本

### 功能
✅ 即時監控 IO 型態  
✅ 可監控單一股票或全市場  
✅ 自動發送通知（彈窗/聲音/推播）  
✅ 包含強度和量比資訊  

### 參數說明

| 參數 | 預設值 | 說明 | 建議設定 |
|------|--------|------|----------|
| DetectOO | true | 偵測OO型態 | 依需求 |
| DetectII | true | 偵測II型態 | true（突破機會） |
| DetectIOI | true | 偵測IOI型態 | 依需求 |
| MinStrength | 1 | 最小強度 | 2（減少雜訊） |
| AlertOncePerBar | true | 每根K棒只警示一次 | true |
| UseVolumeFilter | false | 使用量能過濾 | true（建議） |
| MinVolumeRatio | 1.0 | 最小量比 | 1.2-1.5 |

### 警示訊息範例

```
【IO型態警示】2330 偵測到 II(內包-內包) (強度:強) 量比:1.45 時間:1330 價:585.00
【IO型態警示】0050 偵測到 OO(外包-外包) (強度:中) 量比:1.12 時間:1015 價:138.50
【IO型態警示】2454 偵測到 IOI(內-外-內) (強度:中) 時間:1425 價:425.50
```

### 使用技巧

#### 技巧 1: 分層設定
```
第1層（寬鬆）：
  - MinStrength = 1
  - 監控觀察清單
  - 提早注意

第2層（嚴格）：
  - MinStrength = 3
  - UseVolumeFilter = true
  - 只接收最強訊號
```

#### 技巧 2: 多時間週期
```
短線：5分 + 15分
波段：60分 + 日線
長線：週線 + 月線

同時監控 → 訊號共振時進場
```

#### 技巧 3: 搭配其他條件
```
收到警示後確認：
✓ 趨勢方向（EMA）
✓ 支撐壓力位
✓ 成交量確認
✓ 大盤狀態

全部符合 → 進場機率高
```

---

## 🔍 IOPattern_Screener.xs - 選股腳本

### 功能
✅ 批次掃描全市場  
✅ 篩選符合 IO 型態的股票  
✅ 7個輸出欄位可排序  
✅ 支援強度和量能過濾  

### 參數說明

| 參數 | 預設值 | 說明 | 建議設定 |
|------|--------|------|----------|
| DetectOO | true | 選出OO型態 | 依策略 |
| DetectII | true | 選出II型態 | true（最常用） |
| DetectIOI | true | 選出IOI型態 | 依策略 |
| MinStrength | 1 | 最小強度 | 2（減少雜訊） |
| UseVolumeFilter | false | 使用量能過濾 | true（建議） |
| MinVolumeRatio | 1.0 | 最小量比 | 1.0-1.2 |
| SortByStrength | true | 依強度排序 | true |

### 輸出欄位

| 欄位 | 內容 | 數值 | 用途 |
|------|------|------|------|
| OutputField1 | IO型態 | 1=II, 2=OO, 3=IOI | 型態類型 |
| OutputField2 | 型態強度 | 1=弱, 2=中, 3=強 | 排序用 |
| OutputField3 | OO型態 | 0/1 | 篩選用 |
| OutputField4 | II型態 | 0/1 | 篩選用 |
| OutputField5 | IOI型態 | 0/1 | 篩選用 |
| OutputField6 | 量比 | 數值 | 排序用 |
| OutputField7 | 收盤價 | 數值 | 參考 |

### 選股策略範例

#### 策略 1: II型態突破選股（最常用）
```
目標：找出盤整收斂、即將突破的股票

參數設定：
- DetectII = true
- DetectOO = false
- DetectIOI = false
- MinStrength = 2
- UseVolumeFilter = true
- MinVolumeRatio = 1.0
- SortByStrength = true

後續動作：
1. 依強度排序（強→弱）
2. 優先看量比 > 1.2 的
3. 確認在趨勢中或支撐位
4. 設定警示等待突破
```

#### 策略 2: OO型態趨勢加速選股
```
目標：找出波動擴大、趨勢加速的股票

參數設定：
- DetectOO = true
- DetectOO = false
- DetectIOI = false
- MinStrength = 2
- UseVolumeFilter = true
- MinVolumeRatio = 1.5（高量能）
- SortByStrength = true

後續動作：
1. 確認明確趨勢存在
2. OO型態方向與趨勢一致
3. 順勢進場
4. 移動止損
```

#### 策略 3: 全型態掃描（進階）
```
目標：不遺漏任何型態機會

參數設定：
- DetectOO = true
- DetectII = true
- DetectIOI = true
- MinStrength = 2
- UseVolumeFilter = true
- MinVolumeRatio = 1.0
- SortByStrength = true

後續動作：
1. 查看各型態分佈
2. 依市場狀態選擇
3. 趨勢市場 → OO/II
4. 盤整市場 → IOI（反轉）
```

---

## 📊 完整工作流程

### 波段交易者（推薦流程）

```
週期：日線
頻率：每日收盤後

🔍 選股階段
1. 執行 IOPattern_Screener.xs
   - DetectII = true
   - MinStrength = 2
   - UseVolumeFilter = true
   ↓
2. 產生 10-30 檔候選股票
   ↓
3. 依強度和量比排序
   ↓
4. 選出 TOP 5-10 檔

📊 確認階段
5. 打開個股圖表
   - 加入 IOPattern_Indicator_v2.xs
   ↓
6. 確認型態位置
   - 在趨勢中？
   - 在支撐/壓力位？
   - 其他技術指標確認
   ↓
7. 篩選出 3-5 檔最佳標的

🔔 監控階段
8. 設定 IOPattern_Alert.xs
   - MinStrength = 2
   - UseVolumeFilter = true
   ↓
9. 等待突破訊號
   ↓
10. 收到警示 → 開盤觀察 → 突破確認 → 進場

💰 交易階段
11. 進場價：突破型態高點
12. 止損價：型態低點
13. 停利價：2倍型態高度
14. 持有：直到停利/停損或型態改變
```

---

## 💡 實戰範例

### 範例 1: 台積電 (2330) II型態突破

```
日期：2024/12/10

選股結果：
- IO型態：1 (II)
- 型態強度：3 (強)
- 量比：1.35

圖表確認：
✓ 連續兩根內包（580-590區間）
✓ 在日線20EMA上方
✓ 盤整後收斂

警示訊息：
【IO型態警示】2330 偵測到 II(內包-內包) (強度:強) 量比:1.35 時間:1330 價:585.00

交易計畫：
進場：591（突破型態高點）
止損：579（型態低點）
停利：603（2倍型態高度：12點）
結果：595 出場，獲利4點
```

### 範例 2: 聯發科 (2454) OO型態趨勢加速

```
日期：2024/12/15

選股結果：
- IO型態：2 (OO)
- 型態強度：2 (中)
- 量比：1.58

圖表確認：
✓ 連續兩根外包（波動擴大）
✓ 上升趨勢中
✓ 突破前高

警示訊息：
【IO型態警示】2454 偵測到 OO(外包-外包) (強度:中) 量比:1.58 時間:1015 價:1250

交易計畫：
進場：1255（順勢進場）
止損：移動止損（每日更新）
停利：趨勢反轉訊號
結果：持有中，+8%
```

---

## ⚙️ 常見問題 FAQ

### Q1: 選股結果太多怎麼辦？
```
A: 提高篩選標準
   - MinStrength = 3（只看強型態）
   - MinVolumeRatio = 1.5（高量能）
   - 單獨選擇一種型態（如只選II）
```

### Q2: 選股結果太少或沒有？
```
A: 放寬篩選標準
   - MinStrength = 1（接受弱型態）
   - UseVolumeFilter = false（關閉量能過濾）
   - 全選型態（OO/II/IOI都選）
```

### Q3: 警示太頻繁怎麼辦？
```
A: 調整警示參數
   - MinStrength = 3（只警示強型態）
   - UseVolumeFilter = true（開啟量能過濾）
   - MinVolumeRatio = 1.5（提高量能門檻）
   - 或換到較長週期（15分→60分→日線）
```

### Q4: 警示太少怎麼辦？
```
A: 放寬警示條件
   - MinStrength = 1（接受所有強度）
   - UseVolumeFilter = false（關閉過濾）
   - 監控更多股票
   - 或換到較短週期（日線→60分→15分）
```

### Q5: 如何判斷型態的可靠性？
```
A: 綜合判斷
   ✓ 型態強度（強 > 中 > 弱）
   ✓ 成交量配合（放量 > 縮量）
   ✓ 趨勢方向（順勢 > 逆勢）
   ✓ 關鍵位置（支撐壓力位 > 一般位置）
   ✓ 時間週期（長週期 > 短週期）
```

---

## 🎯 成功使用的關鍵

### ✅ DO - 應該做的

1. **系統化使用**
   - 每天固定時間執行選股
   - 持續追蹤觀察清單
   - 記錄交易結果

2. **配合其他分析**
   - 趨勢指標（EMA）
   - 支撐壓力位
   - 成交量分析
   - 基本面確認（波段）

3. **風險控制**
   - 每個交易都設止損
   - 控制單一持倉比例
   - 不過度交易

4. **持續優化**
   - 回顧交易記錄
   - 調整參數設定
   - 適應市場變化

### ❌ DON'T - 不應該做的

1. **過度依賴**
   - ❌ 型態不是聖杯
   - ❌ 不是每個型態都成功
   - ❌ 需要配合其他分析

2. **忽略風險**
   - ❌ 不設止損
   - ❌ 重倉單一股票
   - ❌ 逆勢交易

3. **頻繁調整**
   - ❌ 每天改參數
   - ❌ 追求完美設定
   - ❌ 看到虧損就換策略

4. **情緒化交易**
   - ❌ 沒有警示就進場
   - ❌ 虧損加碼攤平
   - ❌ 獲利立刻出場（太早）

---

## 📚 進階學習

### 建議閱讀順序

1. **IOPattern_README.md**（完整說明）
   - 型態詳細解釋
   - 交易策略
   - 參數設定指南

2. **IOPattern_SUMMARY.md**（快速參考）
   - 語法說明
   - 問題解決
   - 版本比較

3. **IOPattern_PlotSyntax_Explanation.md**（技術細節）
   - Plot 語法說明
   - 技術實作
   - 進階自訂

4. **Price Action 文檔系列**
   - 理論基礎
   - 市場心理
   - 進階型態

---

## 🎉 開始你的 IO Pattern 交易之旅！

### 今天就開始

1. ✅ 安裝三個腳本（指標/警示/選股）
2. ✅ 執行一次選股，看看結果
3. ✅ 打開圖表，加入指標
4. ✅ 設定警示，等待訊號
5. ✅ 模擬交易一週，熟悉流程

### 一週後

1. ✅ 檢視模擬交易結果
2. ✅ 調整參數設定
3. ✅ 開始小額實盤
4. ✅ 持續記錄和學習

### 一個月後

1. ✅ 建立自己的參數組合
2. ✅ 形成穩定的交易流程
3. ✅ 逐步增加交易規模
4. ✅ 享受系統化交易的樂趣

---

**記住**: 
- 🎯 耐心等待高勝率設定
- 🎯 嚴格執行風險控制
- 🎯 持續學習和優化
- 🎯 享受交易過程

**祝你交易順利！** 📈✨

---

**需要幫助？**
- 查看 IOPattern_README.md 獲得完整說明
- 參考 IOPattern_SUMMARY.md 快速解決問題
- 閱讀 Price Action 文檔深入學習

