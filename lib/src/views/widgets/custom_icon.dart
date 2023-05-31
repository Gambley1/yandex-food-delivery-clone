import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart' show FaIcon;

enum IconType {
  iconButton,
  simpleIcon,
}

class CustomIcon extends StatelessWidget {
  const CustomIcon({
    required this.icon,
    required IconType type,
    super.key,
    this.color = Colors.black,
    this.splashRadius = 18,
    this.onPressed,
    this.size = 22,
  }) : _type = type;

  final double splashRadius;
  final IconData icon;
  final VoidCallback? onPressed;
  final double size;
  final Color color;
  final IconType? _type;

  @override
  Widget build(BuildContext context) {
    return _type == IconType.iconButton
        ? GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onPressed ?? () {},
            child: IconButton(
              splashRadius: splashRadius,
              onPressed: onPressed ?? () {},
              icon: FaIcon(
                icon,
                size: size,
                color: color,
              ),
            ),
          )
        : _type == IconType.simpleIcon
            ? FaIcon(
                color: color,
                icon,
                size: size,
              )
            : Container();
  }
}
