import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/shell/main_shell.dart';
import '../providers/properties_provider.dart';
import '../widgets/property_card.dart';
import 'add_edit_properties.dart';

class PropertiesPage extends ConsumerWidget {
  const PropertiesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(propertiesProvider);
    final searchQuery = ref.watch(shellSearchQueryProvider);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final filteredProperties =
        state.properties.where((prop) {
          if (searchQuery.trim().isEmpty) return true;
          final q = searchQuery.trim().toLowerCase();
          return prop.name.toLowerCase().contains(q) ||
              (prop.address?.toLowerCase().contains(q) ?? false);
        }).toList();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: _buildBody(context, ref, state, filteredProperties, theme, cs),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    PropertiesState state,
    List filteredProperties,
    ThemeData theme,
    ColorScheme cs,
  ) {
    // ── Loading ─────────────────────────────────────────────────────────────
    if (state.isLoading) {
      return Center(child: CircularProgressIndicator(color: cs.primary));
    }

    // ── Error ────────────────────────────────────────────────────────────────
    if (state.failure != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline_rounded, size: 56, color: cs.error),
              const SizedBox(height: 16),
              Text(
                'Failed to load properties',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: cs.onSurface,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                state.failure!.message,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: cs.onSurface.withAlpha(153),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed:
                    () =>
                        ref.read(propertiesProvider.notifier).fetchProperties(),
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: cs.primary,
                  foregroundColor: cs.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // ── Empty (no properties at all) ─────────────────────────────────────────
    if (state.properties.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.home_work_outlined, size: 64, color: cs.outline),
            const SizedBox(height: 16),
            Text(
              'No properties found',
              style: theme.textTheme.titleMedium?.copyWith(
                color: cs.onSurface.withAlpha(153),
              ),
            ),
          ],
        ),
      );
    }

    // ── Empty search result ──────────────────────────────────────────────────
    if (filteredProperties.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off_rounded, size: 56, color: cs.outline),
            const SizedBox(height: 16),
            Text(
              'No matching properties found',
              style: theme.textTheme.titleMedium?.copyWith(
                color: cs.onSurface.withAlpha(153),
              ),
            ),
          ],
        ),
      );
    }

    // ── List ──────────────────────────────────────────────────────────────────
    return RefreshIndicator(
      color: cs.primary,
      onRefresh: () => ref.read(propertiesProvider.notifier).fetchProperties(),
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 80),
        itemCount: filteredProperties.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              child: Row(
                children: [
                  Icon(Icons.home_work_rounded, size: 22, color: cs.primary),
                  const SizedBox(width: 10),
                  Text(
                    '${filteredProperties.length} '
                    'propert${filteredProperties.length == 1 ? 'y' : 'ies'}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: cs.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 24,
                      minHeight: 24,
                    ),
                    visualDensity: VisualDensity.compact,
                    onPressed: () {
                      showDialog(
                        context: context,
                        useSafeArea: false,
                        builder: (context) =>
                            const AddEditPropertiesPage(),
                      );
                    },
                    icon: Icon(
                      Icons.add_circle_outline_rounded,
                      size: 25,
                      color: cs.primary,
                    ),
                  ),
                ],
              ),
            );
          }

          return PropertyCard(property: filteredProperties[index - 1]);
        },
      ),
    );
  }
}
