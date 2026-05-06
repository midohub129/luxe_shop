-- ============================================================
-- LuxeShop - Supabase Database Schema
-- Premium E-Commerce App for the Syrian Market
-- ============================================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ──────────────────────────────────────
-- Users Table (extends Supabase Auth)
-- ──────────────────────────────────────
CREATE TABLE users (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email TEXT NOT NULL,
    full_name TEXT,
    phone_number TEXT,
    city TEXT,
    address TEXT,
    avatar_url TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Validate Syrian phone numbers (+963 or 09XXXXXXXX)
ALTER TABLE users ADD CONSTRAINT valid_phone
    CHECK (phone_number IS NULL OR phone_number ~ '^(\+963|0)?9[0-9]{8}$');

-- Valid Syrian cities
ALTER TABLE users ADD CONSTRAINT valid_city
    CHECK (city IS NULL OR city IN (
        'دمشق', 'حلب', 'حمص', 'حماة', 'اللاذقية', 'طرطوس',
        'دير الزور', 'الرقة', 'الحسكة', 'درعا', 'السويداء',
        'القنيطرة', 'إدلب', 'ريف دمشق'
    ));

-- ──────────────────────────────────────
-- Products Table
-- ──────────────────────────────────────
CREATE TABLE products (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    name_en TEXT,
    description TEXT,
    category TEXT NOT NULL CHECK (category IN ('clothes', 'accessories', 'jewelry')),
    price_syp DECIMAL(12,2) NOT NULL CHECK (price_syp >= 0),
    price_usd DECIMAL(10,2) NOT NULL CHECK (price_usd >= 0),
    discount_price_syp DECIMAL(12,2) CHECK (discount_price_syp IS NULL OR discount_price_syp >= 0),
    discount_price_usd DECIMAL(10,2) CHECK (discount_price_usd IS NULL OR discount_price_usd >= 0),
    images TEXT[] DEFAULT '{}',
    stock_quantity INTEGER DEFAULT 0 CHECK (stock_quantity >= 0),
    sizes TEXT[] DEFAULT '{}',
    colors TEXT[] DEFAULT '{}',
    rating DECIMAL(2,1) DEFAULT 0 CHECK (rating >= 0 AND rating <= 5),
    review_count INTEGER DEFAULT 0 CHECK (review_count >= 0),
    is_featured BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes for common queries
CREATE INDEX idx_products_category ON products(category);
CREATE INDEX idx_products_featured ON products(is_featured) WHERE is_featured = TRUE;
CREATE INDEX idx_products_created ON products(created_at DESC);
CREATE INDEX idx_products_name_search ON products USING gin(to_tsvector('simple', name || ' ' || COALESCE(name_en, '')));

-- ──────────────────────────────────────
-- Wishlists Table
-- ──────────────────────────────────────
CREATE TABLE wishlists (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    UNIQUE(user_id, product_id)
);

CREATE INDEX idx_wishlists_user ON wishlists(user_id);

-- ──────────────────────────────────────
-- Orders Table
-- ──────────────────────────────────────
CREATE TABLE orders (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    total_syp DECIMAL(14,2) NOT NULL CHECK (total_syp >= 0),
    total_usd DECIMAL(12,2) NOT NULL CHECK (total_usd >= 0),
    status TEXT NOT NULL DEFAULT 'pending'
        CHECK (status IN ('pending', 'confirmed', 'shipped', 'delivered', 'cancelled')),
    payment_method TEXT NOT NULL
        CHECK (payment_method IN ('cash_on_delivery', 'manual_transfer')),
    shipping_city TEXT NOT NULL,
    shipping_address TEXT NOT NULL,
    phone_number TEXT NOT NULL,
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_orders_user ON orders(user_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_orders_created ON orders(created_at DESC);

-- ──────────────────────────────────────
-- Order Items Table
-- ──────────────────────────────────────
CREATE TABLE order_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    order_id UUID NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    product_id UUID NOT NULL REFERENCES products(id),
    product_name TEXT NOT NULL,
    product_image TEXT,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    price_syp DECIMAL(12,2) NOT NULL CHECK (price_syp >= 0),
    price_usd DECIMAL(10,2) NOT NULL CHECK (price_usd >= 0),
    size TEXT,
    color TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

CREATE INDEX idx_order_items_order ON order_items(order_id);

-- ──────────────────────────────────────
-- Row Level Security (RLS)
-- ──────────────────────────────────────

-- Users
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own profile"
    ON users FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile"
    ON users FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Users can insert own profile"
    ON users FOR INSERT WITH CHECK (auth.uid() = id);

-- Products (public read)
ALTER TABLE products ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Products are viewable by everyone"
    ON products FOR SELECT USING (true);

-- Wishlists
ALTER TABLE wishlists ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can manage own wishlist"
    ON wishlists FOR ALL USING (auth.uid() = user_id);

-- Orders
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own orders"
    ON orders FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can create own orders"
    ON orders FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Order Items
ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own order items"
    ON order_items FOR SELECT
    USING (EXISTS (
        SELECT 1 FROM orders WHERE orders.id = order_items.order_id AND orders.user_id = auth.uid()
    ));

CREATE POLICY "Users can create own order items"
    ON order_items FOR INSERT
    WITH CHECK (EXISTS (
        SELECT 1 FROM orders WHERE orders.id = order_items.order_id AND orders.user_id = auth.uid()
    ));

-- ──────────────────────────────────────
-- Triggers for updated_at
-- ──────────────────────────────────────
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_users_updated_at
    BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER update_products_updated_at
    BEFORE UPDATE ON products
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER update_orders_updated_at
    BEFORE UPDATE ON orders
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- ──────────────────────────────────────
-- Storage Bucket for Product Images
-- ──────────────────────────────────────
-- Run this in Supabase Dashboard > Storage:
-- Create a public bucket named 'product-images'
-- Set policy: Allow public reads, authenticated writes

-- ──────────────────────────────────────
-- Sample Data (Optional)
-- ──────────────────────────────────────
INSERT INTO products (name, name_en, description, category, price_syp, price_usd, discount_price_syp, discount_price_usd, images, stock_quantity, sizes, colors, rating, review_count, is_featured) VALUES
('فستان سهرة أنيق', 'Elegant Evening Dress', 'فستان سهرة فاخر مصنوع من أجود أنواع الأقمشة، مناسب للمناسبات الخاصة والحفلات.', 'clothes', 850000, 65, 680000, 52, ARRAY['https://images.unsplash.com/photo-1566174053879-31528523f8ae?w=400'], 15, ARRAY['S','M','L','XL'], ARRAY['أسود','أحمر','كحلي'], 4.8, 124, true),
('بلوزة حرير فاخرة', 'Luxury Silk Blouse', 'بلوزة من الحرير الطبيعي بتصميم عصري وأنيق.', 'clothes', 420000, 32, NULL, NULL, ARRAY['https://images.unsplash.com/photo-1564257631407-4deb1f99d992?w=400'], 30, ARRAY['S','M','L'], ARRAY['أبيض','وردي','بيج'], 4.5, 89, true),
('حقيبة يد جلدية', 'Leather Handbag', 'حقيبة يد من الجلد الطبيعي بتصميم عصري وعملي.', 'accessories', 650000, 50, NULL, NULL, ARRAY['https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=400'], 20, ARRAY[]::TEXT[], ARRAY['أسود','بني','تان'], 4.7, 167, true),
('عقد ذهبي فاخر', 'Luxury Gold Necklace', 'عقد ذهبي عيار 21 بتصميم دمشقي تقليدي.', 'jewelry', 3500000, 269, NULL, NULL, ARRAY['https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f?w=400'], 5, ARRAY[]::TEXT[], ARRAY[]::TEXT[], 5.0, 312, true),
('خاتم ألماس أنيق', 'Elegant Diamond Ring', 'خاتم من الذهب الأبيض مرصع بالألماس الطبيعي.', 'jewelry', 5200000, 400, NULL, NULL, ARRAY['https://images.unsplash.com/photo-1605100804763-247f67b3557e?w=400'], 3, ARRAY['6','7','8','9'], ARRAY[]::TEXT[], 4.9, 187, true);
