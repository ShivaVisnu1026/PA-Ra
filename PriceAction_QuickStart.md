# Price Action All In One - 快速開始指南

## 🚀 5分鐘快速上手

### 1️⃣ 檔案說明

```
📦 Price Action All In One - XQScript 版本
├── 📄 PriceAction_AllInOne_Indicator.xs    ← 指標版（在圖表上顯示）
├── 📄 PriceAction_AllInOne_Alert.xs        ← 警示版（發送通知）
├── 📖 PriceAction_AllInOne_README.md       ← 完整說明文件
└── 📖 PriceAction_QuickStart.md            ← 本文件（快速開始）
```

### 2️⃣ 立即使用

#### 方案 A：只看圖表指標
```
1. 開啟 XQ 全球贏家
2. 複製 PriceAction_AllInOne_Indicator.xs 內容
3. 新增腳本 → 貼上 → 儲存
4. 在K線圖上加入技術指標
5. 完成！可以看到 EMA 和前日高低點
```

#### 方案 B：接收警示通知（推薦）
```
1. 複製 PriceAction_AllInOne_Alert.xs 內容
2. 新增腳本 → 貼上 → 儲存
3. 在商品上設定警示
4. 完成！當型態出現時會收到通知
```

#### 方案 C：完整體驗（指標 + 警示）
```
1. 匯入兩個腳本（指標版 + 警示版）
2. 圖表上加入指標版（視覺化）
3. 設定警示版（即時通知）
4. 完成！同時擁有視覺和警示功能
```

---

## 📊 預設功能一覽

### 指標版會顯示：
- ✅ 3條 EMA（20期 當前/15分/60分）
- ✅ 前日收盤價（橘色線）
- ✅ 前日高點（紅色線）
- ✅ 前日低點（綠色線）
- ✅ 偵測結果欄位（跳空、IO型態）

### 警示版會通知：
- ✅ 傳統跳空（上漲/下跌）
- ✅ 影線跳空（上漲/下跌）
- ✅ OO 型態（連續外包）
- ✅ II 型態（連續內包）
- ✅ IOI 型態（內外內突破）

---

## ⚙️ 常用參數調整

### 🎯 日內交易（5分鐘K線）
保持預設值即可！

### 🎯 波段交易（日線）
修改以下參數：
```
指標版：
- pv1stTF = "W"  （前週收盤）
- pv2ndTF = "W"  （前週高點）
- pv3rdTF = "W"  （前週低點）
```

### 🎯 只想看 EMA（關閉其他功能）
```
指標版：
- pv1stUse = false
- pv2ndUse = false
- pv3rdUse = false
- detectTraditionalGap = false
- detectTailGap = false
- detectOO = false
- detectII = false
- detectIOI = false
```

### 🎯 只想收到重要警示
```
警示版：
- alertTraditionalGap = true   ← 保留
- alertTailGap = false          ← 關閉（太頻繁）
- alertBodyGap = false          ← 關閉
- alertOO = false               ← 關閉
- alertII = false               ← 關閉
- alertIOI = true               ← 保留（突破型態）
- alertHL = false               ← 關閉
```

---

## 💡 實戰應用場景

### 場景 1：尋找突破點
```
觀察重點：
1. 價格靠近前日高點（紅線）
2. 收到 IOI 型態警示
3. 價格突破前日高點

→ 做多訊號
```

### 場景 2：判斷趨勢強度
```
觀察重點：
1. 價格在 3 條 EMA 之上
2. EMA 呈現多頭排列
3. 出現向上跳空

→ 強勢多頭，可追漲
```

### 場景 3：尋找支撐
```
觀察重點：
1. 價格下跌至前日低點（綠線）
2. 出現 II 型態（盤整收斂）
3. 價格守住前日低點

→ 支撐有效，可做多
```

### 場景 4：避開假突破
```
觀察重點：
1. 價格突破前日高點
2. 但沒有跳空配合
3. 沒有 IOI 型態確認

→ 可能假突破，觀望
```

---

## 🔍 輸出欄位解讀

### 指標版 OutputField

| 欄位名稱 | 數值含義 |
|---------|---------|
| 傳統跳空 | 1=向上, -1=向下, 0=無 |
| IO型態 | 0=無, 1=OO, 2=II, 3=IOI |
| EMA1值 | 當前 EMA 數值 |
| 前日高點 | 前一日最高價 |
| 前日低點 | 前一日最低價 |

### 警示版 OutputField

| 欄位名稱 | 數值含義 |
|---------|---------|
| 跳空類型 | 1/-1=傳統, 2/-2=影線, 3/-3=實體 |
| IO型態 | 0=無, 1=OO, 2=II, 3=IOI |
| H計數 | 當前多頭推進次數 |
| L計數 | 當前空頭推進次數 |

---

## ❓ 常見問題速查

### Q：為什麼沒有看到 EMA 線？
```
A：檢查參數中 emaXstUse 是否為 true
```

### Q：警示太多怎麼辦？
```
A：關閉 alertTailGap 和 alertBodyGap
   只保留 alertTraditionalGap 和 alertIOI
```

### Q：如何只監控特定商品？
```
A：在該商品上單獨設定警示
   不要使用全市場掃描
```

### Q：OutputField 的數字看不懂？
```
A：參考上面的「輸出欄位解讀」表格
```

### Q：可以用在期貨嗎？
```
A：可以！設定方式相同
   建議使用較短週期（1分、3分K線）
```

---

## 📚 進階學習

想了解更多？請查看：
- 📖 **PriceAction_AllInOne_README.md** - 完整功能說明
- 📖 **原始 Pine Script** - https://tw.tradingview.com/script/n78QYp0G-Price-Action-All-In-One/
- 📖 **Al Brooks 價格行為** - 搜尋相關教學資源

---

## ✅ 檢查清單

開始使用前，確認：
- [ ] 已匯入至少一個腳本（指標版或警示版）
- [ ] 理解預設功能（EMA + 前值 + 型態偵測）
- [ ] 知道如何查看 OutputField 數值
- [ ] 了解警示訊息的含義
- [ ] 準備好在實際交易中測試

---

**祝交易順利！** 📈

有問題請參考完整文件：`PriceAction_AllInOne_README.md`

