import 'package:flutter/material.dart';
import 'package:graduation_project/shared/helpers.dart';
import 'package:graduation_project/shared/resources/color_manager.dart';
import 'package:loading_indicator/loading_indicator.dart';

class MyLoadingIndicator extends StatefulWidget {
  const MyLoadingIndicator({
    Key? key,
    this.height,
    this.width,
    this.color,
    this.circular = false,
  }) : super(key: key);
  final double? width;
  final Color? color;
  final double? height;
  final bool circular;

  @override
  State<MyLoadingIndicator> createState() => _MyLoadingIndicatorState();
}

class _MyLoadingIndicatorState extends State<MyLoadingIndicator> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: widget.width ?? kWidth / 6,
        height: widget.height ?? kHeight / 8,
        child: LoadingIndicator(
          indicatorType: widget.circular
              ? Indicator.ballSpinFadeLoader
              : Indicator.ballBeat,
          colors: [
            widget.color ?? ColorManager.gray,
          ],
        ),
      ),
    );
  }
}
