/**
 * ChefPoint Modular Brand Architecture
 * Central configuration for all brands
 * Add new brands here without rebuilding the app
 */

export type BrandStatus = 'active' | 'coming_soon' | 'maintenance';
export type BrandId = 'chicken-bowl' | 'pasa-wrap' | 'crema-medina' | 'smash-rabat' | 'sweet-rabat';

export interface Brand {
  id: BrandId;
  name: string;
  slug: string;
  tagline: string;
  emoji: string;
  accentColor: string;
  secondaryColor: string;
  status: BrandStatus;
  launchDate?: Date;
  deliveryTime: string;
  minOrder: number;
  operatingHours: {
    open: string;
    close: string;
  };
}

/**
 * Master brand registry
 * Each brand must be defined here first before adding to database
 */
export const BRANDS_REGISTRY: Record<BrandId, Brand> = {
  'chicken-bowl': {
    id: 'chicken-bowl',
    name: 'Chicken Bowl',
    slug: 'chicken-bowl',
    tagline: 'Frais. Savoureux. Fait pour vous.',
    emoji: '🥗',
    accentColor: '#C9A84C',
    secondaryColor: '#0E0C08',
    status: 'active',
    deliveryTime: '25–35 min',
    minOrder: 65,
    operatingHours: { open: '10:00', close: '22:00' },
  },
  'pasa-wrap': {
    id: 'pasa-wrap',
    name: 'Paşa Wrap',
    slug: 'pasa-wrap',
    tagline: 'Wraps Turcs Authentiques',
    emoji: '🌯',
    accentColor: '#E8935A',
    secondaryColor: '#0E0C08',
    status: 'coming_soon',
    deliveryTime: '20–30 min',
    minOrder: 55,
    operatingHours: { open: '11:00', close: '23:00' },
  },
  'crema-medina': {
    id: 'crema-medina',
    name: 'Crema Medina',
    slug: 'crema-medina',
    tagline: 'Glaces Artisanales',
    emoji: '🍦',
    accentColor: '#E84A5F',
    secondaryColor: '#0E0C08',
    status: 'coming_soon',
    deliveryTime: 'À emporter',
    minOrder: 30,
    operatingHours: { open: '14:00', close: '21:00' },
  },
  'smash-rabat': {
    id: 'smash-rabat',
    name: 'Smash Rabat',
    slug: 'smash-rabat',
    tagline: 'Smash Burgers Gourmands',
    emoji: '🍔',
    accentColor: '#4ECDC4',
    secondaryColor: '#0E0C08',
    status: 'coming_soon',
    deliveryTime: '25–35 min',
    minOrder: 70,
    operatingHours: { open: '12:00', close: '23:00' },
  },
  'sweet-rabat': {
    id: 'sweet-rabat',
    name: 'Sweet Rabat',
    slug: 'sweet-rabat',
    tagline: 'Pâtisserie & Viennoiserie',
    emoji: '🍮',
    accentColor: '#B57BEA',
    secondaryColor: '#0E0C08',
    status: 'coming_soon',
    deliveryTime: 'À emporter',
    minOrder: 40,
    operatingHours: { open: '07:00', close: '20:00' },
  },
};

/**
 * Get active brands only
 */
export function getActiveBrands(): Brand[] {
  return Object.values(BRANDS_REGISTRY).filter((b) => b.status === 'active');
}

/**
 * Get all brands (active + coming_soon)
 */
export function getAllBrands(): Brand[] {
  return Object.values(BRANDS_REGISTRY);
}

/**
 * Get brand by ID
 */
export function getBrandById(id: BrandId): Brand | undefined {
  return BRANDS_REGISTRY[id];
}

/**
 * Get brand by slug
 */
export function getBrandBySlug(slug: string): Brand | undefined {
  return Object.values(BRANDS_REGISTRY).find((b) => b.slug === slug);
}

/**
 * Get coming soon brands
 */
export function getComingSoonBrands(): Brand[] {
  return Object.values(BRANDS_REGISTRY).filter((b) => b.status === 'coming_soon');
}

/**
 * Check if brand is open (based on operating hours)
 */
export function isBrandOpen(brand: Brand): boolean {
  const now = new Date();
  const hours = now.getHours().toString().padStart(2, '0');
  const minutes = now.getMinutes().toString().padStart(2, '0');
  const currentTime = `${hours}:${minutes}`;

  return currentTime >= brand.operatingHours.open && currentTime <= brand.operatingHours.close;
}

/**
 * Default active brand (loaded on app startup)
 */
export const DEFAULT_ACTIVE_BRAND_ID: BrandId = 'chicken-bowl';
