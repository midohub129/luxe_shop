import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;
import '../config/app_theme.dart';
import '../providers/cart_provider.dart';
import 'home/home_screen.dart';
import 'categories/categories_screen.dart';
import 'cart/cart_screen.dart';
import 'profile/profile_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    CategoriesScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 15,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'الرئيسية',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.category_outlined),
              activeIcon: Icon(Icons.category),
              label: 'الأقسام',
            ),
            BottomNavigationBarItem(
              icon: Consumer<CartProvider>(
                builder: (context, cartProvider, child) {
                  if (cartProvider.itemCount == 0) {
                    return const Icon(Icons.shopping_cart_outlined);
                  }
                  return badges.Badge(
                    badgeContent: Text(
                      '${cartProvider.itemCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    badgeStyle: const badges.BadgeStyle(
                      badgeColor: AppTheme.accentColor,
                      padding: EdgeInsets.all(5),
                    ),
                    child: const Icon(Icons.shopping_cart_outlined),
                  );
                },
              ),
              activeIcon: Consumer<CartProvider>(
                builder: (context, cartProvider, child) {
                  if (cartProvider.itemCount == 0) {
                    return const Icon(Icons.shopping_cart);
                  }
                  return badges.Badge(
                    badgeContent: Text(
                      '${cartProvider.itemCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    badgeStyle: const badges.BadgeStyle(
                      badgeColor: AppTheme.accentColor,
                      padding: EdgeInsets.all(5),
                    ),
                    child: const Icon(Icons.shopping_cart),
                  );
                },
              ),
              label: 'السلة',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'حسابي',
            ),
          ],
        ),
      ),
    );
  }
}
