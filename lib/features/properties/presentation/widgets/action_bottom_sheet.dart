import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/property_entity.dart';
import '../pages/add_edit_properties.dart';
import '../../../../shared/dialogs/confirmation_dialog.dart';
import '../providers/properties_provider.dart';

/// Bottom sheet shown when the user taps the three-dot (⋮) icon on a property
/// card. Opened with [useRootNavigator: true] so it renders above the
/// BottomNavigationBar.
class ActionBottomSheet extends ConsumerWidget {
  final PropertyEntity property;

  const ActionBottomSheet({super.key, required this.property});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Drag handle ─────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Container(
                width: 50,
                height: 4,
                decoration: BoxDecoration(
                  color: cs.onSurface.withAlpha(60),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // ── Title ────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                'Property Actions',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: cs.onSurface,
                ),
              ),
            ),

            // ── Edit ─────────────────────────────────────────
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: cs.primary.withAlpha(20),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.edit_outlined, color: cs.primary, size: 20),
              ),
              title: Text(
                'Edit Property',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: cs.onSurface,
                ),
              ),
              subtitle: Text(
                'Update property details',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: cs.onSurface.withAlpha(140),
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
                showDialog(
                  context: context,
                  useSafeArea: false,
                  builder: (_) => AddEditPropertiesPage(
                    propertyId: property.id,
                    editingProperty: property,
                  ),
                );
              },
            ),

            // ── Delete ───────────────────────────────────────
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: cs.error.withAlpha(20),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.delete_outline, color: cs.error, size: 20),
              ),
              title: Text(
                'Delete Property',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: cs.error,
                ),
              ),
              subtitle: Text(
                'Permanently remove this property',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: cs.onSurface.withAlpha(140),
                ),
              ),
              onTap: () async {
                // ⚠️  Capture everything from ref/context BEFORE the first
                // async gap. After Navigator.pop() the ConsumerWidget is
                // disposed and `ref` becomes invalid.
                final messenger = ScaffoldMessenger.of(context);
                final notifier = ref.read(propertiesProvider.notifier);
                final errorColor = cs.error;
                Navigator.of(context).pop();

                final confirmed = await showConfirmationDialog(
                  context: context,
                  title: 'Delete Property?',
                  message:
                      'The property "${property.name}" will be permanently deleted. This action cannot be undone.',
                  confirmLabel: 'Delete',
                  cancelLabel: 'Cancel',
                  isDestructive: true,
                  icon: Icon(Icons.warning_rounded, size: 28, color: errorColor),
                );

                if (confirmed == true) {
                  await notifier.deleteProperty(property.id);

                  // Read state via the container – safe even after disposal
                  // because we use the captured notifier's last emitted state.
                  final currentState = notifier.state;

                  if (currentState.failure != null) {
                    messenger.showSnackBar(
                      SnackBar(
                        content: Text(currentState.failure!.message),
                        backgroundColor: errorColor,
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  } else {
                    messenger.showSnackBar(
                      const SnackBar(
                        content: Text('Property deleted successfully'),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                }
              },
            ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
