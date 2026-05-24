# dayanraj.com

Personal website. Plain HTML, CSS, and JS — no framework, no build step.

## Local preview

```bash
python3 -m http.server 8000
# open http://localhost:8000
```

## Deploy to AWS S3 + CloudFront

### One-time AWS setup

1. **S3 bucket** — Create a bucket named `dayanraj.com`. Enable static website hosting with index document `index.html` and error document `404.html`.
2. **Keep bucket private** — Do not enable public access. Use CloudFront with OAC instead.
3. **ACM certificate** — Request a cert for `dayanraj.com` and `www.dayanraj.com` in region `us-east-1` (required for CloudFront).
4. **CloudFront distribution** — Create a distribution pointing to the S3 bucket origin using OAC. Set the default root object to `index.html`. Add CNAME aliases for both apex and `www`.
5. **DNS** — In Route 53 (or your DNS provider), add A/AAAA alias records for `dayanraj.com` and `www.dayanraj.com` pointing to the CloudFront distribution domain.
6. **CloudFront function (optional)** — Add a viewer-request function to redirect `www` → apex.

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
├── feed.xml                RSS feed
├── robots.txt
├── sitemap.xml
├── assets/
│   ├── css/main.css        All styles + design tokens
│   ├── js/
│   │   └── theme.js        Dark/light toggle
│   └── img/
│       ├── favicon.svg
│       └── og-default.png  Default social share image (add yours)
└── deploy.sh               S3 sync + CloudFront invalidation
```

## Customisation tips

- **Accent color** — Change `--accent` in `assets/css/main.css` (`:root` and `[data-theme="light"]`).
- **Bio / headline** — Edit `index.html` and `about.html` directly.
- **Skills** — Edit the `.skill-chip` list in `about.html`.
- **Social share image** — Replace `assets/img/og-default.png` (1200×630 px recommended).
- **Profile photo** — Add `assets/img/avatar.jpg` and reference it in `about.html` if desired.
