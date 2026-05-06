import 'package:intl/intl.dart';

class Formatters {
  static String formatPriceSYP(double price) {
    final formatter = NumberFormat('#,###', 'ar');
    return '${formatter.format(price)} ل.س';
  }

  static String formatPriceUSD(double price) {
    final formatter = NumberFormat('#,##0.00', 'en');
    return '\$${formatter.format(price)}';
  }

  static String formatDate(DateTime date) {
    final formatter = DateFormat('yyyy/MM/dd', 'ar');
    return formatter.format(date);
  }

  static String formatPhoneNumber(String phone) {
    if (phone.startsWith('+963')) return phone;
    if (phone.startsWith('0')) return '+963${phone.substring(1)}';
    return '+963$phone';
  }

  static bool isValidSyrianPhone(String phone) {
    final cleaned = phone.replaceAll(RegExp(r'[\s\-()]'), '');
    return RegExp(r'^(\+963|0)?9\d{8}$').hasMatch(cleaned);
  }

  static bool isValidEmail(String email) {
    return RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$').hasMatch(email);
  }
}
