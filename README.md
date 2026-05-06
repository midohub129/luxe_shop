# LuxeShop - لوكس شوب

Premium e-commerce mobile application built with Flutter and Supabase, designed specifically for the Syrian market. The app offers a high-end shopping experience for clothes, accessories, and jewelry with full Arabic RTL support.

## Features

### Shopping Experience
- **Modern Grid UI** for product browsing with shimmer loading
- **Product Categories**: Clothes (ملابس), Accessories (إكسسوارات), Jewelry (مجوهرات)
- **Product Details** with image gallery, size/color selection, and quantity picker
- **Search** functionality across Arabic and English product names
- **Featured Products** banner with premium design

### Cart & Checkout
- **Shopping Cart** with quantity management
- **Wishlist** functionality
- **Cash on Delivery** payment method
- **Manual Transfer** payment option
- **Order Tracking** with status updates (Pending → Confirmed → Shipped → Delivered)

### User Experience
- **Full RTL (Right-to-Left)** support for Arabic language
- **Arabic Localization** as default language
- **Syrian Cities** selection (Damascus, Aleppo, Homs, etc.)
- **Syrian Phone Number** validation (+963 format)
- **Dual Currency** display (SYP and USD)
- **Premium UI** with elegant animations and transitions

### Navigation
Clean bottom navigation bar with 4 tabs:
1. **Home** (الرئيسية) - Featured products, categories, and search
2. **Categories** (الأقسام) - Browse by category with tabs
3. **Cart** (السلة) - Shopping cart with badge count
4. **Profile** (حسابي) - User account, orders, and settings

## Tech Stack

- **Frontend**: Flutter (Dart)
- **Backend**: Supabase (Auth, Database, Storage)
- **State Management**: Provider
- **Architecture**: Feature-based folder structure

## Project Structure

```
lib/
├── config/              # App configuration
│   ├── app_constants.dart   # Syrian cities, categories, order statuses
│   ├── app_theme.dart       # Premium theme with Cairo font
│   └── supabase_config.dart # Supabase connection config
├── l10n/                # Localization (Arabic/English ARB files)
├── models/              # Data models
│   ├── app_user.dart
│   ├── cart_item.dart
│   ├── order.dart
│   └── product.dart
├── providers/           # State management
│   ├── auth_provider.dart
│   ├── cart_provider.dart
│   ├── product_provider.dart
│   └── wishlist_provider.dart
├── screens/             # UI screens
│   ├── auth/            # Login & Register
│   ├── cart/            # Shopping cart
│   ├── categories/      # Category browsing
│   ├── checkout/        # Order checkout
│   ├── home/            # Home screen
│   ├── orders/          # Order history
│   ├── product_detail/  # Product detail view
│   ├── profile/         # User profile
│   ├── wishlist/        # Wishlist
│   └── main_navigation.dart
├── services/            # Backend services
│   ├── mock_data_service.dart
│   └── supabase_service.dart
├── utils/               # Utilities
│   └── formatters.dart  # Price, phone, date formatting
├── widgets/             # Reusable widgets
│   ├── category_chip.dart
│   ├── product_card.dart
│   ├── section_header.dart
│   └── shimmer_loading.dart
└── main.dart
```

## Database Schema

The Supabase database includes the following tables:

### `users`
Extends Supabase Auth with Syrian-specific fields:
- `phone_number` - Validated Syrian phone format
- `city` - Constrained to Syrian governorates
- `address`, `full_name`, `avatar_url`

### `products`
- Categories: `clothes`, `accessories`, `jewelry`
- Dual pricing: `price_syp`, `price_usd`
- Discount pricing support
- Multiple images, sizes, colors (arrays)
- Rating system with review count

### `orders`
- Status tracking: `pending` → `confirmed` → `shipped` → `delivered`
- Payment methods: `cash_on_delivery`, `manual_transfer`
- Syrian shipping details

### `order_items`
- Links orders to products with quantity, size, color selections
- Stores snapshot of product name/price at time of order

### `wishlists`
- User-product relationship with unique constraint

Full schema with RLS policies: [`supabase/schema.sql`](supabase/schema.sql)

## Getting Started

### Prerequisites
- Flutter SDK 3.x+
- Dart 3.x+
- A Supabase project

### Setup

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd luxe_shop
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Supabase**
   
   Update `lib/config/supabase_config.dart` with your Supabase project URL and anon key, or pass them via `--dart-define`:
   ```bash
   flutter run \
     --dart-define=SUPABASE_URL=https://your-project.supabase.co \
     --dart-define=SUPABASE_ANON_KEY=your-anon-key
   ```

4. **Set up the database**
   
   Run the SQL schema in your Supabase SQL editor:
   ```bash
   # Copy contents of supabase/schema.sql into Supabase Dashboard > SQL Editor
   ```

5. **Run the app**
   ```bash
   flutter run
   ```

## Mock Data

The app includes mock product data for development/demo purposes via `MockDataService`. When connected to Supabase, the app will fetch real data from the database. Sample seed data is also included in the schema SQL.

## Payment Methods

- **Cash on Delivery** (الدفع عند الاستلام): Pay when you receive your order
- **Manual Transfer** (تحويل يدوي): Transfer via local banking/hawala

## License

This project is proprietary. All rights reserved.
