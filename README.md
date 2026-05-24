# dayanraj.com

Personal website + tech blog. Plain HTML, CSS, and JS — no framework, no build step.

## Local preview

```bash
python3 -m http.server 8000
# open http://localhost:8000
```

## Writing a new post

Run the scaffold script (requires `python3` and `bash`):

```bash
chmod +x scripts/new-post.sh   # first time only
./scripts/new-post.sh "My Post Title"
```

This will:
1. Create `blog/my-post-title/index.html` from the template
2. Add an entry to `articles.json`
3. Add an `<item>` to `feed.xml`
4. Add a `<url>` to `sitemap.xml`

Then:
- Write your post in `blog/my-post-title/index.html`
- Update `excerpt`, `tags`, and `readingTime` in `articles.json`
- Update the `<description>` in `feed.xml`

Code blocks use Prism.js for syntax highlighting. Specify a language:

```html
<pre><code class="language-bash">
echo "hello"
</code></pre>
```

Supported language IDs: `bash`, `python`, `javascript`, `typescript`, `yaml`, `json`, `dockerfile`, `go`, etc.

## Deploy to AWS S3 + CloudFront

### One-time AWS setup

1. **S3 bucket** — Create a bucket named `dayanraj.com`. Enable static website hosting with index document `index.html` and error document `404.html`.
2. **Keep bucket private** — Do not enable public access. Use CloudFront with OAC instead.
3. **ACM certificate** — Request a cert for `dayanraj.com` and `www.dayanraj.com` in region `us-east-1` (required for CloudFront).
4. **CloudFront distribution** — Create a distribution pointing to the S3 bucket origin using OAC. Set the default root object to `index.html`. Add CNAME aliases for both apex and `www`.
5. **DNS** — In Route 53 (or your DNS provider), add A/AAAA alias records for `dayanraj.com` and `www.dayanraj.com` pointing to the CloudFront distribution domain.
6. **CloudFront function (optional)** — Add a viewer-request function to redirect `www` → apex and to append `/index.html` to directory paths (for pretty URLs).

### Deploying

```bash
export CF_DIST_ID=EXXXXXXXXXXXXX   # your CloudFront distribution ID
chmod +x deploy.sh                 # first time only
./deploy.sh
```

The script syncs all site files to S3 and triggers a `/*` CloudFront invalidation.

## File structure

```
/
├── index.html              Home / hero
├── about.html              About page
├── 404.html                S3 error document
├── blog/
│   ├── index.html          Blog list (reads articles.json via JS)
│   ├── _template/          Copy this to start a new post
│   └── <slug>/
│       └── index.html      Individual post
├── articles.json           Post manifest (drives blog list + home)
├── feed.xml                RSS feed
├── robots.txt
├── sitemap.xml
├── assets/
│   ├── css/main.css        All styles + design tokens
│   ├── js/
│   │   ├── theme.js        Dark/light toggle
│   │   └── blog-index.js   Renders post list from articles.json
│   └── img/
│       ├── favicon.svg
│       └── og-default.png  Default social share image (add yours)
├── scripts/
│   └── new-post.sh         Post scaffold script
└── deploy.sh               S3 sync + CloudFront invalidation
```

## Customisation tips

- **Accent color** — Change `--accent` in `assets/css/main.css` (`:root` and `[data-theme="light"]`).
- **Bio / headline** — Edit `index.html` and `about.html` directly.
- **Skills** — Edit the `.skill-chip` list in `about.html`.
- **Social share image** — Replace `assets/img/og-default.png` (1200×630 px recommended).
- **Profile photo** — Add `assets/img/avatar.jpg` and reference it in `about.html` if desired.
