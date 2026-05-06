import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product.dart';
import '../models/order.dart' as app_order;
import '../models/app_user.dart';

class SupabaseService {
  final SupabaseClient _client;

  SupabaseService(this._client);

  SupabaseClient get client => _client;

  // ─── Auth ───

  Future<AuthResponse> signUp(String email, String password) async {
    return await _client.auth.signUp(email: email, password: password);
  }

  Future<AuthResponse> signIn(String email, String password) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  User? get currentUser => _client.auth.currentUser;

  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  // ─── User Profile ───

  Future<AppUser?> getUserProfile(String userId) async {
    final response =
        await _client.from('users').select().eq('id', userId).maybeSingle();
    if (response == null) return null;
    return AppUser.fromJson(response);
  }

  Future<void> createUserProfile(AppUser user) async {
    await _client.from('users').upsert(user.toJson());
  }

  Future<void> updateUserProfile(Map<String, dynamic> data) async {
    await _client.from('users').update(data).eq('id', currentUser!.id);
  }

  // ─── Products ───

  Future<List<Product>> getProducts({
    String? category,
    String? searchQuery,
    int limit = 20,
    int offset = 0,
  }) async {
    var query = _client.from('products').select();

    if (category != null) {
      query = query.eq('category', category);
    }

    if (searchQuery != null && searchQuery.isNotEmpty) {
      query = query.or('name.ilike.%$searchQuery%,name_en.ilike.%$searchQuery%');
    }

    final response = await query
        .order('created_at', ascending: false)
        .range(offset, offset + limit - 1);

    return (response as List).map((e) => Product.fromJson(e)).toList();
  }

  Future<List<Product>> getFeaturedProducts() async {
    final response = await _client
        .from('products')
        .select()
        .eq('is_featured', true)
        .order('created_at', ascending: false)
        .limit(10);

    return (response as List).map((e) => Product.fromJson(e)).toList();
  }

  Future<Product?> getProduct(String id) async {
    final response =
        await _client.from('products').select().eq('id', id).maybeSingle();
    if (response == null) return null;
    return Product.fromJson(response);
  }

  // ─── Wishlist ───

  Future<List<String>> getWishlistIds(String userId) async {
    final response = await _client
        .from('wishlists')
        .select('product_id')
        .eq('user_id', userId);

    return (response as List)
        .map((e) => e['product_id'] as String)
        .toList();
  }

  Future<void> addToWishlist(String userId, String productId) async {
    await _client.from('wishlists').insert({
      'user_id': userId,
      'product_id': productId,
    });
  }

  Future<void> removeFromWishlist(String userId, String productId) async {
    await _client
        .from('wishlists')
        .delete()
        .eq('user_id', userId)
        .eq('product_id', productId);
  }

  // ─── Orders ───

  Future<String> createOrder(app_order.Order order) async {
    final response = await _client
        .from('orders')
        .insert(order.toJson())
        .select('id')
        .single();

    return response['id'] as String;
  }

  Future<void> createOrderItems(List<Map<String, dynamic>> items) async {
    await _client.from('order_items').insert(items);
  }

  Future<List<app_order.Order>> getUserOrders(String userId) async {
    final response = await _client
        .from('orders')
        .select('*, order_items(*)')
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (response as List)
        .map((e) => app_order.Order.fromJson(e))
        .toList();
  }
}
