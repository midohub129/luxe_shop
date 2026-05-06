class AppConstants {
  static const String appName = 'LuxeShop';
  static const String appNameAr = 'لوكس شوب';

  static const List<String> syrianCities = [
    'دمشق',
    'حلب',
    'حمص',
    'حماة',
    'اللاذقية',
    'طرطوس',
    'دير الزور',
    'الرقة',
    'الحسكة',
    'درعا',
    'السويداء',
    'القنيطرة',
    'إدلب',
    'ريف دمشق',
  ];

  static const List<String> categories = [
    'ملابس',
    'إكسسوارات',
    'مجوهرات',
  ];

  static const List<String> categoryKeys = [
    'clothes',
    'accessories',
    'jewelry',
  ];

  static const List<String> orderStatuses = [
    'pending',
    'confirmed',
    'shipped',
    'delivered',
    'cancelled',
  ];

  static const Map<String, String> orderStatusAr = {
    'pending': 'قيد الانتظار',
    'confirmed': 'مؤكد',
    'shipped': 'تم الشحن',
    'delivered': 'تم التسليم',
    'cancelled': 'ملغي',
  };

  static const Map<String, String> paymentMethods = {
    'cash_on_delivery': 'الدفع عند الاستلام',
    'manual_transfer': 'تحويل يدوي',
  };
}
