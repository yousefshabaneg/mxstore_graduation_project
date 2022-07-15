import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../shared/helpers.dart';
import '../../shared/resources/assets_manager.dart';
import '../../shared/resources/color_manager.dart';
import '../../shared/widgets/app_buttons.dart';
import '../../shared/widgets/app_text.dart';

class ReviewSuccessfullyWidget extends StatelessWidget {
  const ReviewSuccessfullyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              ImageAssets.SuccessReview,
              height: kHeight * 0.3,
            ),
            kVSeparator(),
            BodyText(
              text: "Thank you for your review",
              color: ColorManager.black,
              size: 20,
            ),
            kVSeparator(),
            SizedBox(
              width: kWidth * 0.7,
              child: SubtitleText(
                text:
                    "We wil use your feedback to enhance your overall shopping experience",
                align: TextAlign.center,
                size: 14,
              ),
            ),
            kVSeparator(factor: 0.04),
            SolidButton(
              color: Colors.white,
              backgroundColor: ColorManager.blue,
              text: "BACK TO REVIEWS",
              size: 14,
              widthFactor: 0.4,
              heightFactor: 0.05,
              radius: 5,
              onTap: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
            kVSeparator(),
            SolidButton(
              color: Colors.black87,
              backgroundColor: Colors.white,
              text: "BACK TO ORDER",
              borderColor: Colors.grey.shade500,
              size: 14,
              widthFactor: 0.4,
              heightFactor: 0.05,
              radius: 5,
              onTap: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          ],
        ),
      ),
    );
  }
}
