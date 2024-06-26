import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shared/shared.dart';

class DiscountCard extends StatelessWidget {
  const DiscountCard({
    required this.discounts,
    super.key,
  });

  final List<int> discounts;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: discounts.map(
            (discount) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md - 6,
                    ),
                    margin: const EdgeInsets.symmetric(
                      vertical: AppSpacing.md - 6,
                    ),
                    height: MenuBloc.discountHeight,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue.shade200,
                          Colors.blue.shade300,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(
                        28,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                              colors: [
                                Colors.lightBlue.shade400,
                                Colors.lightBlue.shade100,
                              ],
                            ),
                          ),
                          child: const AppIcon(
                            icon: LucideIcons.percent,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        const Text('Discount on several items'),
                        const SizedBox(width: AppSpacing.sm),
                        Text('$discount%', style: context.bodyLarge),
                      ],
                    ),
                  ),
                ],
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}
