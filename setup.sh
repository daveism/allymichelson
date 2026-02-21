#!/bin/bash
# ============================================================
# Ally Michelson Portfolio - Project Setup Script
# Run from: /Users/dmichels/Documents/GitHub/allymichelson
#
# Usage:
#   chmod +x setup.sh
#   ./setup.sh
# ============================================================

set -e
echo "🎨 Setting up Ally Michelson Portfolio..."
echo "==========================================="

# ---- Create directory structure ----
echo "📁 Creating directories..."
mkdir -p .github/workflows
mkdir -p config
mkdir -p content/portfolio/2d
mkdir -p content/portfolio/3d
mkdir -p content/portfolio/digital
mkdir -p content/portfolio/tattoos
mkdir -p public/images/2d
mkdir -p public/images/3d
mkdir -p public/images/digital
mkdir -p public/images/tattoos
mkdir -p public/images/site
mkdir -p public/documents
mkdir -p scripts
mkdir -p src/app/about
mkdir -p src/app/contact
mkdir -p src/app/portfolio/\[category\]/\[slug\]
mkdir -p src/components/layout
mkdir -p src/components/ui
mkdir -p src/components/art
mkdir -p src/lib
mkdir -p src/styles

# ============================================================
# ROOT CONFIG FILES
# ============================================================

echo "📄 Writing root config files..."

cat > package.json << 'ENDOFFILE'
{
  "name": "ally-portfolio",
  "version": "1.0.0",
  "private": true,
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "next lint",
    "scrape": "node scripts/scrape-wix.mjs"
  },
  "dependencies": {
    "gray-matter": "^4.0.3",
    "js-yaml": "^4.1.0",
    "next": "^14.2.0",
    "react": "^18.3.0",
    "react-dom": "^18.3.0",
    "remark": "^15.0.1",
    "remark-html": "^16.0.1"
  },
  "devDependencies": {
    "@types/js-yaml": "^4.0.9",
    "@types/node": "^20.14.0",
    "@types/react": "^18.3.0",
    "@types/react-dom": "^18.3.0",
    "autoprefixer": "^10.4.19",
    "playwright": "^1.44.0",
    "postcss": "^8.4.38",
    "tailwindcss": "^3.4.4",
    "typescript": "^5.4.0"
  }
}
ENDOFFILE

cat > next.config.js << 'ENDOFFILE'
/** @type {import('next').NextConfig} */
const nextConfig = {
  output: 'export',
  // Uncomment basePath for GitHub Pages (username.github.io/repo-name)
  // Remove when using a custom domain
  // basePath: '/allymichelson',
  images: {
    unoptimized: true,
  },
  trailingSlash: true,
};

module.exports = nextConfig;
ENDOFFILE

cat > tsconfig.json << 'ENDOFFILE'
{
  "compilerOptions": {
    "target": "es5",
    "lib": ["dom", "dom.iterable", "esnext"],
    "allowJs": true,
    "skipLibCheck": true,
    "strict": true,
    "noEmit": true,
    "esModuleInterop": true,
    "module": "esnext",
    "moduleResolution": "bundler",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "preserve",
    "incremental": true,
    "plugins": [{ "name": "next" }],
    "paths": { "@/*": ["./src/*"] }
  },
  "include": ["next-env.d.ts", "**/*.ts", "**/*.tsx", ".next/types/**/*.ts"],
  "exclude": ["node_modules"]
}
ENDOFFILE

cat > tailwind.config.ts << 'ENDOFFILE'
import type { Config } from 'tailwindcss';

const config: Config = {
  content: ['./src/**/*.{js,ts,jsx,tsx,mdx}'],
  theme: {
    extend: {
      colors: {
        bg: 'var(--color-bg)',
        'bg-alt': 'var(--color-bg-alt)',
        surface: 'var(--color-surface)',
        'text-primary': 'var(--color-text-primary)',
        'text-secondary': 'var(--color-text-secondary)',
        'text-muted': 'var(--color-text-muted)',
        accent: {
          primary: 'var(--color-accent-primary)',
          secondary: 'var(--color-accent-secondary)',
          tertiary: 'var(--color-accent-tertiary)',
        },
        hover: 'var(--color-hover)',
        active: 'var(--color-active)',
        focus: 'var(--color-focus)',
        border: 'var(--color-border)',
        'border-hover': 'var(--color-border-hover)',
        error: 'var(--color-error)',
        success: 'var(--color-success)',
      },
      fontFamily: {
        heading: 'var(--font-heading)',
        body: 'var(--font-body)',
        accent: 'var(--font-accent)',
      },
      maxWidth: {
        layout: 'var(--layout-max-width)',
      },
      borderRadius: {
        card: 'var(--card-radius)',
        btn: 'var(--btn-radius)',
      },
    },
  },
  plugins: [],
};

export default config;
ENDOFFILE

cat > postcss.config.js << 'ENDOFFILE'
module.exports = {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
};
ENDOFFILE

cat > .gitignore << 'ENDOFFILE'
node_modules/
.next/
out/
.DS_Store
*.tsbuildinfo
next-env.d.ts
ENDOFFILE

# ============================================================
# GITHUB ACTIONS
# ============================================================

echo "🚀 Writing GitHub Actions workflow..."

cat > .github/workflows/deploy.yml << 'ENDOFFILE'
name: Deploy to GitHub Pages

on:
  push:
    branches: [main]
  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: "pages"
  cancel-in-progress: false

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'

      - name: Install dependencies
        run: npm ci

      - name: Build
        run: npm run build

      - name: Upload artifact
        uses: actions/upload-pages-artifact@v3
        with:
          path: ./out

  deploy:
    needs: build
    runs-on: ubuntu-latest
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    steps:
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
ENDOFFILE

# ============================================================
# YAML CONFIG FILES
# ============================================================

echo "⚙️  Writing YAML config files..."

cat > config/site.yaml << 'ENDOFFILE'
title: "Ally Michelson"
description: "Art portfolio — 2D, 3D, Digital, and Tattoo work"
author: "Ally Michelson"
email: "allysonmichelson@gmail.com"
url: "https://username.github.io/allymichelson"
social:
  instagram: "https://www.instagram.com/ally_._art/"
ENDOFFILE

cat > config/navigation.yaml << 'ENDOFFILE'
items:
  - label: "Home"
    path: "/"
  - label: "2D"
    path: "/portfolio/2d"
    isPortfolioCategory: true
  - label: "3D"
    path: "/portfolio/3d"
    isPortfolioCategory: true
  - label: "Digital"
    path: "/portfolio/digital"
    isPortfolioCategory: true
  - label: "Tattoos"
    path: "/portfolio/tattoos"
    isPortfolioCategory: true
  - label: "About"
    path: "/about"
  - label: "Contact"
    path: "/contact"
ENDOFFILE

cat > config/portfolio.yaml << 'ENDOFFILE'
sections:
  - slug: "2d"
    title: "2D"
    description: "Paintings, drawings, ink work, and sketchbook explorations"
    coverImage: "/images/2d/2d-01.jpg"
    contentDir: "content/portfolio/2d"
    order: 1
  - slug: "3d"
    title: "3D"
    description: "Metalsmithing, sculpture, shadow boxes, and installations"
    coverImage: "/images/3d/3d-01.jpg"
    contentDir: "content/portfolio/3d"
    order: 2
  - slug: "digital"
    title: "Digital"
    description: "3D renders, game environments, and digital compositions"
    coverImage: "/images/digital/digital-01.png"
    contentDir: "content/portfolio/digital"
    order: 3
  - slug: "tattoos"
    title: "Tattoos"
    description: "Tattoo designs and completed work"
    coverImage: ""
    contentDir: "content/portfolio/tattoos"
    order: 4
ENDOFFILE

cat > config/theme.yaml << 'ENDOFFILE'
palette:
  background: "#0a0a0a"
  backgroundAlt: "#141414"
  surface: "#1a1a1a"
  textPrimary: "#e8e4df"
  textSecondary: "#8a8580"
  textMuted: "#5a5550"
  accentPrimary: "#b5ff2b"
  accentSecondary: "#ff6b35"
  accentTertiary: "#7b68ee"
  hover: "#c8ff57"
  active: "#9ae600"
  focus: "#b5ff2b40"
  border: "#2a2a2a"
  borderHover: "#3a3a3a"
  error: "#ff4757"
  success: "#2ed573"

typography:
  headingFont: "'Playfair Display', serif"
  bodyFont: "'Inter', sans-serif"
  accentFont: "'Space Grotesk', sans-serif"
  headingWeight: "700"
  bodyWeight: "400"
  baseSize: "16px"

buttons:
  borderRadius: "2px"
  paddingX: "1.5rem"
  paddingY: "0.75rem"
  textTransform: "uppercase"
  letterSpacing: "0.1em"
  primary:
    background: "accentPrimary"
    text: "background"
    hoverBackground: "hover"
  secondary:
    background: "transparent"
    text: "textPrimary"
    border: "border"
    hoverBorder: "accentPrimary"
    hoverText: "accentPrimary"
  ghost:
    background: "transparent"
    text: "textSecondary"
    hoverText: "accentPrimary"

cards:
  borderRadius: "4px"
  hoverScale: "1.03"
  hoverShadow: "0 8px 32px rgba(181, 255, 43, 0.15)"
  transition: "all 0.3s cubic-bezier(0.4, 0, 0.2, 1)"

layout:
  maxWidth: "1400px"
  navPosition: "left"
  gridGap: "1rem"
  sectionPadding: "4rem"
ENDOFFILE

# ============================================================
# CONTENT FILES
# ============================================================

echo "📝 Writing content markdown files..."

cat > content/about.md << 'ENDOFFILE'
---
title: "About Me"
profileImage: "/images/site/profile.jpg"
cvDownload: "/documents/ally-michelson-cv.pdf"
---

## About Me

Ally Michelson is pursuing a BFA in Studio Art at Appalachian State University in Boone, North Carolina, focusing on metalsmithing and painting. Their work reflects on self-discovery and connections between barriers and personal understanding, exploring boundaries and the unknown through symbolism in windows, doors, stars, and numbers.

## Artist Statement

Art has always been a place where complex ideas and emotions can be turned into something tangible. In my recent work, I represent subconscious ideas that I have been drawn to and have thought about for years. My art is both a reflection of my internal experiences and a way to communicate those experiences to others.

Barriers, embodied by windows, doors, and gates, are recurring motifs, symbolizing boundaries between the known and unknown, the visible and hidden. They define space, create divisions, control interaction, and ask questions like, "What is on the other side?" These elements represent how I process and compartmentalize life, serving as both physical and metaphorical tools for understanding the world around me.

Numbers are another central theme, reflecting my compulsive need to count everything. Steps, noises, things around me, patterns; I am always striving for order and repetition. This obsessive counting creates structure in the chaos, and through art, I release these patterns, turning internal struggles into something real. Counting is my way of understanding the unknown or things that are not in my control.

Barriers, like doors, windows, and gates, are the physical representation of this. They are what separates the known and the unknown. They are how I open myself to the world, how I close myself off, and how I separate my life into different sections to be able to understand it better.

Art allows me to navigate barriers, process, and bridge the gap between inner and outer worlds. By transforming obsession into physical forms, I seek connection and understanding, one counted step at a time.
ENDOFFILE

cat > content/contact.md << 'ENDOFFILE'
---
title: "Contact"
formspreeId: "YOUR_FORMSPREE_ID"
---

## Get in Touch

Reach out for commissions, collaborations, or just to say hello.

## Social Links

- [Instagram](https://www.instagram.com/ally_._art/)
- [Email](mailto:allysonmichelson@gmail.com)
ENDOFFILE

# ============================================================
# SRC/LIB FILES
# ============================================================

echo "📚 Writing library files..."

cat > src/lib/types.ts << 'ENDOFFILE'
export interface SiteConfig {
  title: string;
  description: string;
  author: string;
  email: string;
  url: string;
  social: Record<string, string>;
}

export interface NavItem {
  label: string;
  path: string;
  isPortfolioCategory?: boolean;
}

export interface NavigationConfig {
  items: NavItem[];
}

export interface PortfolioSection {
  slug: string;
  title: string;
  description?: string;
  coverImage?: string;
  contentDir: string;
  order: number;
}

export interface PortfolioConfig {
  sections: PortfolioSection[];
}

export interface ArtPiece {
  slug: string;
  title: string;
  description: string;
  image: string;
  category: string;
  tags: string[];
  date: string;
  medium: string;
  dimensions: string;
  featured: boolean;
  order: number;
  content: string;
}

export interface ThemeConfig {
  palette: Record<string, string>;
  typography: Record<string, string>;
  buttons: Record<string, any>;
  cards: Record<string, string>;
  layout: Record<string, string>;
}

export interface AboutConfig {
  title: string;
  profileImage?: string;
  cvDownload?: string;
  content: string;
}

export interface ContactConfig {
  title: string;
  formspreeId: string;
  content: string;
}
ENDOFFILE

cat > src/lib/config.ts << 'ENDOFFILE'
import fs from 'fs';
import path from 'path';
import yaml from 'js-yaml';
import type {
  SiteConfig, NavigationConfig, PortfolioConfig, ThemeConfig
} from './types';

const configDir = path.join(process.cwd(), 'config');

function loadYaml<T>(filename: string): T {
  const filePath = path.join(configDir, filename);
  const raw = fs.readFileSync(filePath, 'utf8');
  return yaml.load(raw) as T;
}

let _site: SiteConfig | null = null;
let _nav: NavigationConfig | null = null;
let _portfolio: PortfolioConfig | null = null;
let _theme: ThemeConfig | null = null;

export function getSiteConfig(): SiteConfig {
  if (!_site) _site = loadYaml<SiteConfig>('site.yaml');
  return _site;
}

export function getNavigationConfig(): NavigationConfig {
  if (!_nav) _nav = loadYaml<NavigationConfig>('navigation.yaml');
  return _nav;
}

export function getPortfolioConfig(): PortfolioConfig {
  if (!_portfolio) _portfolio = loadYaml<PortfolioConfig>('portfolio.yaml');
  _portfolio.sections.sort((a, b) => a.order - b.order);
  return _portfolio;
}

export function getThemeConfig(): ThemeConfig {
  if (!_theme) _theme = loadYaml<ThemeConfig>('theme.yaml');
  return _theme;
}

export function getThemeCSSVars(): string {
  const t = getThemeConfig();
  const p = t.palette;
  const ty = t.typography;
  const c = t.cards;
  const b = t.buttons;

  return `
    --color-bg: ${p.background};
    --color-bg-alt: ${p.backgroundAlt};
    --color-surface: ${p.surface};
    --color-text-primary: ${p.textPrimary};
    --color-text-secondary: ${p.textSecondary};
    --color-text-muted: ${p.textMuted};
    --color-accent-primary: ${p.accentPrimary};
    --color-accent-secondary: ${p.accentSecondary};
    --color-accent-tertiary: ${p.accentTertiary};
    --color-hover: ${p.hover};
    --color-active: ${p.active};
    --color-focus: ${p.focus};
    --color-border: ${p.border};
    --color-border-hover: ${p.borderHover};
    --color-error: ${p.error};
    --color-success: ${p.success};
    --font-heading: ${ty.headingFont};
    --font-body: ${ty.bodyFont};
    --font-accent: ${ty.accentFont};
    --font-heading-weight: ${ty.headingWeight};
    --font-body-weight: ${ty.bodyWeight};
    --font-base-size: ${ty.baseSize};
    --card-radius: ${c.borderRadius};
    --card-hover-scale: ${c.hoverScale};
    --card-hover-shadow: ${c.hoverShadow};
    --card-transition: ${c.transition};
    --btn-radius: ${b.borderRadius};
    --btn-px: ${b.paddingX};
    --btn-py: ${b.paddingY};
    --btn-transform: ${b.textTransform};
    --btn-spacing: ${b.letterSpacing};
    --layout-max-width: ${t.layout.maxWidth};
    --layout-gap: ${t.layout.gridGap};
    --layout-padding: ${t.layout.sectionPadding};
  `.trim();
}
ENDOFFILE

cat > src/lib/content.ts << 'ENDOFFILE'
import fs from 'fs';
import path from 'path';
import matter from 'gray-matter';
import { remark } from 'remark';
import html from 'remark-html';
import type { ArtPiece, AboutConfig, ContactConfig } from './types';
import { getPortfolioConfig } from './config';

const contentDir = path.join(process.cwd(), 'content');

async function renderMarkdown(md: string): Promise<string> {
  const result = await remark().use(html).process(md);
  return result.toString();
}

export async function getArtPiecesByCategory(category: string): Promise<ArtPiece[]> {
  const portfolio = getPortfolioConfig();
  const section = portfolio.sections.find(s => s.slug === category);
  if (!section) return [];

  const dir = path.join(process.cwd(), section.contentDir);
  if (!fs.existsSync(dir)) return [];

  const files = fs.readdirSync(dir).filter(f => f.endsWith('.md'));
  const pieces: ArtPiece[] = [];

  for (const file of files) {
    const raw = fs.readFileSync(path.join(dir, file), 'utf8');
    const { data, content: body } = matter(raw);
    const renderedContent = await renderMarkdown(body);
    const slug = file.replace(/\.md$/, '');

    pieces.push({
      slug,
      title: data.title || '',
      description: data.description || '',
      image: data.image || '',
      category: data.category || category,
      tags: data.tags || [],
      date: data.date || '',
      medium: data.medium || '',
      dimensions: data.dimensions || '',
      featured: data.featured || false,
      order: data.order || 999,
      content: renderedContent,
    });
  }

  pieces.sort((a, b) => {
    if (a.order !== b.order) return a.order - b.order;
    return new Date(b.date).getTime() - new Date(a.date).getTime();
  });

  return pieces;
}

export async function getArtPiece(
  category: string, slug: string
): Promise<ArtPiece | null> {
  const pieces = await getArtPiecesByCategory(category);
  return pieces.find(p => p.slug === slug) || null;
}

export async function getFeaturedPieces(): Promise<ArtPiece[]> {
  const portfolio = getPortfolioConfig();
  const all: ArtPiece[] = [];
  for (const section of portfolio.sections) {
    const pieces = await getArtPiecesByCategory(section.slug);
    all.push(...pieces.filter(p => p.featured));
  }
  return all.slice(0, 6);
}

export function getAllCategorySlugs(): string[] {
  return getPortfolioConfig().sections.map(s => s.slug);
}

export async function getAllPieceSlugs(
  category: string
): Promise<{ category: string; slug: string }[]> {
  const pieces = await getArtPiecesByCategory(category);
  return pieces.map(p => ({ category, slug: p.slug }));
}

export async function getAboutContent(): Promise<AboutConfig> {
  const filePath = path.join(contentDir, 'about.md');
  if (!fs.existsSync(filePath)) {
    return { title: 'About', content: '' };
  }
  const raw = fs.readFileSync(filePath, 'utf8');
  const { data, content } = matter(raw);
  const rendered = await renderMarkdown(content);
  return {
    title: data.title || 'About',
    profileImage: data.profileImage,
    cvDownload: data.cvDownload,
    content: rendered,
  };
}

export async function getContactContent(): Promise<ContactConfig> {
  const filePath = path.join(contentDir, 'contact.md');
  if (!fs.existsSync(filePath)) {
    return { title: 'Contact', formspreeId: '', content: '' };
  }
  const raw = fs.readFileSync(filePath, 'utf8');
  const { data, content } = matter(raw);
  const rendered = await renderMarkdown(content);
  return {
    title: data.title || 'Contact',
    formspreeId: data.formspreeId || '',
    content: rendered,
  };
}

export async function getAdjacentPieces(
  category: string, slug: string
): Promise<{ prev: ArtPiece | null; next: ArtPiece | null }> {
  const pieces = await getArtPiecesByCategory(category);
  const idx = pieces.findIndex(p => p.slug === slug);
  return {
    prev: idx > 0 ? pieces[idx - 1] : null,
    next: idx < pieces.length - 1 ? pieces[idx + 1] : null,
  };
}
ENDOFFILE

# ============================================================
# COMPONENTS
# ============================================================

echo "🧩 Writing components..."

cat > src/components/layout/Navigation.tsx << 'ENDOFFILE'
'use client';

import { useState } from 'react';
import Link from 'next/link';
import { usePathname } from 'next/navigation';
import type { NavItem } from '@/lib/types';

interface Props {
  items: NavItem[];
  siteTitle: string;
}

export default function Navigation({ items, siteTitle }: Props) {
  const pathname = usePathname();
  const [open, setOpen] = useState(false);

  const isActive = (p: string) => {
    if (p === '/') return pathname === '/';
    return pathname.startsWith(p);
  };

  return (
    <>
      <button
        className="fixed top-6 left-6 z-50 lg:hidden flex flex-col gap-1.5"
        onClick={() => setOpen(!open)}
        aria-label="Toggle menu"
      >
        <span className={`block w-6 h-0.5 bg-text-primary transition-transform duration-300 ${open ? 'rotate-45 translate-y-2' : ''}`} />
        <span className={`block w-6 h-0.5 bg-text-primary transition-opacity duration-300 ${open ? 'opacity-0' : ''}`} />
        <span className={`block w-6 h-0.5 bg-text-primary transition-transform duration-300 ${open ? '-rotate-45 -translate-y-2' : ''}`} />
      </button>

      <nav className={`
        fixed top-0 left-0 h-full w-64 bg-bg z-40
        flex flex-col pt-12 px-8
        transition-transform duration-300
        lg:translate-x-0 border-r border-border
        ${open ? 'translate-x-0' : '-translate-x-full'}
      `}>
        <Link
          href="/"
          className="font-heading text-2xl text-text-primary no-underline mb-8 hover:text-text-primary"
          onClick={() => setOpen(false)}
        >
          {siteTitle}
        </Link>

        <div className="flex flex-col gap-1">
          {items.map(item => (
            <Link
              key={item.path}
              href={item.path}
              onClick={() => setOpen(false)}
              className={`
                font-accent text-sm tracking-widest uppercase py-2 no-underline
                transition-colors duration-200
                ${isActive(item.path)
                  ? 'text-accent-primary'
                  : 'text-text-secondary hover:text-text-primary'}
              `}
            >
              {item.label}
            </Link>
          ))}
        </div>

        <div className="mt-auto mb-8">
          <div className="w-16 h-0.5 bg-gradient-to-r from-accent-primary to-accent-secondary rounded" />
        </div>
      </nav>

      {open && (
        <div
          className="fixed inset-0 bg-black/60 z-30 lg:hidden"
          onClick={() => setOpen(false)}
        />
      )}
    </>
  );
}
ENDOFFILE

cat > src/components/layout/Footer.tsx << 'ENDOFFILE'
import type { SiteConfig } from '@/lib/types';

interface Props {
  config: SiteConfig;
}

export default function Footer({ config }: Props) {
  return (
    <footer className="border-t border-border mt-16 py-12 px-8">
      <div className="max-w-layout mx-auto flex flex-col sm:flex-row justify-between gap-8">
        <div>
          <p className="text-text-secondary text-sm">Email</p>
          <a
            href={`mailto:${config.email}`}
            className="text-text-primary text-sm hover:text-accent-primary no-underline"
          >
            {config.email}
          </a>
        </div>
        <div>
          <p className="text-text-secondary text-sm">Follow</p>
          <div className="flex gap-4 mt-1">
            {Object.entries(config.social).map(([name, url]) => (
              <a
                key={name}
                href={url}
                target="_blank"
                rel="noopener noreferrer"
                className="text-text-primary text-sm capitalize hover:text-accent-primary no-underline"
              >
                {name}
              </a>
            ))}
          </div>
        </div>
        <div className="text-text-muted text-xs self-end">
          &copy; {new Date().getFullYear()} {config.author}
        </div>
      </div>
    </footer>
  );
}
ENDOFFILE

cat > src/components/ui/SectionCard.tsx << 'ENDOFFILE'
import Link from 'next/link';
import Image from 'next/image';
import type { PortfolioSection } from '@/lib/types';

interface Props {
  section: PortfolioSection;
}

export default function SectionCard({ section }: Props) {
  return (
    <Link href={`/portfolio/${section.slug}`} className="no-underline group">
      <div className="art-card relative aspect-[4/3] bg-surface overflow-hidden">
        {section.coverImage && (
          <Image
            src={section.coverImage}
            alt={section.title}
            fill
            className="object-cover transition-transform duration-500 group-hover:scale-105"
            sizes="(max-width: 768px) 100vw, 50vw"
          />
        )}
        <div className="absolute inset-0 bg-gradient-to-t from-black/70 via-black/20 to-transparent" />
        <div className="absolute bottom-0 left-0 right-0 p-6">
          {section.title && (
            <h3 className="font-heading text-2xl text-white mb-1">{section.title}</h3>
          )}
          {section.description && (
            <p className="text-sm text-white/70 line-clamp-2">{section.description}</p>
          )}
        </div>
        <div className="absolute bottom-0 left-0 w-0 h-0.5 bg-accent-primary transition-all duration-500 group-hover:w-full" />
      </div>
    </Link>
  );
}
ENDOFFILE

cat > src/components/ui/ArtPieceCard.tsx << 'ENDOFFILE'
import Link from 'next/link';
import Image from 'next/image';
import type { ArtPiece } from '@/lib/types';

interface Props {
  piece: ArtPiece;
}

export default function ArtPieceCard({ piece }: Props) {
  return (
    <Link
      href={`/portfolio/${piece.category}/${piece.slug}`}
      className="no-underline group"
    >
      <div className="art-card relative bg-surface overflow-hidden">
        <div className="relative aspect-square">
          <Image
            src={piece.image}
            alt={piece.title || 'Art piece'}
            fill
            className="object-cover transition-transform duration-500 group-hover:scale-105"
            sizes="(max-width: 768px) 100vw, (max-width: 1024px) 50vw, 33vw"
            loading="lazy"
          />
        </div>
        {(piece.title || piece.description) && (
          <div className="absolute inset-0 bg-black/0 group-hover:bg-black/50 transition-all duration-300 flex items-end">
            <div className="p-4 translate-y-4 opacity-0 group-hover:translate-y-0 group-hover:opacity-100 transition-all duration-300">
              {piece.title && (
                <h4 className="font-heading text-lg text-white mb-1">{piece.title}</h4>
              )}
              {piece.description && (
                <p className="text-xs text-white/70 line-clamp-2">{piece.description}</p>
              )}
            </div>
          </div>
        )}
      </div>
    </Link>
  );
}
ENDOFFILE

cat > src/components/art/ArtGrid.tsx << 'ENDOFFILE'
import ArtPieceCard from '@/components/ui/ArtPieceCard';
import type { ArtPiece } from '@/lib/types';

interface Props {
  pieces: ArtPiece[];
}

export default function ArtGrid({ pieces }: Props) {
  if (pieces.length === 0) {
    return (
      <div className="text-center py-20">
        <p className="text-text-muted text-lg">No pieces in this collection yet.</p>
      </div>
    );
  }

  return (
    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
      {pieces.map(piece => (
        <ArtPieceCard key={piece.slug} piece={piece} />
      ))}
    </div>
  );
}
ENDOFFILE

cat > src/components/ui/ContactForm.tsx << 'ENDOFFILE'
'use client';

import { useState } from 'react';

interface Props {
  formspreeId: string;
}

export default function ContactForm({ formspreeId }: Props) {
  const [status, setStatus] = useState<'idle' | 'sending' | 'sent' | 'error'>('idle');

  async function handleSubmit() {
    setStatus('sending');
    const form = document.getElementById('contact-form') as HTMLElement;
    const inputs = form.querySelectorAll('input, textarea') as NodeListOf<HTMLInputElement | HTMLTextAreaElement>;
    const formData = new FormData();
    inputs.forEach(inp => { if (inp.name) formData.append(inp.name, inp.value); });

    try {
      const res = await fetch(`https://formspree.io/f/${formspreeId}`, {
        method: 'POST',
        body: formData,
        headers: { Accept: 'application/json' },
      });
      if (res.ok) {
        setStatus('sent');
        inputs.forEach(i => { i.value = ''; });
      } else {
        setStatus('error');
      }
    } catch {
      setStatus('error');
    }
  }

  if (status === 'sent') {
    return (
      <div className="bg-surface border border-border rounded-card p-8 text-center">
        <p className="text-accent-primary font-accent text-lg">Message sent!</p>
        <p className="text-text-secondary mt-2">Thank you for reaching out.</p>
        <button onClick={() => setStatus('idle')} className="btn btn-secondary mt-4">
          Send another
        </button>
      </div>
    );
  }

  const inputClass = `w-full bg-surface border border-border rounded-btn px-4 py-3 text-text-primary
    focus:border-accent-primary focus:outline-none focus:ring-1 focus:ring-focus transition-colors`;

  return (
    <div id="contact-form" className="flex flex-col gap-4">
      <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
        <div>
          <label htmlFor="name" className="block text-text-secondary text-sm mb-1 font-accent">Name</label>
          <input type="text" id="name" name="name" required className={inputClass} />
        </div>
        <div>
          <label htmlFor="email" className="block text-text-secondary text-sm mb-1 font-accent">Email</label>
          <input type="email" id="email" name="email" required className={inputClass} />
        </div>
      </div>
      <div>
        <label htmlFor="subject" className="block text-text-secondary text-sm mb-1 font-accent">Subject</label>
        <input type="text" id="subject" name="subject" className={inputClass} />
      </div>
      <div>
        <label htmlFor="message" className="block text-text-secondary text-sm mb-1 font-accent">Message</label>
        <textarea id="message" name="message" rows={6} required className={`${inputClass} resize-none`} />
      </div>
      <button
        type="button"
        disabled={status === 'sending'}
        onClick={handleSubmit}
        className="btn btn-primary self-start"
      >
        {status === 'sending' ? 'Sending...' : 'Send Message'}
      </button>
      {status === 'error' && (
        <p className="text-error text-sm">Something went wrong. Please try again.</p>
      )}
    </div>
  );
}
ENDOFFILE

# ============================================================
# APP PAGES
# ============================================================

echo "📄 Writing page files..."

cat > src/app/globals.css << 'ENDOFFILE'
@tailwind base;
@tailwind components;
@tailwind utilities;

@import url('https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700&family=Inter:wght@300;400;500;600&family=Space+Grotesk:wght@400;500;600;700&display=swap');

@layer base {
  body {
    background-color: var(--color-bg);
    color: var(--color-text-primary);
    font-family: var(--font-body);
    font-weight: var(--font-body-weight);
    font-size: var(--font-base-size);
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
  }
  h1, h2, h3, h4, h5, h6 {
    font-family: var(--font-heading);
    font-weight: var(--font-heading-weight);
    color: var(--color-text-primary);
  }
  a { color: var(--color-accent-primary); transition: color 0.2s ease; }
  a:hover { color: var(--color-hover); }
  ::selection { background: var(--color-accent-primary); color: var(--color-bg); }
}

@layer components {
  .art-card {
    border-radius: var(--card-radius);
    overflow: hidden;
    transition: var(--card-transition);
    cursor: pointer;
  }
  .art-card:hover {
    transform: scale(var(--card-hover-scale));
    box-shadow: var(--card-hover-shadow);
  }
  .btn {
    display: inline-flex; align-items: center; justify-content: center;
    padding: var(--btn-py) var(--btn-px);
    border-radius: var(--btn-radius);
    text-transform: var(--btn-transform);
    letter-spacing: var(--btn-spacing);
    font-family: var(--font-accent);
    font-weight: 600; font-size: 0.875rem;
    transition: all 0.2s ease; cursor: pointer;
    border: 1px solid transparent;
  }
  .btn-primary { background: var(--color-accent-primary); color: var(--color-bg); }
  .btn-primary:hover { background: var(--color-hover); color: var(--color-bg); }
  .btn-secondary { background: transparent; color: var(--color-text-primary); border-color: var(--color-border); }
  .btn-secondary:hover { border-color: var(--color-accent-primary); color: var(--color-accent-primary); }
  .btn-ghost { background: transparent; color: var(--color-text-secondary); }
  .btn-ghost:hover { color: var(--color-accent-primary); }

  .prose-custom h2 { font-size: 1.75rem; margin-top: 2.5rem; margin-bottom: 1rem; color: var(--color-text-primary); }
  .prose-custom h3 { font-size: 1.25rem; margin-top: 2rem; margin-bottom: 0.75rem; }
  .prose-custom p { margin-bottom: 1rem; line-height: 1.75; color: var(--color-text-secondary); }
  .prose-custom ul, .prose-custom ol { margin-bottom: 1rem; padding-left: 1.5rem; color: var(--color-text-secondary); }
  .prose-custom li { margin-bottom: 0.5rem; }
  .prose-custom a { color: var(--color-accent-primary); text-decoration: underline; text-underline-offset: 2px; }
  .prose-custom a:hover { color: var(--color-hover); }
  .prose-custom strong { color: var(--color-text-primary); font-weight: 600; }
  .prose-custom blockquote {
    border-left: 3px solid var(--color-accent-primary);
    padding-left: 1rem; margin: 1.5rem 0;
    color: var(--color-text-secondary); font-style: italic;
  }
  .organic-line { position: relative; }
  .organic-line::after {
    content: ''; position: absolute; bottom: -4px; left: 0;
    width: 60px; height: 3px;
    background: linear-gradient(90deg, var(--color-accent-primary), var(--color-accent-secondary));
    border-radius: 2px;
  }
}

::-webkit-scrollbar { width: 8px; }
::-webkit-scrollbar-track { background: var(--color-bg); }
::-webkit-scrollbar-thumb { background: var(--color-border); border-radius: 4px; }
::-webkit-scrollbar-thumb:hover { background: var(--color-border-hover); }
ENDOFFILE

cat > src/app/layout.tsx << 'ENDOFFILE'
import type { Metadata } from 'next';
import './globals.css';
import Navigation from '@/components/layout/Navigation';
import Footer from '@/components/layout/Footer';
import { getSiteConfig, getNavigationConfig, getThemeCSSVars } from '@/lib/config';

const site = getSiteConfig();
const nav = getNavigationConfig();
const cssVars = getThemeCSSVars();

export const metadata: Metadata = {
  title: { default: site.title, template: `%s | ${site.title}` },
  description: site.description,
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <head>
        <style dangerouslySetInnerHTML={{ __html: `:root { ${cssVars} }` }} />
      </head>
      <body className="bg-bg text-text-primary font-body min-h-screen">
        <Navigation items={nav.items} siteTitle={site.title} />
        <div className="lg:ml-64">
          <main className="min-h-screen">{children}</main>
          <Footer config={site} />
        </div>
      </body>
    </html>
  );
}
ENDOFFILE

cat > src/app/page.tsx << 'ENDOFFILE'
import Image from 'next/image';
import Link from 'next/link';
import { getFeaturedPieces } from '@/lib/content';
import { getSiteConfig, getPortfolioConfig } from '@/lib/config';
import ArtPieceCard from '@/components/ui/ArtPieceCard';

export default async function HomePage() {
  const site = getSiteConfig();
  const featured = await getFeaturedPieces();
  const portfolio = getPortfolioConfig();

  return (
    <div>
      {/* Hero */}
      <section className="relative h-[70vh] min-h-[500px] flex items-center justify-center overflow-hidden">
        <div className="absolute inset-0">
          <Image
            src="/images/site/hero.jpg"
            alt={`${site.title} hero artwork`}
            fill
            className="object-cover"
            priority
          />
          <div className="absolute inset-0 bg-gradient-to-b from-black/40 via-black/20 to-bg" />
        </div>
        <div className="relative z-10 text-center px-8">
          <h1 className="font-heading text-5xl md:text-7xl text-white mb-4">{site.title}</h1>
          <p className="font-accent text-sm md:text-base text-white/70 tracking-[0.3em] uppercase">
            2D &middot; 3D &middot; Digital &middot; Tattoos
          </p>
          <div className="mt-6 w-24 h-0.5 mx-auto bg-gradient-to-r from-accent-primary to-accent-secondary rounded" />
        </div>
      </section>

      {/* Featured */}
      {featured.length > 0 && (
        <section className="px-8 py-16 max-w-layout mx-auto">
          <h2 className="font-heading text-3xl mb-2 organic-line">Featured Work</h2>
          <p className="text-text-secondary mb-10 mt-6">Selected pieces across all disciplines</p>
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
            {featured.map(piece => (
              <ArtPieceCard key={piece.slug} piece={piece} />
            ))}
          </div>
        </section>
      )}

      {/* Explore */}
      <section className="px-8 py-16 max-w-layout mx-auto">
        <h2 className="font-heading text-3xl mb-10 organic-line">Explore</h2>
        <div className="grid grid-cols-2 md:grid-cols-4 gap-4 mt-6">
          {portfolio.sections.map(section => (
            <Link key={section.slug} href={`/portfolio/${section.slug}`} className="no-underline group">
              <div className="relative aspect-square bg-surface rounded-card overflow-hidden art-card">
                {section.coverImage && (
                  <Image src={section.coverImage} alt={section.title} fill
                    className="object-cover transition-transform duration-500 group-hover:scale-105"
                    sizes="(max-width: 768px) 50vw, 25vw" />
                )}
                <div className="absolute inset-0 bg-black/30 group-hover:bg-black/50 transition-colors" />
                <div className="absolute inset-0 flex items-center justify-center">
                  <span className="font-heading text-2xl text-white">{section.title}</span>
                </div>
              </div>
            </Link>
          ))}
        </div>
      </section>
    </div>
  );
}
ENDOFFILE

cat > src/app/about/page.tsx << 'ENDOFFILE'
import Image from 'next/image';
import type { Metadata } from 'next';
import { getAboutContent } from '@/lib/content';

export const metadata: Metadata = { title: 'About' };

export default async function AboutPage() {
  const about = await getAboutContent();

  return (
    <div className="px-8 py-16 max-w-3xl mx-auto">
      {about.profileImage && (
        <div className="relative w-48 h-48 rounded-full overflow-hidden mb-8 mx-auto border-2 border-border">
          <Image src={about.profileImage} alt="Profile" fill className="object-cover" priority />
        </div>
      )}
      <div className="prose-custom" dangerouslySetInnerHTML={{ __html: about.content }} />
      {about.cvDownload && (
        <div className="mt-8">
          <a href={about.cvDownload} className="btn btn-primary no-underline" download>Download CV</a>
        </div>
      )}
    </div>
  );
}
ENDOFFILE

cat > src/app/contact/page.tsx << 'ENDOFFILE'
import type { Metadata } from 'next';
import { getContactContent } from '@/lib/content';
import ContactForm from '@/components/ui/ContactForm';

export const metadata: Metadata = { title: 'Contact' };

export default async function ContactPage() {
  const contact = await getContactContent();

  return (
    <div className="px-8 py-16 max-w-3xl mx-auto">
      <h1 className="font-heading text-4xl mb-4 organic-line">Contact</h1>
      <div className="prose-custom mt-8 mb-12" dangerouslySetInnerHTML={{ __html: contact.content }} />
      <ContactForm formspreeId={contact.formspreeId} />
    </div>
  );
}
ENDOFFILE

cat > src/app/portfolio/page.tsx << 'ENDOFFILE'
import type { Metadata } from 'next';
import { getPortfolioConfig } from '@/lib/config';
import SectionCard from '@/components/ui/SectionCard';

export const metadata: Metadata = { title: 'Portfolio' };

export default function PortfolioPage() {
  const portfolio = getPortfolioConfig();

  return (
    <div className="px-8 py-16 max-w-layout mx-auto">
      <h1 className="font-heading text-4xl mb-4 organic-line">Portfolio</h1>
      <p className="text-text-secondary mt-8 mb-12">Explore work across all disciplines</p>
      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        {portfolio.sections.map(section => (
          <SectionCard key={section.slug} section={section} />
        ))}
      </div>
    </div>
  );
}
ENDOFFILE

cat > 'src/app/portfolio/[category]/page.tsx' << 'ENDOFFILE'
import type { Metadata } from 'next';
import { getPortfolioConfig } from '@/lib/config';
import { getArtPiecesByCategory, getAllCategorySlugs } from '@/lib/content';
import ArtGrid from '@/components/art/ArtGrid';

interface Props {
  params: { category: string };
}

export function generateStaticParams() {
  return getAllCategorySlugs().map(category => ({ category }));
}

export function generateMetadata({ params }: Props): Metadata {
  const portfolio = getPortfolioConfig();
  const section = portfolio.sections.find(s => s.slug === params.category);
  return {
    title: section?.title || params.category.toUpperCase(),
    description: section?.description,
  };
}

export default async function CategoryPage({ params }: Props) {
  const portfolio = getPortfolioConfig();
  const section = portfolio.sections.find(s => s.slug === params.category);
  const pieces = await getArtPiecesByCategory(params.category);

  return (
    <div className="px-8 py-16 max-w-layout mx-auto">
      <h1 className="font-heading text-4xl mb-2 organic-line">
        {section?.title || params.category.toUpperCase()}
      </h1>
      {section?.description && (
        <p className="text-text-secondary mt-6 mb-12">{section.description}</p>
      )}
      <ArtGrid pieces={pieces} />
    </div>
  );
}
ENDOFFILE

cat > 'src/app/portfolio/[category]/[slug]/page.tsx' << 'ENDOFFILE'
import Image from 'next/image';
import Link from 'next/link';
import type { Metadata } from 'next';
import { getPortfolioConfig } from '@/lib/config';
import {
  getArtPiece, getAllCategorySlugs, getAllPieceSlugs, getAdjacentPieces,
} from '@/lib/content';
import { notFound } from 'next/navigation';

interface Props {
  params: { category: string; slug: string };
}

export async function generateStaticParams() {
  const categories = getAllCategorySlugs();
  const all: { category: string; slug: string }[] = [];
  for (const cat of categories) {
    const slugs = await getAllPieceSlugs(cat);
    all.push(...slugs);
  }
  return all;
}

export async function generateMetadata({ params }: Props): Promise<Metadata> {
  const piece = await getArtPiece(params.category, params.slug);
  if (!piece) return { title: 'Not Found' };
  return { title: piece.title || 'Art Piece', description: piece.description };
}

export default async function PiecePage({ params }: Props) {
  const piece = await getArtPiece(params.category, params.slug);
  if (!piece) notFound();

  const portfolio = getPortfolioConfig();
  const section = portfolio.sections.find(s => s.slug === params.category);
  const { prev, next } = await getAdjacentPieces(params.category, params.slug);

  return (
    <div className="px-8 py-16 max-w-5xl mx-auto">
      <Link
        href={`/portfolio/${params.category}`}
        className="inline-flex items-center text-text-secondary hover:text-accent-primary text-sm font-accent tracking-wider uppercase no-underline mb-8"
      >
        <span className="mr-2">&larr;</span> Back to {section?.title || params.category}
      </Link>

      <div className="relative w-full max-h-[75vh] overflow-hidden rounded-card bg-surface mb-8">
        <Image
          src={piece.image}
          alt={piece.title || 'Art piece'}
          width={1200} height={900}
          className="w-full h-auto object-contain"
          priority
        />
      </div>

      <div className="max-w-3xl">
        {piece.title && <h1 className="font-heading text-3xl md:text-4xl mb-4">{piece.title}</h1>}

        {(piece.medium || piece.dimensions || piece.date) && (
          <div className="flex flex-wrap gap-x-6 gap-y-2 text-text-secondary text-sm mb-6 font-accent">
            {piece.medium && <span>{piece.medium}</span>}
            {piece.dimensions && <span>{piece.dimensions}</span>}
            {piece.date && <span>{new Date(piece.date).getFullYear()}</span>}
          </div>
        )}

        {piece.description && (
          <p className="text-text-secondary text-lg mb-6 leading-relaxed">{piece.description}</p>
        )}

        {piece.tags.length > 0 && (
          <div className="flex flex-wrap gap-2 mb-8">
            {piece.tags.map(tag => (
              <span key={tag} className="px-3 py-1 bg-surface text-text-muted text-xs font-accent rounded-full border border-border">
                {tag}
              </span>
            ))}
          </div>
        )}

        {piece.content && (
          <div className="prose-custom mt-8 border-t border-border pt-8"
            dangerouslySetInnerHTML={{ __html: piece.content }} />
        )}

        <div className="flex justify-between items-center mt-12 pt-8 border-t border-border">
          {prev ? (
            <Link href={`/portfolio/${params.category}/${prev.slug}`}
              className="text-text-secondary hover:text-accent-primary no-underline font-accent text-sm tracking-wider uppercase">
              &larr; {prev.title || 'Previous'}
            </Link>
          ) : <div />}
          {next ? (
            <Link href={`/portfolio/${params.category}/${next.slug}`}
              className="text-text-secondary hover:text-accent-primary no-underline font-accent text-sm tracking-wider uppercase">
              {next.title || 'Next'} &rarr;
            </Link>
          ) : <div />}
        </div>
      </div>
    </div>
  );
}
ENDOFFILE

# ============================================================
# SCRAPER SCRIPT
# ============================================================

echo "🕷️  Writing scraper script..."

cat > scripts/scrape-wix.mjs << 'ENDOFFILE'
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
ENDOFFILE

# ============================================================
# README
# ============================================================

echo "📖 Writing README..."

cat > README.md << 'ENDOFFILE'
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
ENDOFFILE

# ============================================================
# PLACEHOLDER IMAGE
# ============================================================

# Create a simple placeholder so the site doesn't break before scraping
echo "🖼️  Creating placeholder image..."
# Create a tiny 1x1 pixel PNG as placeholder
printf '\x89PNG\r\n\x1a\n\x00\x00\x00\rIHDR\x00\x00\x00\x01\x00\x00\x00\x01\x08\x02\x00\x00\x00\x90wS\xde\x00\x00\x00\x0cIDATx\x9cc\xf8\x0f\x00\x00\x01\x01\x00\x05\x18\xd8N\x00\x00\x00\x00IEND\xaeB`\x82' > public/images/site/hero.jpg

# ============================================================
echo ""
echo "✅ All files created!"
echo ""
echo "Next steps:"
echo "  1. npm install"
echo "  2. npx playwright install chromium"
echo "  3. npm run scrape          (downloads art from Wix site)"
echo "  4. npm run dev             (start dev server)"
echo ""
echo "  Later: git add . && git commit -m 'initial portfolio' && git push"
echo "==========================================="
