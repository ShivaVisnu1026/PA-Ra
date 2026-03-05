#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Taiwan Market News Crawler - Main Runner
Command-line interface for running the news crawler system
"""

import argparse
import sys
import os
import json
from datetime import datetime
from pathlib import Path

# Add current directory to path for imports
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from taiwan_news_crawler import TaiwanNewsCrawler
from xscript_syntax_extractor import XScriptSyntaxExtractor
from news_alert_manager import AlertManager
from news_archive_manager import NewsArchiveManager


def load_config(config_path: str = "GR/04_tools/crawler_config.json") -> dict:
    """Load configuration file"""
    try:
        with open(config_path, 'r', encoding='utf-8') as f:
            return json.load(f)
    except FileNotFoundError:
        print(f"Error: Config file not found: {config_path}")
        sys.exit(1)
    except json.JSONDecodeError as e:
        print(f"Error parsing config file: {e}")
        sys.exit(1)


def run_crawler(config: dict, sites: list = None, mode: str = "full"):
    """Run the crawler with specified configuration"""
    
    print("=" * 80)
    print("Taiwan Market News Crawler")
    print("=" * 80)
    print(f"開始時間: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print(f"模式: {mode}")
    print("=" * 80)
    
    # Initialize components
    crawler = TaiwanNewsCrawler()
    
    # Filter sites if specified
    if sites:
        crawler.sites = [s for s in crawler.sites if s.name in sites]
        if not crawler.sites:
            print(f"錯誤: 找不到指定的網站: {sites}")
            return
    
    # Run crawler
    if mode in ["full", "news"]:
        print("\n開始抓取新聞...")
        articles = crawler.crawl_all_sites()
        print(f"\n抓取完成，共 {len(articles)} 篇文章")
    else:
        articles = []
    
    # Code extraction
    code_blocks_map = {}
    if mode in ["full", "code-only"]:
        print("\n開始提取程式碼...")
        extractor = XScriptSyntaxExtractor(config)
        
        # Extract code from articles
        for article in articles:
            # Get article HTML content (we need to re-fetch or store it)
            # For now, we'll extract from content text
            code_blocks = extractor.extract_code_blocks(
                f"<html><body><pre>{article.content}</pre></body></html>",
                article.url
            )
            if code_blocks:
                code_blocks_map[article.url] = code_blocks
                print(f"  從 {article.source} 提取 {len(code_blocks)} 個程式碼區塊")
        
        # Save code examples
        if code_blocks_map:
            all_code_blocks = []
            for blocks in code_blocks_map.values():
                all_code_blocks.extend(blocks)
            
            code_output_dir = config.get('code_extraction', {}).get('output_directory', 'DaTa/News/CodeExamples')
            extractor.save_code_examples(all_code_blocks, code_output_dir)
    
    # Alert system
    alerts = []
    if mode in ["full", "news"] and articles:
        print("\n檢查警示...")
        alert_manager = AlertManager(config)
        
        for article in articles:
            alert = alert_manager.check_article(article)
            if alert:
                alert_manager.send_notifications(alert)
                alerts.append(alert)
        
        if alerts:
            summary = alert_manager.get_alert_summary()
            print(f"\n警示摘要:")
            print(f"  總計: {summary['total']} 個警示")
            for priority, count in summary['by_priority'].items():
                if count > 0:
                    print(f"  {priority}: {count} 個")
        else:
            print("  無警示觸發")
    
    # Archive system
    if mode in ["full", "news"] and articles:
        print("\n歸檔文章...")
        archive_manager = NewsArchiveManager(config)
        archived_count = archive_manager.archive_articles(articles, code_blocks_map)
        
        # Show statistics
        stats = archive_manager.get_statistics()
        print(f"\n歸檔統計:")
        print(f"  總文章數: {stats['total_articles']}")
        print(f"  依日期: {len(stats['articles_by_date'])} 天")
        print(f"  依來源: {len(stats['articles_by_source'])} 個來源")
    
    # Summary
    print("\n" + "=" * 80)
    print("執行摘要")
    print("=" * 80)
    print(f"文章數: {len(articles)}")
    print(f"程式碼區塊: {sum(len(blocks) for blocks in code_blocks_map.values())}")
    print(f"警示數: {len(alerts)}")
    print(f"結束時間: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print("=" * 80)


def main():
    """Main entry point"""
    parser = argparse.ArgumentParser(
        description='Taiwan Market News Crawler - 台灣市場新聞爬蟲系統',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
範例:
  # 執行完整爬取（新聞 + 程式碼 + 警示 + 歸檔）
  python run_news_crawler.py

  # 只抓取新聞
  python run_news_crawler.py --mode news

  # 只提取程式碼
  python run_news_crawler.py --mode code-only

  # 指定網站
  python run_news_crawler.py --sites cnYES commercial_times

  # 使用自訂配置檔
  python run_news_crawler.py --config custom_config.json
        """
    )
    
    parser.add_argument(
        '--config',
        type=str,
        default='GR/04_tools/crawler_config.json',
        help='配置檔案路徑 (預設: GR/04_tools/crawler_config.json)'
    )
    
    parser.add_argument(
        '--sites',
        nargs='+',
        help='指定要抓取的網站 (例如: cnYES commercial_times)'
    )
    
    parser.add_argument(
        '--mode',
        choices=['full', 'news', 'code-only'],
        default='full',
        help='執行模式: full=完整, news=只抓新聞, code-only=只提取程式碼'
    )
    
    parser.add_argument(
        '--list-sites',
        action='store_true',
        help='列出所有可用的網站'
    )
    
    args = parser.parse_args()
    
    # List sites
    if args.list_sites:
        config = load_config(args.config)
        print("可用的網站:")
        for site in config.get('sites', []):
            status = "✓" if site.get('enabled', True) else "✗"
            print(f"  {status} {site.get('name', 'unknown')} - {site.get('display_name', '')}")
        return
    
    # Load config and run
    config = load_config(args.config)
    
    try:
        run_crawler(config, args.sites, args.mode)
    except KeyboardInterrupt:
        print("\n\n使用者中斷執行")
        sys.exit(1)
    except Exception as e:
        print(f"\n錯誤: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)


if __name__ == "__main__":
    main()
