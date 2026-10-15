import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../router/app_router.dart';
import '../theme/theme_provider.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final authState = ref.watch(authProvider);
    final themeNotifier = ref.read(themeProvider.notifier);
    final isDark = ref.watch(themeProvider) == ThemeMode.dark;

    return Drawer(
      child: Column(
        children: [
          // ── Dynamic Header Container ────────────────────────
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(
              16,
              MediaQuery.of(context).padding.top + 16,
              16,
              16,
            ),
            decoration: BoxDecoration(color: colorScheme.primary),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: colorScheme.onPrimary.withAlpha(50),
                  child: Icon(
                    Icons.person,
                    size: 30,
                    color: colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  authState.user?.name.isNotEmpty == true
                      ? authState.user!.name
                      : 'Task Bnb User',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  authState.user?.phone.isNotEmpty == true
                      ? authState.user!.phone
                      : (authState.user?.email ?? ''),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onPrimary.withAlpha(200),
                  ),
                ),
                if (authState.user?.company != null &&
                    authState.user!.company!.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.onPrimary.withAlpha(40),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${authState.user!.company} • ${authState.user!.plan?.toUpperCase() ?? "ACTIVE"}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // ── Menu Items ──────────────────────────────────────
          ListTile(
            leading: Icon(Icons.person_outlined, color: colorScheme.onSurface),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pop(context);
              context.push(AppRoutes.profile);
            },
          ),
          ListTile(
            leading: Icon(Icons.settings_outlined, color: colorScheme.onSurface),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              context.push(AppRoutes.settings);
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications_outlined, color: colorScheme.onSurface),
            title: const Text('Notifications'),
            onTap: () {
              Navigator.pop(context);
              context.push(AppRoutes.notifications);
            },
          ),

          // ── Spacer ──────────────────────────────────────────
          const Spacer(),
          const Divider(height: 1),

          // ── Theme Toggle ────────────────────────────────────
          SwitchListTile(
            secondary: Icon(
              isDark ? Icons.dark_mode : Icons.light_mode,
              color: colorScheme.onSurface,
            ),
            title: Text(isDark ? 'Dark Mode' : 'Light Mode'),
            value: isDark,
            onChanged: (_) => themeNotifier.toggle(),
          ),

          // ── Logout ──────────────────────────────────────────
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text(
              'Logout',
              style: TextStyle(color: Colors.redAccent),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (dialogContext) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
                  title: const Text('Log out of your account?'),
                  content: Text(
                    'Are you sure you want to log out of TaskBnB?',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withAlpha(170),
                    ),
                  ),
                  actionsPadding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
                  actions: [
                    Row(
                      children: [
                        // Cancel Button
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              side: BorderSide(
                                color: colorScheme.outline.withAlpha(100),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () => Navigator.of(dialogContext).pop(),
                            child: Text(
                              'Cancel',
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: colorScheme.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Gradient Log out Button
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  colorScheme.primary,
                                  colorScheme.secondary,
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: colorScheme.primary.withAlpha(90),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () async {
                                  Navigator.of(dialogContext).pop();
                                  Navigator.of(context).pop();
                                  await ref
                                      .read(authProvider.notifier)
                                      .logout();
                                },
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Log out',
                                    style: theme.textTheme.labelLarge?.copyWith(
                                      color: colorScheme.onPrimary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
