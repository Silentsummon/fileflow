import 'package:dio/dio.dart';

class ApiClient {
  final Dio _dio;
  final String baseUrl;
  final String apiKey;

  ApiClient({required this.baseUrl, required this.apiKey})
      : _dio = Dio() {
    _dio.options.headers['X-API-Key'] = apiKey;
  }

  /// Uploads a file to POST {baseUrl}/upload
  /// Calls onProgress(sentBytes, totalBytes) as the upload streams.
  Future<void> uploadFile({
    required String filePath,
    required String fileName,
    required String category,
    required void Function(int sent, int total) onProgress,
  }) async {
    final formData = FormData.fromMap({
      // Backend expects the field named 'tag' — 'category' is only
      // the name used on the Dart/UI side, kept for consistency
      // with the rest of the app.
      'tag': category,
      'file': await MultipartFile.fromFile(filePath, filename: fileName),
    });

    await _dio.post(
      '$baseUrl/upload',
      data: formData,
      onSendProgress: (sent, total) => onProgress(sent, total),
    );
  }

  /// Checks GET {baseUrl}/health — used to verify backend is reachable.
  Future<bool> checkHealth() async {
    try {
      final response = await _dio.get('$baseUrl/health');
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
