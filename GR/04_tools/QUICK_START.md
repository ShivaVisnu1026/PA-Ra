# Quick Start Guide - Taiwan Market News Crawler

## 快速開始

### 1. 安裝依賴

```powershell
pip install -r GR/04_tools/requirements_crawler.txt
```

### 2. 執行爬蟲

```powershell
# 基本執行（完整模式）
python GR/04_tools/run_news_crawler.py

# 只抓取新聞
python GR/04_tools/run_news_crawler.py --mode news

# 只提取程式碼
python GR/04_tools/run_news_crawler.py --mode code-only
```

## Web to Markdown (自訂網址)

1. 編輯 `WebCrawler/web_to_md_config.json`，填入 `urls` 清單。
2. 執行：

```powershell
python WebCrawler/web_to_md_crawler.py
```

或雙擊 `WebCrawler/run_web_to_md.bat`（可建立桌面捷徑作為一鍵執行圖示）。

### 3. 查看結果

- **文章歸檔**: `DaTa/News/Archive/YYYY-MM-DD/`
- **程式碼範例**: `DaTa/News/CodeExamples/YYYY-MM-DD/`
- **警示記錄**: `DaTa/News/Alerts/alerts.json`
- **搜尋索引**: `DaTa/News/Archive/index.json`

## 配置自訂網站

編輯 `GR/04_tools/crawler_config.json`，在 `sites` 陣列中新增：

```json
{
  "name": "your_site",
  "display_name": "您的網站",
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

## 設定警示關鍵字

在 `crawler_config.json` 的 `alert_settings` 中修改：

```json
{
  "alert_settings": {
    "keywords": {
      "high_priority": ["台積電", "TSMC"],
      "medium_priority": ["大盤", "指數"],
      "low_priority": ["財報"]
    }
  }
}
```

## 常見問題

**Q: 如何新增更多網站？**  
A: 編輯 `crawler_config.json`，在 `sites` 陣列中新增網站配置。

**Q: 如何調整爬取速度？**  
A: 修改 `crawler_settings.request_delay`（秒數）。

**Q: 如何啟用電子郵件通知？**  
A: 在配置檔中設定 `email_settings` 並啟用 `notification_channels.email`。

**Q: 提取的程式碼在哪裡？**  
A: `DaTa/News/CodeExamples/YYYY-MM-DD/code_blocks/` 目錄下，依類型分類。

## 下一步

- 閱讀完整文檔: `README_NEWS_CRAWLER.md`
- 自訂配置: 編輯 `crawler_config.json`
- 設定排程: 使用 Windows Task Scheduler
