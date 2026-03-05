#!/usr/bin/env python3
"""
XSHelp indexer: traverse the XSHelp site and generate index.json and INDEX.md
without downloading or saving any page contents locally.

Usage (PowerShell on Windows):
  python scripts/xshelp_indexer.py --base https://xshelp.xq.com.tw/XSHelp/ \
         --out docs/sources/xshelp_mirror --delay 0.5 --max-pages 0
"""

from __future__ import annotations

import argparse
import re
import time
from pathlib import Path
from typing import Dict, List, Iterable, Optional
from urllib.parse import urlparse, urljoin, parse_qs

import requests
from bs4 import BeautifulSoup
from requests.adapters import HTTPAdapter
from urllib3.util.retry import Retry


GROUP_PARAM = "group"
HELP_PARAM = "HelpName"


def build_session() -> requests.Session:
    s = requests.Session()
    retries = Retry(
        total=5,
        backoff_factor=0.5,
        status_forcelist=[429, 500, 502, 503, 504],
        respect_retry_after_header=True,
    )
    ad = HTTPAdapter(max_retries=retries)
    s.mount("http://", ad)
    s.mount("https://", ad)
    s.headers.update(
        {
            "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) XSHelpIndexer/1.0",
            "Accept-Language": "zh-TW,zh;q=0.9,en;q=0.8",
        }
    )
    return s


def should_visit(base_netloc: str, url: str) -> bool:
    p = urlparse(url)
    if p.netloc and p.netloc != base_netloc:
        return False
    return p.path.startswith("/XSHelp")


def iterate_links(base_url: str, html: str) -> Iterable[str]:
    soup = BeautifulSoup(html, "lxml")
    for a in soup.find_all("a", href=True):
        yield urljoin(base_url, a["href"])


def extract_title(html: str) -> str:
    soup = BeautifulSoup(html, "lxml")
    return soup.title.string.strip() if soup.title and soup.title.string else ""


def parse_group_help(url: str) -> tuple[Optional[str], Optional[str]]:
    q = parse_qs(urlparse(url).query)
    return q.get(GROUP_PARAM, [None])[0], q.get(HELP_PARAM, [None])[0]


def write_index(out_dir: Path, entries: List[dict]) -> None:
    import json

    out_dir.mkdir(parents=True, exist_ok=True)
    (out_dir / "index.json").write_text(
        json.dumps(entries, ensure_ascii=False, indent=2), encoding="utf-8"
    )

    grouped: Dict[str, List[dict]] = {}
    for e in entries:
        grouped.setdefault(e.get("group") or "_misc", []).append(e)

    lines: List[str] = ["# XSHelp Index", ""]
    for group in sorted(grouped.keys(), key=lambda x: x.lower()):
        lines.append(f"## {group}")
        lines.append("")
        for e in sorted(grouped[group], key=lambda x: (e.get("helpname") or "").lower()):
            title = e.get("title") or e.get("helpname") or "(untitled)"
            url = e.get("url")
            lines.append(f"- [{title}]({url}) — `HelpName={e.get('helpname')}`")
        lines.append("")
    (out_dir / "INDEX.md").write_text("\n".join(lines).rstrip() + "\n", encoding="utf-8")


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--base", default="https://xshelp.xq.com.tw/XSHelp/", help="Base URL")
    ap.add_argument("--out", default="docs/sources/xshelp_mirror", help="Output directory")
    ap.add_argument("--delay", type=float, default=0.5, help="Seconds between requests")
    ap.add_argument("--max-pages", type=int, default=0, help="Limit pages (0=unlimited)")
    args = ap.parse_args()

    session = build_session()
    base_netloc = urlparse(args.base).netloc

    queue = [args.base]
    seen: set[str] = set()
    entries: List[dict] = []
    saved = 0

    while queue:
        url = queue.pop(0)
        if url in seen:
            continue
        seen.add(url)
        if not should_visit(base_netloc, url):
            continue

        try:
            r = session.get(url, timeout=20)
            r.raise_for_status()
        except Exception as e:
            print(f"[WARN] {url} -> {e}")
            continue

        html = r.text
        for link in iterate_links(url, html):
            if link not in seen and should_visit(base_netloc, link):
                queue.append(link)

        group, helpname = parse_group_help(url)
        if group or helpname:
            title = extract_title(html)
            entries.append(
                {
                    "group": group,
                    "helpname": helpname,
                    "title": title,
                    "url": url,
                }
            )
            saved += 1
            print(f"[OK] {url}")

        if args.max_pages and saved >= args.max_pages:
            break
        time.sleep(max(args.delay, 0.0))

    write_index(Path(args.out), entries)
    print(f"[OK] Wrote index to {Path(args.out) / 'index.json'} and {Path(args.out) / 'INDEX.md'} with {len(entries)} entries.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())


