import Image from 'next/image';
import Link from 'next/link';
import { getSiteConfig } from '@/lib/config';
import { imgSrc } from '@/lib/utils';

export default function HomePage() {
  const site = getSiteConfig();

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

      {/*
        FEATURED WORK
        ─────────────
        Each featured piece is hardcoded below as a card linking to its detail page.

        To change which piece appears:
        - Update the href, image src, alt, title, and description for that card

        To add a new featured piece:
        - Copy one of the <Link>...</Link> blocks below and update:
            href     → /portfolio/{category}/{slug}
            src      → the image path from the piece's .md frontmatter
            alt/h4   → piece title
            p        → piece description (optional, remove the <p> if none)

        To remove a featured piece:
        - Delete the entire <Link>...</Link> block for that piece

        Example of a new featured card:
          <Link href="/portfolio/tattoos/tattoo-piece-01" className="no-underline group relative z-0 hover:z-10">
            <div className="art-card relative bg-surface overflow-hidden">
              <div className="relative">
                <Image src={imgSrc('/images/tattoos/tattoo-01.jpg')} alt="Tattoo Title"
                  width={800} height={800}
                  className="w-full h-auto transition-transform duration-500 group-hover:scale-110"
                  sizes="(max-width: 768px) 100vw, (max-width: 1024px) 50vw, 33vw" loading="lazy" />
              </div>
              <div className="absolute inset-0 bg-black/0 group-hover:bg-black/50 transition-all duration-300 flex items-end">
                <div className="p-4 translate-y-4 opacity-0 group-hover:translate-y-0 group-hover:opacity-100 transition-all duration-300">
                  <h4 className="font-heading text-lg text-white mb-1">Tattoo Title</h4>
                  <p className="text-xs text-white/70 line-clamp-2">Optional description</p>
                </div>
              </div>
            </div>
          </Link>
      */}
      <section className="px-8 py-16 max-w-layout mx-auto">
        <h2 className="font-heading text-3xl mb-2 organic-line">Featured Work</h2>
        <p className="text-text-secondary mb-10 mt-6">Selected pieces across all disciplines</p>
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">

          {/* Featured piece 1: 2D */}
          <Link href="/portfolio/2d/2d-piece-01" className="no-underline group relative z-0 hover:z-10">
            <div className="art-card relative bg-surface overflow-hidden">
              <div className="relative">
                {/* ✏️ UPDATE IMAGE: change path below to swap featured image */}
                <Image src={imgSrc('/images/2d/2d-01.jpg')} alt="Title"
                  width={800} height={800}
                  className="w-full h-auto transition-transform duration-500 group-hover:scale-110"
                  sizes="(max-width: 768px) 100vw, (max-width: 1024px) 50vw, 33vw" loading="lazy" />
              </div>
              <div className="absolute inset-0 bg-black/0 group-hover:bg-black/50 transition-all duration-300 flex items-end">
                <div className="p-4 translate-y-4 opacity-0 group-hover:translate-y-0 group-hover:opacity-100 transition-all duration-300">
                  <h4 className="font-heading text-lg text-white mb-1">Title</h4>
                  <p className="text-xs text-white/70 line-clamp-2">Short Description</p>
                </div>
              </div>
            </div>
          </Link>

          {/* Featured piece 2: 3D */}
          <Link href="/portfolio/3d/3d-piece-01" className="no-underline group relative z-0 hover:z-10">
            <div className="art-card relative bg-surface overflow-hidden">
              <div className="relative">
                {/* ✏️ UPDATE IMAGE: change path below to swap featured image */}
                <Image src={imgSrc('/images/3d/3d-01.jpg')} alt="3D piece"
                  width={800} height={800}
                  className="w-full h-auto transition-transform duration-500 group-hover:scale-110"
                  sizes="(max-width: 768px) 100vw, (max-width: 1024px) 50vw, 33vw" loading="lazy" />
              </div>
            </div>
          </Link>

          {/* Featured piece 3: Digital */}
          <Link href="/portfolio/digital/digital-piece-01" className="no-underline group relative z-0 hover:z-10">
            <div className="art-card relative bg-surface overflow-hidden">
              <div className="relative">
                {/* ✏️ UPDATE IMAGE: change path below to swap featured image */}
                <Image src={imgSrc('/images/digital/digital-01.png')} alt="Digital piece"
                  width={800} height={800}
                  className="w-full h-auto transition-transform duration-500 group-hover:scale-110"
                  sizes="(max-width: 768px) 100vw, (max-width: 1024px) 50vw, 33vw" loading="lazy" />
              </div>
            </div>
          </Link>

        </div>
      </section>

      {/*
        EXPLORE SECTIONS
        ────────────────
        Each section card is hardcoded below, linking to its portfolio category page.

        To change a section's cover image:
        - Update the Image src for that section's block below

        To add a new section:
        1. Copy one of the <Link>...</Link> blocks below and update:
             href  → /portfolio/{new-slug}
             src   → cover image path (put image in public/images/{new-slug}/)
             title → the section display name
        2. Add the section in config/portfolio.yaml so its listing page works:
             - slug: "mixed-media"
               title: "Mixed Media"
               description: "Collage, assemblage, and experimental work"
               coverImage: "/images/mixed-media/cover.jpg"
               contentDir: "content/portfolio/mixed-media"
               order: 5
        3. Create the content directory: content/portfolio/mixed-media/
        4. Create the image directory: public/images/mixed-media/
        5. Add piece .md files to the content directory

        To remove a section:
        - Delete the entire <Link>...</Link> block for that section

        Example of a new section card:
          <Link href="/portfolio/mixed-media" className="no-underline group">
            <div className="relative aspect-square bg-surface rounded-card overflow-hidden art-card">
              <Image src={imgSrc('/images/mixed-media/cover.jpg')} alt="Mixed Media" fill
                className="object-cover transition-transform duration-500 group-hover:scale-105"
                sizes="(max-width: 768px) 50vw, 25vw" />
              <div className="absolute inset-0 bg-black/30 group-hover:bg-black/50 transition-colors" />
              <div className="absolute inset-0 flex items-center justify-center">
                <span className="font-heading text-2xl text-white">Mixed Media</span>
              </div>
            </div>
          </Link>
      */}
      <section className="px-8 py-16 max-w-layout mx-auto">
        <h2 className="font-heading text-3xl mb-10 organic-line">Explore</h2>
        <div className="grid grid-cols-2 md:grid-cols-4 gap-4 mt-6">

          {/* Section: 2D */}
          <Link href="/portfolio/2d" className="no-underline group">
            <div className="relative aspect-square bg-surface rounded-card overflow-hidden art-card">
              {/* ✏️ UPDATE IMAGE: change path below to swap cover image */}
              <Image src={imgSrc('/images/2d/2d-01.jpg')} alt="2D" fill
                className="object-cover transition-transform duration-500 group-hover:scale-105"
                sizes="(max-width: 768px) 50vw, 25vw" />
              <div className="absolute inset-0 bg-black/30 group-hover:bg-black/50 transition-colors" />
              <div className="absolute inset-0 flex items-center justify-center">
                <span className="font-heading text-2xl text-white">2D</span>
              </div>
            </div>
          </Link>

          {/* Section: 3D */}
          <Link href="/portfolio/3d" className="no-underline group">
            <div className="relative aspect-square bg-surface rounded-card overflow-hidden art-card">
              {/* ✏️ UPDATE IMAGE: change path below to swap cover image */}
              <Image src={imgSrc('/images/3d/3d-01.jpg')} alt="3D" fill
                className="object-cover transition-transform duration-500 group-hover:scale-105"
                sizes="(max-width: 768px) 50vw, 25vw" />
              <div className="absolute inset-0 bg-black/30 group-hover:bg-black/50 transition-colors" />
              <div className="absolute inset-0 flex items-center justify-center">
                <span className="font-heading text-2xl text-white">3D</span>
              </div>
            </div>
          </Link>

          {/* Section: Digital */}
          <Link href="/portfolio/digital" className="no-underline group">
            <div className="relative aspect-square bg-surface rounded-card overflow-hidden art-card">
              {/* ✏️ UPDATE IMAGE: change path below to swap cover image */}
              <Image src={imgSrc('/images/digital/digital-01.png')} alt="Digital" fill
                className="object-cover transition-transform duration-500 group-hover:scale-105"
                sizes="(max-width: 768px) 50vw, 25vw" />
              <div className="absolute inset-0 bg-black/30 group-hover:bg-black/50 transition-colors" />
              <div className="absolute inset-0 flex items-center justify-center">
                <span className="font-heading text-2xl text-white">Digital</span>
              </div>
            </div>
          </Link>

          {/* Section: Tattoos */}
          <Link href="/portfolio/tattoos" className="no-underline group">
            <div className="relative aspect-square bg-surface rounded-card overflow-hidden art-card">
              <div className="absolute inset-0 bg-black/30 group-hover:bg-black/50 transition-colors" />
              <div className="absolute inset-0 flex items-center justify-center">
                <span className="font-heading text-2xl text-white">Tattoos</span>
              </div>
            </div>
          </Link>

        </div>
      </section>
    </div>
  );
}
