import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/api_config.dart';
import '../main.dart';
import '../screens/pilih_pengguna_screen.dart';
import '../utils/constants.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();

  late final Dio _dio;
  late final FlutterSecureStorage _secureStorage;

  factory DioClient() {
    return _instance;
  }

  DioClient._internal() {
    _secureStorage = const FlutterSecureStorage();
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: ApiConfig.connectTimeout,
        receiveTimeout: ApiConfig.receiveTimeout,
        sendTimeout: ApiConfig.sendTimeout,
        contentType: 'application/json',
        headers: {'Accept': 'application/json'},
      ),
    );
    _dio.interceptors.add(AuthInterceptor(_secureStorage));
    _dio.interceptors.add(LoggingInterceptor());
  }

  Dio get dio => _dio;
  FlutterSecureStorage get secureStorage => _secureStorage;
}

class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage secureStorage;

  AuthInterceptor(this.secureStorage);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await secureStorage.read(key: AppConstants.tokenKey);

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    return handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      // Token expired atau invalid
      await secureStorage.delete(key: AppConstants.tokenKey);

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(AppConstants.userRoleKey);
      await prefs.remove(AppConstants.userNameKey);
      await prefs.remove(AppConstants.userPhoneKey);

      final navigator = navigatorKey.currentState;
      if (navigator != null) {
        navigator.pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const PilihPenggunaScreen()),
          (route) => false,
        );
      }
    }

    return handler.next(err);
  }
}

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint('🚀 REQUEST[${options.method}] => PATH: ${options.path}');
    debugPrint('Headers: ${options.headers}');
    debugPrint('Data: ${options.data}');
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint(
      '✅ RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
    );
    debugPrint('Data: ${response.data}');
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint(
      '❌ ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
    );
    debugPrint('Message: ${err.message}');
    debugPrint('Response: ${err.response?.data}');
    return handler.next(err);
  }
}
