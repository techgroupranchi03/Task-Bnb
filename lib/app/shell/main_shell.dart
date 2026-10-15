import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'app_drawer.dart';
import 'shell_appbar.dart';
import 'shell_bottom_nav.dart';

final mainScaffoldKeyProvider = Provider((ref) => GlobalKey<ScaffoldState>());

/// Controls whether the app bar & bottom nav are visible.
/// Both [ShellAppBar] and [ShellBottomNav] react to this provider.
final barsVisibleProvider = StateProvider<bool>((ref) => true);

/// The currently active search query — written by [ShellAppBar] via
/// [onSearchChanged], read by tab pages that support search.
final shellSearchQueryProvider = StateProvider<String>((ref) => '');

// ── Per-tab config ────────────────────────────────────────────────────────────
typedef _TabConfig = ({String title, bool showSearch, String searchHint});

const _tabConfigs = <_TabConfig>[
  (title: 'Dashboard', showSearch: false, searchHint: ''),
  (title: 'Properties', showSearch: true, searchHint: 'Search properties...'),
  (title: 'Inventory', showSearch: false, searchHint: ''),
  (title: 'Team', showSearch: true, searchHint: 'Search team members...'),
  (title: 'Tasks', showSearch: false, searchHint: ''),
];

class MainShell extends ConsumerStatefulWidget {
  final StatefulNavigationShell navigationShell;

  const MainShell({super.key, required this.navigationShell});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  bool _barsVisible = true;

  void _setVisible(bool visible) {
    if (_barsVisible == visible) return;
    setState(() => _barsVisible = visible);
    ref.read(barsVisibleProvider.notifier).state = visible;
  }

  void _onTabTapped(int index) {
    // Always show bars and clear search when switching tabs.
    _setVisible(true);
    ref.read(shellSearchQueryProvider.notifier).state = '';
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  bool _onScrollNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      final delta = notification.scrollDelta ?? 0;
      final offset = notification.metrics.pixels;

      // Snap back to visible when at the very top.
      if (offset <= 0) {
        _setVisible(true);
        return false;
      }
      // Hide on scroll-down, show on scroll-up.
      if (delta > 6) {
        _setVisible(false);
      } else if (delta < -6) {
        _setVisible(true);
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = ref.watch(mainScaffoldKeyProvider);
    final tabIndex = widget.navigationShell.currentIndex;
    final config = _tabConfigs[tabIndex];

    return Scaffold(
      key: scaffoldKey,
      // extendBody lets the body render behind the bottom nav so that
      // when the nav animates to height 0 there is no black gap.
      extendBody: true,
      drawer: const AppDrawer(),
      body: Column(
        children: [
          // ── Shell-level AppBar ─────────────────────────────────────────────
          // Placed here (not in Scaffold's appBar: param) so that when it
          // animates to height 0 the Expanded navigation shell fills the freed
          // space immediately — no blank gap, identical to ShellBottomNav.
          ShellAppBar(
            title: config.title,
            showSearch: config.showSearch,
            searchHint: config.searchHint,
            onSearchChanged: (q) =>
                ref.read(shellSearchQueryProvider.notifier).state = q,
            onSearchCleared: () =>
                ref.read(shellSearchQueryProvider.notifier).state = '',
          ),
          // ── Page body ─────────────────────────────────────────────────────
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: _onScrollNotification,
              child: widget.navigationShell,
            ),
          ),
        ],
      ),
      bottomNavigationBar: ShellBottomNav(
        currentIndex: tabIndex,
        onTabTapped: _onTabTapped,
        isVisible: _barsVisible,
      ),
    );
  }
}
