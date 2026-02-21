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
