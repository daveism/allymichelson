export interface SiteConfig {
  title: string;
  description: string;
  author: string;
  email: string;
  url: string;
  social: Record<string, string>;
}

export interface NavItem {
  label: string;
  path: string;
  isPortfolioCategory?: boolean;
}

export interface NavigationConfig {
  items: NavItem[];
}

export interface PortfolioSection {
  slug: string;
  title: string;
  description?: string;
  coverImage?: string;
  contentDir: string;
  order: number;
}

export interface PortfolioConfig {
  sections: PortfolioSection[];
}

export interface ArtPiece {
  slug: string;
  title: string;
  description: string;
  image: string;
  category: string;
  tags: string[];
  date: string;
  medium: string;
  dimensions: string;
  featured: boolean;
  order: number;
  content: string;
}

export interface ThemeConfig {
  palette: Record<string, string>;
  typography: Record<string, string>;
  buttons: Record<string, any>;
  cards: Record<string, string>;
  layout: Record<string, string>;
}

export interface AboutConfig {
  title: string;
  profileImage?: string;
  cvDownload?: string;
  content: string;
}

export interface ContactConfig {
  title: string;
  formspreeId: string;
  content: string;
}
