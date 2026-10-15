import 'package:dio/dio.dart';
import '../../utils/app_logger.dart';

class LoggingInterceptor extends Interceptor {
  final _log = AppLogger.instance;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _log.debug(
      '→ ${options.method} ${options.uri}\n'
      'Headers: ${options.headers}\n'
      'Body: ${options.data}',
    );
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _log.debug(
      '← ${response.statusCode} ${response.requestOptions.uri}\n'
      'Response: ${response.data}',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _log.error(
      '✗ ${err.requestOptions.method} ${err.requestOptions.uri}\n'
      'Error: ${err.message}',
      err,
    );
    handler.next(err);
  }
}
