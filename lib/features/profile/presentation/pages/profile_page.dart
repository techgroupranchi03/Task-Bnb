import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_bnb/features/auth/presentation/providers/auth_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final user = ref.watch(authProvider).user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ── Profile Card Header ──────────────────────────
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: colorScheme.primary.withAlpha(40),
                      child: Icon(
                        Icons.person,
                        size: 40,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      user?.name.isNotEmpty == true ? user!.name : 'User',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (user?.phone.isNotEmpty == true) ...[
                      const SizedBox(height: 4),
                      Text(
                        user!.phone,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                    if (user?.status != null) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withAlpha(30),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green),
                        ),
                        child: Text(
                          user!.status!.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ── Account & Business Info Card ────────────────
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Business Info', style: theme.textTheme.titleMedium),
                    const Divider(height: 24),
                    _ProfileTile(
                      icon: Icons.business,
                      label: 'Company',
                      value: user?.company ?? 'Not set',
                    ),
                    _ProfileTile(
                      icon: Icons.phone,
                      label: 'Phone',
                      value: user?.phone.isNotEmpty == true ? user!.phone : 'N/A',
                    ),
                    _ProfileTile(
                      icon: Icons.badge,
                      label: 'User ID',
                      value: user?.id ?? 'N/A',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ── Subscription Details Card ───────────────────
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Subscription & Plan', style: theme.textTheme.titleMedium),
                    const Divider(height: 24),
                    _ProfileTile(
                      icon: Icons.workspace_premium,
                      label: 'Plan',
                      value: user?.plan?.toUpperCase() ?? 'STANDARD',
                      valueColor: colorScheme.primary,
                    ),
                    _ProfileTile(
                      icon: Icons.calendar_today,
                      label: 'Valid From',
                      value: _formatDate(user?.validFrom),
                    ),
                    _ProfileTile(
                      icon: Icons.event,
                      label: 'Valid To',
                      value: _formatDate(user?.validTo),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) return 'N/A';
    try {
      final dt = DateTime.parse(rawDate);
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) {
      return rawDate;
    }
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _ProfileTile({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Text(label, style: theme.textTheme.bodyMedium),
          const Spacer(),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
