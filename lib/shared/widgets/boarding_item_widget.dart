import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
        Spacer(flex: 4),
        SvgPicture.asset(model.image, height: 300),
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
