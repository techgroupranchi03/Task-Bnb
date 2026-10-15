import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'main_shell.dart';

/// Shell-level animated app bar.
///
/// When placed as a direct child of a Column in the shell body (not as
/// Scaffold's `appBar:` param), AnimatedContainer → height 0 truly frees
/// the space — no blank gap, exactly like [ShellBottomNav].
///
/// Built-in search mode: set [showSearch] true. The page reacts to
/// query changes via [onSearchChanged].
class ShellAppBar extends StatefulWidget {
  final String title;
  final bool showDrawerButton;
  final bool showSearch;
  final String searchHint;
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onSearchCleared;
  final List<Widget>? extraActions;

  const ShellAppBar({
    super.key,
    required this.title,
    this.showDrawerButton = true,
    this.showSearch = false,
    this.searchHint = 'Search...',
    this.onSearchChanged,
    this.onSearchCleared,
    this.extraActions,
  });

  @override
  State<ShellAppBar> createState() => _ShellAppBarState();
}

class _ShellAppBarState extends State<ShellAppBar> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openSearch() => setState(() => _isSearching = true);

  void _closeSearch() {
    _searchController.clear();
    widget.onSearchChanged?.call('');
    widget.onSearchCleared?.call();
    setState(() => _isSearching = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final topPadding = MediaQuery.of(context).padding.top;
    // Full height = status bar + toolbar
    final fullHeight = topPadding + kToolbarHeight;

    // ── Title widget ─────────────────────────────────────────────────────────
    Widget titleChild;
    if (_isSearching) {
      titleChild = SizedBox(
        height: 38,
        child: TextField(
          controller: _searchController,
          autofocus: true,
          style: theme.textTheme.bodyMedium?.copyWith(color: cs.onSurface),
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            hintText: widget.searchHint,
            hintStyle: theme.textTheme.bodyMedium
                ?.copyWith(color: cs.onSurface.withAlpha(128)),
            prefixIcon:
                Icon(Icons.search_rounded, size: 20, color: cs.primary),
            suffixIcon: _searchController.text.isNotEmpty
                ? GestureDetector(
                    onTap: () {
                      _searchController.clear();
                      widget.onSearchChanged?.call('');
                      setState(() {});
                    },
                    child: Icon(Icons.clear_rounded,
                        size: 18, color: cs.onSurface.withAlpha(153)),
                  )
                : null,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            filled: true,
            fillColor:
                cs.surfaceContainerHighest.withAlpha(isDark ? 102 : 153),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: cs.primary, width: 1.5),
            ),
          ),
          onChanged: (val) {
            widget.onSearchChanged?.call(val);
            setState(() {}); // rebuild to show/hide the clear button
          },
        ),
      );
    } else {
      titleChild = Text(widget.title,
          style:
              theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600));
    }

    // ── Actions ───────────────────────────────────────────────────────────────
    final actions = <Widget>[
      if (!_isSearching && widget.extraActions != null) ...widget.extraActions!,
      if (widget.showSearch)
        _isSearching
            ? IconButton(
                icon: const Icon(Icons.close_rounded),
                tooltip: 'Close search',
                onPressed: _closeSearch,
              )
            : IconButton(
                icon: const Icon(Icons.search_rounded),
                tooltip: 'Search',
                onPressed: _openSearch,
              ),
    ];

    return Consumer(
      builder: (context, ref, _) {
        final barsVisible = ref.watch(barsVisibleProvider);
        // Keep bar visible while user is actively searching.
        final effectiveVisible = barsVisible || _isSearching;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          // Collapses to 0 on scroll-down, exactly like ShellBottomNav.
          height: effectiveVisible ? fullHeight : 0,
          child: OverflowBox(
            maxHeight: fullHeight,
            alignment: Alignment.topCenter,
            child: AppBar(
              title: titleChild,
              leading: _isSearching
                  ? null
                  : (widget.showDrawerButton
                      ? Builder(
                          builder: (ctx) => IconButton(
                            icon: const Icon(Icons.menu),
                            onPressed: () =>
                                ref.read(mainScaffoldKeyProvider)
                                    .currentState
                                    ?.openDrawer(),
                          ),
                        )
                      : null),
              automaticallyImplyLeading: false,
              actions: actions,
            ),
          ),
        );
      },
    );
  }
}
