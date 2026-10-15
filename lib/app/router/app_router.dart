import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/tasks/presentation/pages/tasks_page.dart';
import '../../features/tasks/presentation/pages/task_detail_page.dart';
import '../../features/properties/presentation/pages/properties_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/notifications/presentation/pages/notifications_page.dart';
import '../../features/team/presentation/pages/team_page.dart';
import '../../features/inventory/presentation/pages/inventory_page.dart';
import '../shell/main_shell.dart';

class AppRoutes {
  static const login = '/login';
  static const dashboard = '/dashboard';
  static const tasks = '/tasks';
  static const taskDetail = '/tasks/:id';
  static const properties = '/properties';
  static const inventory = '/inventory';
  static const team = '/team';
  static const notifications = '/notifications';
  static const profile = '/profile';
  static const settings = '/settings';
}

final routerProvider = Provider<GoRouter>((ref) {
  final isInitialising =
      ref.watch(authProvider.select((s) => s.isInitialising));
  final isAuthenticated =
      ref.watch(authProvider.select((s) => s.isAuthenticated));

  return GoRouter(
    initialLocation: AppRoutes.dashboard,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      if (isInitialising) {
        return null;
      }

      final isLoggingIn = state.matchedLocation == AppRoutes.login;

      if (!isAuthenticated) {
        return isLoggingIn ? null : AppRoutes.login;
      }

      if (isLoggingIn) {
        return AppRoutes.dashboard;
      }

      return null;
    },
    routes: [
      // Login — standalone, no bottom nav
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),

      // Main app shell — 5 bottom tabs
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShell(navigationShell: navigationShell);
        },
        branches: [
          // Tab 0 — Dashboard
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.dashboard,
                name: 'dashboard',
                builder: (context, state) => const DashboardPage(),
              ),
            ],
          ),

          // Tab 1 — Properties
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.properties,
                name: 'properties',
                builder: (context, state) => const PropertiesPage(),
              ),
            ],
          ),

          // Tab 2 — Inventory
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.inventory,
                name: 'inventory',
                builder: (context, state) => const InventoryPage(),
              ),
            ],
          ),

          // Tab 3 — Team
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.team,
                name: 'team',
                builder: (context, state) => const TeamPage(),
              ),
            ],
          ),

          // Tab 4 — Tasks
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.tasks,
                name: 'tasks',
                builder: (context, state) => const TasksPage(),
                routes: [
                  GoRoute(
                    path: ':id',
                    name: 'taskDetail',
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return TaskDetailPage(taskId: id);
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),

      // Standalone pages — pushed on top, no bottom nav
      GoRoute(
        path: AppRoutes.profile,
        name: 'profile',
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        name: 'settings',
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: AppRoutes.notifications,
        name: 'notifications',
        builder: (context, state) => const NotificationsPage(),
      ),
    ],
  );
});

