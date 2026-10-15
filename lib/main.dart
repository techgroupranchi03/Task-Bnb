import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app/config/app_config.dart';
import 'app/router/app_router.dart';
import 'app/theme/app_theme.dart';
import 'app/theme/theme_provider.dart';
import 'core/network/dio_client.dart';
import 'core/storage/shared_prefs_service.dart';
import 'core/utils/app_logger.dart';

/// Default entry point when running `flutter run` without target flag.
void main() => bootstrap(Environment.development);

/// Generic bootstrap called by each flavour entry point.
Future<void> bootstrap(Environment environment) async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load .env with fallback
  final envFile = switch (environment) {
    Environment.development => '.env.development',
    Environment.staging => '.env.staging',
    Environment.production => '.env.production',
  };

  try {
    await dotenv.load(fileName: envFile);
  } catch (e) {
    debugPrint('Warning: Could not load $envFile, falling back to default configuration.');
  }

  // Initialise AppConfig
  AppConfig.initialize(
    environment: environment,
    baseUrl: dotenv.env['BASE_URL'] ?? 'https://dev-api.taskbnb.com',
    apiTimeout: int.tryParse(dotenv.env['API_TIMEOUT'] ?? '') ?? 30000,
    enableLogging: dotenv.env['ENABLE_LOGGING'] == 'true',
  );

  // Initialise services
  AppLogger.instance.init();
  await SharedPrefsService.instance.init();
  DioClient.instance.init();

  runApp(const ProviderScope(child: TaskBnbApp()));
}

class TaskBnbApp extends ConsumerWidget {
  const TaskBnbApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Task Bnb',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
