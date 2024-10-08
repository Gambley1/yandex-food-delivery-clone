import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class RestaurantsNoInternetView extends StatelessWidget {
  const RestaurantsNoInternetView({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      sliver: SliverList.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xlg),
            child: ShimmerPlaceholder(
              height: 160,
              borderRadius:
                  BorderRadius.circular(AppSpacing.md + AppSpacing.sm),
              width: double.infinity,
            ),
          );
        },
      ),
    );
  }
}
