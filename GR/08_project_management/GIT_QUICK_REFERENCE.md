# Git 快速參考卡

> 最常用的 Git 指令速查表

---

## 🚀 每日基本流程

```bash
# 1️⃣ 開始工作（拉取最新版本）
git pull origin master

# 2️⃣ 修改檔案後查看狀態
git status

# 3️⃣ 添加所有變更
git add .

# 4️⃣ 提交變更
git commit -m "新增：功能說明"

# 5️⃣ 推送到 GitHub
git push origin master
```

---

## 📋 常用指令

### 查看狀態
```bash
git status              # 查看目前狀態
git diff                # 查看變更內容
git log                 # 查看提交歷史
git log --oneline       # 簡潔的歷史記錄
```

### 添加和提交
```bash
git add .                               # 添加所有變更
git add 檔案名稱                        # 添加特定檔案
git commit -m "訊息"                    # 提交變更
git commit -m "新增：Pin Bar 警示"     # 良好的訊息範例
```

### 推送和拉取
```bash
git push origin master      # 推送到 GitHub
git pull origin master      # 從 GitHub 拉取
```

### 復原操作
```bash
git checkout -- 檔案名稱    # 放棄工作區的變更
git reset HEAD 檔案名稱     # 取消 add
git reset --hard HEAD~1     # 回到上一個 commit（危險！）
```

---

## 💡 Commit 訊息範本

```bash
# 新增功能
git commit -m "新增：RSI 超買警示腳本"

# 修正錯誤
git commit -m "修正：警示重複觸發問題"

# 更新文檔
git commit -m "文檔：更新 FUNCTIONS_INDEX"

# 重構程式碼
git commit -m "重構：改善程式碼可讀性"

# 其他
git commit -m "測試：新增單元測試"
git commit -m "樣式：統一程式碼格式"
```

---

## 🆘 常見問題

### 推送時提示「被拒絕」
```bash
# 原因：GitHub 有新的變更
# 解決：先拉取，再推送
git pull origin master
git push origin master
```

### 不小心修改了錯誤的檔案
```bash
# 還沒 commit：直接放棄變更
git checkout -- 檔案名稱

# 已經 commit：回退
git reset --hard HEAD~1
```

### 遇到衝突
```bash
# 1. 拉取時出現衝突訊息
git pull origin master

# 2. 手動編輯衝突的檔案，移除標記：
#    <<<<<<< HEAD
#    你的版本
#    =======
#    對方的版本
#    >>>>>>>

# 3. 標記已解決
git add 檔案名稱

# 4. 完成合併
git commit -m "合併：解決衝突"
git push origin master
```

---

## ✅ 每日檢查清單

### 開始工作
- [ ] `git pull origin master`

### 結束工作
- [ ] `git status`（確認變更）
- [ ] `git add .`（添加變更）
- [ ] `git commit -m "訊息"`（提交）
- [ ] `git push origin master`（推送）

---

## 🔗 完整指南

詳細說明請參考：[Git/GitHub 工作流程指南](GIT_WORKFLOW.md)

---

**最後更新**：2025-10-20

