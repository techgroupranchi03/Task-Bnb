import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/shell/main_shell.dart';
import '../../domain/entities/team_member_entity.dart';
import '../providers/team_provider.dart';
import '../widgets/team_member_card.dart';

class TeamPage extends ConsumerStatefulWidget {
  const TeamPage({super.key});

  @override
  ConsumerState<TeamPage> createState() => _TeamPageState();
}

class _TeamPageState extends ConsumerState<TeamPage> {
  String _selectedRole = 'All';

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(teamProvider);
    final searchQuery = ref.watch(shellSearchQueryProvider);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // ── Role Counts ──────────────────────────────────────────────────────────
    final allMembers = state.members;
    final Map<String, int> roleCounts = {'All': allMembers.length};
    for (final m in allMembers) {
      final role = m.role.trim();
      if (role.isNotEmpty) roleCounts[role] = (roleCounts[role] ?? 0) + 1;
    }

    // ── Filter Members ───────────────────────────────────────────────────────
    final filteredMembers = allMembers.where((member) {
      if (_selectedRole != 'All' &&
          member.role.toLowerCase() != _selectedRole.toLowerCase()) {
        return false;
      }
      if (searchQuery.trim().isNotEmpty) {
        final q = searchQuery.trim().toLowerCase();
        return member.name.toLowerCase().contains(q) ||
            member.role.toLowerCase().contains(q) ||
            member.phone.toLowerCase().contains(q);
      }
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: _buildBody(
          context, state, roleCounts, filteredMembers, theme, cs, isDark),
    );
  }

  Widget _buildBody(
    BuildContext context,
    TeamState state,
    Map<String, int> roleCounts,
    List<TeamMemberEntity> filteredMembers,
    ThemeData theme,
    ColorScheme cs,
    bool isDark,
  ) {
    // ── Loading ──────────────────────────────────────────────────────────────
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
              Text('Failed to load team members',
                  style: theme.textTheme.titleMedium?.copyWith(
                      color: cs.onSurface, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text(state.failure!.message,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: cs.onSurface.withAlpha(153)),
                  textAlign: TextAlign.center),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () =>
                    ref.read(teamProvider.notifier).fetchTeamMembers(),
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: cs.primary,
                  foregroundColor: cs.onPrimary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // ── Empty (no members at all) ────────────────────────────────────────────
    if (state.members.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.group_outlined, size: 64, color: cs.outline),
            const SizedBox(height: 16),
            Text('No team members found',
                style: theme.textTheme.titleMedium
                    ?.copyWith(color: cs.onSurface.withAlpha(153))),
          ],
        ),
      );
    }

    // ── Filter chips + cards in a single scrollable ──────────────────────────
    return RefreshIndicator(
      color: cs.primary,
      onRefresh: () => ref.read(teamProvider.notifier).fetchTeamMembers(),
      child: CustomScrollView(
        slivers: [
          // Filter Chips Row
          SliverToBoxAdapter(
            child: SizedBox(
              height: 52,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 6),
                children: roleCounts.entries.map((entry) {
                  final role = entry.key;
                  final count = entry.value;
                  final isSelected = _selectedRole == role;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      selected: isSelected,
                      showCheckmark: false,
                      label: Text('$role $count'),
                      labelStyle: theme.textTheme.labelMedium?.copyWith(
                        color: isSelected
                            ? cs.onPrimary
                            : cs.onSurface.withAlpha(204),
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                      selectedColor: cs.primary,
                      backgroundColor:
                          isDark ? cs.surfaceContainerHigh : cs.surface,
                      side: isSelected
                          ? BorderSide.none
                          : BorderSide(color: cs.outline.withAlpha(77)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      onSelected: (_) =>
                          setState(() => _selectedRole = role),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Empty filter/search result
          if (filteredMembers.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.search_off_rounded,
                        size: 56, color: cs.outline),
                    const SizedBox(height: 16),
                    Text('No matching team members found',
                        style: theme.textTheme.titleMedium
                            ?.copyWith(color: cs.onSurface.withAlpha(153))),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.only(top: 4, bottom: 80),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) =>
                      TeamMemberCard(member: filteredMembers[index]),
                  childCount: filteredMembers.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
