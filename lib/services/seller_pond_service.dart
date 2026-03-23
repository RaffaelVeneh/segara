import 'package:dio/dio.dart';

import '../api/dio_client.dart';

class SellerPond {
  final String id;
  final String code;
  final int capacity;
  final String status;
  final String? fishType;
  final DateTime? startedAt;
  final DateTime? estHarvestAt;

  const SellerPond({
    required this.id,
    required this.code,
    required this.capacity,
    required this.status,
    this.fishType,
    this.startedAt,
    this.estHarvestAt,
  });

  factory SellerPond.fromJson(Map<String, dynamic> json) {
    final activeBatch = _firstBatch(json['production_batches']);
    return SellerPond(
      id: (json['id'] ?? '').toString(),
      code: (json['code'] ?? '').toString(),
      capacity: ((json['capacity'] ?? 0) as num).toInt(),
      status: (json['status'] ?? 'EMPTY').toString(),
      fishType: activeBatch?['fish_type']?.toString(),
      startedAt: _parseDate(activeBatch?['started_at']),
      estHarvestAt: _parseDate(activeBatch?['est_harvest_at']),
    );
  }

  static Map<String, dynamic>? _firstBatch(dynamic value) {
    if (value is List &&
        value.isNotEmpty &&
        value.first is Map<String, dynamic>) {
      return value.first as Map<String, dynamic>;
    }
    return null;
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) {
      return null;
    }
    return DateTime.tryParse(value.toString());
  }
}

class SellerPondService {
  final Dio _dio;

  SellerPondService({Dio? dio}) : _dio = dio ?? DioClient().dio;

  Future<List<SellerPond>> getPonds() async {
    try {
      final response = await _dio.get('/ponds');
      final data = response.data is Map<String, dynamic>
          ? (response.data['data'] as List<dynamic>? ?? const <dynamic>[])
          : const <dynamic>[];
      return data
          .whereType<Map<String, dynamic>>()
          .map(SellerPond.fromJson)
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> createPond({
    required String code,
    required int capacity,
    required String fishType,
    required DateTime startedAt,
    required DateTime estHarvestAt,
  }) async {
    try {
      await _dio.post(
        '/ponds',
        data: {
          'code': code,
          'capacity': capacity,
          'fish_type': fishType,
          'started_at': _formatDate(startedAt),
          'est_harvest_at': _formatDate(estHarvestAt),
        },
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> updatePond({
    required String pondId,
    int? capacity,
    String? status,
    String? fishType,
    DateTime? startedAt,
    DateTime? estHarvestAt,
  }) async {
    try {
      final payload = <String, dynamic>{
        'capacity': capacity,
        'status': status,
        'fish_type': fishType,
        'started_at': startedAt != null ? _formatDate(startedAt) : null,
        'est_harvest_at': estHarvestAt != null
            ? _formatDate(estHarvestAt)
            : null,
      }..removeWhere((key, value) => value == null);

      await _dio.put('/ponds/$pondId', data: payload);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _formatDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  String _handleError(DioException e) {
    if (e.response?.data is Map) {
      final map = e.response?.data as Map;
      return (map['message'] ?? 'Terjadi kesalahan pada server').toString();
    }
    return e.message ?? 'Terjadi kesalahan pada server';
  }
}
