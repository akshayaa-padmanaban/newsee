/* 
@author     : karthick.d
@desc       : 
 */
import 'package:dio/dio.dart';
import 'package:newsee/core/api/http_connection_failure.dart';

class DioHttpExceptionParser {
  final DioException exception;

  DioHttpExceptionParser({required this.exception});

  HttpConnectionFailure parse() {
    switch (exception.type) {
      case DioExceptionType.connectionError:
        return HttpConnectionFailure(message: '');

      case DioExceptionType.badResponse:
        return HttpConnectionFailure(message: '');

      case DioExceptionType.badCertificate:
        return HttpConnectionFailure(message: '');

      case DioExceptionType.connectionTimeout:
        return HttpConnectionFailure(message: '');

      case DioExceptionType.sendTimeout:
        return HttpConnectionFailure(message: '');

      case DioExceptionType.cancel:
        return HttpConnectionFailure(message: '');

      case DioExceptionType.unknown:
        return HttpConnectionFailure(message: '');

      case DioExceptionType.receiveTimeout:
        return HttpConnectionFailure(message: '');
    }
  }
}
