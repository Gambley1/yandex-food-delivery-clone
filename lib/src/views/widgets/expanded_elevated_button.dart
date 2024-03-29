import 'package:flutter/material.dart';
import 'package:papa_burger/src/views/widgets/k_text.dart';

class ExpandedElevatedButton extends StatelessWidget {
  const ExpandedElevatedButton({
    required this.label,
    this.onTap,
    this.icon,
    this.radius = 16,
    this.backgroundColor = Colors.transparent,
    this.elevation,
    this.textColor = Colors.white,
    this.size = 20,
    super.key,
  });

  ExpandedElevatedButton.inProgress({
    required double radius,
    required Color textColor,
    required Color backgroundColor,
    String label = '',
    double scale = 0.6,
    Key? key,
  }) : this(
          radius: radius,
          backgroundColor: backgroundColor,
          textColor: textColor,
          label: label,
          icon: Transform.scale(
            scale: scale,
            child: const CircularProgressIndicator(color: Colors.black),
          ),
          key: key,
        );
  final String label;
  final double radius;
  final double size;
  final Color textColor;
  final double? elevation;
  final Color backgroundColor;
  final Widget? icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final icon = this.icon;
    return SizedBox(
      height: 42,
      width: double.infinity,
      child: icon != null
          ? ElevatedButton.icon(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                elevation: elevation,
                backgroundColor: backgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radius),
                ),
              ),
              label: KText(
                text: label,
                size: size,
                color: textColor,
              ),
              icon: icon,
            )
          : ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: elevation,
                backgroundColor: backgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radius),
                ),
              ),
              onPressed: onTap,
              child: KText(
                text: label,
                size: size,
                color: textColor,
              ),
            ),
    );
  }
}
