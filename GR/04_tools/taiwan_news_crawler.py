#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Taiwan Market News Crawler
Crawls Taiwan financial news websites and extracts market-relevant information
"""

import requests
from bs4 import BeautifulSoup
import os
import time
import re
import json
import hashlib
from urllib.parse import urljoin, urlparse
from datetime import datetime
from dataclasses import dataclass, asdict
from typing import List, Optional, Dict, Set
from requests.adapters import HTTPAdapter
from urllib3.util.retry import Retry


@dataclass
class NewsArticle:
    """Article data structure"""
    title: str
    url: str
    content: str
    date: str
    author: str = ""
    source: str = ""
    category: str = ""
    scraped_at: str = ""
    content_hash: str = ""

    def __post_init__(self):
        if not self.scraped_at:
            self.scraped_at = datetime.now().isoformat()
        if not self.content_hash:
            self.content_hash = self._generate_hash()

    def _generate_hash(self) -> str:
        """Generate hash for duplicate detection"""
        content_str = f"{self.url}{self.title}{self.content[:500]}"
        return hashlib.md5(content_str.encode('utf-8')).hexdigest()


@dataclass
class NewsSite:
    """Site configuration"""
    name: str
    display_name: str
    base_url: str
    news_list_url: str
    selectors: Dict[str, str]
    update_frequency: str
    enabled: bool = True
    code_extraction: bool = False

    @classmethod
    def from_dict(cls, data: dict) -> 'NewsSite':
        """Create NewsSite from dictionary"""
        return cls(
            name=data.get('name', ''),
            display_name=data.get('display_name', ''),
            base_url=data.get('base_url', ''),
            news_list_url=data.get('news_list_url', ''),
            selectors=data.get('selectors', {}),
            update_frequency=data.get('update_frequency', 'hourly'),
            enabled=data.get('enabled', True),
            code_extraction=data.get('code_extraction', False)
        )


class TaiwanNewsCrawler:
    """Main crawler class for Taiwan financial news"""

    def __init__(self, config_path: str = "GR/04_tools/crawler_config.json"):
        """Initialize crawler with configuration"""
        self.config = self._load_config(config_path)
        self.session = self._build_session()
        self.scraped_urls: Set[str] = set()
        self.articles: List[NewsArticle] = []
        self.sites: List[NewsSite] = [
            NewsSite.from_dict(site) for site in self.config.get('sites', [])
            if site.get('enabled', True)
        ]
        self.settings = self.config.get('crawler_settings', {})

    def _load_config(self, config_path: str) -> dict:
        """Load configuration from JSON file"""
        try:
            with open(config_path, 'r', encoding='utf-8') as f:
                return json.load(f)
        except FileNotFoundError:
            print(f"Warning: Config file not found: {config_path}")
            return {}
        except json.JSONDecodeError as e:
            print(f"Error parsing config file: {e}")
            return {}

    def _build_session(self) -> requests.Session:
        """Build requests session with retry logic"""
        session = requests.Session()
        retries = Retry(
            total=self.settings.get('max_retries', 3),
            backoff_factor=self.settings.get('retry_delay', 1.0),
            status_forcelist=[429, 500, 502, 503, 504],
            respect_retry_after_header=True
        )
        adapter = HTTPAdapter(max_retries=retries)
        session.mount("http://", adapter)
        session.mount("https://", adapter)
        session.headers.update({
            'User-Agent': self.settings.get(
                'user_agent',
                'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
            ),
            'Accept-Language': 'zh-TW,zh;q=0.9,en;q=0.8'
        })
        return session

    def get_page_content(self, url: str) -> Optional[str]:
        """Get page content with error handling"""
        try:
            response = self.session.get(
                url,
                timeout=self.settings.get('timeout', 20)
            )
            response.raise_for_status()
            # Try to detect encoding
            if response.encoding is None or response.encoding == 'ISO-8859-1':
                response.encoding = 'utf-8'
            return response.text
        except requests.exceptions.RequestException as e:
            print(f"Error fetching {url}: {e}")
            return None

    def extract_article_links(self, html_content: str, site: NewsSite) -> List[str]:
        """Extract article links from news list page"""
        soup = BeautifulSoup(html_content, 'lxml')
        links = []
        
        # Try multiple selector strategies
        selectors = site.selectors.get('article_links', '')
        if not selectors:
            # Fallback: find all links that might be articles
            all_links = soup.find_all('a', href=True)
            for link in all_links:
                href = link.get('href', '')
                if href and self._is_article_url(href, site):
                    full_url = urljoin(site.base_url, href)
                    if full_url not in links:
                        links.append(full_url)
        else:
            # Use configured selector
            try:
                elements = soup.select(selectors)
                for elem in elements:
                    href = elem.get('href', '')
                    if href:
                        full_url = urljoin(site.base_url, href)
                        if full_url not in links:
                            links.append(full_url)
            except Exception as e:
                print(f"Error using selector '{selectors}': {e}")
        
        return links[:self.settings.get('max_articles_per_site', 50)]

    def _is_article_url(self, url: str, site: NewsSite) -> bool:
        """Check if URL looks like an article URL"""
        # Skip common non-article patterns
        skip_patterns = [
            '/category/', '/tag/', '/author/', '/page/',
            '/search', '/login', '/register', '/contact',
            '#', 'javascript:', 'mailto:'
        ]
        url_lower = url.lower()
        if any(pattern in url_lower for pattern in skip_patterns):
            return False
        
        # Check if URL contains article-like patterns
        article_patterns = ['/news/', '/article/', '/story', '/post/']
        return any(pattern in url_lower for pattern in article_patterns)

    def parse_article_content(self, html_content: str, url: str, site: NewsSite) -> Optional[NewsArticle]:
        """Parse article content from HTML"""
        soup = BeautifulSoup(html_content, 'lxml')
        
        # Extract title
        title = self._extract_text(soup, site.selectors.get('title', 'h1'))
        if not title:
            title = soup.find('title')
            title = title.get_text(strip=True) if title else "未知標題"
        
        # Extract content
        content = self._extract_text(soup, site.selectors.get('content', 'article'))
        if not content:
            # Fallback: try to get main content
            main = soup.find('main') or soup.find('article') or soup.find('body')
            if main:
                # Remove script and style tags
                for tag in main.find_all(['script', 'style', 'nav', 'aside']):
                    tag.decompose()
                content = main.get_text(separator='\n', strip=True)
        
        if not content or len(content) < 50:
            return None
        
        # Extract date
        date = self._extract_text(soup, site.selectors.get('date', 'time'))
        if not date:
            # Try to find date in meta tags
            meta_date = soup.find('meta', property='article:published_time')
            if meta_date:
                date = meta_date.get('content', '')
        
        # Extract author
        author = self._extract_text(soup, site.selectors.get('author', ''))
        
        return NewsArticle(
            title=title,
            url=url,
            content=content,
            date=date or "",
            author=author or "",
            source=site.name,
            category=""
        )

    def _extract_text(self, soup: BeautifulSoup, selector: str) -> str:
        """Extract text using CSS selector"""
        if not selector:
            return ""
        
        try:
            elements = soup.select(selector)
            if elements:
                return elements[0].get_text(separator='\n', strip=True)
        except Exception:
            pass
        
        return ""

    def crawl_site(self, site: NewsSite) -> List[NewsArticle]:
        """Crawl a single news site"""
        print(f"\n開始抓取: {site.display_name} ({site.name})")
        print(f"URL: {site.news_list_url}")
        
        articles = []
        
        # Get news list page
        list_content = self.get_page_content(site.news_list_url)
        if not list_content:
            print(f"無法獲取新聞列表頁面: {site.news_list_url}")
            return articles
        
        # Extract article links
        article_links = self.extract_article_links(list_content, site)
        print(f"找到 {len(article_links)} 篇文章連結")
        
        # Limit articles per site
        max_articles = self.settings.get('max_articles_per_site', 50)
        article_links = article_links[:max_articles]
        
        # Crawl each article
        for i, article_url in enumerate(article_links, 1):
            if article_url in self.scraped_urls:
                continue
            
            print(f"  抓取文章 {i}/{len(article_links)}: {article_url[:80]}...")
            
            article_content = self.get_page_content(article_url)
            if article_content:
                article = self.parse_article_content(article_content, article_url, site)
                if article:
                    # Check for duplicates
                    if article.content_hash not in [a.content_hash for a in articles]:
                        articles.append(article)
                        self.scraped_urls.add(article_url)
                        self.articles.append(article)
            
            # Rate limiting
            delay = self.settings.get('request_delay', 0.5)
            time.sleep(delay)
        
        print(f"完成 {site.display_name}: 抓取 {len(articles)} 篇文章")
        return articles

    def crawl_all_sites(self) -> List[NewsArticle]:
        """Crawl all enabled sites"""
        all_articles = []
        max_total = self.settings.get('max_articles_per_run', 200)
        
        for site in self.sites:
            if not site.enabled:
                continue
            
            try:
                articles = self.crawl_site(site)
                all_articles.extend(articles)
                
                # Check total limit
                if len(all_articles) >= max_total:
                    print(f"\n達到最大文章數限制: {max_total}")
                    break
                    
            except Exception as e:
                print(f"抓取 {site.display_name} 時發生錯誤: {e}")
                continue
        
        print(f"\n總共抓取 {len(all_articles)} 篇文章")
        return all_articles

    def get_articles(self) -> List[NewsArticle]:
        """Get all scraped articles"""
        return self.articles

    def clear_cache(self):
        """Clear scraped URLs cache"""
        self.scraped_urls.clear()
        self.articles.clear()


def main():
    """Main function for testing"""
    crawler = TaiwanNewsCrawler()
    articles = crawler.crawl_all_sites()
    
    print(f"\n抓取完成！共 {len(articles)} 篇文章")
    for article in articles[:5]:  # Show first 5
        print(f"\n標題: {article.title}")
        print(f"來源: {article.source}")
        print(f"URL: {article.url}")


if __name__ == "__main__":
    main()
