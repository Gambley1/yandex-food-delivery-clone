import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:papa_burger/src/config/config.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class DrawerView extends StatelessWidget {
  const DrawerView({super.key});

  void Function()? _drawerOptionAction(
    BuildContext context,
    DrawerOption name,
  ) =>
      switch (name) {
        DrawerOption.orders => () => context.pushNamed(AppRoutes.orders.name),
        DrawerOption.profile => () => context.pushNamed(AppRoutes.profile.name),
      };

  IconData _drawerOptionIcon(DrawerOption name) => switch (name) {
        DrawerOption.profile => LucideIcons.user,
        DrawerOption.orders => LucideIcons.shoppingCart,
      };

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      width: context.screenWidth * 0.7,
      child: ListView(
        children: [
          DrawerHeader(
            child: Row(
              children: [
                Text('Papa', style: context.headlineMedium),
                Assets.images.papaBurgerLogo.image(height: 60, width: 60),
                Text('Burger', style: context.headlineMedium),
              ],
            ),
          ),
          ...DrawerOption.values.map(
            (option) => ListTile(
              horizontalTitleGap: AppSpacing.sm,
              onTap: _drawerOptionAction(context, option),
              leading: AppIcon(icon: _drawerOptionIcon(option)),
              title: Text(option.name),
            ),
          ),
        ],
      ),
    );
  }
}
