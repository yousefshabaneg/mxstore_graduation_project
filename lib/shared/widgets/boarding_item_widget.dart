import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:graduation_project/data/models/boarding_model.dart';
import 'package:graduation_project/shared/constants.dart';
import 'package:graduation_project/shared/helpers.dart';
import 'package:graduation_project/shared/resources/color_manager.dart';
import 'package:graduation_project/shared/widgets/app_text.dart';

class BoardingItem extends StatelessWidget {
  late OnBoardingModel model;
  BoardingItem({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipPath(
          clipper: OvalBottomBorderClipper(),
          child: Container(
            height: kHeight * 0.6,
            width: kWidth,
            child: Image.asset(model.image, fit: BoxFit.cover),
          ),
        ),
        Spacer(flex: 2),
        Container(
          child: Text(
            model.title,
            style: kTheme.textTheme.headline1!.copyWith(
              color: ColorManager.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Spacer(flex: 1),
        Container(
          width: kWidth * 0.7,
          child: SubtitleText(
            text: model.subTitle,
            size: 16,
            color: ColorManager.white,
            align: TextAlign.center,
          ),
        ),
        Spacer(flex: 4),
      ],
    );
  }
}
