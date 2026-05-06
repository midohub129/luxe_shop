import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);
  int get itemCount => _items.length;
  int get totalQuantity =>
      _items.fold(0, (sum, item) => sum + item.quantity);

  double get totalPriceSYP =>
      _items.fold(0, (sum, item) => sum + item.totalPriceSYP);

  double get totalPriceUSD =>
      _items.fold(0, (sum, item) => sum + item.totalPriceUSD);

  bool isInCart(String productId) {
    return _items.any((item) => item.product.id == productId);
  }

  void addToCart(Product product, {String? size, String? color}) {
    final existingIndex = _items.indexWhere((item) =>
        item.product.id == product.id &&
        item.selectedSize == size &&
        item.selectedColor == color);

    if (existingIndex >= 0) {
      _items[existingIndex].quantity++;
    } else {
      _items.add(CartItem(
        product: product,
        selectedSize: size,
        selectedColor: color,
      ));
    }
    notifyListeners();
  }

  void removeFromCart(String productId, {String? size, String? color}) {
    _items.removeWhere((item) =>
        item.product.id == productId &&
        item.selectedSize == size &&
        item.selectedColor == color);
    notifyListeners();
  }

  void updateQuantity(String productId, int quantity,
      {String? size, String? color}) {
    final index = _items.indexWhere((item) =>
        item.product.id == productId &&
        item.selectedSize == size &&
        item.selectedColor == color);

    if (index >= 0) {
      if (quantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = quantity;
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
