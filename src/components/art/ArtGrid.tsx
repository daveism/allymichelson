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
