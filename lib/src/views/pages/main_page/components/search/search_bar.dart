import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'
    show FontAwesomeIcons;
import 'package:papa_burger/src/restaurant.dart'
    show
        AppInputText,
        NavigatorExtension,
        kDefaultSearchBarRadius,
        searchFoodLabel;

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({
    super.key,
    this.withNavigation = true,
    this.enabled = true,
    this.labelText = searchFoodLabel,
    this.onChanged,
    this.controller,
  });

  final bool withNavigation;
  final bool enabled;
  final String labelText;
  final TextEditingController? controller;
  final dynamic Function(String term)? onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: withNavigation ? context.navigateToSearchView : () {},
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(kDefaultSearchBarRadius),
        ),
        child: AppInputText(
          enabled: enabled,
          textController: controller,
          enabledBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          hintText: labelText,
          onChanged: onChanged,
          borderRadius: kDefaultSearchBarRadius,
          prefixIcon: const Icon(
            FontAwesomeIcons.magnifyingGlass,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
