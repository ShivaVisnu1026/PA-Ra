#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
章節內容處理器
用於處理從圖檔提取的內容並生成 Markdown 檔案
"""

def process_chapter_content(chapter_name, content_data):
    """
    處理章節內容並生成 Markdown 檔案
    
    Args:
        chapter_name: 章節名稱
        content_data: 內容資料字典
    """
    
    # 建立 Markdown 內容
    markdown_content = f"""# {chapter_name}

## 📚 章節概述
{content_data.get('overview', '')}

## 📖 主要內容
{content_data.get('main_content', '')}

## 💻 程式碼範例
{content_data.get('code_examples', '')}

## 🔧 重要語法
{content_data.get('syntax_rules', '')}

## 💡 實用技巧
{content_data.get('tips', '')}

## ⚠️ 注意事項
{content_data.get('notes', '')}

## 📝 學習重點
{content_data.get('key_points', '')}
"""
    
    # 儲存檔案
    filename = f"docs/pdf/{chapter_name.replace(' ', '_')}.md"
    with open(filename, 'w', encoding='utf-8') as f:
        f.write(markdown_content)
    
    print(f"已建立章節筆記：{filename}")

if __name__ == "__main__":
    print("章節內容處理器已準備就緒")
    print("請按照模板格式提供章節內容")
