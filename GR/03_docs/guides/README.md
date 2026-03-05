# XScript 開發指南

> 完整的 XScript 開發文檔

---

## 📚 指南目錄

### 核心指南

#### [🎯 五種腳本類型說明](SCRIPT_TYPES.md) ⭐ 必讀
了解 XScript 的五種腳本類型：指標、警示、選股、交易、函數

**包含內容**：
- 每種類型的用途和特點
- 可用的資料和限制
- 典型結構和範例
- 注意事項和最佳實踐
- 類型選擇指南

#### [💬 AI 提示詞指南](AI_PROMPTING_GUIDE.md) ⭐ 必讀
學習如何與 AI 有效溝通，獲得最佳開發協助

**包含內容**：
- 有效提示詞的原則
- 提示詞範本（撰寫新腳本、除錯、學習、優化）
- 進階技巧
- XScript 特定技巧
- 實際案例

#### [🎨 程式碼風格指南](STYLE_GUIDE.md) ⭐ 必讀
統一的程式碼風格規範

**包含內容**：
- 命名規範（變數、參數、函數）
- 註解規範
- 程式碼結構
- 最佳實踐
- 腳本範本
- 常見錯誤

#### [🔧 專案維護指南](MAINTENANCE_GUIDE.md) ⭐ 必讀
專案的維護和更新流程

**包含內容**：
- 日常維護流程
- 文檔更新規範
- 品質控制標準
- AI 訓練資料管理
- 協作建議
- 維護檢查清單

#### [📦 Git/GitHub 工作流程指南](GIT_WORKFLOW.md) ⭐ 必讀
版本控制和團隊協作流程

**包含內容**：
- Git 核心概念（本機 vs GitHub）
- 完整工作流程（pull → 修改 → commit → push）
- Gordon 和 Ronnie 的協作流程
- 常見情境處理（衝突、錯誤復原等）
- 緊急救援指南
- 實用指令參考

**快速參考**：[Git 快速參考卡](GIT_QUICK_REFERENCE.md)

---

## 🚀 快速開始

### 新手入門
1. 閱讀 [五種腳本類型說明](SCRIPT_TYPES.md) 了解基本概念
2. 查看 [examples/](../../examples/) 的範例程式碼
3. 參考 [AI 提示詞指南](AI_PROMPTING_GUIDE.md) 學習如何請求協助

### 開發腳本
1. 確定腳本類型（參考 [SCRIPT_TYPES.md](SCRIPT_TYPES.md)）
2. 遵循 [程式碼風格指南](STYLE_GUIDE.md)
3. 在 `scripts/{type}/brainstorm/` 開發和測試
4. 測試完成後移到 `production/`
5. 如果是函數，更新 [FUNCTIONS_INDEX.md](../../scripts/functions/FUNCTIONS_INDEX.md)

### 維護專案
1. 遵循 [維護指南](MAINTENANCE_GUIDE.md) 的流程
2. 定期整理 brainstorm 資料夾
3. 更新相關文檔
4. 記錄修正和學習心得

---

## 📖 其他資源

### 學習資料
- [docs/learning/](../learning/) - XScript 語法學習
- [docs/resources/](../resources/) - 原始資源和參考資料

### 問題排除
- [docs/troubleshooting/](../troubleshooting/) - 常見錯誤和解決方案

### 參考資料
- [docs/reference/](../reference/) - 規格、保留字、術語表

---

## 🎯 重要提醒

### ⚠️ 開發前必讀
- [x] [SCRIPT_TYPES.md](SCRIPT_TYPES.md) - 了解腳本類型
- [x] [STYLE_GUIDE.md](STYLE_GUIDE.md) - 遵循風格規範
- [x] [GIT_WORKFLOW.md](GIT_WORKFLOW.md) - 了解版本控制流程

### ⚠️ 開發後必做
- [ ] 程式碼品質檢查
- [ ] 遵循維護流程
- [ ] （函數）更新 FUNCTIONS_INDEX.md
- [ ] Git commit 和 push 到 GitHub

---

**最後更新**：2025-10-20  
**維護者**：Gordon, Ronnie

