import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../helpers.dart';
import '../resources/assets_manager.dart';
import '../resources/color_manager.dart';
import 'app_text.dart';

class SearchNotFoundWidget extends StatelessWidget {
  const SearchNotFoundWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: kHeight * 0.3,
              child: SvgPicture.asset(ImageAssets.search),
            ),
            BodyText(
              text: "Sorry, no results found",
              color: ColorManager.dark,
            ),
            const FractionallySizedBox(
              widthFactor: 0.7,
              child: SubtitleText(
                text:
                    "What you searched was unfortunately not found or doesn't exist",
                align: TextAlign.center,
                size: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
