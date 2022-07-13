import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dialogs/dialogs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/shared/resources/color_manager.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

var kSize, kHeight = 0.0, kWidth = 0.0;

Widget kGrayDivider({double factor = 0.02}) => Padding(
      padding: EdgeInsets.symmetric(vertical: kHeight * factor),
      child: Container(
        height: kHeight * factor,
        color: ColorManager.lightGray,
      ),
    );

Widget kDivider({double factor = 0.005, double opacity = 1}) => Padding(
      padding: EdgeInsets.symmetric(vertical: kHeight * factor),
      child: Divider(
        color: ColorManager.subtitle.withOpacity(opacity),
      ),
    );

Widget kVerticalDivider() => VerticalDivider(
      color: ColorManager.gray,
      thickness: 1,
      indent: 30,
      endIndent: 30,
    );

Widget kVSeparator({double factor = 0.02}) => SizedBox(
      height: kHeight * factor,
    );
Widget kHSeparator({double factor = 0.02}) => SizedBox(
      width: kWidth * factor,
    );

String formatText(String? text) {
  if (text != null && text.length > 1) return text;
  return "";
}

String nameHandler(String name) {
  var split = name.split(" ");
  if (split[0].length > 15) return split[0].substring(0, 15);
  return split.length > 2 ? split.getRange(0, 2).join(" ") : split.join(" ");
}

String formatPrice(dynamic price) =>
    NumberFormat.simpleCurrency().format(price).replaceFirst("\$", "");

String parseDateTime(String date, {bool withTime = false}) {
  DateTime dateTime = DateTime.parse(date);
  return withTime
      ? DateFormat('MMM d, yyy, ').add_jm().format(dateTime)
      : DateFormat('MMM d, yyy').format(dateTime);
}

String delivery(String date, {bool withTime = false}) {
  DateTime dateTime = DateTime.parse(date);
  return withTime
      ? DateFormat('MMM d, yyy, ').add_jm().format(dateTime)
      : DateFormat('MMM d, yyy').format(dateTime);
}

String greetingMessage() {
  var hour = DateTime.now().hour;
  if (hour < 12) {
    return 'Good Morning';
  }
  if (hour < 17) {
    return 'Good Day';
  }
  return 'Good Evening';
}

void push(context, widget, {root = false}) =>
    Navigator.of(context, rootNavigator: root).push(PageRouteBuilder(
        transitionsBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secAnimation, Widget child) {
          var begin = Offset(1, 0);
          var end = Offset(0, 0);
          var tween = Tween(begin: begin, end: end);
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(
            position: offsetAnimation,
            child: widget,
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secAnimation) {
          return widget;
        }));

void pushScaleTransition(context, widget) => Navigator.push(
    context,
    PageRouteBuilder(
        transitionsBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secAnimation, Widget child) {
          var begin = Offset(1, 0);
          var end = Offset(0, 0);
          var tween = Tween(begin: begin, end: end);
          var offsetAnimation = animation.drive(tween);
          return ScaleTransition(
            alignment: Alignment.bottomCenter,
            scale: Tween<double>(begin: 0.1, end: 1).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutSine,
              ),
            ),
            child: widget,
          );
        },
        transitionDuration: Duration(milliseconds: 600),
        pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secAnimation) {
          return widget;
        }));

void pushReplacementScaleTransition(context, widget) =>
    Navigator.pushReplacement(
        context,
        PageRouteBuilder(
            transitionsBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secAnimation,
                Widget child) {
              var begin = Offset(1, 0);
              var end = Offset(0, 0);
              var tween = Tween(begin: begin, end: end);
              var offsetAnimation = animation.drive(tween);
              return ScaleTransition(
                alignment: Alignment.bottomCenter,
                scale: Tween<double>(begin: 0.1, end: 1).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutSine,
                  ),
                ),
                child: widget,
              );
            },
            transitionDuration: Duration(milliseconds: 600),
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secAnimation) {
              return widget;
            }));
void pushReplacement(context, widget) => Navigator.pushReplacement(
    context,
    PageRouteBuilder(
        transitionsBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secAnimation, Widget child) {
          var begin = Offset(1, 0);
          var end = Offset(0, 0);
          var tween = Tween(begin: begin, end: end);
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(
            position: offsetAnimation,
            child: widget,
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secAnimation) {
          return widget;
        }));
void pushReplacementNamed(context, route) =>
    Navigator.pushReplacementNamed(context, route);
void pushNamed(context, route) => Navigator.pushNamed(context, route);

showRequiredFieldsDialog(context) {
  final choice = MessageDialog(
    dialogBackgroundColor: Colors.white,
    title: "Fields are required",
    message: 'Please fill in all fields',
    buttonOkColor: ColorManager.primary,
    buttonOkText: 'OK',
  );
  choice.show(context, barrierColor: Colors.black12);
}

showEditInfoSheet(context, {required Widget child}) =>
    showCupertinoModalBottomSheet(
      expand: false,
      context: context,
      backgroundColor: Colors.white,
      barrierColor: Colors.white,
      builder: (context) => child,
    );

OrderStatus getOrderStatus(String? shipping) {
  switch (shipping?.toLowerCase()) {
    case "cancelled":
      return OrderStatus.Cancelled;
    case "processing":
      return OrderStatus.Processing;
    case "shipped":
      return OrderStatus.Shipped;
    case "delivered":
      return OrderStatus.Delivered;
    default:
      return OrderStatus.Ordered;
  }
}

enum OrderStatus {
  Ordered,
  Processing,
  Shipped,
  Delivered,
  Cancelled,
}
