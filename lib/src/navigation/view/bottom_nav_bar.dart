import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:papa_burger/src/config/config.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final navigationBarItems = mainNavigationBarItems(
      homeLabel: 'Home',
      cartLabel: 'Cart',
    );

    return BottomNavigationBar(
      iconSize: 28,
      currentIndex: navigationShell.currentIndex,
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        if (index != 1) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        } else {
          context.pushNamed(AppRoutes.cart.name);
        }
      },
      items: navigationBarItems
          .map(
            (e) => BottomNavigationBarItem(
              icon: e.child ?? Icon(e.icon),
              label: e.label,
              tooltip: e.tooltip,
            ),
          )
          .toList(),
    );
  }
}
