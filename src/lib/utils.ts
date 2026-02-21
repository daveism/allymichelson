export function imgSrc(path: string): string {
  if (!path) return path;
  if (path.startsWith('http')) return path;
  const base = process.env.NEXT_PUBLIC_BASE_PATH || '';
  return `${base}${path}`;
}
