#!/usr/bin/env python3

"""
XS Guard: Scan .xs files for reserved-word prefixes that commonly cause compiler errors.

Checks for identifiers starting with these prefixes (case-insensitive):
  daily, trade, position, filled, order

Usage:
  python scripts/xs_guard_reserved_words.py [root_dir]

Exit code:
  0 if no issues, 1 if violations found or error.
"""

import re
import sys
from pathlib import Path

RESERVED_PREFIXES = [
    "daily", "trade", "position", "filled", "order",
]

# very simple tokenizer: ignore content inside quotes, then regex on words
STRING_RE = re.compile(r'"[^"\\]*(?:\\.[^"\\]*)*"')
WORD_RE = re.compile(r'\b([A-Za-z_][A-Za-z0-9_]*)\b')

def strip_strings(s: str) -> str:
    return STRING_RE.sub('""', s)

def find_violations(text: str, path: Path):
    issues = []
    stripped = strip_strings(text)
    for i, line in enumerate(stripped.splitlines(), start=1):
        for m in WORD_RE.finditer(line):
            word = m.group(1)
            lw = word.lower()
            for p in RESERVED_PREFIXES:
                if lw.startswith(p):
                    issues.append((i, word, p))
                    break
    return issues

def main():
    root = Path(sys.argv[1]) if len(sys.argv) > 1 else Path('.')
    xs_files = list(root.rglob('*.xs'))
    any_issues = False
    for f in xs_files:
        try:
            text = f.read_text(encoding='utf-8', errors='ignore')
        except Exception as e:
            print(f"[ERROR] Cannot read {f}: {e}")
            any_issues = True
            continue
        issues = find_violations(text, f)
        if issues:
            any_issues = True
            print(f"\n[VIOLATIONS] {f}")
            for line_no, word, prefix in issues[:50]:
                print(f"  L{line_no}: identifier '{word}' starts with reserved prefix '{prefix}'")
            if len(issues) > 50:
                print(f"  ... {len(issues)-50} more ...")
    if any_issues:
        print("\nGuard failed: Found reserved-word prefix identifiers. Rename them (e.g., 'day_', 'txn_', 'pos_').")
        sys.exit(1)
    print("XS Guard: no reserved-word prefix violations found.")
    return 0

if __name__ == '__main__':
    main()



