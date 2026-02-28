import fs from 'fs';
import path from 'path';
import yaml from 'js-yaml';
import type {
  SiteConfig, NavigationConfig, PortfolioConfig, ThemeConfig
} from './types';

const configDir = path.join(process.cwd(), 'config');

function loadYaml<T>(filename: string): T {
  const filePath = path.join(configDir, filename);
  const raw = fs.readFileSync(filePath, 'utf8');
  return yaml.load(raw) as T;
}

let _site: SiteConfig | null = null;
let _nav: NavigationConfig | null = null;
let _portfolio: PortfolioConfig | null = null;
let _theme: ThemeConfig | null = null;

export function getSiteConfig(): SiteConfig {
  if (!_site) _site = loadYaml<SiteConfig>('site.yaml');
  return _site;
}

export function getNavigationConfig(): NavigationConfig {
  if (!_nav) _nav = loadYaml<NavigationConfig>('navigation.yaml');
  return _nav;
}

export function getPortfolioConfig(): PortfolioConfig {
  if (!_portfolio) _portfolio = loadYaml<PortfolioConfig>('portfolio.yaml');
  _portfolio.sections.sort((a, b) => a.order - b.order);
  return _portfolio;
}

export function getThemeConfig(): ThemeConfig {
  if (!_theme) _theme = loadYaml<ThemeConfig>('theme.yaml');
  return _theme;
}

export function getThemeCSSVars(): string {
  const t = getThemeConfig();
  const p = t.palette;
  const ty = t.typography;
  const c = t.cards;
  const b = t.buttons;

  return `
    --color-bg: ${p.background};
    --color-bg-alt: ${p.backgroundAlt};
    --color-surface: ${p.surface};
    --color-text-primary: ${p.textPrimary};
    --color-text-secondary: ${p.textSecondary};
    --color-text-muted: ${p.textMuted};
    --color-accent-primary: ${p.accentPrimary};
    --color-accent-secondary: ${p.accentSecondary};
    --color-accent-tertiary: ${p.accentTertiary};
    --color-hover: ${p.hover};
    --color-active: ${p.active};
    --color-focus: ${p.focus};
    --color-border: ${p.border};
    --color-border-hover: ${p.borderHover};
    --color-error: ${p.error};
    --color-success: ${p.success};
    --font-heading: ${ty.headingFont};
    --font-body: ${ty.bodyFont};
    --font-accent: ${ty.accentFont};
    --font-heading-weight: ${ty.headingWeight};
    --font-body-weight: ${ty.bodyWeight};
    --font-base-size: ${ty.baseSize};
    --font-h1-size: ${ty.h1Size};
    --font-h2-size: ${ty.h2Size};
    --font-subtitle-size: ${ty.subtitleSize};
    --card-radius: ${c.borderRadius};
    --card-hover-scale: ${c.hoverScale};
    --card-hover-shadow: ${c.hoverShadow};
    --card-transition: ${c.transition};
    --btn-radius: ${b.borderRadius};
    --btn-px: ${b.paddingX};
    --btn-py: ${b.paddingY};
    --btn-transform: ${b.textTransform};
    --btn-spacing: ${b.letterSpacing};
    --layout-max-width: ${t.layout.maxWidth};
    --layout-gap: ${t.layout.gridGap};
    --layout-padding: ${t.layout.sectionPadding};
  `.trim();
}
