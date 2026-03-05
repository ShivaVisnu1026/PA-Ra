# Git Commit 規則指南

> 專案 Git Commit 訊息規範，確保版本控制的一致性和可讀性

---

## 🚨 重要規則

### ⚠️ 必須使用英文 Commit 訊息

**原因**：中文 commit 訊息在 GitHub 上會顯示亂碼，影響專案可讀性。

```bash
# ✅ 正確
git commit -m "feat: Add breakout alert script"
git commit -m "fix: Resolve RSI calculation error"

# ❌ 錯誤（會造成亂碼）
git commit -m "新增：突破警示腳本"
git commit -m "修正：RSI 計算錯誤"
```

---

## 📝 Commit 訊息格式

### 標準格式

```
type(scope): description

[optional body]

[optional footer]
```

### 類型 (Type)

| 類型 | 說明 | 範例 |
|------|------|------|
| `feat` | 新功能 | `feat: Add Pin Bar alert script` |
| `fix` | 錯誤修正 | `fix: Resolve duplicate trigger issue` |
| `docs` | 文檔更新 | `docs: Update API documentation` |
| `style` | 程式碼格式調整 | `style: Format code according to guide` |
| `refactor` | 程式碼重構 | `refactor: Simplify alert logic` |
| `test` | 測試相關 | `test: Add unit tests for functions` |
| `chore` | 維護性工作 | `chore: Update dependencies` |
| `perf` | 效能優化 | `perf: Optimize calculation speed` |
| `ci` | CI/CD 相關 | `ci: Add automated testing` |
| `build` | 建置系統 | `build: Update webpack config` |

### 範圍 (Scope) - 可選

指定變更影響的範圍：

```bash
# 腳本類型
feat(alerts): Add breakout alert script
feat(indicators): Add custom RSI function
feat(screeners): Add momentum screener
feat(trading): Add position management

# 文檔類型
docs(guides): Update Git workflow guide
docs(api): Add function documentation

# 工具類型
chore(tools): Update scraping script
test(scripts): Add alert validation tests
```

### 描述 (Description)

- 使用現在式動詞（Add, Fix, Update, Remove）
- 首字母小寫
- 不要以句號結尾
- 簡潔明瞭，不超過 50 字元

```bash
# ✅ 好的描述
feat: Add breakout alert with outside bid detection
fix: Resolve memory leak in tick processing
docs: Update installation instructions

# ❌ 不好的描述
feat: Added breakout alert with outside bid detection  # 過去式
fix: Resolves memory leak in tick processing          # 第三人稱
docs: Updated installation instructions               # 過去式
```

---

## 🎯 實際範例

### XScript 專案範例

```bash
# 新增腳本
feat(alerts): Add breakout with outside bid alert
feat(indicators): Add custom EMA calculation function
feat(screeners): Add momentum stock screener

# 修正錯誤
fix(alerts): Resolve duplicate trigger in RSI alert
fix(indicators): Fix calculation error in MACD function
fix(screeners): Correct volume filter logic

# 文檔更新
docs(guides): Update Git workflow with English commit rules
docs(api): Add function parameter documentation
docs(examples): Add breakout strategy examples

# 重構程式碼
refactor(alerts): Simplify alert trigger logic
refactor(functions): Standardize variable naming
refactor(scripts): Improve code readability

# 測試
test(alerts): Add unit tests for alert functions
test(indicators): Validate calculation accuracy
test(integration): Add end-to-end testing

# 維護
chore(deps): Update XScript dependencies
chore(ci): Add automated testing pipeline
chore(scripts): Clean up unused functions
```

### 複雜變更範例

```bash
# 多個檔案變更
feat: Add comprehensive breakout detection system

- Add breakout alert script with outside bid detection
- Add momentum screener for breakout candidates  
- Update documentation with usage examples
- Add unit tests for new functions

# 重大重構
refactor: Restructure alert system architecture

BREAKING CHANGE: Alert function signatures have changed.
Migration guide available in docs/migration.md.

# 緊急修正
fix: Critical bug in tick volume calculation

Resolves issue where tick volume was incorrectly calculated,
causing false alerts. Immediate fix required for production.
```

---

## 🔧 實用工具

### Git Hooks（自動檢查）

創建 `.git/hooks/commit-msg` 檔案：

```bash
#!/bin/sh
# 檢查 commit 訊息格式

commit_regex='^(feat|fix|docs|style|refactor|test|chore|perf|ci|build)(\(.+\))?: .{1,50}$'

if ! grep -qE "$commit_regex" "$1"; then
    echo "❌ Invalid commit message format!"
    echo "✅ Use: type(scope): description"
    echo "📝 Example: feat(alerts): Add breakout alert script"
    exit 1
fi

echo "✅ Commit message format is valid"
```

### VS Code 設定

在 `.vscode/settings.json` 中：

```json
{
  "git.inputValidation": "always",
  "git.inputValidationLength": 50,
  "git.inputValidationSubjectLength": 50
}
```

---

## 📋 檢查清單

### Commit 前檢查

- [ ] 使用英文撰寫 commit 訊息
- [ ] 選擇正確的類型（feat, fix, docs, etc.）
- [ ] 描述簡潔明瞭（不超過 50 字元）
- [ ] 使用現在式動詞
- [ ] 首字母小寫
- [ ] 不以句號結尾

### 推送前檢查

- [ ] 所有變更都已測試
- [ ] 程式碼符合風格指南
- [ ] 相關文檔已更新
- [ ] Commit 訊息格式正確
- [ ] 沒有敏感資訊

---

## 🚀 快速參考

### 常用指令

```bash
# 基本提交
git add .
git commit -m "feat: Add new alert script"
git push origin master

# 修改最後一次 commit 訊息
git commit --amend -m "feat: Add breakout alert script"

# 查看 commit 歷史
git log --oneline -10

# 查看特定檔案的歷史
git log --oneline -- 檔案路徑
```

### 緊急情況

```bash
# 如果已經推送了中文 commit
git commit --amend -m "feat: Add breakout alert script"
git push origin master --force

# 如果有多個中文 commit 需要修正
git rebase -i HEAD~3  # 互動式 rebase
# 在編輯器中將 'pick' 改為 'reword' 來修改訊息
```

---

## 📚 學習資源

- [Conventional Commits](https://www.conventionalcommits.org/)
- [Angular Commit Guidelines](https://github.com/angular/angular/blob/main/CONTRIBUTING.md#commit)
- [Git Commit Best Practices](https://chris.beams.io/posts/git-commit/)

---

## 🎯 總結

### 核心原則

1. **必須使用英文**：避免亂碼問題
2. **格式一致**：`type(scope): description`
3. **描述清楚**：簡潔明瞭，不超過 50 字元
4. **類型正確**：選擇合適的 commit 類型
5. **現在式動詞**：Add, Fix, Update, Remove

### 團隊協作

- **Gordon**：審核 commit 訊息格式
- **Ronnie**：遵循 commit 規則
- **雙方**：互相提醒使用英文

---

**記住：好的 commit 訊息是專案可維護性的基礎！** 🚀

---

**最後更新**：2025-10-21  
**維護者**：Gordon, Ronnie  
**版本**：1.0
