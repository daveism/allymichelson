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
          <div className="mt-6 w-24 h-0.5 mx-auto bg-gradient-to-r from-accent-primary via-accent-tertiary to-accent-secondary rounded" />
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
