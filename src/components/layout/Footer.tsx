import type { SiteConfig } from '@/lib/types';

interface Props {
  config: SiteConfig;
}

export default function Footer({ config }: Props) {
  return (
    <footer className="border-t border-border mt-16 py-12 px-8">
      <div className="max-w-layout mx-auto flex flex-col sm:flex-row justify-between gap-8">
        <div>
          <p className="text-text-secondary text-sm">Email</p>
          <a
            href={`mailto:${config.email}`}
            className="text-text-primary text-sm hover:text-accent-primary no-underline"
          >
            {config.email}
          </a>
        </div>
        <div>
          <p className="text-text-secondary text-sm">Follow</p>
          <div className="flex gap-4 mt-1">
            {Object.entries(config.social).map(([name, url]) => (
              <a
                key={name}
                href={url}
                target="_blank"
                rel="noopener noreferrer"
                className="text-text-primary text-sm capitalize hover:text-accent-primary no-underline"
              >
                {name}
              </a>
            ))}
          </div>
        </div>
        <div className="text-text-muted text-xs self-end">
          &copy; {new Date().getFullYear()} {config.author}
        </div>
      </div>
    </footer>
  );
}
