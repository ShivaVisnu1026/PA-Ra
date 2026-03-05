# Taiwan Market News Web Crawler System

台灣市場新聞爬蟲系統 - 用於監控台灣金融新聞網站、提取市場相關資訊，並挖掘 xQScript 語法模式和程式碼範例。

## 功能特性

- **多網站支援**: 支援多個台灣金融新聞網站（鉅亨網、工商時報、經濟日報等）
- **程式碼提取**: 自動從網頁中提取 xQScript 程式碼範例和語法模式
- **智能警示**: 基於關鍵字的警示系統，可即時通知重要新聞
- **結構化歸檔**: 將文章和程式碼歸檔到結構化的目錄中，便於後續分析
- **可搜尋索引**: 維護可搜尋的文章索引，方便快速查找

## 安裝

### 1. 安裝依賴套件

```powershell
pip install -r GR/04_tools/requirements_crawler.txt
```

### 2. 配置設定檔

編輯 `GR/04_tools/crawler_config.json` 以自訂：
- 要監控的網站
- 警示關鍵字
- 爬取參數
- 輸出目錄

## 使用方法

### 基本使用

```powershell
# 執行完整爬取（新聞 + 程式碼 + 警示 + 歸檔）
python GR/04_tools/run_news_crawler.py
```

### 進階選項

```powershell
# 只抓取新聞
python GR/04_tools/run_news_crawler.py --mode news

# 只提取程式碼
python GR/04_tools/run_news_crawler.py --mode code-only

# 指定特定網站
python GR/04_tools/run_news_crawler.py --sites cnYES commercial_times

# 列出所有可用網站
python GR/04_tools/run_news_crawler.py --list-sites

# 使用自訂配置檔
python GR/04_tools/run_news_crawler.py --config custom_config.json
```

## 系統架構

### 主要模組

1. **taiwan_news_crawler.py** - 主要爬蟲模組
   - 多網站支援
   - 內容提取
   - 重複檢測

2. **xscript_syntax_extractor.py** - 程式碼提取模組
   - 從 HTML 中提取程式碼區塊
   - 識別 xQScript 語法模式
   - 分類程式碼類型（indicator, alert, screener, function）

3. **news_alert_manager.py** - 警示管理模組
   - 關鍵字匹配
   - 優先級管理
   - 多通道通知（console, file, email）

4. **news_archive_manager.py** - 歸檔管理模組
   - 結構化儲存
   - 可搜尋索引
   - 依日期和來源組織

5. **run_news_crawler.py** - 主執行腳本
   - 命令列介面
   - 整合所有模組
   - 支援排程執行

## 目錄結構

執行後會產生以下目錄結構：

```
DaTa/
  News/
    Archive/                    # 歸檔的文章
      YYYY-MM-DD/
        source_name/
          article_*.md
          articles.json
    CodeExamples/              # 提取的程式碼
      YYYY-MM-DD/
        syntax_patterns.json
        code_blocks/
          indicator/
            indicator_*.xs
          alert/
            alert_*.xs
          screener/
            screener_*.xs
          function/
            function_*.xs
    Alerts/                    # 警示記錄
      alerts.json
    Index/                     # 搜尋索引
      index.json
```

## 配置說明

### 網站配置

每個網站在 `crawler_config.json` 中定義：

```json
{
  "name": "cnYES",
  "display_name": "鉅亨網",
  "base_url": "https://news.cnyes.com/",
  "news_list_url": "https://news.cnyes.com/news/cat/tw_stock",
  "selectors": {
    "article_links": "a[href*='/news/']",
    "title": "h1, .article-title",
    "content": ".article-content",
    "date": ".date, time"
  },
  "update_frequency": "hourly",
  "enabled": true
}
```

### 警示關鍵字

配置關鍵字和優先級：

```json
{
  "alert_settings": {
    "keywords": {
      "high_priority": ["台積電", "TSMC", "大盤"],
      "medium_priority": ["聯發科", "鴻海"],
      "low_priority": ["財報", "營收"]
    }
  }
}
```

### 爬取設定

```json
{
  "crawler_settings": {
    "request_delay": 0.5,
    "timeout": 20,
    "max_retries": 3,
    "max_articles_per_site": 50
  }
}
```

## 排程執行

### Windows Task Scheduler

1. 開啟「工作排程器」
2. 建立基本工作
3. 設定觸發條件（例如：每天 7:00 AM）
4. 設定動作：啟動程式
   - 程式：`python`
   - 引數：`GR/04_tools/run_news_crawler.py`
   - 開始於：專案根目錄

### PowerShell 排程

建立批次檔 `run_crawler_daily.bat`:

```batch
@echo off
cd /d E:\PriceActions-main
python GR\04_tools\run_news_crawler.py
```

然後使用 Task Scheduler 執行此批次檔。

## 程式碼提取

系統會自動從網頁中提取 xQScript 程式碼，並：

1. 識別程式碼類型（indicator, alert, screener, function, autotrade）
2. 提取函數簽名和參數
3. 提取變數和輸入參數
4. 提取指標函數使用
5. 儲存到分類目錄中

提取的程式碼會包含：
- 來源 URL
- 提取時間
- 程式碼類型
- 元數據（函數、變數、參數等）

## 警示系統

當文章包含配置的關鍵字時，系統會：

1. 檢查文章標題和內容
2. 匹配關鍵字並確定優先級
3. 發送通知：
   - **Console**: 在終端顯示警示
   - **File**: 儲存到 `DaTa/News/Alerts/alerts.json`
   - **Email**: 可選的電子郵件通知（需配置）

## 搜尋功能

使用歸檔管理器的搜尋功能：

```python
from news_archive_manager import NewsArchiveManager

manager = NewsArchiveManager()
results = manager.search_index("台積電", limit=20)
for article in results:
    print(f"{article['title']} - {article['source']}")
```

## 疑難排解

### 常見問題

1. **無法連接到網站**
   - 檢查網路連線
   - 確認網站 URL 是否正確
   - 檢查防火牆設定

2. **提取不到內容**
   - 網站結構可能已變更
   - 更新 `crawler_config.json` 中的 CSS 選擇器
   - 檢查網站是否需要登入

3. **程式碼提取失敗**
   - 確認網頁包含 xQScript 程式碼
   - 檢查程式碼是否在 `<pre>` 或 `<code>` 標籤中
   - 確認程式碼包含 xQScript 關鍵字

4. **警示未觸發**
   - 檢查關鍵字配置是否正確
   - 確認警示系統已啟用
   - 檢查文章內容是否包含關鍵字

### 除錯模式

在程式碼中加入詳細日誌：

```python
import logging
logging.basicConfig(level=logging.DEBUG)
```

## 最佳實踐

1. **定期更新選擇器**: 網站結構可能變更，定期檢查並更新 CSS 選擇器
2. **合理設定延遲**: 避免請求過於頻繁，遵守網站的 robots.txt
3. **監控警示**: 定期檢查警示記錄，調整關鍵字配置
4. **備份資料**: 定期備份 `DaTa/News/` 目錄
5. **清理舊資料**: 定期清理過舊的文章和程式碼，避免佔用過多空間

## 擴展功能

### 新增網站

在 `crawler_config.json` 的 `sites` 陣列中新增：

```json
{
  "name": "new_site",
  "display_name": "新網站",
  "base_url": "https://example.com/",
  "news_list_url": "https://example.com/news",
  "selectors": {
    "article_links": ".news-list a",
    "title": "h1",
    "content": ".content",
    "date": ".date"
  },
  "enabled": true
}
```

### 自訂警示規則

修改 `alert_settings` 中的關鍵字配置，或擴展 `AlertRule` 類別以支援更複雜的規則。

## 授權與免責聲明

本工具僅供研究和學習使用。使用時請遵守：
- 各網站的服務條款
- robots.txt 規則
- 版權和智慧財產權法規

## 支援

如有問題或建議，請參考：
- 專案文檔
- 現有範例程式碼
- XQ 官方文檔

---

**版本**: 1.0.0  
**最後更新**: 2024-01-01
