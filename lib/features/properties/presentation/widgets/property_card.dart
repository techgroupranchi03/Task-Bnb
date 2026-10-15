import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../domain/entities/property_entity.dart';
import 'action_bottom_sheet.dart';

class PropertyCard extends StatelessWidget {
  final PropertyEntity property;

  const PropertyCard({super.key, required this.property});

  Future<void> _openGoogleMap(BuildContext context) async {
    if (!property.hasGoogleMapLink) return;
    final uri = Uri.parse(property.googleMapLink!);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open map link')),
        );
      }
    }
  }

  void _showActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      // useRootNavigator: true pushes the sheet to the root navigator so it
      // renders ABOVE the BottomNavigationBar
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ActionBottomSheet(property: property),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.colorScheme.outline, width: 1),
      ),
      color: theme.colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Property Image with three-dot overlay ────────────
          Stack(
            children: [
              if (property.hasImage)
                CachedNetworkImage(
                  imageUrl: property.propertyImageUrl!,
                  height: 170,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder:
                      (context, url) => Container(
                        height: 170,
                        color: theme.colorScheme.primary.withAlpha(15),
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                  errorWidget:
                      (context, url, error) => Container(
                        height: 140,
                        color: theme.colorScheme.primary.withAlpha(20),
                        child: Center(
                          child: Icon(
                            Icons.home_work_outlined,
                            size: 48,
                            color: theme.colorScheme.primary.withAlpha(128),
                          ),
                        ),
                      ),
                )
              else
                Container(
                  height: 120,
                  width: double.infinity,
                  color: theme.colorScheme.primary.withAlpha(20),
                  child: Center(
                    child: Icon(
                      Icons.home_work_outlined,
                      size: 48,
                      color: theme.colorScheme.primary.withAlpha(128),
                    ),
                  ),
                ),

              // ── Three-dot menu button (top-right corner) ─────
              Positioned(
                top: 8,
                right: 8,
                child: Material(
                  color: Colors.black.withAlpha(110),
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () => _showActionSheet(context),
                    child: const Padding(
                      padding: EdgeInsets.all(6),
                      child: Icon(
                        Icons.more_vert,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // ── Details Section ──────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name
                Text(
                  property.name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                // Address (only if exists & non-empty)
                if (property.hasAddress) ...[
                  const SizedBox(height: 6),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          property.address!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withAlpha(179),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],

                // Google Map Link Button (only if exists & non-empty)
                if (property.hasGoogleMapLink) ...[
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: OutlinedButton.icon(
                      onPressed: () => _openGoogleMap(context),
                      icon: Icon(
                        Icons.map_outlined,
                        size: 16,
                        color: theme.colorScheme.primary,
                      ),
                      label: Text(
                        'View on Map',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        side: BorderSide(
                          color: theme.colorScheme.primary.withAlpha(102),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
