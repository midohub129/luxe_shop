import 'product.dart';

class CartItem {
  final Product product;
  int quantity;
  final String? selectedSize;
  final String? selectedColor;

  CartItem({
    required this.product,
    this.quantity = 1,
    this.selectedSize,
    this.selectedColor,
  });

  double get totalPriceSYP => product.effectivePriceSYP * quantity;
  double get totalPriceUSD => product.effectivePriceUSD * quantity;

  Map<String, dynamic> toJson() {
    return {
      'product_id': product.id,
      'quantity': quantity,
      'selected_size': selectedSize,
      'selected_color': selectedColor,
    };
  }
}
