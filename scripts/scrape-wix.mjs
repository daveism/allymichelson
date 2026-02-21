#!/usr/bin/env node
/**
 * One-time scraper for allymichelson.com (Wix)
 * Downloads all art images and generates Markdown content files.
 *
 * Usage:
 *   npm install playwright
 *   npx playwright install chromium
 *   node scripts/scrape-wix.mjs
 */
import { chromium } from 'playwright';
import fs from 'fs/promises';
import path from 'path';

const BASE_URL = 'https://www.allymichelson.com';
const OUTPUT = process.cwd();

const PAGES = [
  { url: '/projects-7', category: '2d', title: '2D' },
  { url: '/copy-of-3d', category: '3d', title: '3D' },
  { url: '/copy-of-digital', category: 'digital', title: 'Digital' },
];

async function downloadImage(url, dest) {
  try {
    const res = await fetch(url);
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    const buf = Buffer.from(await res.arrayBuffer());
    await fs.writeFile(dest, buf);
    return true;
  } catch (e) {
    console.error(`  ❌ Failed: ${e.message}`);
    return false;
  }
}

async function extractImages(page) {
  return page.evaluate(() => {
    const m = {};
    document.querySelectorAll('*').forEach(el => {
      const srcs = [];
      try {
        const bg = getComputedStyle(el).backgroundImage;
        if (bg && bg.includes('wixstatic')) {
          const match = bg.match(/url\("?([^")\s]+)"?\)/);
          if (match) srcs.push(decodeURIComponent(match[1]));
        }
      } catch {}
      if (el.src && el.src.includes('wixstatic')) srcs.push(el.src);

      srcs.forEach(url => {
        const match = url.match(/media\/(ab8b75_[a-f0-9]+~mv2\.\w+)/);
        if (match) {
          const fid = match[1];
          const wm = url.match(/w_(\d+)/);
          const w = wm ? parseInt(wm[1]) : 0;
          if (w > 100 && !fid.includes('6075634883d8')) {
            if (!m[fid] || w > m[fid].w) m[fid] = { fid, w };
          }
        }
      });
    });
    return Object.values(m);
  });
}

async function scrollFull(page) {
  let last = 0;
  for (let i = 0; i < 30; i++) {
    await page.evaluate(() => window.scrollTo(0, document.body.scrollHeight));
    await page.waitForTimeout(800);
    const h = await page.evaluate(() => document.body.scrollHeight);
    if (h === last) break;
    last = h;
  }
}

async function main() {
  console.log('🎨 Ally Michelson Portfolio Scraper\n');

  const dirs = [
    'content/portfolio/2d', 'content/portfolio/3d',
    'content/portfolio/digital', 'content/portfolio/tattoos',
    'public/images/2d', 'public/images/3d',
    'public/images/digital', 'public/images/tattoos',
    'public/images/site',
  ];
  for (const d of dirs) await fs.mkdir(path.join(OUTPUT, d), { recursive: true });

  const browser = await chromium.launch({ headless: true });
  const ctx = await browser.newContext({ viewport: { width: 1920, height: 1080 } });
  const page = await ctx.newPage();
  let total = 0;

  for (const { url, category, title } of PAGES) {
    console.log(`\n📂 ${title} (${url})`);
    await page.goto(`${BASE_URL}${url}`, { waitUntil: 'networkidle' });
    await page.waitForTimeout(2000);
    await scrollFull(page);
    await page.waitForTimeout(1000);

    const images = await extractImages(page);
    console.log(`  Found ${images.length} images`);

    for (let i = 0; i < images.length; i++) {
      const img = images[i];
      const ext = img.fid.split('.').pop();
      const fname = `${category}-${String(i + 1).padStart(2, '0')}.${ext}`;
      const imgUrl = `https://static.wixstatic.com/media/${img.fid}`;
      const dest = path.join(OUTPUT, 'public', 'images', category, fname);

      process.stdout.write(`  ${fname}...`);
      const ok = await downloadImage(imgUrl, dest);
      if (ok) console.log(' ✅');

      if (ok) {
        const slug = `${category}-piece-${String(i + 1).padStart(2, '0')}`;
        const md = `---\ntitle: ""\ndescription: ""\nimage: "/images/${category}/${fname}"\ncategory: "${category}"\ntags: []\ndate: "${new Date().toISOString().split('T')[0]}"\nmedium: ""\ndimensions: ""\nfeatured: ${i === 0 ? 'true' : 'false'}\norder: ${i + 1}\n---\n`;
        await fs.writeFile(path.join(OUTPUT, 'content', 'portfolio', category, `${slug}.md`), md);
        total++;
      }
    }
  }

  // Hero image
  console.log('\n🏠 Home hero...');
  await page.goto(BASE_URL, { waitUntil: 'networkidle' });
  await page.waitForTimeout(2000);
  const homeImgs = await extractImages(page);
  if (homeImgs.length > 0) {
    const hero = homeImgs.reduce((a, b) => (a.w > b.w ? a : b));
    const ext = hero.fid.split('.').pop();
    const ok = await downloadImage(
      `https://static.wixstatic.com/media/${hero.fid}`,
      path.join(OUTPUT, 'public', 'images', 'site', `hero.${ext}`)
    );
    console.log(ok ? '  ✅ Hero saved' : '  ❌ Hero failed');
  }

  await browser.close();
  console.log(`\n🎉 Done! ${total} images scraped.`);
  console.log('Next: Add titles/descriptions to content/portfolio/*.md');
  console.log('Then: npm run dev');
}

main().catch(console.error);
