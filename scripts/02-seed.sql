-- ============================================================================
-- CHEFPOINT SEED DATA
-- Initial data for Chicken Bowl brand and test users
-- ============================================================================

-- ============================================================================
-- INSERT BRANDS
-- ============================================================================

INSERT INTO brands (slug, name, tagline, emoji, accent_color, secondary_color, status, launch_date, delivery_time, min_order)
VALUES 
  ('chicken-bowl', 'Chicken Bowl', 'Frais. Savoureux. Fait pour vous.', '🥗', '#C9A84C', '#0E0C08', 'active', NOW(), '25–35 min', 65.00),
  ('pasa-wrap', 'Paşa Wrap', 'Wraps Turcs Authentiques', '🌯', '#E8935A', '#0E0C08', 'coming_soon', NULL, '20–30 min', 55.00),
  ('crema-medina', 'Crema Medina', 'Glaces Artisanales', '🍦', '#E84A5F', '#0E0C08', 'coming_soon', NULL, 'À emporter', 30.00),
  ('smash-rabat', 'Smash Rabat', 'Smash Burgers Gourmands', '🍔', '#4ECDC4', '#0E0C08', 'coming_soon', NULL, '25–35 min', 70.00),
  ('sweet-rabat', 'Sweet Rabat', 'Pâtisserie & Viennoiserie', '🍮', '#B57BEA', '#0E0C08', 'coming_soon', NULL, 'À emporter', 40.00);

-- ============================================================================
-- INSERT CHICKEN BOWL PRODUCTS (5 featured bowls)
-- ============================================================================

INSERT INTO products (brand_id, category, name, description, base_price, weight_grams, active, ingredients)
VALUES 
  (
    (SELECT id FROM brands WHERE slug = 'chicken-bowl'),
    'bowls',
    'Classic Herb Bowl',
    'Thym & Fraîcheur - Riz basmati, poulet thym, salades fraîches, pois chiches',
    65.00,
    580,
    TRUE,
    jsonb_build_array(
      jsonb_build_object('name', 'Riz Basmati Safrané', 'quantity', '220g'),
      jsonb_build_object('name', 'Poulet Crème Thym', 'quantity', '120g'),
      jsonb_build_object('name', 'Salade Green Mix', 'quantity', '80g'),
      jsonb_build_object('name', 'Tomates en Dés', 'quantity', '40g'),
      jsonb_build_object('name', 'Pois Chiches Gingembre', 'quantity', '60g'),
      jsonb_build_object('name', 'Haydari Yaourt Filtré', 'quantity', '60g')
    )
  ),
  (
    (SELECT id FROM brands WHERE slug = 'chicken-bowl'),
    'bowls',
    'Spicy Grill Bowl',
    'Pimenté & Fumé - Poulet grillé épicé, saveurs mexicaines, salades',
    65.00,
    580,
    TRUE,
    jsonb_build_array(
      jsonb_build_object('name', 'Riz Basmati Safrané', 'quantity', '220g'),
      jsonb_build_object('name', 'Poulet Grillé Épicé', 'quantity', '120g'),
      jsonb_build_object('name', 'Salade Green Mix', 'quantity', '80g'),
      jsonb_build_object('name', 'Tomates en Dés', 'quantity', '40g'),
      jsonb_build_object('name', 'Haricots Mexicains', 'quantity', '60g'),
      jsonb_build_object('name', 'Tarator Yaourt', 'quantity', '60g')
    )
  ),
  (
    (SELECT id FROM brands WHERE slug = 'chicken-bowl'),
    'bowls',
    'Sweet & Smoky Bowl',
    'Sucré & Barbecue - Poulet honey BBQ, notes caramélisées, saveurs marocaines',
    65.00,
    580,
    TRUE,
    jsonb_build_array(
      jsonb_build_object('name', 'Riz Basmati Safrané', 'quantity', '220g'),
      jsonb_build_object('name', 'Poulet Honey BBQ', 'quantity', '120g'),
      jsonb_build_object('name', 'Salade Green Mix', 'quantity', '80g'),
      jsonb_build_object('name', 'Tomates en Dés', 'quantity', '40g'),
      jsonb_build_object('name', 'Tabbouleh Marocain', 'quantity', '60g'),
      jsonb_build_object('name', 'Mutabbel Aubergine', 'quantity', '60g')
    )
  ),
  (
    (SELECT id FROM brands WHERE slug = 'chicken-bowl'),
    'bowls',
    'Oriental Ginger Bowl',
    'Gingembre & Exotique - Poulet ginger chili, saveurs asiatiques adaptées',
    65.00,
    580,
    TRUE,
    jsonb_build_array(
      jsonb_build_object('name', 'Riz Basmati Safrané', 'quantity', '220g'),
      jsonb_build_object('name', 'Poulet Ginger Chili', 'quantity', '120g'),
      jsonb_build_object('name', 'Salade Green Mix', 'quantity', '80g'),
      jsonb_build_object('name', 'Tomates en Dés', 'quantity', '40g'),
      jsonb_build_object('name', 'Courgette Chermoula', 'quantity', '60g'),
      jsonb_build_object('name', 'Houmous Marocain', 'quantity', '60g')
    )
  ),
  (
    (SELECT id FROM brands WHERE slug = 'chicken-bowl'),
    'bowls',
    'Fresh Lemon Bowl',
    'Citronné & Léger - Poulet citron herbes, saveurs fraîches et légères',
    65.00,
    580,
    TRUE,
    jsonb_build_array(
      jsonb_build_object('name', 'Riz Basmati Safrané', 'quantity', '220g'),
      jsonb_build_object('name', 'Poulet Lemon Herb', 'quantity', '120g'),
      jsonb_build_object('name', 'Salade Green Mix', 'quantity', '80g'),
      jsonb_build_object('name', 'Tomates en Dés', 'quantity', '40g'),
      jsonb_build_object('name', 'Pois Chiches Curcuma', 'quantity', '60g'),
      jsonb_build_object('name', 'Yaourt Betterave', 'quantity', '60g')
    )
  );

-- Add sides
INSERT INTO products (brand_id, category, name, description, base_price, weight_grams, active, ingredients)
VALUES 
  (
    (SELECT id FROM brands WHERE slug = 'chicken-bowl'),
    'sides',
    'Hummus Marocain',
    'Pois chiches, tahini, citron, ail',
    15.00,
    150,
    TRUE,
    jsonb_build_array(
      jsonb_build_object('name', 'Pois chiches', 'quantity', '100g'),
      jsonb_build_object('name', 'Tahini', 'quantity', '30g'),
      jsonb_build_object('name', 'Citron frais', 'quantity', '10g')
    )
  ),
  (
    (SELECT id FROM brands WHERE slug = 'chicken-bowl'),
    'sides',
    'Tabbouleh',
    'Persil, tomates, oignons, bulgur, citron',
    12.00,
    120,
    TRUE,
    jsonb_build_array(
      jsonb_build_object('name', 'Persil frais', 'quantity', '60g'),
      jsonb_build_object('name', 'Tomates', 'quantity', '40g'),
      jsonb_build_object('name', 'Bulgur', 'quantity', '30g')
    )
  ),
  (
    (SELECT id FROM brands WHERE slug = 'chicken-bowl'),
    'sides',
    'Salade Verte',
    'Mix de laitues fraîches, concombre, tomates',
    8.00,
    150,
    TRUE,
    jsonb_build_array(
      jsonb_build_object('name', 'Laitues mixtes', 'quantity', '100g'),
      jsonb_build_object('name', 'Concombre', 'quantity', '30g'),
      jsonb_build_object('name', 'Tomates', 'quantity', '20g')
    )
  );

-- Add drinks
INSERT INTO products (brand_id, category, name, description, base_price, weight_grams, active, ingredients)
VALUES 
  (
    (SELECT id FROM brands WHERE slug = 'chicken-bowl'),
    'drinks',
    'Jus Citron Frais',
    'Citrons pressés frais, glaçons, un zeste de sucre',
    12.00,
    330,
    TRUE,
    jsonb_build_array(
      jsonb_build_object('name', 'Citrons frais', 'quantity', '3-4'),
      jsonb_build_object('name', 'Eau', 'quantity', '250ml')
    )
  ),
  (
    (SELECT id FROM brands WHERE slug = 'chicken-bowl'),
    'drinks',
    'Eau Minérale',
    'Eau minérale Sidi Ali',
    3.00,
    500,
    TRUE,
    jsonb_build_array()
  ),
  (
    (SELECT id FROM brands WHERE slug = 'chicken-bowl'),
    'drinks',
    'Thé à la Menthe',
    'Thé vert marocain traditionnel avec menthe fraîche',
    8.00,
    350,
    TRUE,
    jsonb_build_array(
      jsonb_build_object('name', 'Thé vert', 'quantity', '5g'),
      jsonb_build_object('name', 'Menthe fraîche', 'quantity', '10g')
    )
  );

-- ============================================================================
-- INSERT PRODUCT VARIANTS (Sizes, Proteins, Sauces)
-- ============================================================================

-- Sizes for bowls
INSERT INTO product_variants (product_id, variant_type, name, price_modifier)
SELECT id, 'size', 'Small', -5.00 FROM products WHERE name = 'Classic Herb Bowl'
UNION ALL
SELECT id, 'size', 'Regular', 0.00 FROM products WHERE name = 'Classic Herb Bowl'
UNION ALL
SELECT id, 'size', 'Large', 10.00 FROM products WHERE name = 'Classic Herb Bowl'
UNION ALL
SELECT id, 'size', 'Small', -5.00 FROM products WHERE name = 'Spicy Grill Bowl'
UNION ALL
SELECT id, 'size', 'Regular', 0.00 FROM products WHERE name = 'Spicy Grill Bowl'
UNION ALL
SELECT id, 'size', 'Large', 10.00 FROM products WHERE name = 'Spicy Grill Bowl'
UNION ALL
SELECT id, 'size', 'Small', -5.00 FROM products WHERE name = 'Sweet & Smoky Bowl'
UNION ALL
SELECT id, 'size', 'Regular', 0.00 FROM products WHERE name = 'Sweet & Smoky Bowl'
UNION ALL
SELECT id, 'size', 'Large', 10.00 FROM products WHERE name = 'Sweet & Smoky Bowl'
UNION ALL
SELECT id, 'size', 'Small', -5.00 FROM products WHERE name = 'Oriental Ginger Bowl'
UNION ALL
SELECT id, 'size', 'Regular', 0.00 FROM products WHERE name = 'Oriental Ginger Bowl'
UNION ALL
SELECT id, 'size', 'Large', 10.00 FROM products WHERE name = 'Oriental Ginger Bowl'
UNION ALL
SELECT id, 'size', 'Small', -5.00 FROM products WHERE name = 'Fresh Lemon Bowl'
UNION ALL
SELECT id, 'size', 'Regular', 0.00 FROM products WHERE name = 'Fresh Lemon Bowl'
UNION ALL
SELECT id, 'size', 'Large', 10.00 FROM products WHERE name = 'Fresh Lemon Bowl';

-- ============================================================================
-- INSERT PROMOTIONS
-- ============================================================================

INSERT INTO promotions (brand_id, code, discount_percent, max_uses, expiry_date, active)
VALUES 
  (
    (SELECT id FROM brands WHERE slug = 'chicken-bowl'),
    'BIENVENUE10',
    10,
    100,
    NOW() + INTERVAL '30 days',
    TRUE
  ),
  (
    (SELECT id FROM brands WHERE slug = 'chicken-bowl'),
    'DELIVERY20',
    20,
    50,
    NOW() + INTERVAL '15 days',
    TRUE
  ),
  (
    (SELECT id FROM brands WHERE slug = 'chicken-bowl'),
    'LOYALTY5',
    5,
    999,
    NOW() + INTERVAL '90 days',
    TRUE
  );

-- ============================================================================
-- SUCCESS MESSAGE
-- ============================================================================
-- Seed data insertion complete
-- Tables populated:
-- - brands (5 brands: 1 active, 4 coming_soon)
-- - products (10 items: 5 bowls, 3 sides, 2 drinks)
-- - product_variants (15 size variants)
-- - promotions (3 promo codes)
