import 'package:dio/dio.dart';

class ApiService {
  late final Dio _dio;

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://www.themealdb.com/api/json/v1/1/',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );
  }

  Future<List<dynamic>> fetchMealsByLetter(String letter) async {
    try {
      final res = await _dio.get('search.php', queryParameters: {'f': letter});
      return res.data['meals'] is List ? res.data['meals'] : [];
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<List<dynamic>> searchMealsByName(String query) async {
    try {
      final res = await _dio.get('search.php', queryParameters: {'s': query});
      return res.data['meals'] is List ? res.data['meals'] : [];
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  String _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Timeout error. Check connection.';
      default:
        return 'Network error occurred.';
    }
  }
}