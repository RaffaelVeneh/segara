/// Constants untuk aplikasi Segara
class AppConstants {
  // API Base URL - Sesuaikan dengan environment Anda
  // Untuk Android Emulator: http://10.0.2.2:8000
  // Untuk iOS Simulator: http://localhost:8000
  // Untuk device real: http://<your-machine-ip>:8000
  // Untuk Windows Desktop dev: http://localhost:8000

  // ⚙️ UBAH INI SESUAI SERVER LARAVEL ANDA:
  static const String baseUrl =
      'http://192.168.1.29:8000/api'; // Ubah localhost jika perlu

  // API Endpoints
  static const String authSendOtp = '/auth/send-otp';
  static const String authVerifyOtp = '/auth/verify-otp';
  static const String authLogout = '/auth/logout';
  static const String authRefreshToken = '/auth/refresh';

  static const String userProfile = '/user/profile';
  static const String userUpdate = '/user/update';

  static const String pondsGet = '/ponds';
  static const String pondsCreate = '/ponds';
  static const String pondsUpdate = '/ponds/:id';
  static const String pondsDelete = '/ponds/:id';

  static const String productsGet = '/products';
  static const String productDetail = '/products/:id';

  static const String ordersCreate = '/orders';
  static const String ordersGet = '/orders';
  static const String orderDetail = '/orders/:id';
  static const String ordersCancel = '/orders/:id/cancel';

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String userRoleKey = 'user_role';
  static const String userNameKey = 'user_name';
  static const String userPhoneKey = 'user_phone';

  // User Roles
  static const String roleSellerRt = 'SELLER_RT';
  static const String roleBuyer = 'BUYER';
  static const String roleAdmin = 'ADMIN';

  // Request Timeout
  static const int requestTimeoutSeconds = 30;

  // Pagination
  static const int paginationLimit = 20;
}
