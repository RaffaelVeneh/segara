class ApiConfig {
  // Ganti URL ini saat pengujian jaringan lokal:
  // - Android Emulator: http://10.0.2.2:8000/api
  // - Device fisik (WiFi yang sama): http://192.168.x.x:8000/api
  static const String baseUrl = 'http://192.168.1.29:8000/api';

  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
}
