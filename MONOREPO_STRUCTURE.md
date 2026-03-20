# ChefPoint Monorepo Architecture

## Project Structure

```
chefpoint/
├── apps/
│   ├── kitchen-dashboard/          # Kitchen dashboard web app (Next.js)
│   │   ├── app/
│   │   │   ├── dashboard/          # Main dashboard screens
│   │   │   ├── layout.tsx
│   │   │   └── page.tsx
│   │   ├── components/             # Dashboard-specific components
│   │   ├── public/
│   │   └── package.json
│   │
│   └── mobile/                     # Customer mobile app (React Native + Expo)
│       ├── app/                    # Expo Router (file-based routing)
│       │   ├── (auth)/             # Auth stack
│       │   │   ├── splash.tsx
│       │   │   ├── phone-auth.tsx
│       │   │   └── otp-verify.tsx
│       │   │
│       │   ├── (app)/              # Main app stack (protected)
│       │   │   ├── home/
│       │   │   ├── menu/
│       │   │   ├── orders/
│       │   │   └── profile/
│       │   │
│       │   └── _layout.tsx         # Root navigator
│       │
│       ├── components/             # Mobile-specific components
│       ├── hooks/                  # Mobile-specific hooks
│       ├── app.json                # Expo config
│       └── package.json
│
├── lib/                            # Shared code (used by both apps)
│   ├── brands/
│   │   ├── config.ts               # Brand registry (Chicken Bowl + future brands)
│   │   ├── context.tsx             # BrandProvider for dynamic theming
│   │   └── hooks.ts                # useBrand() and related hooks
│   │
│   ├── supabase/
│   │   ├── client.ts               # Supabase client init
│   │   ├── server.ts               # Server-side Supabase client
│   │   └── types.ts                # Database types (auto-generated)
│   │
│   ├── api/
│   │   ├── orders.ts               # Order API helpers
│   │   ├── products.ts             # Product API helpers
│   │   ├── auth.ts                 # Auth helpers
│   │   └── realtime.ts             # Supabase Realtime subscriptions
│   │
│   ├── hooks/
│   │   ├── useOrders.ts            # Fetch orders (React Query)
│   │   ├── useProducts.ts          # Fetch products (React Query)
│   │   ├── useAuth.ts              # Auth state
│   │   └── useRealtime.ts          # Realtime subscriptions
│   │
│   ├── utils/
│   │   ├── formatting.ts           # Price, date formatting
│   │   ├── validation.ts           # Phone, email validation
│   │   └── constants.ts            # App-wide constants
│   │
│   ├── stores/                     # Zustand stores (state management)
│   │   ├── cart.ts                 # Cart state
│   │   └── auth.ts                 # Auth state
│   │
│   └── types/
│       ├── orders.ts               # Order types
│       ├── products.ts             # Product types
│       └── brands.ts               # Brand types
│
├── components/                     # Shared components library
│   ├── ui/
│   │   ├── Button.tsx
│   │   ├── Card.tsx
│   │   ├── Badge.tsx
│   │   ├── Typography.tsx
│   │   └── [other shared UI components]
│   │
│   ├── brand/
│   │   ├── BrandHeader.tsx         # Brand-aware header
│   │   ├── BrandFooter.tsx         # Brand-aware footer
│   │   └── BrandSwitcher.tsx       # Admin brand selector
│   │
│   └── order/
│       ├── OrderCard.tsx
│       ├── OrderStatusTimeline.tsx
│       └── OrderTracking.tsx
│
├── public/
│   ├── brands/
│   │   ├── chicken-bowl/
│   │   │   ├── logo.svg
│   │   │   ├── hero-banner.jpg
│   │   │   └── accent-color.css
│   │   │
│   │   ├── pasa-wrap/             # Future brand (ready to activate)
│   │   ├── crema-medina/
│   │   ├── smash-rabat/
│   │   └── sweet-rabat/
│   │
│   ├── icons/
│   ├── fonts/
│   └── locales/                    # i18n translations
│       ├── fr/
│       │   ├── common.json
│       │   ├── orders.json
│       │   └── menu.json
│       │
│       └── ar/                     # Arabic (RTL)
│           ├── common.json
│           ├── orders.json
│           └── menu.json
│
├── scripts/
│   ├── 01-schema.sql               # Initial database schema
│   ├── 02-seed.sql                 # Seed data (Chicken Bowl products)
│   └── migrations/                 # Future database migrations
│       ├── 03-add-payment-table.sql
│       └── [future migrations]
│
├── middleware.ts                   # Next.js middleware (auth checks)
├── next.config.js                  # Next.js config
├── tailwind.config.ts              # Tailwind + design tokens
├── tsconfig.json
├── package.json                    # Root package (monorepo dependencies)
│
└── MONOREPO_STRUCTURE.md           # This file


## Key Architectural Decisions

### 1. Modular Brand System (Day 1)

Every component is **brand-aware** from day one:

```typescript
// In any component:
import { useBrand } from '@/lib/brands/context';

export function BrandHeader() {
  const { activeBrand } = useBrand();
  return (
    <header style={{ backgroundColor: activeBrand.accentColor }}>
      {activeBrand.name}
    </header>
  );
}
```

When a new brand (e.g., Paşa Wrap) is ready:
1. Add brand config to `lib/brands/config.ts`
2. Add brand assets to `public/brands/pasa-wrap/`
3. Add brand products to Supabase `products` table
4. Switch active brand in admin dashboard
5. **No rebuild needed** — theme changes via CSS variables

### 2. Shared vs. App-Specific Code

- **Shared (`lib/`, `components/`, `public/`):** Used by both dashboard + mobile
- **App-specific (`apps/kitchen-dashboard/`, `apps/mobile/`):** Only for that app
- **Principle:** Never duplicate code. Share everything possible.

### 3. Database-First Design

- `brands` table is source of truth
- Brand switching pulls from database (not just config)
- Kitchen staff + Admins can activate/deactivate brands in real-time
- Mobile app fetches active brand on startup

### 4. Supabase Real-time Integration

- **Dashboard** subscribes to `orders` INSERT → new order arrives
- **Mobile** subscribes to their order status → real-time updates
- Both use same subscription logic from `lib/api/realtime.ts`

### 5. Localization (i18n) Ready

- All UI strings in `public/locales/{lang}/`
- Mobile app supports: French (default) + Arabic (RTL)
- Kitchen dashboard: French only (for now)
- Switch language in mobile settings → app reloads with new language

### 6. State Management

- **React Query** for server state (orders, products, users)
- **Zustand** for client state (cart, auth session)
- **React Context** for brand selection (global)
- **Supabase Auth** for authentication state

### 7. TypeScript Everywhere

- Auto-generate database types from Supabase schema
- Strict types for orders, products, users, etc.
- Brand types exported from `lib/brands/config.ts`

---

## Development Workflow

### Adding a New Feature

1. **Define types** → `lib/types/`
2. **Create API helper** → `lib/api/`
3. **Build shared component** → `components/`
4. **Use in dashboard** → `apps/kitchen-dashboard/`
5. **Use in mobile** → `apps/mobile/`

### Adding a New Brand

1. Add brand config → `lib/brands/config.ts`
2. Add brand assets → `public/brands/{brand-slug}/`
3. Insert products to Supabase `products` table (with brand_id)
4. Toggle `status` to `'active'` in Supabase
5. Admin clicks "Activate {Brand}" in dashboard
6. All users instantly see new brand (no rebuild)

### Deploying Updates

- **Kitchen Dashboard:** Deploy to Vercel (Next.js)
- **Mobile App:** Build + ship to App Store / Play Store
- **Shared Code:** Update in `lib/`, both apps auto-refresh

---

## Tech Stack Reference

| Layer | Technology |
|-------|-----------|
| **Database** | Supabase PostgreSQL |
| **Auth** | Supabase Phone OTP |
| **Real-time** | Supabase Subscriptions |
| **Kitchen Dashboard** | Next.js 16, React 19 |
| **Mobile App** | React Native, Expo |
| **State** | React Query, Zustand, Supabase Auth |
| **Styling** | Tailwind CSS + CSS Variables |
| **i18n** | next-i18next (dashboard), i18next (mobile) |
| **Payment** | CMI Gateway (Edge Function) |
| **Push Notifications** | Expo Notifications |
| **Maps** | Google Maps API / Mapbox |

---

## File Size Budget

- **Shared Code** (`lib/`, `components/`): ~150 KB (used by both apps)
- **Kitchen Dashboard** (`apps/kitchen-dashboard/`): ~500 KB
- **Mobile App** (`apps/mobile/`): ~15-20 MB (after native build)

---

## Next Steps

1. ✅ Execute `01-schema.sql` in Supabase
2. ✅ Execute `02-seed.sql` to add Chicken Bowl products
3. 🔄 Build Kitchen Dashboard (Milestone 3)
4. 🔄 Build Mobile App Screens (Milestones 4-8)
5. 🔄 Real-time Testing (Milestone 9)
6. 🔄 Payment Integration (Milestone 10)
7. 🔄 Brand Module Ready (Milestone 11)

---

**Last Updated:** 2024-12-23  
**Status:** Milestone 1 - Database Infrastructure
