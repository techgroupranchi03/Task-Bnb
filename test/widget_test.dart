import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_bnb/main.dart';
import 'package:task_bnb/core/storage/shared_prefs_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await SharedPrefsService.instance.init();
    await tester.pumpWidget(
      const ProviderScope(child: TaskBnbApp()),
    );
    await tester.pumpAndSettle();
    expect(find.byType(TaskBnbApp), findsOneWidget);
  });
}
