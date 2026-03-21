import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'utils/constants.dart';

void testConnection() async {
  try {
    final dio = Dio();

    debugPrint('🔍 Testing connection to: ${AppConstants.baseUrl}');

    final response = await dio.get(
      '${AppConstants.baseUrl}/ponds',
      options: Options(validateStatus: (status) => status != null),
    );

    debugPrint('✅ Status: ${response.statusCode}');
    debugPrint('📦 Response: ${response.data}');

    if (response.statusCode == 200) {
      debugPrint('🎉 Koneksi ke database BERHASIL!');
    } else {
      debugPrint('❌ Error: ${response.data}');
    }
  } catch (e) {
    debugPrint('❌ Connection Error: $e');
  }
}
