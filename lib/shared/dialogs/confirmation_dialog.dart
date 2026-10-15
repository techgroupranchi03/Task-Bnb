import 'package:flutter/material.dart';
import '../widgets/app_button.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';

/// Reusable confirmation dialog for destructive actions (delete, etc.)
///
/// Usage:
/// ```dart
/// final result = await showConfirmationDialog(
///   context: context,
///   title: 'Delete Property?',
///   message: 'This action cannot be undone.',
///   confirmLabel: 'Delete',
///   isDestructive: true,
/// );
/// if (result == true) {
///   // Handle deletion
/// }
/// ```
Future<bool?> showConfirmationDialog({
  required BuildContext context,
  required String title,
  required String message,
  String confirmLabel = 'Confirm',
  String cancelLabel = 'Cancel',
  bool isDestructive = false,
  Widget? icon,
}) async {
  final theme = Theme.of(context);
  final cs = theme.colorScheme;

  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
        backgroundColor: cs.surface,
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Icon (if provided) ──────────────────────────
              if (icon != null) ...[
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        isDestructive
                            ? AppColors.error.withAlpha(20)
                            : cs.primary.withAlpha(20),
                  ),
                  child: Center(child: icon),
                ),
                const SizedBox(height: AppSpacing.lg),
              ],

              // ── Title ────────────────────────────────────
              Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: cs.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),

              // ── Message ──────────────────────────────────
              Text(
                message,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: cs.onSurface.withAlpha(179),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),

              // ── Buttons ──────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Cancel button
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.md,
                        ),
                        side: BorderSide(color: cs.outline.withAlpha(102)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radiusSm,
                          ),
                        ),
                      ),
                      child: Text(
                        cancelLabel,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: cs.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),

                  // Confirm buttondfsdfsad fsdfdsf
                  Expanded(
                    child: GradientButton(
                      label: confirmLabel,
                      onPressed: () => Navigator.of(context).pop(true),
                      height: 48,
                      gradientStartColor: cs.primary,
                      gradientEndColor: cs.secondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
