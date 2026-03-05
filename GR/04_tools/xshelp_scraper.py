# scripts/xshelp_scraper.py
#!/usr/bin/env python3
"""
Mirror XScript XSHelp site into local docs for offline use.

- Crawls all pages on the same host under /XSHelp/
- Captures pages with HelpName/group query params
- Saves raw HTML and extracted Markdown
- Downloads images to assets/
- Polite retries + delay

Usage (PowerShell):
  python scripts/xshelp_scraper.py --base https://xshelp.xq.com.tw/XSHelp/ ^
         --out docs/sources/xshelp_mirror --delay 0.5 --max-pages 0
"""
from __future__ import annotations
import argparse, hashlib, re, time
from pathlib import Path
from urllib.parse import urlparse, urljoin, parse_qs
from dataclasses import dataclass
from typing import Iterable, Optional
import requests
from bs4 import BeautifulSoup
from requests.adapters import HTTPAdapter
from urllib3.util.retry import Retry

GROUP_PARAM = "group"
HELP_PARAM = "HelpName"

def build_session() -> requests.Session:
    s = requests.Session()
    retries = Retry(total=5, backoff_factor=0.5,
                    status_forcelist=[429,500,502,503,504],
                    respect_retry_after_header=True)
    ad = HTTPAdapter(max_retries=retries)
    s.mount("http://", ad); s.mount("https://", ad)
    s.headers.update({
        "User-Agent": "Mozilla/5.0 XScriptCrawler/1.0",
        "Accept-Language": "zh-TW,zh;q=0.9,en;q=0.8",
    })
    return s

def safe_filename(name: str) -> str:
    name = re.sub(r"[^\w\-.]+", "_", name).strip("._")
    return name or "index"

def extract_markdown(soup: BeautifulSoup) -> str:
    main = soup.find(id="content") or soup.find("main") or soup
    for tag in main.find_all(["nav","aside","script","style"]):
        tag.decompose()
    out = []
    title = soup.title.string.strip() if soup.title and soup.title.string else ""
    if title: out += [f"# {title}", ""]
    for el in main.descendants:
        if not getattr(el, "name", None): continue
        if el.name in ("h1","h2","h3","h4"):
            lvl = int(el.name[1]); txt = el.get_text(" ", strip=True)
            if txt: out += ["#"*lvl + " " + txt, ""]
        elif el.name == "p":
            txt = el.get_text(" ", strip=True)
            if txt: out += [txt, ""]
        elif el.name in ("pre","code"):
            code = el.get_text("\n", strip=False)
            if code:
                out += ["```", code.rstrip(), "```", ""]
    return ("\n".join(out)).strip() + "\n"

@dataclass
class PageInfo:
    url: str
    group: Optional[str]
    helpname: Optional[str]

def parse_page_info(url: str) -> PageInfo:
    q = parse_qs(urlparse(url).query)
    return PageInfo(url, q.get(GROUP_PARAM,[None])[0], q.get(HELP_PARAM,[None])[0])

def should_visit(base_netloc: str, url: str) -> bool:
    p = urlparse(url)
    if p.netloc and p.netloc != base_netloc: return False
    return p.path.startswith("/XSHelp")

def iterate_links(base_url: str, html: str) -> Iterable[str]:
    soup = BeautifulSoup(html, "lxml")
    for a in soup.find_all("a", href=True):
        yield urljoin(base_url, a["href"])
    for img in soup.find_all("img", src=True):
        yield urljoin(base_url, img["src"])

def is_asset(url: str) -> bool:
    return bool(re.search(r"\.(png|jpe?g|gif|webp|svg)(?:\?|$)", url, re.I))

def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--base", default="https://xshelp.xq.com.tw/XSHelp/")
    ap.add_argument("--out", default="docs/sources/xshelp_mirror")
    ap.add_argument("--delay", type=float, default=0.5)
    ap.add_argument("--max-pages", type=int, default=0, help="0=unlimited")
    args = ap.parse_args()

    out_dir = Path(args.out)
    out_html = out_dir / "html"
    out_md = out_dir / "markdown"
    out_assets = out_dir / "assets"
    for d in (out_html, out_md, out_assets): d.mkdir(parents=True, exist_ok=True)

    session = build_session()
    base_netloc = urlparse(args.base).netloc
    queue = [args.base]
    seen: set[str] = set()
    saved = 0

    while queue:
        url = queue.pop(0)
        if url in seen: continue
        seen.add(url)
        if not should_visit(base_netloc, url): continue

        try:
            r = session.get(url, timeout=20)
            r.raise_for_status()
            ctype = r.headers.get("Content-Type","")
        except Exception as e:
            print(f"[WARN] {url} -> {e}"); continue

        if is_asset(url) or ctype.startswith("image/"):
            fname = safe_filename(Path(urlparse(url).path).name or "asset")
            (out_assets/fname).write_bytes(r.content)
            continue

        html = r.text
        for link in iterate_links(url, html):
            if link not in seen and should_visit(base_netloc, link):
                queue.append(link)

        info = parse_page_info(url)
        if info.group or info.helpname:
            sub_html = out_html / safe_filename(info.group or "_misc")
            sub_md = out_md / safe_filename(info.group or "_misc")
            sub_html.mkdir(parents=True, exist_ok=True)
            sub_md.mkdir(parents=True, exist_ok=True)
            name = safe_filename(info.helpname or "index")
            html_path = sub_html / f"{name}.html"
            md_path = sub_md / f"{name}.md"
        else:
            digest = hashlib.sha1(url.encode()).hexdigest()[:16]
            html_path = out_html / f"page_{digest}.html"
            md_path = out_md / f"page_{digest}.md"

        html_path.write_text(html, encoding="utf-8")
        try:
            md = extract_markdown(BeautifulSoup(html, "lxml"))
            md_path.write_text(md, encoding="utf-8")
        except Exception as e:
            print(f"[WARN] MD extract failed: {url}: {e}")

        saved += 1
        print(f"[OK] {url} -> {html_path.relative_to(out_dir)}")
        if args.max_pages and saved >= args.max_pages: break
        time.sleep(max(args.delay, 0.0))
    print(f"Done. Saved {saved} pages. HTML:{out_html} MD:{out_md}")
    return 0

if __name__ == "__main__":
    raise SystemExit(main())