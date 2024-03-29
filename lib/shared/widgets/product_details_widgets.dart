import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../data/models/product_model.dart';
import '../components.dart';
import '../constants.dart';
import '../helpers.dart';
import '../resources/color_manager.dart';
import 'app_buttons.dart';
import 'app_text.dart';
import 'bottom_sheet_widgets/scroll_top_sheet.dart';

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
  final Map<String, dynamic> specs;

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
  UserReviews({Key? key, required this.product}) : super(key: key);
  final ProductItemModel product;
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
                    text: product.rating.toString(),
                    size: 45,
                    color: ColorManager.dark,
                  ),
                  Container(
                    width: kWidth * 0.4,
                    child: Column(
                      children: [
                        kRatingIndicator(rating: product.rating),
                        SubtitleText(
                            text: "Based on ${product.reviews} ratings",
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
                    "There are ${product.reviews} customer ratings and ${product.comments.length} customer reviews",
                size: 14,
              ),
            ),
            kDivider(),
          ],
        ),
        ListView.separated(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => UserComment(
            name: product.comments[index].name!,
            comment: product.comments[index].comment!,
            rating: product.comments[index].rating!,
            date: product.comments[index].date!,
          ),
          separatorBuilder: (context, index) => Divider(
            color: ColorManager.gray,
            thickness: 0.4,
          ),
          itemCount: product.comments.length > 4 ? 4 : product.comments.length,
        ),
        Divider(
          color: ColorManager.gray,
          thickness: 0.4,
        ),
        if (product.comments.length > 4) ...[
          const SizedBox(height: 5),
          SolidButton(
            color: ColorManager.info,
            backgroundColor: Colors.white,
            borderColor: ColorManager.info,
            heightFactor: 0.04,
            widthFactor: 0.95,
            size: 12,
            radius: 4,
            text: "VIEW MORE",
            onTap: () {
              push(
                  context,
                  AllReviewView(
                    product: product,
                  ),
                  root: true);
            },
          ),
        ]
      ],
    );
  }
}

class AllReviewView extends StatelessWidget {
  AllReviewView({Key? key, required this.product}) : super(key: key);

  final ProductItemModel product;
  final scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                kHSeparator(),
                Image(
                  image: NetworkImage(product.imageUrl ?? ""),
                  width: kWidth * 0.17,
                  height: kHeight * 0.08,
                ),
                kHSeparator(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SubtitleText(
                      text: product.brandName ?? "",
                      size: 14,
                    ),
                    SizedBox(
                      width: kWidth * 0.7,
                      child: BodyText(
                        text: product.name ?? "",
                        color: ColorManager.dark,
                        size: 14,
                        maxLines: 2,
                      ),
                    ),
                  ],
                )
              ],
            ),
            kDivider(factor: 0.01),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BodyText(
                    text: "User Reviews",
                    color: ColorManager.black,
                  ),
                  Row(
                    children: [
                      BodyText(
                        text: product.rating.toString(),
                        size: 45,
                        color: ColorManager.black,
                      ),
                      Container(
                        width: kWidth * 0.4,
                        child: Column(
                          children: [
                            kRatingIndicator(rating: product.rating),
                            SubtitleText(
                                text: "Based on ${product.reviews} ratings",
                                size: 14),
                          ],
                        ),
                      )
                    ],
                  ),
                  kVSeparator(),
                  Column(
                    children: [
                      for (var i = 5; i >= 1; i--)
                        Row(
                          children: [
                            BodyText(text: "$i", color: ColorManager.black),
                            const SizedBox(width: 5),
                            Icon(Icons.star, color: Colors.amber),
                            const SizedBox(width: 5),
                            LinearPercentIndicator(
                              width: kWidth * 0.5,
                              lineHeight: 5.0,
                              percent: (product.ratingPercent[i] ?? 0) /
                                  product.reviews,
                              backgroundColor: ColorManager.gray,
                              progressColor: Colors.amber,
                            ),
                            const SizedBox(width: 5),
                            SubtitleText(
                                text: "(${product.ratingPercent[i] ?? 0})",
                                size: 12,
                                color: ColorManager.dark)
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
            kDivider(factor: 0.01),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: SubtitleText(
                text:
                    "There are ${product.reviews} customer ratings and ${product.comments.length} customer reviews",
                size: 12,
              ),
            ),
            kGrayDivider(),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
              child: BodyText(
                  text: "${product.comments.length} customer reviews",
                  color: ColorManager.black),
            ),
            kVSeparator(),
            ListView.separated(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => UserComment(
                name: product.comments[index].name!,
                comment: product.comments[index].comment!,
                rating: product.comments[index].rating!,
                date: product.comments[index].date!,
              ),
              separatorBuilder: (context, index) => Divider(
                color: ColorManager.gray,
                thickness: 0.4,
              ),
              itemCount: product.comments.length,
            ),
            kVSeparator(factor: 0.05),
          ],
        ),
      ),
      bottomSheet: ScrollToTopBottomSheet(
        controller: scrollController,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SolidButton(
              color: Colors.white,
              backgroundColor: Colors.black.withOpacity(0.4),
              text: "Back To Top",
              widthFactor: 0.35,
              heightFactor: 0.04,
              size: 12,
              isBold: false,
              withIcon: true,
              icon: FontAwesomeIcons.arrowUp,
              radius: 20,
              onTap: () {
                scrollController.animateTo(0,
                    duration: Duration(milliseconds: 400),
                    curve: Curves.easeInCubic);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class UserComment extends StatelessWidget {
  const UserComment(
      {Key? key,
      this.name = "Anonymous",
      required this.comment,
      required this.date,
      required this.rating})
      : super(key: key);

  final String name;
  final String comment;
  final double rating;
  final DateTime date;
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

  static Widget deliverBy({Duration? duration}) => Row(
        children: [
          Text(
            "Delivery by ",
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
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: ColorManager.dark,
                    fontSize: 15,
                  ),
                ),
                Spacer(),
                SizedBox(
                    width: kWidth * 0.3,
                    child: Text(
                      value,
                      style: kTheme.textTheme.headline5,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    )),
              ],
            ),
          ),
          kDivider(opacity: 0.4),
        ],
      );

  static String shippingDate(Duration duration, {DateTime? dateTime}) {
    if (dateTime == null)
      return DateFormat('EEE, d MMM ').format(DateTime.now().add(duration));
    return DateFormat('EEE, d MMM ').format(dateTime.add(duration));
  }

  static dateDuration(DateTime date) => Jiffy(date, "yyyy-MM-dd").fromNow();
}
