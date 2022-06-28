import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graduation_project/data/models/comment_model.dart';
import 'package:graduation_project/shared/components.dart';
import 'package:graduation_project/shared/constants.dart';
import 'package:graduation_project/shared/helpers.dart';
import 'package:graduation_project/shared/resources/color_manager.dart';
import 'package:graduation_project/shared/widgets/app_text.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

class WarrantyWidget extends StatelessWidget {
  const WarrantyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kHeight * 0.15,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: kWidth * 0.2,
            height: kHeight * 0.13,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FaIcon(FontAwesomeIcons.squareCheck,
                    color: ColorManager.success),
                Text(
                  "1 Year \nWarranty",
                  style: kTheme.textTheme.caption,
                  textAlign: TextAlign.center,
                ),
                Text(
                  "Full Coverage",
                  style: kTheme.textTheme.subtitle1,
                ),
              ],
            ),
          ),
          kVerticalDivider(),
          Container(
            width: kWidth * 0.2,
            height: kHeight * 0.13,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FaIcon(FontAwesomeIcons.creditCard,
                    color: ColorManager.success),
                Text(
                  "Pay on \ndelivery",
                  style: kTheme.textTheme.caption,
                  textAlign: TextAlign.center,
                ),
                Text(
                  "Cash or card",
                  style: kTheme.textTheme.subtitle1,
                ),
              ],
            ),
          ),
          kVerticalDivider(),
          Container(
            width: kWidth * 0.2,
            height: kHeight * 0.13,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FaIcon(FontAwesomeIcons.rotate, color: ColorManager.success),
                Text(
                  "Return \nfor free",
                  style: kTheme.textTheme.caption,
                  textAlign: TextAlign.center,
                ),
                Text(
                  "Up to 30 days",
                  style: kTheme.textTheme.subtitle1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SpecificationExpansionList extends StatefulWidget {
  SpecificationExpansionList({Key? key, required this.specs}) : super(key: key);
  Map<String, dynamic> specs = {};

  @override
  State<SpecificationExpansionList> createState() =>
      _SpecificationExpansionListState();
}

class _SpecificationExpansionListState
    extends State<SpecificationExpansionList> {
  bool _isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return ListTileTheme(
      contentPadding: EdgeInsets.zero,
      child: ExpansionTile(
        title: Text(
          "Specification",
          style: kTheme.textTheme.bodyText1,
        ),
        trailing: AnimatedRotation(
          turns: _isExpanded ? .5 : 0,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOutSine,
          child: Icon(
            Icons.keyboard_arrow_down,
            size: 30,
            color: ColorManager.primary,
          ),
        ),
        onExpansionChanged: (isExpansion) =>
            setState(() => _isExpanded = isExpansion),
        iconColor: Colors.black,
        children: widget.specs.entries
            .map((entry) => ProductDetailsHelpers.specificationItem(
                title: entry.key, value: entry.value))
            .toList(),
      ),
    );
  }
}

class UserReviews extends StatelessWidget {
  UserReviews({Key? key, required this.comments, this.rating = 5})
      : super(key: key);
  List<CommentModel> comments = [];
  double rating;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BodyText(
                text: "User Reviews",
                color: ColorManager.dark,
              ),
              Row(
                children: [
                  BodyText(
                    text: rating.toString(),
                    size: 45,
                    color: ColorManager.dark,
                  ),
                  Container(
                    width: kWidth * 0.4,
                    child: Column(
                      children: [
                        kRatingIndicator(rating: rating),
                        SubtitleText(
                            text: "Based on ${comments.length} ratings",
                            size: 14),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(
              color: ColorManager.gray,
              thickness: 0.4,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: SubtitleText(
                text:
                    "There are ${comments.length} customer ratings and reviews",
                size: 14,
              ),
            ),
            Divider(
              color: ColorManager.gray,
              thickness: 0.4,
            ),
          ],
        ),
        ListView.separated(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => UserComment(
            name: comments[index].name!,
            comment: comments[index].comment!,
            rating: comments[index].rating!,
            date: comments[index].date!,
          ),
          separatorBuilder: (context, index) => Divider(
            color: ColorManager.gray,
            thickness: 0.4,
          ),
          itemCount: comments.length,
        ),
        Divider(
          color: ColorManager.gray,
          thickness: 0.4,
        ),
      ],
    );
  }
}

class UserComment extends StatelessWidget {
  const UserComment(
      {Key? key,
      this.name = "Anonymous",
      required this.comment,
      this.date = "2022-4-1",
      required this.rating})
      : super(key: key);

  final String name;
  final String comment;
  final double rating;
  final String date;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BodyText(
                text: name,
                color: ColorManager.black,
                size: 14,
              ),
              Row(
                children: [
                  FaIcon(
                    FontAwesomeIcons.solidCircleCheck,
                    color: ColorManager.info,
                    size: 12,
                  ),
                  const SizedBox(width: 5),
                  BodyText(
                    text: "Verified Purchase",
                    color: ColorManager.black,
                    size: 14,
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              kRatingIndicator(size: 17, rating: rating),
              SubtitleText(text: ProductDetailsHelpers.dateDuration(date)),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            comment,
            style: TextStyle(
              color: ColorManager.black,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class ProductDetailsHelpers {
  static Widget deliveryAddressWidget(String address) => Row(
        children: [
          Text("Delivery to:  ",
              style: TextStyle(
                color: ColorManager.dark,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              )),
          Text(address,
              style: kTheme.textTheme.headline5!
                  .copyWith(color: ColorManager.info)),
        ],
      );

  static Widget deliveryTime({Duration? duration}) => Row(
        children: [
          FaIcon(FontAwesomeIcons.truck),
          const SizedBox(width: 8),
          Text(
            "Doorstep delivery, by ",
            style: TextStyle(
              color: ColorManager.dark,
              fontSize: 14,
            ),
          ),
          Text(shippingDate(duration ?? Duration(days: 3)),
              style: kTheme.textTheme.headline5!
                  .copyWith(color: ColorManager.success)),
        ],
      );

  static Widget specificationItem({title, value}) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: ColorManager.dark,
                    fontSize: 15,
                  ),
                ),
                Text(value, style: kTheme.textTheme.headline5),
              ],
            ),
          ),
          kDivider(opacity: 0.4),
        ],
      );

  static String shippingDate(Duration duration) =>
      DateFormat('EEE, d MMM ').format(DateTime.now().add(duration));

  static dateDuration(String date) => Jiffy(date, "yyyy-MM-dd").fromNow();
}
