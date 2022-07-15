import 'package:flutter/material.dart';

import '../../helpers.dart';

class CartBottomSheet extends StatefulWidget {
  CartBottomSheet(
      {Key? key,
      required this.child,
      required this.controller,
      this.duration = const Duration(milliseconds: 100)})
      : super(key: key);

  final Widget child;
  final ScrollController controller;
  final Duration duration;

  @override
  State<CartBottomSheet> createState() => _CartBottomSheetState();
}

class _CartBottomSheetState extends State<CartBottomSheet> {
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
  Widget build(BuildContext context) => AnimatedContainer(
        duration: widget.duration,
        height: isVisible ? kHeight * 0.1 : 0,
        width: kWidth,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 1.0,
              spreadRadius: 1.0,
              offset: Offset(1.0, 1.0), // shadow direction: bottom right
            ),
          ],
        ),
        child: widget.child,
      );
}
