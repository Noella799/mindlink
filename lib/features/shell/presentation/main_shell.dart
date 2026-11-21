import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindlink/features/check_in/presentation/screens/check_in_screen.dart';
import 'package:mindlink/features/home/presentation/screens/home_screen.dart';
import 'package:mindlink/features/shell/presentation/nav_provider.dart';
import 'package:mindlink/features/support/presentation/screens/support_screen.dart';

/// Signed-in layout with the three main tabs.
/// Bottom navigation bar in portrait; side navigation rail in landscape
/// and on wide screens, so the content keeps its height.
class MainShell extends ConsumerWidget {
  const MainShell({super.key});

  static const _pages = <Widget>[HomeScreen(), CheckInScreen(), SupportScreen()];

  static const _items = [
    (icon: Icons.home_outlined, selectedIcon: Icons.home_rounded, label: 'Home'),
    (icon: Icons.edit_note_outlined, selectedIcon: Icons.edit_note_rounded, label: 'Check-in'),
    (icon: Icons.support_outlined, selectedIcon: Icons.support_rounded, label: 'Support'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tab = ref.watch(navControllerProvider);
    final nav = ref.read(navControllerProvider.notifier);
    void onSelect(int index) => nav.select(MainTab.values[index]);

    // IndexedStack keeps each tab's state (e.g. half-finished check-in).
    final body = IndexedStack(index: tab.index, children: _pages);

    return LayoutBuilder(
      builder: (context, constraints) {
        final useRail = constraints.maxWidth >= 640;

        if (useRail) {
          return Scaffold(
            body: Row(
              children: [
                SafeArea(
                  right: false,
                  child: NavigationRail(
                    selectedIndex: tab.index,
                    onDestinationSelected: onSelect,
                    labelType: NavigationRailLabelType.all,
                    destinations: [
                      for (final item in _items)
                        NavigationRailDestination(
                          icon: Icon(item.icon),
                          selectedIcon: Icon(item.selectedIcon),
                          label: Text(item.label),
                        ),
                    ],
                  ),
                ),
                const VerticalDivider(width: 1),
                Expanded(child: body),
              ],
            ),
          );
        }

        return Scaffold(
          body: body,
          bottomNavigationBar: NavigationBar(
            selectedIndex: tab.index,
            onDestinationSelected: onSelect,
            destinations: [
              for (final item in _items)
                NavigationDestination(
                  icon: Icon(item.icon),
                  selectedIcon: Icon(item.selectedIcon),
                  label: item.label,
                ),
            ],
          ),
        );
      },
    );
  }
}
