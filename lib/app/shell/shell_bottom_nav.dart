import 'package:flutter/material.dart';

class ShellBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabTapped;
  final bool isVisible;

  const ShellBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTabTapped,
    required this.isVisible,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final navBarHeight = 56.0 + bottomPadding;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      height: isVisible ? navBarHeight : 0,
      child: OverflowBox(
        maxHeight: navBarHeight,
        alignment: Alignment.topCenter,
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTabTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home_work_outlined),
              activeIcon: Icon(Icons.home_work),
              label: 'Properties',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.inventory_2_outlined),
              activeIcon: Icon(Icons.inventory_2),
              label: 'Inventory',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.group_outlined),
              activeIcon: Icon(Icons.group),
              label: 'Team',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.task_outlined),
              activeIcon: Icon(Icons.task),
              label: 'Tasks',
            ),
          ],
        ),
      ),
    );
  }
}
