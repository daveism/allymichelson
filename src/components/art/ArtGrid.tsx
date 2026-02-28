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
    <div className="columns-1 md:columns-2 lg:columns-3 gap-4 [&>*]:mb-4 [&>*]:break-inside-avoid">
      {pieces.map(piece => (
        <ArtPieceCard key={piece.slug} piece={piece} />
      ))}
    </div>
  );
}
