import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/app_user.dart';
import '../services/supabase_service.dart';

class AuthProvider extends ChangeNotifier {
  final SupabaseService _supabaseService;
  AppUser? _user;
  bool _isLoading = false;
  String? _error;

  AuthProvider(this._supabaseService) {
    _init();
  }

  AppUser? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _supabaseService.currentUser != null;
  String? get error => _error;

  void _init() {
    _supabaseService.authStateChanges.listen((event) async {
      if (event.event == AuthChangeEvent.signedIn) {
        await _loadUserProfile();
      } else if (event.event == AuthChangeEvent.signedOut) {
        _user = null;
        notifyListeners();
      }
    });
    if (_supabaseService.currentUser != null) {
      _loadUserProfile();
    }
  }

  Future<void> _loadUserProfile() async {
    final currentUser = _supabaseService.currentUser;
    if (currentUser == null) return;

    _user = await _supabaseService.getUserProfile(currentUser.id);
    if (_user == null) {
      _user = AppUser(
        id: currentUser.id,
        email: currentUser.email ?? '',
        createdAt: DateTime.now(),
      );
      await _supabaseService.createUserProfile(_user!);
    }
    notifyListeners();
  }

  Future<bool> signUp(String email, String password, String fullName) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _supabaseService.signUp(email, password);
      if (response.user != null) {
        _user = AppUser(
          id: response.user!.id,
          email: email,
          fullName: fullName,
          createdAt: DateTime.now(),
        );
        await _supabaseService.createUserProfile(_user!);
        _isLoading = false;
        notifyListeners();
        return true;
      }
      _error = 'فشل إنشاء الحساب';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _supabaseService.signIn(email, password);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    await _supabaseService.signOut();
    _user = null;
    notifyListeners();
  }

  Future<void> updateProfile({
    String? fullName,
    String? phoneNumber,
    String? city,
    String? address,
  }) async {
    final updates = <String, dynamic>{};
    if (fullName != null) updates['full_name'] = fullName;
    if (phoneNumber != null) updates['phone_number'] = phoneNumber;
    if (city != null) updates['city'] = city;
    if (address != null) updates['address'] = address;

    if (updates.isNotEmpty) {
      await _supabaseService.updateUserProfile(updates);
      _user = _user?.copyWith(
        fullName: fullName,
        phoneNumber: phoneNumber,
        city: city,
        address: address,
      );
      notifyListeners();
    }
  }
}
