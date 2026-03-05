#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
XScript Syntax Extractor
Extracts xQScript code blocks and syntax patterns from web pages
"""

import re
import os
import json
from datetime import datetime
from typing import List, Dict, Optional, Tuple
from dataclasses import dataclass, asdict
from bs4 import BeautifulSoup


@dataclass
class CodeBlock:
    """Code block data structure"""
    code: str
    language: str
    script_type: str  # indicator, alert, screener, function, unknown
    source_url: str
    extracted_at: str
    line_count: int
    has_functions: bool
    has_indicators: bool
    metadata: Dict

    def __post_init__(self):
        if not self.extracted_at:
            self.extracted_at = datetime.now().isoformat()
        if not self.line_count:
            self.line_count = len(self.code.split('\n'))


class XScriptSyntaxExtractor:
    """Extract xQScript code patterns from web content"""

    def __init__(self, config: Optional[Dict] = None):
        """Initialize extractor with configuration"""
        if config is None:
            config = {}
        
        code_config = config.get('code_extraction', {})
        self.patterns = code_config.get('patterns', {})
        self.xscript_keywords = self.patterns.get('xscript_keywords', [])
        self.file_extensions = self.patterns.get('file_extensions', ['.xs'])
        self.code_block_selectors = self.patterns.get('code_block_selectors', ['pre', 'code'])
        
        # Common xQScript patterns
        self.script_type_patterns = {
            'indicator': [
                r'\{@type:\s*indicator',
                r'Plot\d+\s*\(',
                r'Plot\s*\(',
            ],
            'alert': [
                r'\{@type:\s*sensor',
                r'\{@type:\s*alert',
            ],
            'screener': [
                r'\{@type:\s*filter',
                r'\{@type:\s*screener',
            ],
            'function': [
                r'function:\s*\w+',
                r'\{@type:\s*function',
            ],
            'autotrade': [
                r'\{@type:\s*autotrade',
                r'SetPosition\s*\(',
            ]
        }

    def extract_code_blocks(self, html_content: str, source_url: str = "") -> List[CodeBlock]:
        """Extract all code blocks from HTML content"""
        soup = BeautifulSoup(html_content, 'lxml')
        code_blocks = []
        
        # Find all code block elements
        for selector in self.code_block_selectors:
            elements = soup.find_all(selector)
            for elem in elements:
                code_text = elem.get_text()
                if self._is_xscript_code(code_text):
                    code_block = self._create_code_block(code_text, source_url)
                    if code_block:
                        code_blocks.append(code_block)
        
        # Also check for markdown code fences in text
        text_content = soup.get_text()
        markdown_blocks = self._extract_markdown_code_blocks(text_content, source_url)
        code_blocks.extend(markdown_blocks)
        
        return code_blocks

    def _extract_markdown_code_blocks(self, text: str, source_url: str) -> List[CodeBlock]:
        """Extract code blocks from markdown-style code fences"""
        code_blocks = []
        
        # Pattern for markdown code fences: ```language\ncode\n```
        pattern = r'```(\w+)?\n(.*?)```'
        matches = re.finditer(pattern, text, re.DOTALL)
        
        for match in matches:
            language = match.group(1) or 'xs'
            code_text = match.group(2).strip()
            
            # Check if it's xScript code
            if language.lower() in ['xs', 'xscript', 'xqscript'] or self._is_xscript_code(code_text):
                code_block = self._create_code_block(code_text, source_url, language)
                if code_block:
                    code_blocks.append(code_block)
        
        return code_blocks

    def _is_xscript_code(self, code: str) -> bool:
        """Check if code text contains xQScript patterns"""
        if not code or len(code.strip()) < 10:
            return False
        
        code_lower = code.lower()
        
        # Check for xScript keywords
        keyword_matches = sum(1 for keyword in self.xscript_keywords if keyword.lower() in code_lower)
        if keyword_matches >= 2:  # At least 2 keywords
            return True
        
        # Check for common xScript patterns
        xscript_patterns = [
            r'input:\s*\w+',
            r'variable:\s*\w+',
            r'vars:\s*\w+',
            r'value\d+\s*=',
            r'ret\s*=',
            r'\{@type:',
        ]
        
        pattern_matches = sum(1 for pattern in xscript_patterns if re.search(pattern, code, re.IGNORECASE))
        return pattern_matches >= 2

    def _create_code_block(self, code: str, source_url: str, language: str = "xs") -> Optional[CodeBlock]:
        """Create CodeBlock object from code text"""
        if not code or len(code.strip()) < 10:
            return None
        
        # Determine script type
        script_type = self._categorize_code(code)
        
        # Extract metadata
        metadata = self._extract_metadata(code)
        
        # Check for functions and indicators
        has_functions = bool(re.search(r'function:\s*\w+', code, re.IGNORECASE))
        has_indicators = bool(re.search(r'Plot\d+\s*\(|Plot\s*\(', code, re.IGNORECASE))
        
        return CodeBlock(
            code=code.strip(),
            language=language,
            script_type=script_type,
            source_url=source_url,
            extracted_at=datetime.now().isoformat(),
            line_count=len(code.split('\n')),
            has_functions=has_functions,
            has_indicators=has_indicators,
            metadata=metadata
        )

    def _categorize_code(self, code: str) -> str:
        """Categorize code by script type"""
        code_lower = code.lower()
        
        # Check each script type
        for script_type, patterns in self.script_type_patterns.items():
            for pattern in patterns:
                if re.search(pattern, code, re.IGNORECASE):
                    return script_type
        
        return 'unknown'

    def _extract_metadata(self, code: str) -> Dict:
        """Extract metadata from code"""
        metadata = {}
        
        # Extract script type annotation
        type_match = re.search(r'\{@type:\s*(\w+)', code, re.IGNORECASE)
        if type_match:
            metadata['annotated_type'] = type_match.group(1)
        
        # Extract input parameters
        input_matches = re.findall(r'input:\s*(\w+)', code, re.IGNORECASE)
        if input_matches:
            metadata['inputs'] = input_matches
        
        # Extract function names
        function_matches = re.findall(r'function:\s*(\w+)', code, re.IGNORECASE)
        if function_matches:
            metadata['functions'] = function_matches
        
        # Extract variable declarations
        var_matches = re.findall(r'(?:variable|vars):\s*(\w+)', code, re.IGNORECASE)
        if var_matches:
            metadata['variables'] = var_matches
        
        # Extract plot statements
        plot_matches = re.findall(r'Plot\d+\s*\([^)]+\)', code, re.IGNORECASE)
        if plot_matches:
            metadata['plots'] = len(plot_matches)
        
        return metadata

    def parse_xscript_syntax(self, code: str) -> Dict:
        """Parse xQScript syntax and extract patterns"""
        patterns = {
            'functions': [],
            'indicators': [],
            'variables': [],
            'inputs': [],
            'plot_statements': [],
            'conditions': []
        }
        
        # Extract functions
        function_pattern = r'function:\s*(\w+)\s*\([^)]*\)'
        functions = re.findall(function_pattern, code, re.IGNORECASE)
        patterns['functions'] = functions
        
        # Extract function signatures
        function_sig_pattern = r'function:\s*(\w+)\s*\(([^)]*)\)'
        for match in re.finditer(function_sig_pattern, code, re.IGNORECASE):
            func_name = match.group(1)
            params = match.group(2).split(',') if match.group(2) else []
            patterns['functions'].append({
                'name': func_name,
                'parameters': [p.strip() for p in params]
            })
        
        # Extract indicators (common functions)
        indicator_functions = ['RSI', 'MACD', 'Average', 'EMA', 'SMA', 'Bollinger', 'Stochastic']
        for indicator in indicator_functions:
            if re.search(rf'{indicator}\s*\(', code, re.IGNORECASE):
                patterns['indicators'].append(indicator)
        
        # Extract variables
        var_pattern = r'(?:variable|vars):\s*(\w+)'
        variables = re.findall(var_pattern, code, re.IGNORECASE)
        patterns['variables'] = variables
        
        # Extract inputs
        input_pattern = r'input:\s*(\w+)\s*\([^)]*\)'
        inputs = re.findall(input_pattern, code, re.IGNORECASE)
        patterns['inputs'] = inputs
        
        # Extract plot statements
        plot_pattern = r'Plot\d+\s*\(([^)]+)\)'
        plots = re.findall(plot_pattern, code, re.IGNORECASE)
        patterns['plot_statements'] = plots
        
        # Extract conditional statements
        condition_pattern = r'if\s+([^:]+)\s+then'
        conditions = re.findall(condition_pattern, code, re.IGNORECASE)
        patterns['conditions'] = conditions
        
        return patterns

    def categorize_code(self, code_blocks: List[CodeBlock]) -> Dict[str, List[CodeBlock]]:
        """Categorize code blocks by type"""
        categorized = {
            'indicator': [],
            'alert': [],
            'screener': [],
            'function': [],
            'autotrade': [],
            'unknown': []
        }
        
        for block in code_blocks:
            category = block.script_type
            if category in categorized:
                categorized[category].append(block)
            else:
                categorized['unknown'].append(block)
        
        return categorized

    def save_code_examples(self, code_blocks: List[CodeBlock], output_dir: str):
        """Save extracted code blocks to organized directory structure"""
        os.makedirs(output_dir, exist_ok=True)
        
        # Categorize code blocks
        categorized = self.categorize_code(code_blocks)
        
        # Create date-based subdirectory
        date_str = datetime.now().strftime('%Y-%m-%d')
        date_dir = os.path.join(output_dir, date_str)
        os.makedirs(date_dir, exist_ok=True)
        
        # Save by category
        code_blocks_dir = os.path.join(date_dir, 'code_blocks')
        os.makedirs(code_blocks_dir, exist_ok=True)
        
        index_data = {
            'extracted_at': datetime.now().isoformat(),
            'total_blocks': len(code_blocks),
            'categories': {},
            'blocks': []
        }
        
        for category, blocks in categorized.items():
            if not blocks:
                continue
            
            category_dir = os.path.join(code_blocks_dir, category)
            os.makedirs(category_dir, exist_ok=True)
            
            index_data['categories'][category] = len(blocks)
            
            for i, block in enumerate(blocks, 1):
                # Create safe filename
                filename = f"{category}_{i:03d}.xs"
                filepath = os.path.join(category_dir, filename)
                
                # Save code
                with open(filepath, 'w', encoding='utf-8') as f:
                    f.write(f"// Source: {block.source_url}\n")
                    f.write(f"// Extracted: {block.extracted_at}\n")
                    f.write(f"// Type: {block.script_type}\n")
                    f.write(f"// Lines: {block.line_count}\n\n")
                    f.write(block.code)
                
                # Add to index
                index_data['blocks'].append({
                    'filename': filename,
                    'category': category,
                    'source_url': block.source_url,
                    'extracted_at': block.extracted_at,
                    'line_count': block.line_count,
                    'has_functions': block.has_functions,
                    'has_indicators': block.has_indicators,
                    'metadata': block.metadata
                })
        
        # Save index
        index_file = os.path.join(date_dir, 'syntax_patterns.json')
        with open(index_file, 'w', encoding='utf-8') as f:
            json.dump(index_data, f, ensure_ascii=False, indent=2)
        
        print(f"保存了 {len(code_blocks)} 個程式碼區塊到 {date_dir}")
        return date_dir


def main():
    """Test function"""
    extractor = XScriptSyntaxExtractor()
    
    # Test code
    test_code = """
    {@type:indicator}
    input: Length(14);
    value1 = RSI(Close, Length);
    Plot1(value1, "RSI");
    """
    
    code_block = extractor._create_code_block(test_code, "test://example.com")
    if code_block:
        print(f"Script Type: {code_block.script_type}")
        print(f"Has Functions: {code_block.has_functions}")
        print(f"Has Indicators: {code_block.has_indicators}")
        print(f"Metadata: {code_block.metadata}")


if __name__ == "__main__":
    main()
