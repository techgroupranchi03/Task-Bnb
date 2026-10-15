import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Welcome Card ──────────────────────────────────
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: theme.colorScheme.primary.withAlpha(30),
                      child: Icon(Icons.waving_hand, color: theme.colorScheme.primary),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Welcome back!', style: theme.textTheme.titleMedium),
                          const SizedBox(height: 4),
                          Text(
                            'Here\'s your activity overview',
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ── Stats Grid ────────────────────────────────────
            Text('Overview', style: theme.textTheme.titleLarge),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.5,
              children: [
                _StatCard(title: 'Total Tasks', value: '24', icon: Icons.task, color: theme.colorScheme.primary),
                _StatCard(title: 'Properties', value: '8', icon: Icons.home_work, color: const Color(0xFF7C3AED)),
                _StatCard(title: 'Team', value: '12', icon: Icons.group, color: const Color(0xFF059669)),
                _StatCard(title: 'Inventory', value: '156', icon: Icons.inventory_2, color: const Color(0xFFF59E0B)),
              ],
            ),
            const SizedBox(height: 20),

            // ── Recent Activity ───────────────────────────────
            Text('Recent Activity', style: theme.textTheme.titleLarge),
            const SizedBox(height: 12),
            ...List.generate(3, (i) {
              final items = [
                ('Task assigned: Clean Room 204', Icons.task_alt, '2 min ago'),
                ('New property added: Villa Azure', Icons.home_work, '15 min ago'),
                ('Inventory restocked: Towels +50', Icons.inventory, '1 hr ago'),
              ];
              final (label, icon, time) = items[i];
              return Card(
                child: ListTile(
                  leading: Icon(icon, color: theme.colorScheme.primary),
                  title: Text(label, style: theme.textTheme.bodyMedium),
                  subtitle: Text(time, style: theme.textTheme.bodySmall),
                  trailing: const Icon(Icons.chevron_right),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 28),
                Text(value, style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            Text(title, style: theme.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
