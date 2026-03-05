# XScript 專案維護指南

> 本指南說明如何維護和更新此專案，確保 AI 能夠持續學習並提供高品質的協助

---

## 🎯 維護目標

1. **保持資訊最新**：及時更新學習資源和文檔
2. **組織良好**：檔案分類清晰，易於查找
3. **品質控制**：確保 production 程式碼品質
4. **知識累積**：持續記錄經驗和最佳實踐

---

## 📁 專案結構說明

### 核心資料夾

```
XScript/
├── scripts/              # 開發中的腳本（工作區）
│   ├── indicators/       # 指標
│   ├── alerts/           # 警示
│   ├── screeners/        # 選股
│   ├── trading/          # 交易
│   └── functions/        # 自訂函數 + FUNCTIONS_INDEX.md
│
├── examples/             # 教學範例（精選的學習素材）
│
├── docs/                 # 文檔資料夾
│   ├── guides/           # 開發指南（核心文檔）
│   ├── learning/         # 學習資料（語法教學）
│   ├── resources/        # 原始資源（參考資料）
│   ├── troubleshooting/  # 問題排除（錯誤修正）
│   ├── reference/        # 參考資料（規格、術語）
│   └── archive/          # 歷史歸檔（過時資料）
│
└── tools/                # 開發工具（爬蟲、驗證器）
```

---

## 🔄 日常維護流程

### 1. 新增腳本

#### 開發階段（Brainstorm）
```bash
# 在對應類型的 brainstorm/ 資料夾開發
scripts/{type}/brainstorm/YourScript.xs
```

**流程**：
1. 在 `brainstorm/` 資料夾創建新腳本
2. 撰寫和測試程式碼
3. 記錄開發過程中的問題和解決方案

**注意**：
- ❌ AI 不會從 brainstorm/ 學習
- ✅ 可以自由實驗和測試
- ✅ 不需要完美的程式碼

#### 正式版本（Production）
```bash
# 測試完成後移到 production/
scripts/{type}/production/YourScript.xs
```

**流程**：
1. 確認腳本功能正常
2. 檢查程式碼品質（參考 [風格指南](STYLE_GUIDE.md)）
3. 移動檔案到 `production/`
4. **如果是函數**：更新 `scripts/functions/FUNCTIONS_INDEX.md`

**檢查清單**：
- [ ] 程式碼無語法錯誤
- [ ] 邏輯經過測試驗證
- [ ] 變數命名清晰
- [ ] 適當的註解說明
- [ ] 遵循程式碼風格指南
- [ ] （函數）已登記在 FUNCTIONS_INDEX.md

### 2. 新增自訂函數

**特殊流程**（因為會被其他腳本引用）：

1. **開發階段**
   ```
   scripts/functions/brainstorm/MyFunction.xs
   ```
   - 開發和測試函數
   - 測試各種參數組合
   - 驗證邊界情況

2. **文檔準備**
   - 準備函數說明（用途、參數、返回值）
   - 準備使用範例
   - 列出注意事項

3. **移到 Production**
   ```
   scripts/functions/production/MyFunction.xs
   ```

4. **更新索引**（⚠️ 重要！）
   編輯 `scripts/functions/FUNCTIONS_INDEX.md`：
   ```markdown
   ### MyFunction（功能簡述）
   - **檔案**：`scripts/functions/production/MyFunction.xs`
   - **用途**：...
   - **參數**：...
   - **返回值**：...
   - **使用範例**：...
   ```

5. **（可選）提供範例**
   在 `examples/` 創建使用範例

---

## 📝 文檔更新規範

### 何時更新哪些文件

#### 發現新的錯誤或問題
**更新文件**：`docs/troubleshooting/common_errors.md`

**範例**：
```markdown
### 錯誤：保留字首導致編譯失敗

**現象**：
變數名稱使用 daily、trade 等開頭，導致編譯錯誤。

**原因**：
XScript 保留這些字首作為系統保留字。

**解決方案**：
避免使用這些字首，可改用 my、calc、check 等。

**相關資源**：
- [保留字列表](../reference/reserved_words.md)
```

#### 學到新的技巧或知識
**更新文件**：`docs/learning/` 對應檔案

**決策流程**：
- 語法相關 → `docs/learning/01_syntax_basics.md`
- 函數使用 → `docs/learning/02_functions.md`
- 進階主題 → `docs/learning/03_advanced_topics.md`
- 特定函數 → 對應的專門檔案

**範例**：
```markdown
### 使用 intrabarpersist 保持狀態

在 K 棒內需要保持變數狀態時，使用 `intrabarpersist` 關鍵字。

**情境**：
在分鐘線警示中，希望在同一根 K 棒內只觸發一次警示。

**解決方案**：
\`\`\`xscript
vars: intrabarpersist AlertTriggered(false);

if Condition and not AlertTriggered then begin
    Alert("條件觸發");
    AlertTriggered = true;
end;
\`\`\`
```

#### 發現新的最佳實踐
**更新文件**：`docs/guides/BEST_PRACTICES.md`

**範例**：
```markdown
### 效能優化：避免重複計算

**問題**：
在迴圈中重複計算相同的值。

**最佳實踐**：
\`\`\`xscript
// ❌ 不好的做法
for i = 0 to 100 begin
    value = SomeExpensiveCalculation();  // 重複計算
    DoSomething(value);
end;

// ✅ 好的做法
value = SomeExpensiveCalculation();  // 只計算一次
for i = 0 to 100 begin
    DoSomething(value);
end;
\`\`\`
```

#### 修正了某個腳本的錯誤
**更新文件**：`docs/troubleshooting/fix_records.md`

**範例**：
```markdown
### 2025-10-20：修正 Pin Bar 警示重複觸發

**檔案**：`scripts/alerts/production/PinBar_Alert.xs`

**問題**：
警示在同一根 K 棒內重複觸發多次。

**原因**：
未使用 `intrabarpersist` 保持狀態。

**修正**：
添加 `intrabarpersist` 關鍵字到狀態變數。

**學到的教訓**：
在分鐘線以下的警示腳本，務必使用 `intrabarpersist` 控制觸發次數。
```

#### 新增投資術語或概念
**更新文件**：`docs/reference/investment_glossary.md`

**範例**：
```markdown
### Pin Bar（針型燭台）

**定義**：
一種價格型態，特徵是長的上影線或下影線，實體相對較小。

**特徵**：
- 影線長度 > 實體的 2 倍
- 表示價格試探但遭到拒絕
- 可能是反轉訊號

**交易含義**：
- 長上影線：買盤無力，可能下跌
- 長下影線：賣盤無力，可能上漲

**相關腳本**：
- `scripts/alerts/production/PinBar_Alert.xs`
```

---

## 🔍 品質控制

### Production 程式碼審核標準

在將腳本從 brainstorm/ 移到 production/ 之前，必須通過以下檢查：

#### 功能性
- [ ] 腳本能夠成功編譯
- [ ] 核心功能經過測試
- [ ] 邊界情況處理正確
- [ ] 錯誤處理妥當

#### 程式碼品質
- [ ] 遵循 [程式碼風格指南](STYLE_GUIDE.md)
- [ ] 變數命名清晰有意義
- [ ] 適當的註解說明
- [ ] 沒有硬編碼的數值（使用 input）

#### 文檔
- [ ] 檔案名稱清楚表達用途
- [ ] 檔案頂部有說明註解
- [ ] 複雜邏輯有解釋
- [ ] （函數）已登記在 FUNCTIONS_INDEX.md

#### 符合規範
- [ ] 放在正確的類型資料夾
- [ ] 遵循腳本類型的規範（參考 [SCRIPT_TYPES.md](SCRIPT_TYPES.md)）
- [ ] 沒有使用保留字

### 定期審查

#### 每週
- 檢查 brainstorm/ 資料夾
  - 哪些腳本可以移到 production？
  - 哪些腳本可以刪除？
- 檢查是否有未登記的函數
- 更新 fix_records.md（如有修正）

#### 每月
- 檢查文檔是否需要更新
- 檢查範例是否仍然有效
- 檢查連結和路徑是否正確
- 整理 brainstorm/ 資料夾

#### 每季度
- 審查所有 production 程式碼
- 更新過時的文檔
- 整理 archive/ 歸檔
- 更新學習資源

---

## 📊 AI 訓練資料管理

### AI 會學習什麼

#### ✅ 用於訓練
- `scripts/{type}/production/` 下的所有腳本
- `examples/` 下的所有範例
- `docs/guides/` 的指南文檔
- `docs/learning/` 的學習資料
- `docs/troubleshooting/` 的問題排除
- `docs/reference/` 的參考資料
- `scripts/functions/FUNCTIONS_INDEX.md`

#### ❌ 不用於訓練
- `scripts/{type}/brainstorm/` 下的腳本
- `docs/archive/` 的歷史資料
- `tools/` 的工具腳本
- 臨時檔案和測試檔案

### 提升 AI 學習效果的技巧

#### 1. 程式碼註解
```xscript
// ✅ 好的註解：說明為什麼
// 使用 intrabarpersist 避免在同一根 K 棒內重複觸發
vars: intrabarpersist AlertTriggered(false);

// ❌ 不好的註解：只說明是什麼
// 宣告變數
vars: intrabarpersist AlertTriggered(false);
```

#### 2. 有意義的命名
```xscript
// ✅ 好的命名
vars: PinBarDetected(false);
vars: UpperShadowLength(0);

// ❌ 不好的命名
vars: flag(false);
vars: len(0);
```

#### 3. 完整的範例
```xscript
// ✅ 好的範例：包含完整上下文
// === Pin Bar 偵測範例 ===
// 偵測長下影線的 Pin Bar，可能是反轉向上訊號

input: ShadowRatio(2, "影線比實體倍數");

vars: BodySize(0);
vars: LowerShadowSize(0);

BodySize = AbsValue(Close - Open);
LowerShadowSize = MinList(Open, Close) - Low;

if LowerShadowSize > BodySize * ShadowRatio then
    Alert("偵測到看漲 Pin Bar");
```

#### 4. 結構化的文檔
使用清晰的標題、列表和程式碼區塊，讓 AI 容易理解結構。

---

## 🛠️ 工具使用

### 保留字檢查
在提交前，使用工具檢查保留字：

```bash
python tools/validators/xs_guard_reserved_words.py
```

### Git 提交檢查
已設定 pre-commit hook 自動檢查保留字。

---

## 📋 常見維護任務

### 任務 1：整理 brainstorm 資料夾

**頻率**：每週

**步驟**：
1. 檢視 `scripts/{type}/brainstorm/` 所有檔案
2. 對於每個檔案，決定：
   - ✅ **成熟**：移到 production/
   - ⏸️ **繼續開發**：保留在 brainstorm/
   - ❌ **不再需要**：刪除
3. 移到 production 的檔案：
   - 執行品質檢查
   - （如果是函數）更新 FUNCTIONS_INDEX.md
   - 記錄在 fix_records.md（如有特殊修正）

### 任務 2：更新自訂函數索引

**頻率**：有新函數時立即更新

**步驟**：
1. 開啟 `scripts/functions/FUNCTIONS_INDEX.md`
2. 找到對應的分類
3. 按照格式添加函數資訊：
   - 函數名稱和用途
   - 檔案路徑
   - 完整說明
   - 參數和返回值
   - 使用範例
   - 注意事項
4. 更新統計資訊

### 任務 3：同步 examples 資料夾

**頻率**：有新的優質範例時

**步驟**：
1. 從 production 選擇優質的腳本
2. 複製到 `examples/` 對應分類
3. 添加詳細的註解說明
4. 確保範例可獨立運行
5. 更新 `examples/README.md`

### 任務 4：更新學習資源

**頻率**：有新的知識或技巧時

**步驟**：
1. 確定資訊歸類（語法/函數/進階）
2. 編輯對應的 .md 檔案
3. 使用清晰的標題和範例
4. 確保與現有內容一致
5. 添加相關連結

### 任務 5：歸檔過時資料

**頻率**：每季度

**步驟**：
1. 檢視 docs/ 下的所有文檔
2. 識別過時或不再相關的內容
3. 移動到 `docs/archive/`
4. 在原位置留下導向說明（如需要）
5. 更新相關連結

---

## 👥 協作建議

### Gordon（專案負責人）

**主要責任**：
- 審核 production 程式碼
- 維護核心文檔（guides/）
- 管理專案架構
- 定期整理和歸檔

**每週任務**：
- 審查 Ronnie 的 brainstorm 程式碼
- 檢查 FUNCTIONS_INDEX.md 更新
- 整理 fix_records.md

### Ronnie（開發組員）

**主要責任**：
- 開發新腳本（在 brainstorm/）
- 記錄學習心得
- 回報問題和建議
- 協助測試和驗證

**開發流程**：
1. 在 brainstorm/ 開發新腳本
2. 測試並記錄問題
3. 請 Gordon 審核
4. 根據回饋修改
5. 移到 production/（Gordon 確認後）

### AI Assistant

**可以協助**：
- 解答 XScript 問題
- 撰寫和除錯程式碼
- 更新文檔內容
- 提供最佳實踐建議

**應該提供的資訊**：
- 腳本類型和用途
- 已嘗試的方法
- 遇到的具體錯誤
- 期望的行為

---

## 📞 獲得協助

### 遇到問題時

1. **檢查文檔**
   - [常見錯誤](../troubleshooting/common_errors.md)
   - [修正記錄](../troubleshooting/fix_records.md)
   - [腳本類型說明](SCRIPT_TYPES.md)

2. **詢問 AI**
   - 描述問題和上下文
   - 提供程式碼片段
   - 說明已嘗試的方法

3. **請教團隊**
   - Gordon：架構和規範問題
   - Ronnie：開發經驗分享

### 建議改進

如果有改進建議：
1. 記錄在專案的 issue 或討論區
2. 與 Gordon 討論
3. 更新相關文檔

---

## ✅ 維護檢查清單

### 每次開發後
- [ ] 程式碼放在正確的位置（brainstorm 或 production）
- [ ] （如果是函數）更新 FUNCTIONS_INDEX.md
- [ ] （如有修正）記錄在 fix_records.md

### 每週
- [ ] 整理 brainstorm 資料夾
- [ ] 檢查未登記的函數
- [ ] 更新必要的文檔

### 每月
- [ ] 檢查所有連結有效性
- [ ] 更新範例（如有新的優質範例）
- [ ] 檢視並更新學習資源

### 每季度
- [ ] 全面審查 production 程式碼
- [ ] 整理和歸檔舊資料
- [ ] 更新專案統計資訊
- [ ] 檢討並改進維護流程

---

## 📈 持續改進

這份維護指南會隨著專案發展而更新。如果發現：
- 流程不夠清楚
- 需要補充說明
- 有更好的做法

請隨時更新本文檔！

---

**最後更新**：2025-10-20  
**維護者**：Gordon, Ronnie  
**版本**：1.0

