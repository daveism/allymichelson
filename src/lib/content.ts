import fs from 'fs';
import path from 'path';
import matter from 'gray-matter';
import { remark } from 'remark';
import html from 'remark-html';
import type { ArtPiece, AboutConfig, ContactConfig } from './types';
import { getPortfolioConfig } from './config';

const contentDir = path.join(process.cwd(), 'content');

async function renderMarkdown(md: string): Promise<string> {
  const result = await remark().use(html, { sanitize: false }).process(md);
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
