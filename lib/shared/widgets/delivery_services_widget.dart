import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graduation_project/shared/helpers.dart';
import 'package:graduation_project/shared/resources/color_manager.dart';
import 'package:graduation_project/shared/widgets/app_text.dart';

class DeliveryServices extends StatelessWidget {
  const DeliveryServices({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: FaIcon(FontAwesomeIcons.creditCard, size: 22),
              ),
              kHSeparator(factor: 0.04),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BodyText(
                    text: "Pay on delivery",
                    color: ColorManager.black,
                  ),
                  SubtitleText(
                    text: "For all orders",
                    color: ColorManager.black,
                  ),
                ],
              )
            ],
          ),
        ),
        Divider(
          color: ColorManager.gray,
          indent: kWidth * 0.1,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: FaIcon(FontAwesomeIcons.arrowsRotate, size: 22),
              ),
              kHSeparator(factor: 0.04),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BodyText(
                    text: "Return policy",
                    color: ColorManager.black,
                  ),
                  Container(
                    width: kWidth * 0.8,
                    child: SubtitleText(
                      text:
                          "Most products can be returned within 30 days of delivery",
                      color: ColorManager.black,
                      size: 14,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        Divider(
          color: ColorManager.gray,
          indent: kWidth * 0.1,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: FaIcon(FontAwesomeIcons.circleQuestion, size: 22),
              ),
              kHSeparator(factor: 0.04),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BodyText(
                    text: "Need Help?",
                    color: ColorManager.black,
                  ),
                  SubtitleText(
                    text: "www.mx-store.com",
                    color: ColorManager.info,
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
