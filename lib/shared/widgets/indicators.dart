import 'package:flutter/material.dart';
import 'package:graduation_project/shared/helpers.dart';
import 'package:graduation_project/shared/resources/color_manager.dart';
import 'package:loading_indicator/loading_indicator.dart';

class MyLoadingIndicator extends StatelessWidget {
  MyLoadingIndicator({
    Key? key,
    this.indicatorType = Indicator.ballSpinFadeLoader,
    this.height,
    this.width,
    this.color,
  }) : super(key: key);
  Indicator indicatorType;
  final double? width;
  final Color? color;
  final double? height;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: width ?? kWidth / 6,
        height: height ?? kHeight / 8,
        child: LoadingIndicator(
          indicatorType: indicatorType,
          colors: [
            color ?? ColorManager.primary,
          ],
        ),
      ),
    );
  }
}
