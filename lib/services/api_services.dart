import 'package:dio/dio.dart';
import '../models/index.dart';
import '../api/dio_client.dart';
import '../utils/constants.dart';

class AuthService {
  final Dio _dio;

  AuthService({Dio? dio}) : _dio = dio ?? DioClient().dio;

  /// Kirim OTP ke nomor WhatsApp (sesuai backend Laravel)
  /// Backend return: { status, message, data: { whatsapp, expires_in } }
  Future<Map<String, dynamic>> sendOtp({required String whatsapp}) async {
    try {
      final response = await _dio.post(
        AppConstants.authSendOtp,
        data: {'whatsapp': whatsapp},
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Verifikasi OTP dan dapatkan token
  /// Backend return: { status, message, data: { token, user } }
  Future<AuthResponse> verifyOtp({
    required String whatsapp,
    required String otp,
  }) async {
    try {
      final response = await _dio.post(
        AppConstants.authVerifyOtp,
        data: {'whatsapp': whatsapp, 'otp': otp},
      );

      // Backend return data di 'data' key
      final data = response.data['data'] ?? response.data;
      return AuthResponse.fromJson(data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      await _dio.post(AppConstants.authLogout);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException e) {
    if (e.response?.data is Map) {
      return e.response?.data['message'] ?? 'An error occurred';
    }
    return e.message ?? 'An error occurred';
  }
}

class PondService {
  final Dio _dio;

  PondService({Dio? dio}) : _dio = dio ?? DioClient().dio;

  /// Fetch semua kolam untuk user (RT)
  Future<PondResponse> getPonds({
    int page = 1,
    int limit = AppConstants.paginationLimit,
  }) async {
    try {
      final response = await _dio.get(
        AppConstants.pondsGet,
        queryParameters: {'page': page, 'per_page': limit},
      );
      return PondResponse.fromJson(response.data['data'] ?? response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Fetch detail kolam
  Future<Pond> getPondDetail(int pondId) async {
    try {
      final response = await _dio.get('${AppConstants.pondsGet}/$pondId');
      return Pond.fromJson(response.data['data'] ?? response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Buat kolam baru
  Future<Pond> createPond({
    required String name,
    required String location,
    required double area,
    String? description,
    String? imageUrl,
  }) async {
    try {
      final response = await _dio.post(
        AppConstants.pondsCreate,
        data: {
          'name': name,
          'location': location,
          'area': area,
          'description': description,
          'image_url': imageUrl,
        },
      );
      return Pond.fromJson(response.data['data'] ?? response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Update kolam
  Future<Pond> updatePond(
    int pondId, {
    String? name,
    String? location,
    double? area,
    String? description,
  }) async {
    try {
      final response = await _dio.put(
        AppConstants.pondsUpdate.replaceAll(':id', pondId.toString()),
        data: {
          'name': name,
          'location': location,
          'area': area,
          'description': description,
        },
      );
      return Pond.fromJson(response.data['data'] ?? response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Delete kolam
  Future<void> deletePond(int pondId) async {
    try {
      await _dio.delete(
        AppConstants.pondsDelete.replaceAll(':id', pondId.toString()),
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException e) {
    if (e.response?.data is Map) {
      return e.response?.data['message'] ?? 'An error occurred';
    }
    return e.message ?? 'An error occurred';
  }
}

class ProductService {
  final Dio _dio;

  ProductService({Dio? dio}) : _dio = dio ?? DioClient().dio;

  /// Fetch semua produk (katalog)
  Future<ProductResponse> getProducts({
    int page = 1,
    int limit = AppConstants.paginationLimit,
    String? category,
  }) async {
    try {
      final response = await _dio.get(
        AppConstants.productsGet,
        queryParameters: {
          'page': page,
          'per_page': limit,
          ...?switch (category) {
            final selectedCategory? => {'category': selectedCategory},
            null => null,
          },
        },
      );
      return ProductResponse.fromJson(response.data['data'] ?? response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Fetch detail produk
  Future<Product> getProductDetail(int productId) async {
    try {
      final response = await _dio.get(
        AppConstants.productDetail.replaceAll(':id', productId.toString()),
      );
      return Product.fromJson(response.data['data'] ?? response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException e) {
    if (e.response?.data is Map) {
      return e.response?.data['message'] ?? 'An error occurred';
    }
    return e.message ?? 'An error occurred';
  }
}

class OrderService {
  final Dio _dio;

  OrderService({Dio? dio}) : _dio = dio ?? DioClient().dio;

  /// Buat order baru (checkout)
  Future<Order> createOrder({required OrderCreateRequest orderRequest}) async {
    try {
      final response = await _dio.post(
        AppConstants.ordersCreate,
        data: orderRequest.toJson(),
      );
      return Order.fromJson(response.data['data'] ?? response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Fetch orders user
  Future<OrderResponse> getOrders({
    int page = 1,
    int limit = AppConstants.paginationLimit,
  }) async {
    try {
      final response = await _dio.get(
        AppConstants.ordersGet,
        queryParameters: {'page': page, 'per_page': limit},
      );
      return OrderResponse.fromJson(response.data['data'] ?? response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Fetch detail order
  Future<Order> getOrderDetail(int orderId) async {
    try {
      final response = await _dio.get(
        AppConstants.orderDetail.replaceAll(':id', orderId.toString()),
      );
      return Order.fromJson(response.data['data'] ?? response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Cancel order
  Future<void> cancelOrder(int orderId) async {
    try {
      await _dio.post(
        AppConstants.ordersCancel.replaceAll(':id', orderId.toString()),
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException e) {
    if (e.response?.data is Map) {
      return e.response?.data['message'] ?? 'An error occurred';
    }
    return e.message ?? 'An error occurred';
  }
}
