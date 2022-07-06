import 'package:flutter/material.dart';
import 'package:graduation_project/shared/constants.dart';

class BodyText extends StatelessWidget {
  final double size;
  final String text;
  final Color color;
  final TextAlign? align;
  final int? maxLines;
  final TextOverflow? overflow;
  const BodyText({
    Key? key,
    required this.text,
    this.size = 16,
    this.align,
    this.maxLines,
    this.overflow,
    this.color = Colors.black54,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: kTheme.textTheme.bodyText1!.copyWith(color: color, fontSize: size),
      textAlign: align,
      maxLines: this.maxLines,
      overflow: this.overflow,
    );
  }
}

class SubtitleText extends StatelessWidget {
  final double size;
  final String text;
  final Color color;
  final TextAlign? align;
  final int? maxLines;
  final TextOverflow? overflow;
  const SubtitleText({
    Key? key,
    required this.text,
    this.size = 16,
    this.align,
    this.maxLines,
    this.overflow,
    this.color = Colors.black54,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: kTheme.textTheme.subtitle1!.copyWith(fontSize: size, color: color),
      textAlign: align,
      overflow: this.overflow,
      maxLines: this.maxLines,
    );
  }
}
