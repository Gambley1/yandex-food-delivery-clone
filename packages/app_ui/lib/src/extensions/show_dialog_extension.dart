// ignore_for_file: public_member_api_docs

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

extension ShowDialogExtension on BuildContext {
  Future<bool?> showCustomDialog({
    required void Function() onTap,
    required String alertText,
    required String actionText,
    String cancelText = 'Cancel',
  }) {
    return showDialog<bool>(
      context: this,
      builder: (context) {
        return AlertDialog(
          content: Text(alertText),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.lg + AppSpacing.xxs),
          ),
          contentPadding: const EdgeInsets.all(AppSpacing.md),
          actions: [
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => context.pop(),
                    child: DialogButton(
                      borderRadius:
                          BorderRadius.circular(AppSpacing.lg + AppSpacing.xxs),
                      padding: const EdgeInsets.all(AppSpacing.md),
                      colorDecoration: Colors.grey.shade200,
                      text: cancelText,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: GestureDetector(
                    onTap: onTap,
                    child: DialogButton(
                      borderRadius:
                          BorderRadius.circular(AppSpacing.lg + AppSpacing.xxs),
                      padding: const EdgeInsets.all(AppSpacing.md),
                      colorDecoration: AppColors.indigo,
                      text: actionText,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class DialogButton extends StatelessWidget {
  const DialogButton({
    required this.padding,
    required this.borderRadius,
    required this.text,
    required this.colorDecoration,
    super.key,
  });

  final BorderRadiusGeometry borderRadius;
  final String text;
  final Color colorDecoration;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Padding(
        padding: padding,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colorDecoration,
            borderRadius: borderRadius,
          ),
          child: LimitedBox(
            child: Center(child: Text(text, style: context.bodyLarge)),
          ),
        ),
      ),
    );
  }
}
