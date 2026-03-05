# Git 協作補充說明

> 回答 Gordon 關於本機/GitHub/協作流程的問題

---

## ❓ 問題 1：本機專案 vs GitHub 專案的差別

### 簡單理解

```
┌─────────────────────┐
│   Gordon 的電腦     │
│  ┌───────────────┐  │
│  │ 本機專案資料夾 │  │  可以自由修改、測試
│  │ (工作區)      │  │  
│  └───────────────┘  │
└──────────┬──────────┘
           │ git push（推送）
           │ git pull（拉取）
           ↓
    ┌─────────────────┐
    │    GitHub       │  線上中央倉庫
    │   (遠端倉庫)    │  團隊共享的版本
    └─────────────────┘
           ↑
           │ git push（推送）
           │ git pull（拉取）
┌──────────┴──────────┐
│   Ronnie 的電腦     │
│  ┌───────────────┐  │
│  │ 本機專案資料夾 │  │  可以自由修改、測試
│  │ (工作區)      │  │
│  └───────────────┘  │
└─────────────────────┘
```

### 關鍵概念

**本機專案資料夾**：
- 就是你電腦上的 `C:\Users\USER\Documents\Github\XScript`
- 可以自由修改、測試、實驗
- **不會**自動同步到 GitHub
- **需要**手動 `git push` 才會上傳到 GitHub

**GitHub 遠端倉庫**：
- 線上的「中央倉庫」
- 所有團隊成員共享的版本
- 作為「真理來源」（source of truth）
- 提供版本控制和備份功能

### 工作流程

✅ **正確的流程**：

```
1. 本機修改和測試
   └─ 在 brainstorm/ 開發
   └─ 充分測試，確認視覺 OK
   └─ 移到 production/（如果是正式版本）

2. 使用 Git 提交
   └─ git add .
   └─ git commit -m "新增：XXX 功能"

3. 推送到 GitHub
   └─ git push origin master

4. 其他人拉取更新
   └─ git pull origin master
```

### 你的理解是正確的！

> 「本機寫完成視覺的OK再用ai agent手動推送到GitHub」

✅ **完全正確**！流程就是：
1. 本機開發和測試
2. 確認沒問題
3. 手動 `git push`（可以在 Cursor 的終端機執行，或使用 GitHub Desktop）

---

## ❓ 問題 2：GitHub 的備份機制

### GitHub 本身就是備份系統！

✅ **Git 就是一個完整的版本控制和備份系統**：

```
每次 commit = 一個完整的備份點

時間軸：
─────●─────●─────●─────●──────> 現在
     │     │     │     │
     v1.0  v1.1  v1.2  v1.3
     
     可以隨時回到任何一個版本！
```

### 備份的層次

#### 層次 1：本機 Git 倉庫
```bash
# 查看所有歷史版本
git log

# 輸出範例
commit abc123... (HEAD -> master)
Author: Gordon
Date:   2025-10-20
    新增：Pin Bar 警示腳本

commit def456...
Author: Ronnie
Date:   2025-10-19
    修正：RSI 計算錯誤

commit ghi789...
Author: Gordon
Date:   2025-10-18
    初始提交
```

**每個 commit 都保存了完整的專案狀態**！

#### 層次 2：GitHub 遠端倉庫
- 本機的所有歷史版本都會推送到 GitHub
- GitHub 的伺服器提供額外的備份保障
- 即使本機電腦壞掉，GitHub 上還有完整備份

#### 層次 3：GitHub 的內部備份
- GitHub 本身有多重備份機制
- 資料存儲在多個地理位置
- 幾乎不可能丟失資料

### 如何還原變更

#### 情境 1：改錯了還沒 commit

```bash
# 放棄所有未提交的變更
git checkout -- 檔案名稱

# 或放棄所有變更
git reset --hard HEAD
```

#### 情境 2：改錯了已經 commit

```bash
# 方法 1：回退到上一個版本
git reset --hard HEAD~1

# 方法 2：查看歷史並跳到特定版本
git log --oneline
# abc123 新增：Pin Bar 警示  <- 現在在這裡，有問題
# def456 修正：RSI 計算     <- 想回到這裡
# ghi789 初始提交

git reset --hard def456
```

#### 情境 3：已經推送到 GitHub

```bash
# 方法 1：使用 revert（推薦，保留歷史）
git revert HEAD
git push origin master

# 方法 2：強制回退（需要團隊協調）
git reset --hard HEAD~1
git push --force origin master  # 危險！團隊要溝通
```

### 不需要額外備份！

❌ **不需要**：
- 不需要手動複製資料夾
- 不需要另外的備份軟體
- 不需要定期打包 zip

✅ **只需要**：
- 定期 `git commit`（創建備份點）
- 定期 `git push`（上傳到 GitHub）

---

## ❓ 問題 3：Gordon 和 Ronnie 的推送說明

### 協作流程詳解

#### Ronnie 的完整流程

```bash
# === 第1步：開始工作前 ===
cd C:\Users\USER\Documents\Github\XScript
git pull origin master
# 為什麼？確保有最新的程式碼，避免衝突

# === 第2步：開發和測試 ===
# 在 scripts/{type}/brainstorm/ 開發
# 充分測試功能

# === 第3步：查看變更 ===
git status
# 會顯示哪些檔案被修改了

# === 第4步：添加變更 ===
git add .
# 把所有變更加入暫存區

# === 第5步：提交變更 ===
git commit -m "新增：均線交叉警示腳本"
# 創建一個版本記錄點

# === 第6步：推送到 GitHub ===
git push origin master
# 上傳到 GitHub

# === 第7步：通知 Gordon ===
# 透過訊息、Email 或其他方式告知：
# 「我剛推送了新的均線交叉警示腳本，請幫忙審核」
```

#### Gordon 的完整流程

```bash
# === 收到 Ronnie 通知後 ===

# 第1步：拉取 Ronnie 的更新
cd C:\Users\USER\Documents\Github\XScript
git pull origin master

# 第2步：查看 Ronnie 的變更
git log -3              # 查看最近3次提交
git diff HEAD~1         # 查看上一次的詳細變更

# 第3步：審核程式碼
# 開啟編輯器檢視檔案
# 測試功能是否正常

# === 情境A：程式碼OK，直接批准 ===
# 什麼都不用做，Ronnie 的變更已經在 GitHub 上了

# === 情境B：需要小修改 ===
# 直接修改檔案
git add .
git commit -m "審核：修改 Ronnie 的警示腳本格式"
git push origin master

# === 情境C：需要移到 production ===
# 移動檔案
mv scripts/alerts/brainstorm/MyAlert.xs scripts/alerts/production/
git add .
git commit -m "發布：將 MyAlert 移到 production"
git push origin master

# === 情境D：有問題，需要回退 ===
git revert HEAD
git push origin master
# 然後通知 Ronnie：「有個問題，已經回退，請修正後再推送」
```

### 特殊情境：衝突處理

#### 什麼是衝突？

Gordon 和 Ronnie **同時修改了同一個檔案的同一個位置**。

**範例**：

```
早上 9:00 - 兩人都從 GitHub pull 了最新版本
早上 9:30 - Gordon 修改了 MyAlert.xs 的第10行
早上 10:00 - Ronnie 也修改了 MyAlert.xs 的第10行
早上 10:30 - Ronnie 先 push 到 GitHub
早上 11:00 - Gordon 嘗試 push → 被拒絕！
```

#### 解決步驟

```bash
# Gordon 執行
git push origin master

# 錯誤訊息
! [rejected]        master -> master (fetch first)

# 解決方法
git pull origin master

# 如果有衝突，會顯示
CONFLICT (content): Merge conflict in scripts/alerts/production/MyAlert.xs

# 開啟 MyAlert.xs，會看到
<<<<<<< HEAD
// Gordon 的版本
MyRSI = RSI(Close, 14);
=======
// Ronnie 的版本
MyRSI = RSI(Close, 20);
>>>>>>> abc1234

# 決定要保留哪個版本（或合併）
MyRSI = RSI(Close, 14);  // 保留 Gordon 的

# 刪除衝突標記，然後
git add scripts/alerts/production/MyAlert.xs
git commit -m "合併：解決 MyAlert 的 RSI 參數衝突"
git push origin master

# 通知 Ronnie：「我解決了衝突，你需要重新 pull」
```

### 避免衝突的最佳實踐

1. **經常 pull**
   ```bash
   # 每次開始工作前
   git pull origin master
   
   # 甚至在工作中途
   git pull origin master
   ```

2. **小步提交**
   ```bash
   # 不要累積太多變更才 commit
   # 功能完成就 commit 和 push
   ```

3. **分工明確**
   ```bash
   # 盡量不要同時修改同一個檔案
   # 如果需要，先溝通
   ```

4. **使用 brainstorm/production 分離**
   ```bash
   # Ronnie 主要在 brainstorm/ 開發
   # Gordon 主要審核和移到 production/
   # 減少同時修改相同檔案的機會
   ```

---

## 📋 推送前檢查清單

### Ronnie 推送前

- [ ] `git pull origin master`（確保有最新版本）
- [ ] 程式碼已充分測試
- [ ] 遵循程式碼風格指南
- [ ] 更新了相關文檔
- [ ] （函數）更新了 FUNCTIONS_INDEX.md
- [ ] `git status`（確認要提交的檔案）
- [ ] `git add .`
- [ ] `git commit -m "清楚的訊息"`
- [ ] `git push origin master`
- [ ] 通知 Gordon

### Gordon 審核後

- [ ] `git pull origin master`（拉取 Ronnie 的更新）
- [ ] 查看 commit 歷史：`git log -3`
- [ ] 測試功能
- [ ] 如有需要，進行修改
- [ ] 移到 production/（如適用）
- [ ] `git add .` → `git commit` → `git push`
- [ ] 回覆 Ronnie 審核結果

---

## 🎯 總結

### 核心答案

1. **本機 vs GitHub**
   - 本機：工作區，自由修改
   - GitHub：中央倉庫，團隊共享
   - 流程：本機修改 → 測試 OK → `git push` → GitHub

2. **GitHub 就是備份**
   - 每次 commit = 一個備份點
   - 可以隨時回到任何版本
   - 不需要額外的備份機制
   - 只要定期 commit 和 push

3. **推送說明**
   - Ronnie：開發 → commit → push → 通知 Gordon
   - Gordon：pull → 審核 → 修改（如需要）→ push
   - 遇到衝突：手動解決 → commit → push

### 已創建的文檔

完整的詳細說明請參考：
- **[GIT_WORKFLOW.md](docs/guides/GIT_WORKFLOW.md)** - 完整的工作流程指南（12000+ 字）
- **[GIT_QUICK_REFERENCE.md](docs/guides/GIT_QUICK_REFERENCE.md)** - 快速參考卡

### 關鍵原則

1. **經常 pull**：避免版本不同步
2. **清楚的 commit**：讓團隊知道你做了什麼
3. **及時 push**：不要累積太多變更
4. **主動溝通**：推送後通知對方
5. **不要害怕**：Git 可以還原幾乎所有錯誤

---

**有了這些文檔，Gordon 和 Ronnie 就可以安全、高效地協作了！** 🎉

---

**最後更新**：2025-10-20  
**維護者**：Gordon, Ronnie

