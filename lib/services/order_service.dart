import 'dart:io';

import 'package:dio/dio.dart';

import '../api/dio_client.dart';

class CreateOrderResult {
  final String orderId;
  final String orderNumber;
  final int totalAmount;
  final DateTime expiredAt;
  final String status;

  CreateOrderResult({
    required this.orderId,
    required this.orderNumber,
    required this.totalAmount,
    required this.expiredAt,
    required this.status,
  });

  factory CreateOrderResult.fromJson(Map<String, dynamic> json) {
    return CreateOrderResult(
      orderId: (json['order_id'] ?? '').toString(),
      orderNumber: (json['order_number'] ?? '').toString(),
      totalAmount: ((json['total_amount'] ?? 0) as num).toInt(),
      expiredAt:
          DateTime.tryParse((json['expired_at'] ?? '').toString()) ??
          DateTime.now().add(const Duration(hours: 2)),
      status: (json['status'] ?? 'PENDING').toString(),
    );
  }
}

class UploadPaymentResult {
  final String orderId;
  final String status;
  final String? paymentProofUrl;

  UploadPaymentResult({
    required this.orderId,
    required this.status,
    this.paymentProofUrl,
  });

  factory UploadPaymentResult.fromJson(Map<String, dynamic> json) {
    return UploadPaymentResult(
      orderId: (json['order_id'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
      paymentProofUrl: json['payment_proof_url']?.toString(),
    );
  }
}

class OrderTrackingData {
  final String orderId;
  final String orderNumber;
  final String status;
  final int totalAmount;
  final DateTime? expiredAt;

  OrderTrackingData({
    required this.orderId,
    required this.orderNumber,
    required this.status,
    required this.totalAmount,
    this.expiredAt,
  });

  factory OrderTrackingData.fromJson(Map<String, dynamic> json) {
    return OrderTrackingData(
      orderId: (json['order_id'] ?? '').toString(),
      orderNumber: (json['order_number'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
      totalAmount: ((json['total_amount'] ?? 0) as num).toInt(),
      expiredAt: json['expired_at'] != null
          ? DateTime.tryParse(json['expired_at'].toString())
          : null,
    );
  }
}

class OrderService {
  final Dio _dio;

  OrderService({Dio? dio}) : _dio = dio ?? DioClient().dio;

  Future<CreateOrderResult> createOrder({
    required List<Map<String, dynamic>> cartItems,
    required String shippingAddress,
    String? notes,
  }) async {
    try {
      final items = cartItems
          .map(
            (item) => {
              'name': item['name']?.toString() ?? 'Produk',
              'fish_type':
                  item['fish_type']?.toString() ??
                  item['name']?.toString() ??
                  'Campuran',
              'price': ((item['price'] ?? 0) as num).toDouble(),
              'quantity': ((item['quantity'] ?? 0) as num).toDouble(),
            },
          )
          .toList();

      final response = await _dio.post(
        '/orders',
        data: {
          'items': items,
          'shipping_address': shippingAddress,
          if (notes != null && notes.isNotEmpty) 'notes': notes,
        },
      );

      final data = response.data is Map<String, dynamic>
          ? (response.data['data'] as Map<String, dynamic>? ??
                response.data as Map<String, dynamic>)
          : <String, dynamic>{};

      return CreateOrderResult.fromJson(data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<UploadPaymentResult> uploadPaymentProof({
    required String orderId,
    required File imageFile,
  }) async {
    try {
      final fileName = imageFile.path.split(Platform.pathSeparator).last;
      final formData = FormData.fromMap({
        'payment_proof': await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
        ),
      });

      final response = await _dio.post(
        '/orders/$orderId/upload-payment',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      final data = response.data is Map<String, dynamic>
          ? (response.data['data'] as Map<String, dynamic>? ??
                response.data as Map<String, dynamic>)
          : <String, dynamic>{};

      return UploadPaymentResult.fromJson(data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<OrderTrackingData> getOrderTracking(String orderId) async {
    try {
      final response = await _dio.get('/orders/$orderId/tracking');
      final data = response.data is Map<String, dynamic>
          ? (response.data['data'] as Map<String, dynamic>? ??
                response.data as Map<String, dynamic>)
          : <String, dynamic>{};

      return OrderTrackingData.fromJson(data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException e) {
    if (e.response?.data is Map) {
      final map = e.response?.data as Map;
      return (map['message'] ?? 'Terjadi kesalahan pada server').toString();
    }
    return e.message ?? 'Terjadi kesalahan pada server';
  }
}
