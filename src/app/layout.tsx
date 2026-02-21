import type { Metadata } from 'next';
import './globals.css';
import Navigation from '@/components/layout/Navigation';
import Footer from '@/components/layout/Footer';
import { getSiteConfig, getNavigationConfig, getThemeCSSVars } from '@/lib/config';

const site = getSiteConfig();
const nav = getNavigationConfig();
const cssVars = getThemeCSSVars();

export const metadata: Metadata = {
  title: { default: site.title, template: `%s | ${site.title}` },
  description: site.description,
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <head>
        <style dangerouslySetInnerHTML={{ __html: `:root { ${cssVars} }` }} />
      </head>
      <body className="bg-bg text-text-primary font-body min-h-screen">
        <Navigation items={nav.items} siteTitle={site.title} />
        <div className="lg:ml-64">
          <main className="min-h-screen">{children}</main>
          <Footer config={site} />
        </div>
      </body>
    </html>
  );
}
