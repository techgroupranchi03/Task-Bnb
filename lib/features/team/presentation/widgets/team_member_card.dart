import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../domain/entities/team_member_entity.dart';
import '../../../../core/utils/app_date_formatter.dart';

class TeamMemberCard extends StatelessWidget {
  final TeamMemberEntity member;

  const TeamMemberCard({super.key, required this.member});

  String get _initials {
    final parts = member.name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts[0].isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  Future<void> _makePhoneCall(BuildContext context, String rawPhone) async {
    final cleaned = rawPhone.replaceAll(RegExp(r'[^\d+]'), '');
    if (cleaned.isEmpty) return;
    final uri = Uri.parse('tel:$cleaned');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Unable to open phone dialer for $rawPhone')),
          );
        }
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unable to open phone dialer for $rawPhone')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final isMemberActive = member.isActive;

    // Status chip colors
    final statusBgColor = isMemberActive
        ? (isDark ? const Color(0xFF1B382B) : const Color(0xFFE8F5E9))
        : (isDark ? cs.surfaceContainerHighest : cs.outline.withAlpha(30));

    final statusTextColor = isMemberActive
        ? (isDark ? const Color(0xFF81C784) : const Color(0xFF2E7D32))
        : cs.onSurface.withAlpha(153);

    // Formatted phone number display
    final displayPhone = member.phone.startsWith('+')
        ? member.phone
        : '+91 ${member.phone}';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: cs.outline.withAlpha(isDark ? 77 : 153),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 51 : 10),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ── Header Row: Avatar, Name/Role, Status Badge ────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Default Initials Circle Avatar using cs.primary
                CircleAvatar(
                  radius: 24,
                  backgroundColor: cs.primary,
                  child: Text(
                    _initials,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: cs.onPrimary,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Name & Role
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        member.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: cs.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        member.role,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: cs.onSurface.withAlpha(153),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                // Status Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusBgColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    member.status.isEmpty
                        ? (isMemberActive ? 'Active' : 'Inactive')
                        : '${member.status[0].toUpperCase()}${member.status.substring(1)}',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: statusTextColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // ── Bottom Row: Phone info & Call button ────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Phone & Last login info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayPhone,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: cs.onSurface,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        AppDateFormatter.formatLastLogin(member.lastLogin),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: cs.onSurface.withAlpha(140),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),

                // Dial Call Icon Button
                Material(
                  color: cs.primary,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    onTap: () => _makePhoneCall(context, member.phone),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 46,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.call_rounded,
                        color: cs.onPrimary,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
