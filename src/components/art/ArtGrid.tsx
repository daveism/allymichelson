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
    <div className="columns-1 md:columns-2 lg:columns-3 gap-4">
      {pieces.map(piece => (
        <div key={piece.slug} className="break-inside-avoid mb-2">
          <ArtPieceCard piece={piece} />
        </div>
      ))}
    </div>
  );
}
