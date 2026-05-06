class Product {
  final String id;
  final String name;
  final String nameEn;
  final String description;
  final String category;
  final double priceSYP;
  final double priceUSD;
  final double? discountPriceSYP;
  final double? discountPriceUSD;
  final List<String> images;
  final int stockQuantity;
  final List<String> sizes;
  final List<String> colors;
  final double rating;
  final int reviewCount;
  final bool isFeatured;
  final DateTime createdAt;

  Product({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.description,
    required this.category,
    required this.priceSYP,
    required this.priceUSD,
    this.discountPriceSYP,
    this.discountPriceUSD,
    required this.images,
    required this.stockQuantity,
    this.sizes = const [],
    this.colors = const [],
    this.rating = 0.0,
    this.reviewCount = 0,
    this.isFeatured = false,
    required this.createdAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      nameEn: json['name_en'] as String? ?? '',
      description: json['description'] as String? ?? '',
      category: json['category'] as String,
      priceSYP: (json['price_syp'] as num).toDouble(),
      priceUSD: (json['price_usd'] as num).toDouble(),
      discountPriceSYP: json['discount_price_syp'] != null
          ? (json['discount_price_syp'] as num).toDouble()
          : null,
      discountPriceUSD: json['discount_price_usd'] != null
          ? (json['discount_price_usd'] as num).toDouble()
          : null,
      images: List<String>.from(json['images'] as List? ?? []),
      stockQuantity: json['stock_quantity'] as int? ?? 0,
      sizes: List<String>.from(json['sizes'] as List? ?? []),
      colors: List<String>.from(json['colors'] as List? ?? []),
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['review_count'] as int? ?? 0,
      isFeatured: json['is_featured'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'name_en': nameEn,
      'description': description,
      'category': category,
      'price_syp': priceSYP,
      'price_usd': priceUSD,
      'discount_price_syp': discountPriceSYP,
      'discount_price_usd': discountPriceUSD,
      'images': images,
      'stock_quantity': stockQuantity,
      'sizes': sizes,
      'colors': colors,
      'rating': rating,
      'review_count': reviewCount,
      'is_featured': isFeatured,
      'created_at': createdAt.toIso8601String(),
    };
  }

  bool get hasDiscount =>
      discountPriceSYP != null && discountPriceSYP! < priceSYP;

  double get effectivePriceSYP => discountPriceSYP ?? priceSYP;
  double get effectivePriceUSD => discountPriceUSD ?? priceUSD;

  double get discountPercentage {
    if (!hasDiscount) return 0;
    return ((priceSYP - discountPriceSYP!) / priceSYP * 100).roundToDouble();
  }

  bool get inStock => stockQuantity > 0;
}
