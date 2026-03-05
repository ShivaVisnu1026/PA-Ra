# XScript 開發與學習專案

> 一個專為訓練 AI 和提升開發效率而設計的 XScript 專案

---

## 🎯 專案目標

本專案主要目標是讓 AI 學習並編寫正確的 XScript 程式，同時建立完整的投資術語和知識庫，提升開發效率。

### 主要用途
1. **AI 訓練**：提供高品質的程式碼和文檔供 AI 學習
2. **開發協作**：Gordon 和 Ronnie 的協作開發空間
3. **知識累積**：系統化的 XScript 學習資源
4. **腳本管理**：區分測試（brainstorm）和正式（production）程式碼

---

## 📁 專案結構

```
XScript/
├── 01_scripts/                      # 💻 腳本開發（工作區）
│   ├── indicators/                  # 指標腳本
│   │   ├── production/              # ✅ 正式版本（AI 可學習）
│   │   └── brainstorm/              # 🧪 測試版本（實驗用）
│   ├── alerts/                      # 警示腳本
│   │   ├── production/
│   │   └── brainstorm/
│   ├── screeners/                   # 選股腳本
│   │   ├── production/
│   │   └── brainstorm/
│   ├── trading/                     # 交易腳本
│   │   ├── production/
│   │   └── brainstorm/
│   └── functions/                   # 自訂函數
│       ├── production/
│       ├── brainstorm/
│       └── FUNCTIONS_INDEX.md       # 🔑 自訂函數索引（重要！）
│
├── 02_examples/                     # 📚 教學範例（精選學習素材）
│   ├── signals/                     # 信號範例
│   └── README.md                    # 範例導覽
│
├── 03_docs/                         # 📖 XQ 官方學習資料
│   ├── guides/                      # 📘 開發指南（核心！）
│   │   ├── SCRIPT_TYPES.md          # 🔑 五種腳本類型完整說明
│   │   ├── AI_PROMPTING_GUIDE.md    # 🔑 AI 提示詞指南
│   │   ├── STYLE_GUIDE.md           # 🔑 程式碼風格指南
│   │   ├── MAINTENANCE_GUIDE.md     # 🔑 專案維護指南
│   │   └── README.md                # 指南導覽
│   │
│   ├── learning/                    # 🎓 學習資料
│   │   ├── README.md                # 學習路徑
│   │   ├── XScript_AddSpread函數使用說明.md
│   │   ├── XScript_intrabarpersist與K棒計數器學習.md
│   │   ├── XScript_學習方法與最佳實踐.md
│   │   └── 跨頻率腳本最佳實踐.md
│   │
│   ├── resources/                   # 📚 原始資源
│   │   ├── textbook/                # 教科書資料
│   │   ├── xq_blog/                 # 部落格文章
│   │   └── xshelp_mirror/           # 官方說明文件
│   │
│   ├── troubleshooting/             # 🔧 問題排除
│   │   └── README.md                # 問題排除指南
│   │
│   ├── reference/                   # 📋 參考資料
│   │   └── investment_glossary.md   # 投資術語表
│   │
│   └── archive/                     # 📦 歷史歸檔
│
├── 04_tools/                        # 🛠️ 開發工具
│   ├── xq_blog_scraper.py           # 部落格爬蟲
│   ├── xshelp_scraper.py            # 說明文件爬蟲
│   ├── xshelp_indexer.py            # 索引生成器
│   └── xs_guard_reserved_words.py   # 保留字檢查器
│
├── 05_tests/                        # 🧪 測試檔案
│   └── golden/                      # 黃金測試案例
│
├── 06_external/                     # 🌐 外部資源
│
├── 07_ronnie_workspace/             # 👤 Ronnie 工作區
│   └── BrainStorm/                  # Ronnie 的測試腳本
│
└── 08_project_management/           # 📊 專案管理與 Git 協作
    ├── GIT_WORKFLOW.md              # 🔑 Git 工作流程指南
    ├── GIT_COMMIT_RULES.md          # 🔑 Git Commit 規則（重要！）
    ├── GIT_QUICK_REFERENCE.md       # Git 快速參考
    ├── project_cleanup_summary.md   # 清理總結
    ├── final_cleanup_report.md      # 最終報告
    ├── project_restructure_final_report.md  # 專案重整最終報告
    ├── Git協作補充說明.md           # Git 協作補充說明
    └── 通知_Ronnie_專案重整說明.md   # Ronnie 通知
```

---

## 🏗️ 最新架構說明

### 專案重整完成
本專案已完成全面重整，建立了清晰的編號排序資料夾結構：

- **01_scripts/**：腳本開發工作區，包含五種腳本類型（指標、警示、選股、交易、函數）
- **02_examples/**：教學範例和學習素材
- **03_docs/**：完整文檔系統，包含指南、學習資料、參考資料
- **04_tools/**：開發工具和輔助腳本
- **05_tests/**：測試檔案和測試資料
- **06_external/**：外部資源和第三方工具
- **07_ronnie_workspace/**：Ronnie 的專屬工作區
- **08_project_reports/**：專案報告和總結文檔

### 檔案命名規範
- **檔名使用英文**：避免編碼問題，確保跨平台相容性
- **內容使用中文**：保持中文的可讀性和親和力
- **描述性檔名**：如 `project_restructure_final_report.md`

### 協作流程
- **Ronnie 開發**：在 `07_ronnie_workspace/BrainStorm/` 開發和測試
- **Gordon 審核**：審核後移到 `01_scripts/{type}/production/`
- **AI 訓練**：只學習 `production/` 和 `examples/` 中的高品質程式碼

詳細說明請參考：[專案重整最終報告](08_project_reports/project_restructure_final_report.md)

---

## 🚀 快速開始

### 新手入門
1. **了解腳本類型**：閱讀 [五種腳本類型說明](03_docs/guides/SCRIPT_TYPES.md) ⭐
2. **學習基礎語法**：查看 [學習資料](03_docs/learning/)
3. **研究範例程式**：瀏覽 [02_examples/](02_examples/)
4. **學習提問技巧**：參考 [AI 提示詞指南](03_docs/guides/AI_PROMPTING_GUIDE.md)

### 開發腳本

#### 第一步：確定類型
XScript 有五種腳本類型，選擇正確的類型很重要：
- 🎯 **指標（Indicator）**：計算並顯示技術指標
- 🔔 **警示（Alert）**：條件觸發時通知
- 🔍 **選股（Screener）**：從市場篩選股票
- 💰 **交易（Trading）**：自動執行交易
- 🔧 **函數（Function）**：可重用的邏輯

詳細說明請參考：[SCRIPT_TYPES.md](03_docs/guides/SCRIPT_TYPES.md)

#### 第二步：開發和測試
1. 在 `01_scripts/{type}/brainstorm/` 開發新腳本
2. 遵循 [程式碼風格指南](03_docs/guides/STYLE_GUIDE.md)
3. 充分測試功能

#### 第三步：發布
1. 測試完成後，移到 `01_scripts/{type}/production/`
2. **如果是函數**：更新 [FUNCTIONS_INDEX.md](01_scripts/functions/FUNCTIONS_INDEX.md) ⚠️
3. 記錄在 [問題排除指南](03_docs/troubleshooting/README.md)（如有特殊修正）

---

## 📚 核心文檔

### 🔑 必讀指南

| 文檔 | 用途 | 何時閱讀 |
|------|------|----------|
| [SCRIPT_TYPES.md](03_docs/guides/SCRIPT_TYPES.md) | 了解五種腳本類型 | 開發前 |
| [STYLE_GUIDE.md](03_docs/guides/STYLE_GUIDE.md) | 程式碼風格規範 | 開發時 |
| [GIT_WORKFLOW.md](03_docs/guides/GIT_WORKFLOW.md) | Git/GitHub 工作流程 | 協作時⭐ |
| [AI_PROMPTING_GUIDE.md](03_docs/guides/AI_PROMPTING_GUIDE.md) | 如何與 AI 溝通 | 需要協助時 |
| [MAINTENANCE_GUIDE.md](03_docs/guides/MAINTENANCE_GUIDE.md) | 專案維護流程 | 維護時 |
| [FUNCTIONS_INDEX.md](01_scripts/functions/FUNCTIONS_INDEX.md) | 自訂函數索引 | 需要函數時 |

### 📖 學習資源

- [學習資料](03_docs/learning/) - XScript 語法和最佳實踐
- [範例程式碼](02_examples/) - 從基礎到進階的完整範例
- [教科書資料](03_docs/resources/textbook/) - 完整的知識庫
- [投資術語表](03_docs/reference/investment_glossary.md) - 投資和交易術語

### 🔧 問題排除

- [問題排除指南](03_docs/troubleshooting/README.md)
- [專案報告](08_project_reports/) - 專案重整和清理報告

---

## 💡 開發流程

### Brainstorm → Production 流程

```
1. 💡 發想階段
   └─ 在 brainstorm/ 開發和實驗
   
2. 🧪 測試階段
   └─ 測試各種情況和邊界值
   
3. ✅ 完善階段
   └─ 檢查品質，符合風格指南
   
4. 🚀 發布階段
   └─ 移到 production/
   └─ （函數）更新 FUNCTIONS_INDEX.md
```

### AI 訓練資料

#### ✅ AI 會學習這些
- `01_scripts/{type}/production/` - 所有正式腳本
- `02_examples/` - 教學範例
- `03_docs/guides/` - 開發指南
- `03_docs/learning/` - 學習資料
- `03_docs/reference/` - 參考資料
- `01_scripts/functions/FUNCTIONS_INDEX.md` - 函數索引

#### ❌ AI 不會學習這些
- `01_scripts/{type}/brainstorm/` - 測試腳本
- `07_ronnie_workspace/` - Ronnie 工作區
- `03_docs/archive/` - 歷史資料
- `04_tools/` - 工具腳本
- `08_project_reports/` - 專案報告

---

## 👥 團隊協作

### Gordon（專案負責人）
**主要責任**：
- 審核 production 程式碼
- 維護核心文檔
- 管理專案架構

### Ronnie（開發組員）
**主要責任**：
- 開發新腳本（在 `07_ronnie_workspace/BrainStorm/`）
- 記錄學習心得
- 回報問題和建議

### 協作流程
1. **開始工作前**：`git pull origin master`（確保有最新版本）
2. Ronnie 在 `07_ronnie_workspace/BrainStorm/` 開發和測試
3. 完成後：`git add .` → `git commit -m "訊息"` → `git push`
4. Ronnie 通知 Gordon：「已推送新的 XXX 功能」
5. Gordon pull 更新、審核程式碼
6. Gordon 確認後移到 `01_scripts/{type}/production/`
7. Gordon push 更新

詳細流程請參考：
- [Git 工作流程指南](03_docs/guides/GIT_WORKFLOW.md) ⭐
- [維護指南](03_docs/guides/MAINTENANCE_GUIDE.md)

---

## 🔐 版本控制與協作

### Git/GitHub 工作流程

本專案使用 Git 進行版本控制，GitHub 作為中央倉庫：

```bash
# 每日基本流程
git pull origin master              # 1. 拉取最新版本
# [修改和測試程式碼]               # 2. 開發工作
git status                          # 3. 確認變更
git add .                           # 4. 添加變更
git commit -m "新增：功能說明"      # 5. 提交變更
git push origin master              # 6. 推送到 GitHub
```

**重要**：
- ✅ 每次開始工作前先 `git pull`
- ✅ 推送前確認程式碼可用
- ✅ 寫清楚的 commit 訊息
- ✅ Ronnie 推送後通知 Gordon 審核

**詳細說明**：[Git/GitHub 工作流程指南](03_docs/guides/GIT_WORKFLOW.md) ⭐  
**快速參考**：[Git 快速參考卡](03_docs/guides/GIT_QUICK_REFERENCE.md)

### 關於備份

✅ **GitHub 本身就是備份系統**：
- 每次 commit 都是一個備份點
- 可以隨時回到任何歷史版本
- 所有變更都有完整記錄
- 改錯了也能輕鬆還原

### Git Pre-commit Hook
自動檢查保留字，避免編譯錯誤：

```bash
# 第一次設定（只需執行一次）
git config core.hooksPath .githooks
chmod +x .githooks/pre-commit  # Linux/Mac
# Windows 不需要 chmod

# 之後每次 git commit 會自動檢查
```

保留字包括：`daily`, `trade`, `position`, `filled`, `order` 等。

### 品質檢查清單
提交到 production 前：
- [ ] 程式碼無語法錯誤
- [ ] 遵循 [風格指南](03_docs/guides/STYLE_GUIDE.md)
- [ ] 適當的註解
- [ ] 功能經過測試
- [ ] （函數）已更新 FUNCTIONS_INDEX.md
- [ ] Git commit 訊息清楚
- [ ] 已推送到 GitHub

---

## 📊 專案統計

- **腳本類型**：5 種（指標、警示、選股、交易、函數）
- **學習資源**：教科書、部落格、官方文檔
- **範例程式**：分類範例，持續擴充中
- **核心文檔**：4 個必讀指南 + 完整參考資料

---

## 🎓 學習路徑

### 初學者（0-2週）
1. 閱讀 [SCRIPT_TYPES.md](03_docs/guides/SCRIPT_TYPES.md)
2. 學習 [基礎語法](03_docs/learning/)
3. 練習 [基礎範例](02_examples/signals/)

### 進階者（2-4週）
1. 開發警示和選股腳本
2. 學習 [進階主題](03_docs/learning/)
3. 研究 [實戰範例](02_examples/)

### 專家（4週以上）
1. 開發交易腳本和自訂函數
2. 深入官方文檔
3. 分享經驗和最佳實踐

---

## 🔗 重要連結

### 核心文檔
- [專案報告](08_project_reports/) - 專案重整和清理報告
- [專案重整最終報告](08_project_reports/project_restructure_final_report.md) - 完整的專案重整說明
- [開發指南](03_docs/guides/) - 所有開發指南
- [自訂函數索引](01_scripts/functions/FUNCTIONS_INDEX.md) - 可用函數列表

### 外部資源
- [XQ 嘉實資訊](https://www.xq.com.tw/) - XScript 官方平台
- [XQ 幫助文檔](03_docs/resources/xshelp_mirror/) - 本地鏡像

---

## ⚠️ 重要提醒

### 開發前必讀
1. ⭐ [五種腳本類型說明](03_docs/guides/SCRIPT_TYPES.md)
2. ⭐ [程式碼風格指南](03_docs/guides/STYLE_GUIDE.md)

### 開發後必做
1. ✅ 品質檢查
2. ✅ （函數）更新 FUNCTIONS_INDEX.md
3. ✅ 移到正確的位置（brainstorm 或 production）

### 維護提醒
- 定期整理 brainstorm 資料夾
- 及時更新文檔
- 記錄問題和解決方案

詳細維護流程：[MAINTENANCE_GUIDE.md](03_docs/guides/MAINTENANCE_GUIDE.md)

---

## 📞 獲得協助

### AI 協助
使用 [AI 提示詞指南](03_docs/guides/AI_PROMPTING_GUIDE.md) 來獲得最佳協助：
- 明確說明腳本類型
- 提供完整上下文
- 引用相關文檔

### 文檔查詢
1. **語法問題**：查看 [學習資料](03_docs/learning/)
2. **錯誤修正**：查看 [問題排除](03_docs/troubleshooting/)
3. **範例參考**：查看 [02_examples/](02_examples/)
4. **術語查詢**：查看 [投資術語表](03_docs/reference/investment_glossary.md)

### 團隊協助
- **Gordon**：架構和規範問題
- **Ronnie**：開發經驗分享

---

## 📈 專案願景

通過持續累積高品質的程式碼和文檔：
- ✨ 讓 AI 成為更好的 XScript 開發助手
- ✨ 建立完整的 XScript 知識庫
- ✨ 提升團隊的開發效率
- ✨ 分享經驗給 XScript 社群

---

## 📄 授權

本專案供內部學習和開發使用。

---

**最後更新**：2025-10-20  
**專案維護**：Gordon, Ronnie  
**版本**：2.0（架構重整版）

---

**開始使用 XScript 開發吧！** 🚀

有任何問題，請參考 [文檔](03_docs/) 或詢問 AI 助手。
