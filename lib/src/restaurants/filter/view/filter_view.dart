import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

class FilterView extends StatelessWidget {
  const FilterView({required this.tags, super.key});

  final List<Tag> tags;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Cuisines and dishes',
                style: context.headlineSmall,
              ),
              Wrap(
                spacing: 10,
                children: tags.map((e) {
                  final imageUrl = e.imageUrl;
                  final name = e.name;
                  return Column(
                    children: [
                      AppCachedImage(
                        height: 80,
                        width: 80,
                        imageUrl: imageUrl,
                        imageType: CacheImageType.sm,
                      ),
                      Text(name),
                    ],
                  );
                }).toList(),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
