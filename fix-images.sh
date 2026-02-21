#!/bin/bash
# ============================================================
# Fix image paths for GitHub Pages basePath
# Run from: /Users/dmichels/Documents/GitHub/allymichelson
#
# Usage:
#   chmod +x fix-images.sh
#   ./fix-images.sh
# ============================================================

set -e
echo "🔧 Fixing image paths for GitHub Pages basePath..."

# ---- 1. Update next.config.js ----
echo "📄 Updating next.config.js..."
cat > next.config.js << 'ENDOFFILE'
/** @type {import('next').NextConfig} */
const nextConfig = {
  output: 'export',
  basePath: '/allymichelson',
  images: {
    unoptimized: true,
  },
  trailingSlash: true,
  env: {
    NEXT_PUBLIC_BASE_PATH: '/allymichelson',
  },
};

module.exports = nextConfig;
ENDOFFILE

# ---- 2. Create utils.ts ----
echo "📄 Creating src/lib/utils.ts..."
cat > src/lib/utils.ts << 'ENDOFFILE'
export function imgSrc(path: string): string {
  if (!path) return path;
  if (path.startsWith('http')) return path;
  const base = process.env.NEXT_PUBLIC_BASE_PATH || '';
  return `${base}${path}`;
}
ENDOFFILE

# ---- 3. Update ArtPieceCard.tsx ----
echo "🧩 Updating ArtPieceCard.tsx..."
cat > src/components/ui/ArtPieceCard.tsx << 'ENDOFFILE'
import Link from 'next/link';
import Image from 'next/image';
import type { ArtPiece } from '@/lib/types';
import { imgSrc } from '@/lib/utils';

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
            src={imgSrc(piece.image)}
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

# ---- 4. Update SectionCard.tsx ----
echo "🧩 Updating SectionCard.tsx..."
cat > src/components/ui/SectionCard.tsx << 'ENDOFFILE'
import Link from 'next/link';
import Image from 'next/image';
import type { PortfolioSection } from '@/lib/types';
import { imgSrc } from '@/lib/utils';

interface Props {
  section: PortfolioSection;
}

export default function SectionCard({ section }: Props) {
  return (
    <Link href={`/portfolio/${section.slug}`} className="no-underline group">
      <div className="art-card relative aspect-[4/3] bg-surface overflow-hidden">
        {section.coverImage && (
          <Image
            src={imgSrc(section.coverImage)}
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

# ---- 5. Update Home page ----
echo "📄 Updating src/app/page.tsx..."
cat > src/app/page.tsx << 'ENDOFFILE'
import Image from 'next/image';
import Link from 'next/link';
import { getFeaturedPieces } from '@/lib/content';
import { getSiteConfig, getPortfolioConfig } from '@/lib/config';
import { imgSrc } from '@/lib/utils';
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
            src={imgSrc('/images/site/hero.jpg')}
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
                  <Image src={imgSrc(section.coverImage)} alt={section.title} fill
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

# ---- 6. Update About page ----
echo "📄 Updating src/app/about/page.tsx..."
cat > src/app/about/page.tsx << 'ENDOFFILE'
import Image from 'next/image';
import type { Metadata } from 'next';
import { getAboutContent } from '@/lib/content';
import { imgSrc } from '@/lib/utils';

export const metadata: Metadata = { title: 'About' };

export default async function AboutPage() {
  const about = await getAboutContent();

  return (
    <div className="px-8 py-16 max-w-3xl mx-auto">
      {about.profileImage && (
        <div className="relative w-48 h-48 rounded-full overflow-hidden mb-8 mx-auto border-2 border-border">
          <Image src={imgSrc(about.profileImage)} alt="Profile" fill className="object-cover" priority />
        </div>
      )}
      <div className="prose-custom" dangerouslySetInnerHTML={{ __html: about.content }} />
      {about.cvDownload && (
        <div className="mt-8">
          <a href={imgSrc(about.cvDownload)} className="btn btn-primary no-underline" download>Download CV</a>
        </div>
      )}
    </div>
  );
}
ENDOFFILE

# ---- 7. Update Individual piece page ----
echo "📄 Updating src/app/portfolio/[category]/[slug]/page.tsx..."
cat > 'src/app/portfolio/[category]/[slug]/page.tsx' << 'ENDOFFILE'
import Image from 'next/image';
import Link from 'next/link';
import type { Metadata } from 'next';
import { getPortfolioConfig } from '@/lib/config';
import { imgSrc } from '@/lib/utils';
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
          src={imgSrc(piece.image)}
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

echo ""
echo "✅ All files patched!"
echo ""
echo "Now run:"
echo "  git add -A"
echo "  git commit -m 'fix: add basePath to all image paths'"
echo "  git push"
echo ""
echo "The site will auto-redeploy in ~1 minute."
