'use client';

import React, { createContext, useContext, useState, useEffect } from 'react';
import { Brand, BrandId, DEFAULT_ACTIVE_BRAND_ID, getBrandById } from './config';

interface BrandContextType {
  activeBrand: Brand | null;
  setActiveBrand: (brandId: BrandId) => void;
  isLoading: boolean;
}

const BrandContext = createContext<BrandContextType | undefined>(undefined);

/**
 * BrandProvider - Wraps entire app to manage brand switching
 * Stores active brand in localStorage for persistence
 */
export function BrandProvider({ children }: { children: React.ReactNode }) {
  const [activeBrand, setActiveBrandState] = useState<Brand | null>(null);
  const [isLoading, setIsLoading] = useState(true);

  // Initialize brand from localStorage or default
  useEffect(() => {
    const savedBrandId = localStorage.getItem('chefpoint_active_brand') as BrandId | null;
    const brandId = savedBrandId || DEFAULT_ACTIVE_BRAND_ID;
    const brand = getBrandById(brandId);

    if (brand) {
      setActiveBrandState(brand);
      applyBrandTheme(brand);
    }

    setIsLoading(false);
  }, []);

  const setActiveBrand = (brandId: BrandId) => {
    const brand = getBrandById(brandId);
    if (brand && brand.status === 'active') {
      setActiveBrandState(brand);
      localStorage.setItem('chefpoint_active_brand', brandId);
      applyBrandTheme(brand);
    }
  };

  return (
    <BrandContext.Provider value={{ activeBrand, setActiveBrand, isLoading }}>
      {children}
    </BrandContext.Provider>
  );
}

/**
 * Hook to access brand context
 */
export function useBrand(): BrandContextType {
  const context = useContext(BrandContext);
  if (!context) {
    throw new Error('useBrand must be used within BrandProvider');
  }
  return context;
}

/**
 * Apply brand theme as CSS variables
 * This enables hot-swapping brands without rebuild
 */
function applyBrandTheme(brand: Brand) {
  const root = document.documentElement;

  // Set CSS custom properties for dynamic theming
  root.style.setProperty('--brand-accent', brand.accentColor);
  root.style.setProperty('--brand-secondary', brand.secondaryColor);
  root.style.setProperty('--brand-name', brand.name);
  root.style.setProperty('--brand-emoji', brand.emoji);

  // Update meta theme color
  const metaTheme = document.querySelector('meta[name="theme-color"]');
  if (metaTheme) {
    metaTheme.setAttribute('content', brand.accentColor);
  }

  // Optional: Update page title
  document.title = `${brand.name} | ChefPoint`;
}

/**
 * Hook to get brand colors
 */
export function useBrandColors() {
  const { activeBrand } = useBrand();
  return {
    accent: activeBrand?.accentColor || '#C9A84C',
    secondary: activeBrand?.secondaryColor || '#0E0C08',
    neutral: '#F5EDD8',
    text: '#A89968',
  };
}

/**
 * Hook to check if brand is loading
 */
export function useBrandLoading() {
  const { isLoading } = useBrand();
  return isLoading;
}
