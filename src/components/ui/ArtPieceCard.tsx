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
      className="no-underline group relative z-0 hover:z-10"
    >
      <div className="art-card relative bg-surface overflow-hidden">
        <div className="relative">
          <Image
            src={imgSrc(piece.image)}
            alt={piece.title || 'Art piece'}
            width={800} height={800}
            className="w-full h-auto transition-transform duration-500 group-hover:scale-110"
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
