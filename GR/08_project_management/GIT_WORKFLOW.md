# Git/GitHub 工作流程指南

> 本指南說明如何使用 Git 和 GitHub 進行版本控制和團隊協作

---

## 🎯 核心概念

### 本機 vs GitHub 的關係

```
┌─────────────────┐         ┌─────────────────┐
│  Gordon 本機    │  push   │                 │
│  專案資料夾     │────────>│                 │
└─────────────────┘         │   GitHub 遠端   │
                            │   （線上倉庫）  │
┌─────────────────┐  pull   │                 │
│  Ronnie 本機    │<────────│                 │
│  專案資料夾     │  push   │                 │
└─────────────────┘────────>└─────────────────┘
```

**簡單來說**：
- **本機專案**：你電腦上的工作區，可以自由修改
- **GitHub 遠端**：線上的「中央倉庫」，所有人共享的版本
- **工作流程**：本機修改 → 測試確認 → 推送到 GitHub → 其他人拉取更新

### GitHub 就是備份！

✅ **GitHub 本身就是版本控制和備份系統**：
- 每次 commit（提交）都是一個完整的備份點
- 可以隨時回到任何一個歷史版本
- 即使改錯了，也能輕鬆還原
- 所有的變更都有完整記錄（誰改的、什麼時候改的、改了什麼）

---

## 📚 基本 Git 概念

### 三個區域

```
工作區                暫存區               本機倉庫            遠端倉庫
(Working Directory)  (Staging Area)      (Local Repo)       (Remote Repo)
                                                              
┌──────────┐         ┌──────────┐        ┌──────────┐       ┌──────────┐
│ 修改檔案 │  add    │ 準備提交 │ commit │ 本機版本 │ push  │ GitHub   │
│          │────────>│          │───────>│          │──────>│          │
│          │         │          │        │          │ pull  │          │
│          │         │          │        │          │<──────│          │
└──────────┘         └──────────┘        └──────────┘       └──────────┘
```

### 常用指令

| 指令 | 用途 | 說明 |
|------|------|------|
| `git status` | 查看狀態 | 查看哪些檔案被修改了 |
| `git add .` | 添加到暫存區 | 準備要提交的變更 |
| `git commit -m "訊息"` | 提交變更 | 在本機創建一個版本記錄點 |
| `git push` | 推送到 GitHub | 將本機變更上傳到線上 |
| `git pull` | 從 GitHub 拉取 | 下載線上的最新變更 |
| `git log` | 查看歷史記錄 | 查看所有的 commit 記錄 |

---

## 🚀 完整工作流程

### 流程圖

```
開始工作
   ↓
1. git pull (拉取最新版本)
   ↓
2. 修改檔案（開發、測試）
   ↓
3. git status (確認變更)
   ↓
4. git add . (添加變更)
   ↓
5. git commit -m "說明" (提交)
   ↓
6. git push (推送到 GitHub)
   ↓
完成
```

### 詳細步驟

#### 步驟 1：開始工作前，先拉取最新版本

```bash
# 確保你有最新的程式碼
git pull origin master
```

**為什麼要這樣做？**
- 避免你的版本和 GitHub 上的版本不同步
- 如果 Ronnie 剛推送了更新，你會立刻得到
- 減少之後的衝突

#### 步驟 2：進行修改

在本機自由修改、開發、測試。

**建議的工作方式**：
- 在 `scripts/{type}/brainstorm/` 開發新功能
- 充分測試，確認沒問題
- 移到 `production/`（如果是正式版本）
- 更新相關文檔

#### 步驟 3：確認變更

```bash
# 查看哪些檔案被修改了
git status

# 查看具體的修改內容
git diff
```

**輸出範例**：
```
Changes not staged for commit:
  modified:   scripts/alerts/production/MyAlert.xs
  modified:   docs/troubleshooting/腳本修正記錄.md
  
Untracked files:
  scripts/functions/production/MyFunction.xs
```

#### 步驟 4：添加變更到暫存區

```bash
# 添加所有變更
git add .

# 或者只添加特定檔案
git add scripts/alerts/production/MyAlert.xs
git add docs/troubleshooting/腳本修正記錄.md
```

#### 步驟 5：提交變更

```bash
git commit -m "新增：MyAlert 警示腳本和 MyFunction 函數"
```

**良好的 commit 訊息格式**：

⚠️ **重要：所有 commit 訊息必須使用英文，避免中文亂碼問題**

```bash
# 格式：type: description 或 type(scope): description

# 新增功能
git commit -m "feat: Add Pin Bar alert script"
git commit -m "feat: Add custom EMA function"
git commit -m "feat(alerts): Add breakout with outside bid alert"

# 修正錯誤
git commit -m "fix: Resolve RSI alert duplicate trigger issue"
git commit -m "fix: Optimize screener script performance"

# 更新文檔
git commit -m "docs: Update maintenance guide"
git commit -m "docs: Add investment terminology glossary"

# 重構程式碼
git commit -m "refactor: Improve code readability"
git commit -m "refactor(scripts): Standardize variable naming"

# 其他
git commit -m "test: Add unit tests for alert functions"
git commit -m "style: Format code according to style guide"
git commit -m "chore: Update project dependencies"
```

**Commit 訊息類型說明**：
- `feat`: 新功能
- `fix`: 錯誤修正
- `docs`: 文檔更新
- `style`: 程式碼格式調整
- `refactor`: 程式碼重構
- `test`: 測試相關
- `chore`: 維護性工作

#### 步驟 6：推送到 GitHub

```bash
# 推送到遠端的 master 分支
git push origin master

# 如果是第一次推送，可能需要設定上游
git push -u origin master
```

**成功的訊息**：
```
Enumerating objects: 5, done.
Counting objects: 100% (5/5), done.
Delta compression using up to 8 threads
Compressing objects: 100% (3/3), done.
Writing objects: 100% (3/3), 1.23 KiB | 1.23 MiB/s, done.
Total 3 (delta 2), reused 0 (delta 0)
To https://github.com/azaleacross/GR.git
   abc1234..def5678  master -> master
```

---

## 👥 Gordon 和 Ronnie 的協作流程

### Gordon 的工作流程

**角色**：專案負責人、審核者

#### 日常工作
```bash
# 1. 開始工作前
git pull origin master

# 2. 審核和開發
# - 審核 Ronnie 的程式碼
# - 開發自己的功能
# - 更新核心文檔

# 3. 提交變更
git status                                    # 確認變更
git add .                                     # 添加所有變更
git commit -m "review: Approve Ronnie's RSI alert script"   # 提交
git push origin master                        # 推送

# 4. 結束工作
# 確保所有變更都已推送
git status  # 應該顯示 "nothing to commit, working tree clean"
```

#### 審核 Ronnie 的工作
```bash
# 1. Ronnie 通知有新的推送後
git pull origin master

# 2. 查看 Ronnie 的變更
git log -3                     # 查看最近 3 次 commit
git diff HEAD~1                # 查看上一次 commit 的變更

# 3. 檢視變更的檔案
# 使用編輯器檢視和測試

# 4. 如果需要修改
# 直接修改檔案，然後 add、commit、push

# 5. 如果需要回退
git revert HEAD                # 回退上一次 commit（保留歷史）
# 或
git reset --hard HEAD~1        # 完全刪除上一次 commit（危險！）
```

### Ronnie 的工作流程

**角色**：開發組員

#### 日常工作
```bash
# 1. 開始工作前（重要！）
git pull origin master

# 2. 開發新功能
# - 在 brainstorm/ 開發和測試
# - 充分測試後移到 production/
# - 更新相關文檔

# 3. 提交變更
git status
git add .
git commit -m "feat: Add moving average crossover alert script"
git push origin master

# 4. 通知 Gordon
# 透過訊息告知：「我推送了新的均線交叉警示，請審核」
```

#### 推送前的檢查清單
- [ ] 程式碼經過測試
- [ ] 遵循程式碼風格指南
- [ ] 更新了相關文檔
- [ ] （函數）更新了 FUNCTIONS_INDEX.md
- [ ] commit 訊息清楚說明變更內容（使用英文）

---

## 🔄 常見情境處理

### 情境 1：推送前發現 GitHub 有新版本

```bash
# 你準備推送時出現錯誤
git push origin master

# 錯誤訊息
! [rejected]        master -> master (fetch first)
error: failed to push some refs to 'https://github.com/...'
hint: Updates were rejected because the remote contains work that you do
hint: not have locally. This is usually caused by another repository pushing
```

**原因**：Ronnie 在你之前推送了變更。

**解決方案**：
```bash
# 1. 先拉取 GitHub 的最新版本
git pull origin master

# 2. 如果沒有衝突，Git 會自動合併
# 然後再推送
git push origin master

# 3. 如果有衝突（見下方「處理衝突」）
```

### 情境 2：忘記 pull 就開始工作了

```bash
# 你已經修改了檔案，但忘記先 pull

# 1. 暫存目前的變更
git stash

# 2. 拉取最新版本
git pull origin master

# 3. 恢復你的變更
git stash pop

# 4. 檢查是否有衝突，解決後繼續工作
```

### 情境 3：不小心修改了錯誤的檔案

```bash
# 還沒 commit 的情況
# 1. 查看狀態
git status

# 2. 恢復特定檔案
git checkout -- 檔案路徑

# 3. 或恢復所有變更
git reset --hard HEAD

# 已經 commit 但還沒 push 的情況
# 1. 回退到上一個 commit
git reset --soft HEAD~1   # 保留變更，只取消 commit
# 或
git reset --hard HEAD~1   # 完全刪除變更

# 已經 push 到 GitHub 的情況
# 1. 使用 revert（推薦，保留歷史）
git revert HEAD
git push origin master

# 2. 或請求 Gordon 協助處理
```

### 情境 4：兩個人同時修改了同一個檔案（衝突）

```bash
# 拉取時出現衝突
git pull origin master

# 輸出
Auto-merging scripts/alerts/production/MyAlert.xs
CONFLICT (content): Merge conflict in scripts/alerts/production/MyAlert.xs
Automatic merge failed; fix conflicts and then commit the result.
```

**解決步驟**：

1. **查看衝突的檔案**
```bash
git status
```

2. **開啟衝突的檔案**，會看到類似這樣的標記：
```xscript
<<<<<<< HEAD
// 你的版本
vars: MyRSI(0);
MyRSI = RSI(Close, 14);
=======
// GitHub（Ronnie）的版本
vars: MyRSI(0);
MyRSI = RSI(Close, 20);
>>>>>>> abc1234567890
```

3. **手動編輯檔案**，決定要保留哪個版本：
```xscript
// 選擇一個版本，或合併兩者
vars: MyRSI(0);
MyRSI = RSI(Close, 14);  // 保留我的版本

// 刪除衝突標記（<<<<<<< ======= >>>>>>>）
```

4. **標記衝突已解決**
```bash
git add scripts/alerts/production/MyAlert.xs
```

5. **完成合併**
```bash
git commit -m "merge: Resolve conflict in MyAlert.xs"
git push origin master
```

6. **通知對方**
告訴 Ronnie 或 Gordon：「我解決了衝突並推送了」

---

## ⚠️ 重要注意事項

### DO（應該做的）

✅ **每次開始工作前 git pull**
```bash
git pull origin master
```

✅ **經常提交，但要有意義**
```bash
# 好的做法：功能完成就提交
git commit -m "新增：RSI 警示腳本"
git commit -m "修正：重複觸發問題"

# 避免：一次提交太多不相關的變更
```

✅ **推送前確認程式碼可用**
- 測試腳本功能
- 檢查語法錯誤
- 遵循程式碼風格

✅ **寫清楚的 commit 訊息（必須使用英文）**
```bash
# 好的訊息
git commit -m "feat: Add Pin Bar alert script with bidirectional detection"
git commit -m "fix: Resolve duplicate trigger issue in RSI alert"

# 不好的訊息
git commit -m "update"
git commit -m "修改"
git commit -m "新增功能"  # 中文會造成亂碼
```

✅ **有疑問時先溝通**
- 不確定要不要推送？先問 Gordon
- 遇到複雜衝突？找對方討論
- 發現問題？立即通知

### DON'T（不應該做的）

❌ **不要直接在 GitHub 網頁編輯**
- 容易造成版本不同步
- 本機會不知道有新的變更

❌ **不要 force push（除非非常確定）**
```bash
# 危險！會覆蓋 GitHub 上的歷史
git push --force origin master
```

❌ **不要 commit 敏感資訊**
- 密碼、API 金鑰
- 個人資料
- 大型二進位檔案（圖片、影片等）

❌ **不要忽略衝突**
- 發現衝突要立即處理
- 不要 push 還沒解決的衝突

---

## 🛠️ 實用 Git 指令

### 查看狀態和歷史

```bash
# 查看目前狀態
git status

# 查看變更內容
git diff

# 查看 commit 歷史
git log

# 查看簡潔的歷史（一行一個 commit）
git log --oneline

# 查看最近 5 次 commit
git log -5

# 查看某個檔案的歷史
git log -- 檔案路徑

# 查看誰修改了哪一行
git blame 檔案路徑
```

### 復原和回退

```bash
# 放棄工作區的變更（還沒 add）
git checkout -- 檔案路徑
git restore 檔案路徑

# 取消 add（從暫存區移除）
git reset HEAD 檔案路徑
git restore --staged 檔案路徑

# 修改上一次 commit 的訊息
git commit --amend -m "新的訊息"

# 回到上一個 commit（保留變更）
git reset --soft HEAD~1

# 回到上一個 commit（刪除變更）
git reset --hard HEAD~1

# 回到特定 commit
git reset --hard commit_hash
```

### 分支操作（進階）

```bash
# 查看分支
git branch

# 創建新分支
git branch 分支名稱

# 切換分支
git checkout 分支名稱
# 或
git switch 分支名稱

# 創建並切換到新分支
git checkout -b 分支名稱
# 或
git switch -c 分支名稱

# 合併分支
git merge 分支名稱

# 刪除分支
git branch -d 分支名稱
```

---

## 📋 每日工作檢查清單

### 開始工作
- [ ] 開啟終端/命令提示字元
- [ ] 切換到專案目錄：`cd C:\Users\USER\Documents\Github\XScript`
- [ ] 拉取最新版本：`git pull origin master`
- [ ] 確認沒有錯誤訊息

### 工作中
- [ ] 修改檔案
- [ ] 隨時 `git status` 確認狀態
- [ ] 功能完成就 commit

### 結束工作
- [ ] 確認所有變更：`git status`
- [ ] 添加變更：`git add .`
- [ ] 提交：`git commit -m "清楚的訊息"`
- [ ] 推送：`git push origin master`
- [ ] 確認推送成功
- [ ] （Ronnie）通知 Gordon 已推送

---

## 🆘 緊急救援

### 「我不小心刪除了重要檔案！」

```bash
# 如果還沒 commit
git checkout -- 檔案路徑

# 如果已經 commit 但還沒 push
git reset --hard HEAD~1

# 如果已經 push 到 GitHub
# 方法 1：找到刪除前的 commit
git log --all --full-history -- 檔案路徑
git checkout commit_hash -- 檔案路徑

# 方法 2：請求 Gordon 協助從 GitHub 恢復
```

### 「我的本機和 GitHub 完全亂掉了！」

```bash
# 最後手段：完全重置（會失去本機未推送的變更）
# 1. 備份重要的未提交變更（複製到其他地方）

# 2. 重置到 GitHub 的狀態
git fetch origin
git reset --hard origin/master

# 3. 清理未追蹤的檔案
git clean -fd

# 4. 確認狀態
git status  # 應該顯示 "nothing to commit, working tree clean"
```

### 「Ronnie 和我同時改了同一個檔案，衝突很複雜！」

```bash
# 方法 1：使用圖形化工具
# VS Code、GitHub Desktop 等都有視覺化的衝突解決工具

# 方法 2：溝通決定
# 1. 先備份你的版本
cp 檔案路徑 檔案路徑.backup

# 2. 使用對方的版本
git checkout --theirs 檔案路徑

# 3. 手動合併你的變更
# 從 .backup 檔案複製需要的部分

# 4. 完成合併
git add 檔案路徑
git commit -m "merge: Manually integrate changes from both parties"
git push origin master
```

---

## 🎓 進階主題

### 使用 .gitignore 忽略檔案

某些檔案不應該上傳到 GitHub：

創建或編輯 `.gitignore` 檔案：
```
# Python 編譯檔案
__pycache__/
*.pyc
*.pyo

# 編輯器設定
.vscode/
.idea/

# 系統檔案
.DS_Store
Thumbs.db

# 暫存檔案
*.tmp
*.bak
*.swp

# 個人設定（不應共享）
config.local.js
.env.local

# 大型檔案
*.mp4
*.zip
```

### 使用分支進行開發（選用）

**概念**：
- `master` 分支：穩定的正式版本
- 功能分支：開發新功能時創建臨時分支

**流程**：
```bash
# 1. 創建功能分支
git checkout -b feature/pin-bar-alert

# 2. 在分支上開發和 commit
git add .
git commit -m "wip: Develop Pin Bar alert"

# 3. 完成後合併回 master
git checkout master
git pull origin master           # 確保 master 是最新的
git merge feature/pin-bar-alert

# 4. 推送
git push origin master

# 5. 刪除功能分支
git branch -d feature/pin-bar-alert
```

### 使用 Git GUI 工具

**推薦工具**：
- **GitHub Desktop**：圖形化介面，適合初學者
- **VS Code 內建**：編輯器內建的 Git 功能
- **GitKraken**：功能強大的 Git 客戶端
- **SourceTree**：免費的 Git GUI

**優點**：
- 視覺化的 commit 歷史
- 簡單的衝突解決介面
- 不需要記指令

---

## 📚 學習資源

### 快速入門
- [Pro Git 書（中文版）](https://git-scm.com/book/zh-tw/v2)
- [GitHub 官方指南](https://guides.github.com/)
- [Git 教學（英文）](https://www.atlassian.com/git/tutorials)

### 視覺化工具
- [Git 視覺化學習](https://learngitbranching.js.org/?locale=zh_TW)
- [Git Cheat Sheet](https://training.github.com/downloads/zh_TW/github-git-cheat-sheet/)

---

## 🎯 總結

### 核心流程（每天重複）

```bash
1. git pull origin master     # 拉取最新
2. [修改檔案]                 # 開發工作
3. git status                 # 確認變更
4. git add .                  # 添加變更
5. git commit -m "訊息"       # 提交
6. git push origin master     # 推送
```

### 關鍵原則

1. **經常 pull**：開始工作前、推送前
2. **清楚的 commit**：有意義的訊息
3. **及時推送**：不要累積太多變更
4. **主動溝通**：有問題立即討論
5. **不要害怕**：Git 可以恢復幾乎所有錯誤

### Gordon 和 Ronnie 的協作

- **Ronnie**：開發 → commit → push → 通知 Gordon
- **Gordon**：pull → 審核 → 修改（如需要）→ push
- **雙方**：經常 pull，保持同步

---

## 📞 需要協助？

遇到 Git 問題時：
1. **不要慌張**：幾乎所有問題都能解決
2. **查看錯誤訊息**：Git 的錯誤訊息通常很有幫助
3. **參考本指南**：查找類似情境
4. **詢問對方**：Gordon 和 Ronnie 互相協助
5. **詢問 AI**：提供完整的錯誤訊息

---

**Git 是強大的工具，掌握基本流程後，協作會變得很順暢！** 🚀

---

**最後更新**：2025-10-20  
**維護者**：Gordon, Ronnie  
**版本**：1.0

