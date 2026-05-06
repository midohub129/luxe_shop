import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../providers/cart_provider.dart';
import '../../utils/formatters.dart';
import '../checkout/checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('سلة التسوق'),
        actions: [
          Consumer<CartProvider>(
            builder: (context, cartProvider, _) {
              if (cartProvider.items.isEmpty) return const SizedBox.shrink();
              return TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('مسح السلة'),
                      content: const Text(
                          'هل أنت متأكد من إفراغ سلة التسوق؟'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('إلغاء'),
                        ),
                        TextButton(
                          onPressed: () {
                            cartProvider.clearCart();
                            Navigator.pop(ctx);
                          },
                          child: const Text('مسح',
                              style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text('مسح الكل',
                    style: TextStyle(color: AppTheme.accentColor)),
              );
            },
          ),
        ],
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, _) {
          if (cartProvider.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined,
                      size: 100, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  const Text(
                    'سلة التسوق فارغة',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'ابدأ بالتسوق وأضف منتجات إلى سلتك',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: cartProvider.items.length,
                  itemBuilder: (context, index) {
                    final item = cartProvider.items[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(
                              imageUrl: item.product.images.isNotEmpty
                                  ? item.product.images.first
                                  : '',
                              width: 90,
                              height: 90,
                              fit: BoxFit.cover,
                              errorWidget: (c, u, e) => Container(
                                width: 90,
                                height: 90,
                                color: Colors.grey.shade100,
                                child: const Icon(Icons.image),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.product.name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                if (item.selectedSize != null ||
                                    item.selectedColor != null)
                                  Text(
                                    [
                                      if (item.selectedSize != null)
                                        'المقاس: ${item.selectedSize}',
                                      if (item.selectedColor != null)
                                        'اللون: ${item.selectedColor}',
                                    ].join(' • '),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppTheme.textSecondary,
                                    ),
                                  ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      Formatters.formatPriceSYP(
                                          item.totalPriceSYP),
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: AppTheme.accentColor,
                                      ),
                                    ),
                                    // Quantity controls
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8),
                                        border: Border.all(
                                          color: AppTheme.dividerColor,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              cartProvider.updateQuantity(
                                                item.product.id,
                                                item.quantity - 1,
                                                size: item.selectedSize,
                                                color: item.selectedColor,
                                              );
                                            },
                                            child: const Padding(
                                              padding: EdgeInsets.all(6),
                                              child: Icon(Icons.remove,
                                                  size: 16),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 10),
                                            child: Text(
                                              '${item.quantity}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              cartProvider.updateQuantity(
                                                item.product.id,
                                                item.quantity + 1,
                                                size: item.selectedSize,
                                                color: item.selectedColor,
                                              );
                                            },
                                            child: const Padding(
                                              padding: EdgeInsets.all(6),
                                              child: Icon(Icons.add,
                                                  size: 16),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Delete
                          IconButton(
                            icon: const Icon(Icons.delete_outline,
                                color: Colors.red, size: 22),
                            onPressed: () {
                              cartProvider.removeFromCart(
                                item.product.id,
                                size: item.selectedSize,
                                color: item.selectedColor,
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              // Bottom summary
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 10,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'المجموع (${cartProvider.totalQuantity} قطعة)',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          Text(
                            Formatters.formatPriceSYP(
                                cartProvider.totalPriceSYP),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.accentColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const CheckoutScreen(),
                              ),
                            );
                          },
                          child: const Text('إتمام الطلب'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
