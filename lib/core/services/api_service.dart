import 'package:dio/dio.dart';
import 'package:restaurent_admin_app/core/services/endpoint.dart';

class ApiService {
  final Dio _dio;

  ApiService()
      : _dio = Dio(BaseOptions(
          baseUrl: EndPoints.baseUrl,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        )) {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Add ngrok skip warning header for ngrok URLs
        if (options.uri.toString().contains('ngrok')) {
          options.headers['ngrok-skip-browser-warning'] = 'true';
        }

        print('🚀 Request: ${options.method} ${options.uri}');
        print('📤 Headers: ${options.headers}');
        if (options.data != null) {
          print('📦 Data: ${options.data}');
        }
        handler.next(options);
      },
      onResponse: (response, handler) {
        print(
            '✅ Response: ${response.statusCode} ${response.requestOptions.uri}');
        print('📥 Data: ${response.data}');

        // Check if response is ngrok warning page
        if (response.data is String &&
            response.data.toString().contains('ngrok')) {
          print(
              '⚠️ Warning: Received ngrok warning page instead of API response');
          print(
              '💡 Retrying request with ngrok-skip-browser-warning header...');

          // Retry the request with the proper header
          final retryOptions = response.requestOptions.copyWith(
            headers: {
              ...response.requestOptions.headers,
              'ngrok-skip-browser-warning': 'true',
            },
          );

          // Make the retry request
          _dio.fetch(retryOptions).then((retryResponse) {
            print('🔄 Retry Response: ${retryResponse.statusCode}');
            print('📥 Retry Data: ${retryResponse.data}');
            handler.resolve(retryResponse);
          }).catchError((error) {
            print('❌ Retry failed: $error');
            handler.next(response);
          });
          return;
        }

        handler.next(response);
      },
      onError: (DioError e, handler) {
        print('❌ Error: ${e.type} - ${e.message}');
        if (e.response != null) {
          print('📥 Error Response: ${e.response?.data}');
        }
        handler.next(e);
      },
    ));
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    ResponseType responseType = ResponseType.json,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: Options(responseType: responseType),
      );
    } on DioError catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response<T>> post<T>(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    ResponseType responseType = ResponseType.json,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(responseType: responseType),
      );
    } on DioError catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response<T>> put<T>(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    ResponseType responseType = ResponseType.json,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(responseType: responseType),
      );
    } on DioError catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response<T>> delete<T>(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    ResponseType responseType = ResponseType.json,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(responseType: responseType),
      );
    } on DioError catch (e) {
      throw _handleDioError(e);
    }
  }

  // Handle all status codes and network errors
  Exception _handleDioError(DioError e) {
    if (e.response != null) {
      final statusCode = e.response?.statusCode ?? 0;
      final data = e.response?.data;
      String message = 'Something went wrong';

      if (data != null && data is Map && data.containsKey('message')) {
        message = data['message'];
      } else {
        switch (statusCode) {
          case 400:
            message = 'Bad request';
            break;
          case 401:
            message = 'Unauthorized. Please login again.';
            break;
          case 403:
            message = 'Forbidden';
            break;
          case 404:
            message = 'Not found';
            break;
          case 500:
            message = 'Internal server error';
            break;
          default:
            message = 'Error $statusCode: ${e.response?.statusMessage}';
        }
      }
      return Exception(message);
    } else {
      if (e.type == DioErrorType.connectionTimeout ||
          e.type == DioErrorType.sendTimeout ||
          e.type == DioErrorType.receiveTimeout) {
        return Exception('Connection timed out. Please try again.');
      } else if (e.type == DioErrorType.cancel) {
        return Exception('Request was cancelled.');
      } else {
        return Exception(
            'Network error. Please check your internet connection.');
      }
    }
  }
}
