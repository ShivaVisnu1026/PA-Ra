# 專案管理與 Git 協作

> 本資料夾包含專案管理相關文檔和 Git 協作指南

---

## 📁 資料夾內容

### 🔑 Git 協作文檔（重要！）

| 文檔 | 說明 | 用途 |
|------|------|------|
| `GIT_WORKFLOW.md` | Git 工作流程完整指南 | 團隊協作標準流程 |
| `GIT_COMMIT_RULES.md` | Git Commit 訊息規範 | **必須使用英文 commit** |
| `GIT_QUICK_REFERENCE.md` | Git 快速參考手冊 | 常用指令查詢 |

### 📊 專案報告

| 文檔 | 說明 | 狀態 |
|------|------|------|
| `project_cleanup_summary.md` | 專案清理總結 | 已完成 |
| `final_cleanup_report.md` | 最終清理報告 | 已完成 |
| `project_restructure_final_report.md` | 專案重整最終報告 | 已完成 |
| `Git協作補充說明.md` | Git 協作補充說明 | 參考用 |
| `通知_Ronnie_專案重整說明.md` | Ronnie 通知文檔 | 歷史記錄 |

---

## 🚨 重要提醒

### Git Commit 規則

⚠️ **所有 commit 訊息必須使用英文，避免中文亂碼問題**

```bash
# ✅ 正確
git commit -m "feat: Add breakout alert script"
git commit -m "fix: Resolve RSI calculation error"

# ❌ 錯誤（會造成亂碼）
git commit -m "新增：突破警示腳本"
git commit -m "修正：RSI 計算錯誤"
```

### 快速參考

- **工作流程**：`GIT_WORKFLOW.md`
- **Commit 格式**：`GIT_COMMIT_RULES.md`
- **常用指令**：`GIT_QUICK_REFERENCE.md`

---

## 📚 使用指南

### 新成員入門

1. 閱讀 `GIT_WORKFLOW.md` 了解基本流程
2. 學習 `GIT_COMMIT_RULES.md` 的 commit 規範
3. 參考 `GIT_QUICK_REFERENCE.md` 查詢指令

### 日常協作

1. 開始工作前：`git pull origin master`
2. 完成工作後：`git add .` → `git commit -m "英文訊息"` → `git push`
3. 遇到問題：參考相關文檔或詢問團隊成員

### 專案管理

- 查看專案報告了解歷史變更
- 參考清理報告了解專案結構演進
- 使用協作說明進行團隊溝通

---

## 🎯 核心原則

1. **英文 Commit**：避免亂碼，提高可讀性
2. **標準流程**：遵循 Git 工作流程
3. **清楚溝通**：使用標準化的 commit 訊息
4. **團隊協作**：互相提醒和協助

---

**最後更新**：2025-10-21  
**維護者**：Gordon, Ronnie  
**版本**：1.0
