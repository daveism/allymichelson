# Ally Michelson — Art Portfolio

Config-driven static art portfolio built with Next.js, Tailwind CSS, Markdown, and YAML.

## Quick Start

```bash
npm install
npm run dev
```

## Scrape Existing Wix Site (one-time)

```bash
npm install playwright
npx playwright install chromium
npm run scrape
```

## Adding New Art

1. Add image to `public/images/[category]/`
2. Create `.md` file in `content/portfolio/[category]/`:

```markdown
---
title: "My New Piece"
description: "Brief description"
image: "/images/2d/my-piece.jpg"
category: "2d"
tags: ["painting"]
date: "2025-01-15"
medium: "Oil on canvas"
dimensions: "24 x 36 in"
featured: false
order: 1
---
Optional notes here.
```

3. `git add . && git commit -m "new piece" && git push`

## Change Theme

Edit `config/theme.yaml` — all colors, fonts, buttons, and card styles.
Rebuild with `npm run build`.

## Deploy to GitHub Pages

1. Push to `main` — auto-deploys via GitHub Actions
2. Enable in repo **Settings → Pages → Source: GitHub Actions**
3. For `username.github.io/repo-name`, uncomment `basePath` in `next.config.js`

### Custom Domain (later)

1. Add `CNAME` file to `public/` with your domain
2. Remove `basePath` from `next.config.js`
3. Configure DNS (A records or CNAME to `username.github.io`)

## Image Storage

Local by default (`public/images/`). For S3, use full URL in frontmatter:

```markdown
image: "https://your-bucket.s3.amazonaws.com/art/piece.jpg"
```
