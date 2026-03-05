#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
XQ官方部落格內容抓取工具
用於抓取 XQ官方部落格的教學文章和範例程式碼
"""

import requests
from bs4 import BeautifulSoup
import os
import time
import re
from urllib.parse import urljoin, urlparse
import json
from datetime import datetime

class XQBlogScraper:
    def __init__(self, base_url="https://www.xq.com.tw/xstrader/"):
        self.base_url = base_url
        self.session = requests.Session()
        self.session.headers.update({
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
        })
        self.scraped_urls = set()
        self.articles = []
        self.categories = {
            '指標': 'category/指標/',
            '選股': 'category/選股/',
            '策略': 'category/策略/',
            '大盤': 'category/大盤/',
            '筆記': 'category/筆記/',
            '語法': 'category/語法/',
            'XQ介紹': 'category/xq介紹/',
            '美股': 'category/美股/',
            '投資配置': 'category/投資配置/',
            '固定收益': 'category/固定收益/'
        }
        
    def get_page_content(self, url):
        """獲取頁面內容"""
        try:
            response = self.session.get(url, timeout=10)
            response.raise_for_status()
            response.encoding = 'utf-8'
            return response.text
        except Exception as e:
            print(f"獲取頁面失敗 {url}: {e}")
            return None
    
    def parse_article_list(self, html_content, category_name=""):
        """解析文章列表"""
        soup = BeautifulSoup(html_content, 'html.parser')
        articles = []
        
        # 查找文章連結 - 更精確的選擇器
        article_links = soup.find_all('a', href=True)
        
        for link in article_links:
            href = link.get('href')
            title = link.get_text(strip=True)
            
            # 過濾條件：有效的文章連結和標題
            if (href and title and 
                len(title) > 5 and 
                ('xstrader' in href or href.startswith('/')) and
                not any(skip in href.lower() for skip in ['category', 'tag', 'page', 'author'])):
                
                full_url = urljoin(self.base_url, href)
                
                # 避免重複
                if full_url not in [a['url'] for a in articles]:
                    articles.append({
                        'title': title,
                        'url': full_url,
                        'category': category_name or self.extract_category(link)
                    })
        
        return articles
    
    def parse_subcategories(self, html_content, parent_category=""):
        """解析子分類"""
        soup = BeautifulSoup(html_content, 'html.parser')
        subcategories = []
        
        # 查找分類連結
        category_links = soup.find_all('a', href=True)
        
        for link in category_links:
            href = link.get('href')
            title = link.get_text(strip=True)
            
            # 過濾條件：分類連結
            if (href and title and 
                'category' in href and 
                href != self.base_url and
                not href.endswith('/' + parent_category + '/') if parent_category else True):
                
                full_url = urljoin(self.base_url, href)
                
                # 避免重複
                if full_url not in [s['url'] for s in subcategories]:
                    subcategories.append({
                        'name': title,
                        'url': full_url,
                        'path': href,
                        'parent': parent_category
                    })
        
        return subcategories
    
    def extract_category(self, link_element):
        """提取文章分類"""
        # 嘗試從父元素或周圍元素提取分類
        parent = link_element.parent
        if parent:
            category_text = parent.get_text(strip=True)
            if '指標' in category_text:
                return '指標'
            elif '選股' in category_text:
                return '選股'
            elif '策略' in category_text:
                return '策略'
            elif '語法' in category_text:
                return '語法'
        return '其他'
    
    def parse_article_content(self, html_content, url):
        """解析單篇文章內容"""
        soup = BeautifulSoup(html_content, 'html.parser')
        
        # 提取標題
        title = soup.find('h1') or soup.find('title')
        title = title.get_text(strip=True) if title else "未知標題"
        
        # 提取內容
        content_div = soup.find('div', class_='entry-content') or soup.find('article') or soup.find('main')
        if not content_div:
            content_div = soup.find('body')
        
        content = content_div.get_text(strip=True) if content_div else ""
        
        # 提取程式碼
        code_blocks = []
        code_elements = soup.find_all(['pre', 'code'])
        for code_elem in code_elements:
            code_text = code_elem.get_text(strip=True)
            if code_text and len(code_text) > 10:
                code_blocks.append(code_text)
        
        # 提取日期
        date_elem = soup.find('time') or soup.find('span', class_='date')
        date = date_elem.get_text(strip=True) if date_elem else ""
        
        return {
            'title': title,
            'url': url,
            'content': content,
            'code_blocks': code_blocks,
            'date': date,
            'scraped_at': datetime.now().isoformat()
        }
    
    def save_article(self, article, output_dir):
        """保存文章到檔案"""
        # 清理檔名
        safe_title = re.sub(r'[<>:"/\\|?*]', '_', article['title'])
        safe_title = safe_title[:100]  # 限制檔名長度
        
        # 建立檔案路徑
        filename = f"{safe_title}.md"
        filepath = os.path.join(output_dir, filename)
        
        # 建立 Markdown 內容
        markdown_content = f"""# {article['title']}

**來源**: {article['url']}  
**抓取時間**: {article['scraped_at']}  
**原始日期**: {article['date']}

## 內容

{article['content']}

## 程式碼範例

"""
        
        # 添加程式碼區塊
        for i, code_block in enumerate(article['code_blocks'], 1):
            markdown_content += f"""### 範例 {i}

```xs
{code_block}
```

"""
        
        # 保存檔案
        try:
            with open(filepath, 'w', encoding='utf-8') as f:
                f.write(markdown_content)
            print(f"已保存: {filename}")
            return True
        except Exception as e:
            print(f"保存失敗 {filename}: {e}")
            return False
    
    def scrape_category_recursive(self, category_name, category_path, output_dir, parent_category=""):
        """遞歸抓取分類及其子分類的文章"""
        print(f"\n開始抓取分類: {category_name}")
        
        # 建立分類目錄
        if parent_category:
            category_dir = os.path.join(output_dir, parent_category, category_name)
        else:
            category_dir = os.path.join(output_dir, category_name)
        os.makedirs(category_dir, exist_ok=True)
        
        # 獲取分類頁面
        category_url = urljoin(self.base_url, category_path)
        category_content = self.get_page_content(category_url)
        
        if not category_content:
            print(f"無法獲取分類頁面: {category_name}")
            return []
        
        # 1. 解析子分類
        subcategories = self.parse_subcategories(category_content, category_name)
        print(f"分類 {category_name} 找到 {len(subcategories)} 個子分類")
        
        # 2. 解析分類文章列表
        articles = self.parse_article_list(category_content, category_name)
        print(f"分類 {category_name} 找到 {len(articles)} 篇文章")
        
        scraped_articles = []
        
        # 3. 抓取當前分類的文章
        for i, article_info in enumerate(articles, 1):
            url = article_info['url']
            if url in self.scraped_urls:
                continue
                
            print(f"  抓取文章 {i}/{len(articles)}: {article_info['title']}")
            
            # 獲取文章內容
            article_content = self.get_page_content(url)
            if article_content:
                # 解析文章內容
                article = self.parse_article_content(article_content, url)
                article['category'] = category_name
                if parent_category:
                    article['parent_category'] = parent_category
                
                # 保存文章到分類目錄
                if self.save_article(article, category_dir):
                    self.scraped_urls.add(url)
                    self.articles.append(article)
                    scraped_articles.append(article)
            
            # 避免請求過於頻繁
            time.sleep(0.5)
        
        # 4. 遞歸抓取子分類
        for subcategory in subcategories:
            try:
                sub_articles = self.scrape_category_recursive(
                    subcategory['name'], 
                    subcategory['path'], 
                    output_dir, 
                    category_name
                )
                scraped_articles.extend(sub_articles)
                print(f"子分類 {subcategory['name']} 完成，抓取 {len(sub_articles)} 篇文章")
            except Exception as e:
                print(f"抓取子分類 {subcategory['name']} 時發生錯誤: {e}")
                continue
        
        return scraped_articles
    
    def scrape_category_simple(self, category_name, category_path, output_dir):
        """抓取特定分類的文章（簡單版本，不遞歸）"""
        print(f"\n開始抓取分類: {category_name}")
        
        # 建立分類目錄
        category_dir = os.path.join(output_dir, category_name)
        os.makedirs(category_dir, exist_ok=True)
        
        # 獲取分類頁面
        category_url = urljoin(self.base_url, category_path)
        category_content = self.get_page_content(category_url)
        
        if not category_content:
            print(f"無法獲取分類頁面: {category_name}")
            return []
        
        # 解析分類文章列表
        articles = self.parse_article_list(category_content, category_name)
        print(f"分類 {category_name} 找到 {len(articles)} 篇文章")
        
        scraped_articles = []
        
        # 抓取每篇文章
        for i, article_info in enumerate(articles, 1):
            url = article_info['url']
            if url in self.scraped_urls:
                continue
                
            print(f"  抓取文章 {i}/{len(articles)}: {article_info['title']}")
            
            # 獲取文章內容
            article_content = self.get_page_content(url)
            if article_content:
                # 解析文章內容
                article = self.parse_article_content(article_content, url)
                article['category'] = category_name
                
                # 保存文章到分類目錄
                if self.save_article(article, category_dir):
                    self.scraped_urls.add(url)
                    self.articles.append(article)
                    scraped_articles.append(article)
            
            # 避免請求過於頻繁
            time.sleep(0.5)
        
        return scraped_articles
    
    def scrape_category(self, category_name, category_path, output_dir):
        """抓取特定分類的文章（保持向後兼容）"""
        return self.scrape_category_simple(category_name, category_path, output_dir)
    
    def scrape_main_page(self, output_dir):
        """抓取主頁面的文章（沒有分類的文章）"""
        print("\n開始抓取主頁面文章...")
        
        # 建立主頁面目錄
        main_dir = os.path.join(output_dir, "主頁面")
        os.makedirs(main_dir, exist_ok=True)
        
        # 獲取主頁面內容
        main_content = self.get_page_content(self.base_url)
        if not main_content:
            print("無法獲取主頁面內容")
            return []
        
        # 解析主頁面文章列表
        articles = self.parse_article_list(main_content, "主頁面")
        print(f"主頁面找到 {len(articles)} 篇文章")
        
        scraped_articles = []
        
        # 抓取每篇文章
        for i, article_info in enumerate(articles, 1):
            url = article_info['url']
            if url in self.scraped_urls:
                continue
                
            print(f"  抓取文章 {i}/{len(articles)}: {article_info['title']}")
            
            # 獲取文章內容
            article_content = self.get_page_content(url)
            if article_content:
                # 解析文章內容
                article = self.parse_article_content(article_content, url)
                article['category'] = "主頁面"
                
                # 保存文章到主頁面目錄
                if self.save_article(article, main_dir):
                    self.scraped_urls.add(url)
                    self.articles.append(article)
                    scraped_articles.append(article)
            
            # 避免請求過於頻繁
            time.sleep(0.5)
        
        return scraped_articles
    
    def scrape_blog(self, output_dir="docs/sources/xq_blog/articles"):
        """抓取部落格內容 - 按分類抓取 + 主頁面文章（非遞歸版本）"""
        print("開始抓取 XQ官方部落格 - 完整抓取...")
        
        # 建立輸出目錄
        os.makedirs(output_dir, exist_ok=True)
        
        total_articles = 0
        
        # 1. 先抓取主頁面文章（沒有分類的文章）
        main_articles = self.scrape_main_page(output_dir)
        total_articles += len(main_articles)
        print(f"主頁面完成，抓取 {len(main_articles)} 篇文章")
        
        # 2. 抓取每個分類（使用非遞歸版本）
        for category_name, category_path in self.categories.items():
            try:
                articles = self.scrape_category_simple(category_name, category_path, output_dir)
                total_articles += len(articles)
                print(f"分類 {category_name} 完成，抓取 {len(articles)} 篇文章")
            except Exception as e:
                print(f"抓取分類 {category_name} 時發生錯誤: {e}")
                continue
        
        # 保存總索引檔案
        self.save_index(output_dir)
        print(f"\n抓取完成！共抓取 {total_articles} 篇文章")
        print(f"包含：主頁面 {len(main_articles)} 篇 + 分類文章 {total_articles - len(main_articles)} 篇")
    
    def save_index(self, output_dir):
        """保存文章索引"""
        index_file = os.path.join(output_dir, "index.json")
        
        # 按分類統計文章
        category_stats = {}
        for article in self.articles:
            category = article.get('category', '未分類')
            if category not in category_stats:
                category_stats[category] = 0
            category_stats[category] += 1
        
        index_data = {
            'scraped_at': datetime.now().isoformat(),
            'total_articles': len(self.articles),
            'total_categories': len(category_stats),
            'category_stats': category_stats,
            'categories': list(self.categories.keys()),
            'articles': self.articles
        }
        
        try:
            with open(index_file, 'w', encoding='utf-8') as f:
                json.dump(index_data, f, ensure_ascii=False, indent=2)
            print(f"已保存索引檔案: {index_file}")
        except Exception as e:
            print(f"保存索引失敗: {e}")

def main():
    """主函數"""
    scraper = XQBlogScraper()
    scraper.scrape_blog()

if __name__ == "__main__":
    main()
