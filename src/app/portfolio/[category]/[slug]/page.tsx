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
    <article className="px-8 py-16 max-w-4xl mx-auto">
      <Link
        href={`/portfolio/${params.category}`}
        className="inline-flex items-center text-text-secondary hover:text-accent-secondary text-sm font-accent tracking-wider uppercase no-underline mb-8"
      >
        <span className="mr-2">&larr;</span> Back to {section?.title || params.category}
      </Link>

      {/* Title */}
      {piece.title && (
        <h1 className="font-heading text-text-primary text-3xl md:text-4xl mb-4">{piece.title}</h1>
      )}

      {/* Subtitle: medium, dimensions, date as labeled fields */}
      {(piece.medium || piece.dimensions || piece.date) && (
        <div className="flex flex-col sm:flex-row sm:flex-wrap gap-x-8 gap-y-2 text-sm font-accent mb-8">
          {piece.medium && (
            <span><strong className="text-text-primary">Medium:</strong>{' '}<span className="text-text-secondary">{piece.medium}</span></span>
          )}
          {piece.dimensions && (
            <span><strong className="text-text-primary">Dimensions:</strong>{' '}<span className="text-text-secondary">{piece.dimensions}</span></span>
          )}
          {piece.date && (
            <span><strong className="text-text-primary">Date:</strong>{' '}<span className="text-text-secondary">{new Date(piece.date).toLocaleDateString('en-US', { year: 'numeric', month: 'long', day: 'numeric' })}</span></span>
          )}
        </div>
      )}

      {/* Main image */}
      <div className="relative w-full rounded-card overflow-hidden mb-8">
        <Image
          src={imgSrc(piece.image)}
          alt={piece.title || 'Art piece'}
          width={1200} height={900}
          className="w-full h-auto"
          priority
        />
      </div>

      {/* Description */}
      {piece.description && (
        <p className="text-text-secondary text-lg leading-relaxed mb-8">{piece.description}</p>
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

      {/* Blog-style markdown content (can include more images, headings, text) */}
      {piece.content && (
        <div className="prose-custom mt-8 border-t border-border pt-8"
          dangerouslySetInnerHTML={{ __html: piece.content }} />
      )}

      <div className="flex justify-between items-center mt-12 pt-8 border-t border-border">
        {prev ? (
          <Link href={`/portfolio/${params.category}/${prev.slug}`}
            className="text-text-secondary hover:text-accent-secondary no-underline font-accent text-sm tracking-wider uppercase">
            &larr; {prev.title || 'Previous'}
          </Link>
        ) : <div />}
        {next ? (
          <Link href={`/portfolio/${params.category}/${next.slug}`}
            className="text-text-secondary hover:text-accent-secondary no-underline font-accent text-sm tracking-wider uppercase">
            {next.title || 'Next'} &rarr;
          </Link>
        ) : <div />}
      </div>
    </article>
  );
}
