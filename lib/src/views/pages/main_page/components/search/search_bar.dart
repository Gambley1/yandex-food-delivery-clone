import 'package:flutter/material.dart';
import 'package:papa_burger/src/restaurant.dart'
    show SearchView, HexColor, kDefaultSearchBarRadius, AppInputText;
import 'package:font_awesome_flutter/font_awesome_flutter.dart'
    show FontAwesomeIcons;
import 'package:page_transition/page_transition.dart'
    show PageTransition, PageTransitionType;

class SearchBar extends StatelessWidget {
  const SearchBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushAndRemoveUntil(
        context,
        PageTransition(
          child: const SearchView(),
          type: PageTransitionType.fade,
        ),
        (route) => true,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: HexColor('#EEEEEE'),
          borderRadius: BorderRadius.circular(kDefaultSearchBarRadius),
        ),
        child: const AppInputText(
          enabled: false,
          enabledBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          labelText: 'Search...',
          borderRadius: kDefaultSearchBarRadius,
          prefixIcon: Icon(
            FontAwesomeIcons.magnifyingGlass,
          ),
        ),
      ),
    );
  }
}
