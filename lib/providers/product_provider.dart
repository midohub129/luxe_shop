import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/mock_data_service.dart';

class ProductProvider extends ChangeNotifier {
  List<Product> _products = [];
  List<Product> _featuredProducts = [];
  bool _isLoading = false;
  String? _selectedCategory;
  String _searchQuery = '';

  List<Product> get products => _filteredProducts;
  List<Product> get featuredProducts => _featuredProducts;
  bool get isLoading => _isLoading;
  String? get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  List<Product> get _filteredProducts {
    var filtered = _products;

    if (_selectedCategory != null) {
      filtered =
          filtered.where((p) => p.category == _selectedCategory).toList();
    }

    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((p) =>
              p.name.contains(_searchQuery) ||
              p.nameEn.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    return filtered;
  }

  Future<void> loadProducts() async {
    _isLoading = true;
    notifyListeners();

    // Using mock data - replace with Supabase calls when connected
    await Future<void>.delayed(const Duration(milliseconds: 500));
    _products = MockDataService.getMockProducts();
    _featuredProducts = _products.where((p) => p.isFeatured).toList();

    _isLoading = false;
    notifyListeners();
  }

  void setCategory(String? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Product? getProductById(String id) {
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  List<Product> getProductsByCategory(String category) {
    return _products.where((p) => p.category == category).toList();
  }
}
