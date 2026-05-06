import 'package:flutter/material.dart';
import '../models/product.dart';

class WishlistProvider extends ChangeNotifier {
  final List<Product> _items = [];

  List<Product> get items => List.unmodifiable(_items);
  int get itemCount => _items.length;

  bool isInWishlist(String productId) {
    return _items.any((item) => item.id == productId);
  }

  void toggleWishlist(Product product) {
    if (isInWishlist(product.id)) {
      _items.removeWhere((item) => item.id == product.id);
    } else {
      _items.add(product);
    }
    notifyListeners();
  }

  void removeFromWishlist(String productId) {
    _items.removeWhere((item) => item.id == productId);
    notifyListeners();
  }

  void clearWishlist() {
    _items.clear();
    notifyListeners();
  }
}
