class Order {
  final String id;
  final String userId;
  final List<OrderItem> items;
  final double totalSYP;
  final double totalUSD;
  final String status;
  final String paymentMethod;
  final String shippingCity;
  final String shippingAddress;
  final String phoneNumber;
  final String? notes;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalSYP,
    required this.totalUSD,
    required this.status,
    required this.paymentMethod,
    required this.shippingCity,
    required this.shippingAddress,
    required this.phoneNumber,
    this.notes,
    required this.createdAt,
    this.updatedAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      items: (json['order_items'] as List?)
              ?.map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      totalSYP: (json['total_syp'] as num).toDouble(),
      totalUSD: (json['total_usd'] as num).toDouble(),
      status: json['status'] as String,
      paymentMethod: json['payment_method'] as String,
      shippingCity: json['shipping_city'] as String,
      shippingAddress: json['shipping_address'] as String,
      phoneNumber: json['phone_number'] as String,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'total_syp': totalSYP,
      'total_usd': totalUSD,
      'status': status,
      'payment_method': paymentMethod,
      'shipping_city': shippingCity,
      'shipping_address': shippingAddress,
      'phone_number': phoneNumber,
      'notes': notes,
    };
  }
}

class OrderItem {
  final String id;
  final String orderId;
  final String productId;
  final String productName;
  final String? productImage;
  final int quantity;
  final double priceSYP;
  final double priceUSD;
  final String? size;
  final String? color;

  OrderItem({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.productName,
    this.productImage,
    required this.quantity,
    required this.priceSYP,
    required this.priceUSD,
    this.size,
    this.color,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] as String,
      orderId: json['order_id'] as String,
      productId: json['product_id'] as String,
      productName: json['product_name'] as String,
      productImage: json['product_image'] as String?,
      quantity: json['quantity'] as int,
      priceSYP: (json['price_syp'] as num).toDouble(),
      priceUSD: (json['price_usd'] as num).toDouble(),
      size: json['size'] as String?,
      color: json['color'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'product_id': productId,
      'product_name': productName,
      'product_image': productImage,
      'quantity': quantity,
      'price_syp': priceSYP,
      'price_usd': priceUSD,
      'size': size,
      'color': color,
    };
  }
}
