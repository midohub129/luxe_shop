import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../providers/product_provider.dart';
import '../../widgets/product_card.dart';
import '../../widgets/category_chip.dart';
import '../../widgets/section_header.dart';
import '../../widgets/shimmer_loading.dart';
import '../categories/categories_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().loadProducts();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<ProductProvider>(
          builder: (context, productProvider, _) {
            return CustomScrollView(
              slivers: [
                // App Bar
                SliverToBoxAdapter(
                  child: _buildHeader(),
                ),
                // Search Bar
                SliverToBoxAdapter(
                  child: _buildSearchBar(productProvider),
                ),
                // Categories
                SliverToBoxAdapter(
                  child: _buildCategories(productProvider),
                ),
                // Featured Banner
                if (productProvider.featuredProducts.isNotEmpty)
                  SliverToBoxAdapter(
                    child: _buildFeaturedBanner(productProvider),
                  ),
                // Section Header
                SliverToBoxAdapter(
                  child: SectionHeader(
                    title: productProvider.selectedCategory != null
                        ? _getCategoryName(productProvider.selectedCategory!)
                        : 'جميع المنتجات',
                    actionText: 'عرض الكل',
                    onAction: () {},
                  ),
                ),
                // Products Grid
                if (productProvider.isLoading)
                  const SliverToBoxAdapter(
                    child: ShimmerLoading(),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.62,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return ProductCard(
                            product: productProvider.products[index],
                          );
                        },
                        childCount: productProvider.products.length,
                      ),
                    ),
                  ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 20),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'مرحباً بك 👋',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'لوكس شوب',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 8,
                ),
              ],
            ),
            child: const Icon(
              Icons.notifications_outlined,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(ProductProvider productProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: _searchController,
        onChanged: productProvider.setSearchQuery,
        textDirection: TextDirection.rtl,
        decoration: InputDecoration(
          hintText: 'ابحث عن المنتجات...',
          prefixIcon:
              const Icon(Icons.search, color: AppTheme.textSecondary),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    productProvider.setSearchQuery('');
                  },
                )
              : null,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildCategories(ProductProvider productProvider) {
    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          CategoryChip(
            label: 'الكل',
            icon: Icons.apps,
            isSelected: productProvider.selectedCategory == null,
            onTap: () => productProvider.setCategory(null),
          ),
          const SizedBox(width: 8),
          CategoryChip(
            label: 'ملابس',
            icon: Icons.checkroom,
            isSelected: productProvider.selectedCategory == 'clothes',
            onTap: () => productProvider.setCategory('clothes'),
          ),
          const SizedBox(width: 8),
          CategoryChip(
            label: 'إكسسوارات',
            icon: Icons.watch,
            isSelected: productProvider.selectedCategory == 'accessories',
            onTap: () => productProvider.setCategory('accessories'),
          ),
          const SizedBox(width: 8),
          CategoryChip(
            label: 'مجوهرات',
            icon: Icons.diamond,
            isSelected: productProvider.selectedCategory == 'jewelry',
            onTap: () => productProvider.setCategory('jewelry'),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedBanner(ProductProvider productProvider) {
    return Container(
      height: 180,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primaryColor, Color(0xFF16213E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            left: -20,
            top: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
          ),
          Positioned(
            right: -30,
            bottom: -30,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'تخفيضات حصرية',
                  style: TextStyle(
                    color: AppTheme.goldColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'خصم يصل إلى 20%',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () {
                    final mainNav = context.findAncestorStateOfType<State>();
                    if (mainNav != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CategoriesScreen(),
                        ),
                      );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.accentColor,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: const Text(
                      'تسوق الآن',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getCategoryName(String key) {
    switch (key) {
      case 'clothes':
        return 'ملابس';
      case 'accessories':
        return 'إكسسوارات';
      case 'jewelry':
        return 'مجوهرات';
      default:
        return key;
    }
  }
}
