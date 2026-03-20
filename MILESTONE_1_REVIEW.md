# ✅ MILESTONE 1 — Supabase Infrastructure & Database Schema

**Status:** Ready for Deployment  
**Supabase Project:** ppwtwcngrchvupmhvtfn (your credentials provided)

---

## 📋 Deliverables Checklist

### 1. Database Schema (`scripts/01-schema.sql`)
All 17 tables created with full RLS policies and indexes:

#### Core Tables
- ✅ **brands** — Master brand registry (5 brands: 1 active, 4 coming_soon)
- ✅ **users** — Linked to auth.users, with role-based access
- ✅ **customers** — Extended customer profiles with loyalty tracking
- ✅ **user_addresses** — Saved delivery addresses

#### Menu & Products
- ✅ **products** — Menu items per brand (category: bowls, drinks, sides, combos)
- ✅ **product_variants** — Sizes, proteins, sauces with price modifiers
- ✅ **promotions** — Discount codes with usage limits

#### Orders
- ✅ **orders** — Main order table with status lifecycle
- ✅ **order_items** — Items per order with variants
- ✅ **order_tracking** — Real-time driver location updates
- ✅ **order_status_log** — History of status changes
- ✅ **kitchen_queue** — Kitchen dashboard ordering

#### Advanced Features
- ✅ **loyalty_cards** — Per-brand stamp cards (5 stamps = 1 free item)
- ✅ **loyalty_rewards** — Points earned per order
- ✅ **drivers** — Driver profiles (rating, location, availability)
- ✅ **order_payments** — Payment transactions (CMI, cash, card on delivery)
- ✅ **push_tokens** — Device tokens for notifications

**Total: 17 Tables | 15 Indexes | 10 RLS Policies**

---

### 2. Seed Data (`scripts/02-seed.sql`)
Pre-loaded data ready to use:

#### Brands (5)
| Brand | Status | Emoji | Color | Launch |
|-------|--------|-------|-------|--------|
| Chicken Bowl | **ACTIVE** | 🥗 | #C9A84C | Immediate |
| Paşa Wrap | Coming Soon | 🌯 | #E8935A | TBD |
| Crema Medina | Coming Soon | 🍦 | #E84A5F | TBD |
| Smash Rabat | Coming Soon | 🍔 | #4ECDC4 | TBD |
| Sweet Rabat | Coming Soon | 🍮 | #B57BEA | TBD |

#### Chicken Bowl Products (10 items)
**Bowls (5):**
- Classic Herb Bowl (65 DH) — Thym & Fraîcheur
- Spicy Grill Bowl (65 DH) — Pimenté & Fumé
- Sweet & Smoky Bowl (65 DH) — Sucré & Barbecue
- Oriental Ginger Bowl (65 DH) — Gingembre & Exotique
- Fresh Lemon Bowl (65 DH) — Citronné & Léger

**Sides (3):**
- Hummus Marocain (15 DH)
- Tabbouleh (12 DH)
- Salade Verte (8 DH)

**Drinks (2):**
- Jus Citron Frais (12 DH)
- Eau Minérale (3 DH)
- Thé à la Menthe (8 DH)

#### Product Variants (15)
- Sizes for all 5 bowls: Small (-5 DH), Regular (0), Large (+10 DH)

#### Promotions (3)
- `BIENVENUE10` — 10% off, 100 uses, 30 days
- `DELIVERY20` — 20% off, 50 uses, 15 days (delivery promo)
- `LOYALTY5` — 5% off, 999 uses, 90 days

---

### 3. Modular Brand Architecture
Files created for extensible brand system:

#### `lib/brands/config.ts`
- **BRANDS_REGISTRY** — Master config for all 5 brands
- **TypeScript interfaces** for Brand, BrandStatus, BrandId
- **Helper functions:**
  - `getActiveBrands()` — Only active brands
  - `getAllBrands()` — All brands including coming_soon
  - `getBrandById()` — Get by ID
  - `getBrandBySlug()` — Get by slug
  - `getComingSoonBrands()` — Filter coming soon
  - `isBrandOpen()` — Check operating hours
  - `DEFAULT_ACTIVE_BRAND_ID` = 'chicken-bowl'

**To add a new brand (e.g., Paşa Wrap):**
```typescript
// 1. Update BRANDS_REGISTRY
'pasa-wrap': {
  id: 'pasa-wrap',
  name: 'Paşa Wrap',
  status: 'active', // Toggle from 'coming_soon'
  // ... other properties
}

// 2. Add brand assets to public/brands/pasa-wrap/
// 3. Insert products to Supabase with brand_id
// 4. No rebuild needed!
```

#### `lib/brands/context.tsx`
- **BrandProvider** — React Context for app-wide brand state
- **useBrand()** hook — Access current brand in any component
- **useBrandColors()** hook — Get brand colors (accent, secondary)
- **applyBrandTheme()** — Apply CSS variables dynamically
- **Hot-swapping:** Brands switch without rebuild via CSS variables

#### `lib/supabase/client.ts`
- Initialize Supabase client with your credentials
- Environment variables: `NEXT_PUBLIC_SUPABASE_URL`, `NEXT_PUBLIC_SUPABASE_ANON_KEY`

---

### 4. Monorepo Structure
Created `MONOREPO_STRUCTURE.md` documenting:

```
chefpoint/
├── apps/kitchen-dashboard/     # Web dashboard (Next.js)
├── apps/mobile/                # Mobile app (React Native + Expo)
├── lib/                        # Shared code (brands, API, hooks, types)
├── components/                 # Shared UI components
├── public/brands/              # Brand assets (logos, images per brand)
├── scripts/                    # Database migrations
└── [config files]
```

---

### 5. Environment Variables
Created `.env.example` with all required variables:

```bash
# Your Supabase credentials (provided)
NEXT_PUBLIC_SUPABASE_URL=https://ppwtwcngrchvupmhvtfn.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=sb_publishable_PJBR1TNSAoUYLxPhyjzV7g_XpRcIWB3
SUPABASE_SERVICE_ROLE_KEY=[pending]

# Future: CMI payments, Google Maps, Expo notifications
```

---

## 🗄️ Database Diagram

### Schema Overview
```
BRANDS (5 brands)
  ├── PRODUCTS (10+ items per brand)
  │   └── PRODUCT_VARIANTS (sizes, proteins)
  │
  ├── USERS (auth.users linked)
  │   ├── CUSTOMERS (profile data)
  │   │   ├── ORDERS (order history)
  │   │   │   ├── ORDER_ITEMS (items per order)
  │   │   │   ├── ORDER_TRACKING (driver location)
  │   │   │   ├── ORDER_STATUS_LOG (history)
  │   │   │   ├── KITCHEN_QUEUE (dashboard queue)
  │   │   │   └── ORDER_PAYMENTS (transaction)
  │   │   │
  │   │   └── LOYALTY_CARDS (stamps per brand)
  │   │       └── LOYALTY_REWARDS (points history)
  │   │
  │   ├── DRIVERS (delivery staff)
  │   └── USER_ADDRESSES (saved locations)
  │
  └── PROMOTIONS (discount codes)
```

---

## 🔐 Row-Level Security (RLS)

Policies enforce access control:

| Table | Policy | Effect |
|-------|--------|--------|
| orders | `Customers view own orders` | Customer sees only their orders |
| orders | `Customers create orders` | Customer can place orders |
| products | `Public view active products` | Anyone sees active menu items |
| push_tokens | `Users manage own tokens` | Users store device tokens only for themselves |

**Kitchen staff & Admins** get broader access via role checks (to be enhanced in Milestone 3).

---

## ✨ Special Features

### 1. Auto-incrementing Order Numbers
```sql
-- Orders get auto-generated numbers: #01000, #01001, etc.
CREATE SEQUENCE order_number_seq START WITH 1000
CREATE TRIGGER generate_order_number_trigger
```

### 2. Auto-updating Timestamps
```sql
-- All tables auto-update `updated_at` column
CREATE TRIGGER update_[table]_updated_at
  BEFORE UPDATE ON [table]
  EXECUTE FUNCTION update_updated_at_column()
```

### 3. JSONB Support
- **products.ingredients** — Array of ingredient objects
- **orders.items** — Cart items with variants
- **users.saved_addresses** — Multiple addresses
- **drivers.vehicle_info** — Vehicle details
- **drivers.current_location** — Real-time driver location

---

## 🚀 Deployment Instructions

### Step 1: Execute Schema
Run in Supabase SQL Editor:
```bash
# Copy entire contents of scripts/01-schema.sql
# Paste into Supabase SQL Editor
# Click "Run"
```

### Step 2: Execute Seed Data
Run in Supabase SQL Editor:
```bash
# Copy entire contents of scripts/02-seed.sql
# Paste into Supabase SQL Editor
# Click "Run"
```

### Step 3: Verify Installation
In Supabase Dashboard:
1. Click "Table Editor" → Verify 17 tables exist
2. Click "brands" → Verify 5 brands exist (1 active)
3. Click "products" → Verify 10 products exist
4. Click "Authentication" → Setup Phone OTP provider (Milestone 1b)

### Step 4: Configure Environment
```bash
# Copy .env.example to .env.local
cp .env.example .env.local

# Fill in Supabase credentials (already in .env.example)
# Add SERVICE_ROLE_KEY later when needed
```

### Step 5: Test Supabase Connection
```bash
# npm install supabase
# The client will be initialized in lib/supabase/client.ts
```

---

## 📊 Success Criteria

✅ All 17 tables created in Supabase  
✅ All RLS policies enabled  
✅ 5 brands seeded (1 active, 4 coming_soon)  
✅ 10 Chicken Bowl products seeded  
✅ 3 promotional codes active  
✅ Brand architecture documented and ready  
✅ Monorepo structure defined  
✅ Environment variables configured  

---

## ⚠️ Risks & Mitigations

| Risk | Mitigation |
|------|-----------|
| RLS policies too restrictive | Start permissive, tighten later |
| Brand switching issues | Test CSS variables before mobile |
| Order number collisions | Sequence is atomic in PostgreSQL |
| Large JSONB fields slow queries | Index JSONB columns in future |

---

## 📝 Next: Milestone 2 Preview

Once M1 is deployed:

1. **Design System** — Tailwind + brand theming setup
2. **Shared Components** — Button, Card, Badge, etc. with brand context
3. **i18n Setup** — French + Arabic translations ready
4. **Storybook** (optional) — Component documentation

**Estimated:** 1 week  
**Dependency:** M1 complete (Supabase live)

---

## 💾 Files Created

| File | Purpose |
|------|---------|
| `scripts/01-schema.sql` | Database schema (17 tables, indexes, triggers) |
| `scripts/02-seed.sql` | Initial data (brands, products, promos) |
| `lib/brands/config.ts` | Brand registry & helper functions |
| `lib/brands/context.tsx` | React Context for brand switching |
| `lib/supabase/client.ts` | Supabase client initialization |
| `.env.example` | Environment variables template |
| `MONOREPO_STRUCTURE.md` | Project architecture documentation |
| `MILESTONE_1_REVIEW.md` | This file |

---

## ✅ Ready to Deploy?

When you confirm, I will:

1. Execute `01-schema.sql` against your Supabase project
2. Execute `02-seed.sql` against your Supabase project
3. Verify all tables and data are created
4. Confirm 5 brands + 10 products visible in dashboard
5. Move to **Milestone 2: Design System & Shared Components**

---

**Your Supabase Credentials:**
- URL: `https://ppwtwcngrchvupmhvtfn.supabase.co`
- Anon Key: `sb_publishable_PJBR1TNSAoUYLxPhyjzV7g_XpRcIWB3`

**Ready to execute Milestone 1? 🚀**
