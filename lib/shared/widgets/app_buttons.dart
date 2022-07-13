import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graduation_project/shared/helpers.dart';
import 'package:graduation_project/shared/resources/color_manager.dart';
import 'package:graduation_project/shared/widgets/app_text.dart';

class SolidButton extends StatelessWidget {
  SolidButton({
    Key? key,
    required this.color,
    this.backgroundColor,
    this.disabledColor,
    this.splashColor = Colors.white,
    this.borderColor = Colors.transparent,
    this.radius = 15,
    this.child,
    this.size = 18,
    this.text = "Save",
    this.shape,
    this.heightFactor = 1,
    this.widthFactor = 1,
    this.onTap,
    this.withIcon = false,
    this.isDisabled = false,
    this.isBold = true,
    this.icon,
  }) : super(key: key);
  final Color color;
  final Color splashColor;
  final bool isBold;
  final String text;
  final Color? backgroundColor;
  final Color? disabledColor;
  final Color borderColor;
  final double radius;
  final double heightFactor;
  final double widthFactor;
  final ShapeBorder? shape;
  final Widget? child;
  final double size;
  bool withIcon;
  bool isDisabled;
  IconData? icon;
  GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: kWidth * widthFactor,
      height: kHeight * heightFactor,
      child: MaterialButton(
        splashColor: splashColor,
        clipBehavior: Clip.antiAlias,
        elevation: 0,
        shape: shape ??
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
              side: BorderSide(color: borderColor, width: 0.7),
            ),
        color: backgroundColor ?? ColorManager.primary,
        textColor: Colors.white,
        onPressed: onTap,
        disabledTextColor: ColorManager.white,
        disabledColor: disabledColor ?? ColorManager.primary.withOpacity(0.4),
        child: child ??
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (withIcon)
                  Row(
                    children: [
                      FaIcon(icon, color: color, size: size),
                      kHSeparator(),
                    ],
                  ),
                Text(
                  text,
                  style: TextStyle(
                      fontSize: size,
                      color: color,
                      fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
                ),
              ],
            ),
      ),
    );
  }
}

class MyOutButton extends StatelessWidget {
  MyOutButton({
    required this.color,
    this.disabledColor,
    this.backgroundColor,
    this.splashColor = Colors.white,
    this.size = 18,
    this.text = "Save",
    this.heightFactor = 0.05,
    this.widthFactor = 0.2,
    this.onTap,
    this.withIcon = false,
    this.isDisabled = false,
    this.icon,
  });
  final Color color;
  final Color splashColor;
  final String text;
  final Color? disabledColor;
  final Color? backgroundColor;
  final double heightFactor;
  final double widthFactor;
  final double size;
  bool withIcon;
  bool isDisabled;
  IconData? icon;
  GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      splashColor: splashColor,
      color: backgroundColor ?? ColorManager.primary,
      minWidth: kWidth * widthFactor,
      height: kHeight * heightFactor,
      textColor: Colors.white,
      onPressed: onTap,
      disabledTextColor: ColorManager.white,
      disabledColor: disabledColor ?? ColorManager.primary.withOpacity(0.4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (withIcon)
            Row(
              children: [
                FaIcon(icon, color: color, size: size),
                kHSeparator(),
              ],
            ),
          Text(
            text,
            style: TextStyle(fontSize: size, color: color),
          ),
        ],
      ),
    );
  }
}

class MyTextButton extends StatelessWidget {
  MyTextButton({
    required this.color,
    this.disabledColor,
    this.backgroundColor,
    this.splashColor = Colors.white,
    this.size = 18,
    this.text = "Save",
    this.heightFactor = 0.05,
    this.widthFactor = 0.2,
    this.onTap,
    this.withIcon = false,
    this.isDisabled = false,
    this.icon,
  });
  final Color color;
  final Color splashColor;
  final String text;
  final Color? disabledColor;
  final Color? backgroundColor;
  final double heightFactor;
  final double widthFactor;
  final double size;
  bool withIcon;
  bool isDisabled;
  IconData? icon;
  GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (withIcon)
            Row(
              children: [
                FaIcon(icon, color: color, size: size),
                kHSeparator(),
              ],
            ),
          Text(
            text,
            style: TextStyle(fontSize: size, color: color),
          ),
        ],
      ),
    );
  }
}
