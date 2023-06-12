import 'package:flutter/material.dart'
    show
        AlertDialog,
        AnnotatedRegion,
        BorderRadius,
        BuildContext,
        Colors,
        EdgeInsets,
        Expanded,
        GestureDetector,
        RoundedRectangleBorder,
        Row,
        SizedBox,
        showDialog;
import 'package:flutter/services.dart' show SystemUiOverlayStyle;
import 'package:papa_burger/src/config/utils/app_colors.dart';
import 'package:papa_burger/src/restaurant.dart'
    show CustomButtonInShowDialog, KText, MyThemeData, NavigatorExtension;

Future<dynamic> showCustomDialog(
  BuildContext context, {
  required void Function() onTap,
  required String alertText,
  required String actionText,
  String cancelText = 'Cancel',
  SystemUiOverlayStyle dialogTheme = MyThemeData.cartViewThemeData,
}) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: dialogTheme,
        child: AlertDialog(
          content: KText(
            text: alertText,
            maxLines: 3,
            size: 18,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          contentPadding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
          actions: [
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => context.pop(withHaptickFeedback: true),
                    child: CustomButtonInShowDialog(
                      borderRadius: BorderRadius.circular(18),
                      padding: const EdgeInsets.all(10),
                      colorDecoration: Colors.grey.shade200,
                      size: 18,
                      text: cancelText,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: onTap,
                    child: CustomButtonInShowDialog(
                      borderRadius: BorderRadius.circular(18),
                      padding: const EdgeInsets.all(10),
                      colorDecoration: kPrimaryBackgroundColor,
                      size: 18,
                      text: actionText,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
