import 'package:logger/logger.dart';
import '../../app/config/app_config.dart';

class AppLogger {
  AppLogger._();
  static AppLogger? _instance;
  static AppLogger get instance => _instance ??= AppLogger._();

  late final Logger _logger;

  void init() {
    _logger = Logger(
      level: AppConfig.instance.enableLogging ? Level.trace : Level.off,
      printer: PrettyPrinter(
        methodCount: 2,
        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: true,
      ),
    );
  }

  void verbose(dynamic message, [dynamic error, StackTrace? stackTrace]) =>
      _logger.t(message, error: error, stackTrace: stackTrace);

  void debug(dynamic message, [dynamic error, StackTrace? stackTrace]) =>
      _logger.d(message, error: error, stackTrace: stackTrace);

  void info(dynamic message, [dynamic error, StackTrace? stackTrace]) =>
      _logger.i(message, error: error, stackTrace: stackTrace);

  void warning(dynamic message, [dynamic error, StackTrace? stackTrace]) =>
      _logger.w(message, error: error, stackTrace: stackTrace);

  void error(dynamic message, [dynamic error, StackTrace? stackTrace]) =>
      _logger.e(message, error: error, stackTrace: stackTrace);
}
