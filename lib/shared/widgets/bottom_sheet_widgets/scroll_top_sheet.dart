import 'package:flutter/material.dart';
import 'package:graduation_project/shared/helpers.dart';

class ScrollToTopBottomSheet extends StatefulWidget {
  const ScrollToTopBottomSheet(
      {Key? key,
      required this.child,
      required this.controller,
      this.duration = const Duration(milliseconds: 100)})
      : super(key: key);

  final Widget child;
  final ScrollController controller;
  final Duration duration;

  @override
  State<ScrollToTopBottomSheet> createState() => _ScrollToTopBottomSheetState();
}

class _ScrollToTopBottomSheetState extends State<ScrollToTopBottomSheet> {
  bool isVisible = false;

  @override
  void initState() {
    widget.controller.addListener(listen);
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.removeListener(listen);
    super.dispose();
  }

  void listen() {
    if (widget.controller.position.pixels > kHeight)
      show();
    else
      hide();
  }

  void show() {
    if (!isVisible) setState(() => isVisible = true);
  }

  void hide() {
    if (isVisible) setState(() => isVisible = false);
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: AnimatedContainer(
          duration: widget.duration,
          child: widget.child,
          height: isVisible ? kHeight * 0.04 : 0,
        ),
      );
}
