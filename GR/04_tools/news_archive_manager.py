#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
News Archive Manager
Manages structured storage of news articles and maintains searchable index
"""

import os
import json
import re
from datetime import datetime
from typing import List, Dict, Optional
from pathlib import Path
from dataclasses import asdict


class NewsArchiveManager:
    """Manages archiving of news articles"""

    def __init__(self, config: Optional[Dict] = None):
        """Initialize archive manager with configuration"""
        if config is None:
            config = {}
        
        archive_config = config.get('archive_settings', {})
        self.enabled = archive_config.get('enabled', True)
        self.output_directory = archive_config.get('output_directory', 'DaTa/News/Archive')
        self.format = archive_config.get('format', 'markdown')
        self.include_metadata = archive_config.get('include_metadata', True)
        self.index_enabled = archive_config.get('index_enabled', True)
        
        # Ensure output directory exists
        os.makedirs(self.output_directory, exist_ok=True)
        
        # Index file path
        self.index_file = os.path.join(self.output_directory, 'index.json')
        self.index_data = self._load_index()

    def _load_index(self) -> Dict:
        """Load existing index"""
        if os.path.exists(self.index_file):
            try:
                with open(self.index_file, 'r', encoding='utf-8') as f:
                    return json.load(f)
            except (json.JSONDecodeError, FileNotFoundError):
                pass
        
        return {
            'created_at': datetime.now().isoformat(),
            'last_updated': datetime.now().isoformat(),
            'total_articles': 0,
            'articles_by_date': {},
            'articles_by_source': {},
            'articles': []
        }

    def _save_index(self):
        """Save index to file"""
        if not self.index_enabled:
            return
        
        self.index_data['last_updated'] = datetime.now().isoformat()
        
        try:
            with open(self.index_file, 'w', encoding='utf-8') as f:
                json.dump(self.index_data, f, ensure_ascii=False, indent=2)
        except Exception as e:
            print(f"Error saving index: {e}")

    def _get_date_directory(self, date_str: Optional[str] = None) -> str:
        """Get directory path for a specific date"""
        if not date_str:
            date_str = datetime.now().strftime('%Y-%m-%d')
        
        return os.path.join(self.output_directory, date_str)

    def _get_source_directory(self, date_dir: str, source: str) -> str:
        """Get directory path for a specific source"""
        # Sanitize source name for filesystem
        safe_source = re.sub(r'[<>:"/\\|?*]', '_', source)
        return os.path.join(date_dir, safe_source)

    def _create_safe_filename(self, title: str, max_length: int = 100) -> str:
        """Create safe filename from title"""
        # Remove invalid characters
        safe_title = re.sub(r'[<>:"/\\|?*]', '_', title)
        # Limit length
        safe_title = safe_title[:max_length]
        # Remove trailing spaces and dots
        safe_title = safe_title.rstrip(' .')
        return safe_title or 'untitled'

    def archive_article(self, article, code_blocks: Optional[List] = None) -> Optional[str]:
        """Archive a single article"""
        if not self.enabled:
            return None
        
        try:
            # Get date directory
            article_date = article.date or datetime.now().strftime('%Y-%m-%d')
            # Try to parse date and format it
            try:
                date_obj = datetime.strptime(article_date[:10], '%Y-%m-%d')
                date_str = date_obj.strftime('%Y-%m-%d')
            except:
                date_str = datetime.now().strftime('%Y-%m-%d')
            
            date_dir = self._get_date_directory(date_str)
            source_dir = self._get_source_directory(date_dir, article.source)
            os.makedirs(source_dir, exist_ok=True)
            
            # Create safe filename
            safe_title = self._create_safe_filename(article.title)
            filename = f"{safe_title}.md"
            filepath = os.path.join(source_dir, filename)
            
            # Avoid overwriting - add number if exists
            counter = 1
            original_filepath = filepath
            while os.path.exists(filepath):
                name_part = safe_title[:90]  # Leave room for counter
                filename = f"{name_part}_{counter}.md"
                filepath = os.path.join(source_dir, filename)
                counter += 1
            
            # Create markdown content
            markdown_content = self._create_markdown(article, code_blocks)
            
            # Save article
            with open(filepath, 'w', encoding='utf-8') as f:
                f.write(markdown_content)
            
            # Update index
            self._update_index(article, filepath, date_str)
            
            return filepath
            
        except Exception as e:
            print(f"Error archiving article '{article.title}': {e}")
            return None

    def _create_markdown(self, article, code_blocks: Optional[List] = None) -> str:
        """Create markdown content for article"""
        lines = []
        
        # Title
        lines.append(f"# {article.title}\n")
        
        # Metadata
        if self.include_metadata:
            lines.append("## 元數據\n")
            lines.append(f"- **來源**: {article.source}")
            lines.append(f"- **URL**: {article.url}")
            lines.append(f"- **日期**: {article.date or '未知'}")
            if article.author:
                lines.append(f"- **作者**: {article.author}")
            lines.append(f"- **抓取時間**: {article.scraped_at}")
            lines.append(f"- **內容雜湊**: {article.content_hash}\n")
        
        # Content
        lines.append("## 內容\n")
        lines.append(article.content)
        lines.append("\n")
        
        # Code blocks if available
        if code_blocks:
            lines.append("## 程式碼範例\n")
            for i, code_block in enumerate(code_blocks, 1):
                lines.append(f"### 範例 {i} ({code_block.script_type})\n")
                lines.append(f"```{code_block.language}")
                lines.append(code_block.code)
                lines.append("```\n")
                if code_block.metadata:
                    lines.append(f"**元數據**: {json.dumps(code_block.metadata, ensure_ascii=False)}\n")
                lines.append("\n")
        
        return "\n".join(lines)

    def _update_index(self, article, filepath: str, date_str: str):
        """Update searchable index"""
        if not self.index_enabled:
            return
        
        article_entry = {
            'title': article.title,
            'url': article.url,
            'source': article.source,
            'date': article.date or date_str,
            'author': article.author,
            'filepath': filepath,
            'scraped_at': article.scraped_at,
            'content_hash': article.content_hash,
            'content_preview': article.content[:200] + "..." if len(article.content) > 200 else article.content
        }
        
        # Add to articles list
        self.index_data['articles'].append(article_entry)
        
        # Update counts
        self.index_data['total_articles'] = len(self.index_data['articles'])
        
        # Update by date
        if date_str not in self.index_data['articles_by_date']:
            self.index_data['articles_by_date'][date_str] = 0
        self.index_data['articles_by_date'][date_str] += 1
        
        # Update by source
        if article.source not in self.index_data['articles_by_source']:
            self.index_data['articles_by_source'][article.source] = 0
        self.index_data['articles_by_source'][article.source] += 1
        
        # Keep only last 10000 articles in index
        if len(self.index_data['articles']) > 10000:
            self.index_data['articles'] = self.index_data['articles'][-10000:]
        
        # Save index periodically (every 10 articles)
        if len(self.index_data['articles']) % 10 == 0:
            self._save_index()

    def archive_articles(self, articles: List, code_blocks_map: Optional[Dict] = None):
        """Archive multiple articles"""
        if not self.enabled:
            return
        
        archived_count = 0
        code_blocks_map = code_blocks_map or {}
        
        for article in articles:
            article_code_blocks = code_blocks_map.get(article.url, [])
            filepath = self.archive_article(article, article_code_blocks)
            if filepath:
                archived_count += 1
        
        # Final save of index
        self._save_index()
        
        print(f"已歸檔 {archived_count}/{len(articles)} 篇文章")
        return archived_count

    def search_index(self, query: str, limit: int = 20) -> List[Dict]:
        """Search articles in index"""
        if not self.index_enabled or not os.path.exists(self.index_file):
            return []
        
        results = []
        query_lower = query.lower()
        
        for article in self.index_data.get('articles', []):
            # Search in title, content preview, and source
            title = article.get('title', '').lower()
            content = article.get('content_preview', '').lower()
            source = article.get('source', '').lower()
            
            if (query_lower in title or 
                query_lower in content or 
                query_lower in source):
                results.append(article)
                
                if len(results) >= limit:
                    break
        
        return results

    def get_statistics(self) -> Dict:
        """Get archive statistics"""
        stats = {
            'total_articles': self.index_data.get('total_articles', 0),
            'articles_by_date': self.index_data.get('articles_by_date', {}),
            'articles_by_source': self.index_data.get('articles_by_source', {}),
            'index_file': self.index_file,
            'index_exists': os.path.exists(self.index_file)
        }
        
        return stats

    def get_articles_by_date(self, date_str: str) -> List[Dict]:
        """Get all articles for a specific date"""
        return [
            article for article in self.index_data.get('articles', [])
            if article.get('date', '').startswith(date_str)
        ]

    def get_articles_by_source(self, source: str) -> List[Dict]:
        """Get all articles from a specific source"""
        return [
            article for article in self.index_data.get('articles', [])
            if article.get('source') == source
        ]


def main():
    """Test function"""
    from taiwan_news_crawler import NewsArticle
    
    manager = NewsArchiveManager()
    
    # Test article
    test_article = NewsArticle(
        title="測試文章標題",
        url="https://example.com/test",
        content="這是一篇測試文章的內容。",
        date="2024-01-01",
        source="test_source"
    )
    
    filepath = manager.archive_article(test_article)
    if filepath:
        print(f"文章已歸檔: {filepath}")
        print(f"統計: {manager.get_statistics()}")


if __name__ == "__main__":
    main()
