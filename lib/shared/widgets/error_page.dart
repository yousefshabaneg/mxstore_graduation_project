import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:graduation_project/shared/constants.dart';
import 'package:graduation_project/shared/helpers.dart';
import 'package:graduation_project/shared/resources/assets_manager.dart';
import 'package:graduation_project/shared/resources/color_manager.dart';
import 'package:graduation_project/shared/widgets/app_buttons.dart';

class Error404Page extends StatelessWidget {
  Error404Page({Key? key}) : super(key: key);
  String headline = "I have bad news for you";
  String caption =
      "The page you are looking for might be removed or is temporarily unavailable.";
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SvgPicture.asset(
              ImageAssets.error,
              fit: BoxFit.cover,
              height: kHeight * 0.5,
            ),
            Text(
              headline,
              style: kTheme.textTheme.headline2!
                  .copyWith(color: ColorManager.error),
            ),
            kVSeparator(factor: 0.01),
            Text(
              caption,
              style: kTheme.textTheme.subtitle1!.copyWith(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            kVSeparator(factor: 0.03),
            SolidButton(
              color: ColorManager.white,
              widthFactor: 0.4,
              heightFactor: 0.05,
              backgroundColor: ColorManager.primary,
              text: "Go to home.",
              onTap: () => tabController.index = 0,
            ),
          ],
        ),
      ),
    );
  }
}
