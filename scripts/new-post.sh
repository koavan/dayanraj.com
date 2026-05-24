#!/usr/bin/env bash
# Usage: ./scripts/new-post.sh "My Post Title"
# Creates a new blog post scaffold and updates articles.json, feed.xml, sitemap.xml.
set -euo pipefail

TITLE="${1:-}"
if [ -z "$TITLE" ]; then
  echo "Usage: ./scripts/new-post.sh \"My Post Title\""
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

SLUG="$(echo "$TITLE" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | sed 's/[^a-z0-9-]//g' | sed 's/--*/-/g')"
DATE="$(date +%Y-%m-%d)"
OUTDIR="$ROOT_DIR/blog/$SLUG"

if [ -d "$OUTDIR" ]; then
  echo "Error: $OUTDIR already exists."
  exit 1
fi

mkdir -p "$OUTDIR"

sed \
  -e "s|POST_TITLE_PLACEHOLDER|$TITLE|g" \
  -e "s|POST_DATE_PLACEHOLDER|$DATE|g" \
  -e "s|POST_SLUG_PLACEHOLDER|$SLUG|g" \
  "$ROOT_DIR/blog/_template/index.html" > "$OUTDIR/index.html"

python3 - "$ROOT_DIR" "$SLUG" "$TITLE" "$DATE" <<'PYEOF'
import json, sys, re
from email.utils import formatdate
from datetime import datetime

root, slug, title, date = sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4]

# Update articles.json
articles_path = f"{root}/articles.json"
with open(articles_path) as f:
    articles = json.load(f)
articles.append({
    "slug": slug,
    "title": title,
    "date": date,
    "excerpt": "TODO: Replace with a 1–2 sentence excerpt shown on the post list.",
    "tags": [],
    "readingTime": "? min read"
})
with open(articles_path, "w") as f:
    json.dump(articles, f, indent=2)
    f.write("\n")

# Update feed.xml — insert before the marker comment
rss_path = f"{root}/feed.xml"
with open(rss_path) as f:
    rss = f.read()

rfc_date = formatdate(usegmt=True)
item = (
    f"    <item>\n"
    f"      <title><![CDATA[{title}]]></title>\n"
    f"      <link>https://dayanraj.com/blog/{slug}/</link>\n"
    f"      <guid>https://dayanraj.com/blog/{slug}/</guid>\n"
    f"      <pubDate>{rfc_date}</pubDate>\n"
    f"      <description><![CDATA[TODO: Add excerpt here.]]></description>\n"
    f"    </item>\n"
)
marker = "    <!-- posts will be added here by new-post.sh -->"
rss = rss.replace(marker, item + marker)
with open(rss_path, "w") as f:
    f.write(rss)

# Update sitemap.xml — insert before the marker comment
sitemap_path = f"{root}/sitemap.xml"
with open(sitemap_path) as f:
    sitemap = f.read()

url_entry = (
    f"  <url>\n"
    f"    <loc>https://dayanraj.com/blog/{slug}/</loc>\n"
    f"    <lastmod>{date}</lastmod>\n"
    f"    <changefreq>monthly</changefreq>\n"
    f"    <priority>0.7</priority>\n"
    f"  </url>\n"
)
sitemap_marker = "  <!-- Blog posts are added here by new-post.sh -->"
sitemap = sitemap.replace(sitemap_marker, url_entry + sitemap_marker)
with open(sitemap_path, "w") as f:
    f.write(sitemap)

print(f"Updated: articles.json, feed.xml, sitemap.xml")
PYEOF

echo ""
echo "Post created:"
echo "  $OUTDIR/index.html"
echo ""
echo "Next steps:"
echo "  1. Write your post in $OUTDIR/index.html"
echo "  2. Update 'excerpt', 'tags', and 'readingTime' in articles.json"
echo "  3. Update <description> in feed.xml"
echo "  4. Run ./deploy.sh"
