import '../utils/constants.dart';

class ApiConfig {
  static const String baseUrl = AppConstants.baseUrl;

  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
}
