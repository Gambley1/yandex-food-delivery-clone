import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class MenuSectionHeader extends StatelessWidget {
  const MenuSectionHeader({
    required this.categoryName,
    required this.isSectionEmpty,
    required this.categoryHeight,
    super.key,
  });

  final String categoryName;
  final bool isSectionEmpty;
  final double categoryHeight;

  @override
  Widget build(BuildContext context) {
    return isSectionEmpty
        ? const SliverToBoxAdapter()
        : SliverPadding(
            padding: const EdgeInsets.only(
              left: AppSpacing.md,
              top: AppSpacing.md,
            ),
            sliver: SliverToBoxAdapter(
              child: SizedBox(
                height: categoryHeight,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    categoryName,
                    style: context.headlineMedium
                        ?.copyWith(fontWeight: AppFontWeight.bold),
                  ),
                ),
              ),
            ),
          );
  }
}
