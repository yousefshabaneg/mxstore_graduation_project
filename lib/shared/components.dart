import 'package:bot_toast/bot_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../data/models/brand_model.dart';
import '../data/models/category_model.dart';
import 'constants.dart';
import 'helpers.dart';
import 'resources/color_manager.dart';
import 'widgets/filtered_item_view.dart';
import 'widgets/indicators.dart';

void showToast({
  required String msg,
  required ToastStates state,
  double fontSize = 16,
  int seconds = 3,
}) =>
    BotToast.showText(
      text: msg,
      duration: Duration(seconds: seconds),
      contentColor: toastColor(state),
      clickClose: true,
      align: const Alignment(0, -1),
    );

enum ToastStates { success, error, warning }

Color toastColor(ToastStates state) {
  switch (state) {
    case ToastStates.success:
      return Colors.green;
    case ToastStates.error:
      return Colors.red;
    case ToastStates.warning:
      return Colors.yellow;
  }
}

Widget lvCategories(context, List<CategoryModel> categories) => Padding(
      padding: EdgeInsets.symmetric(horizontal: kWidth * 0.05),
      child: SizedBox(
        height: kHeight * 0.12,
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) => Container(
            margin: EdgeInsets.only(right: kWidth * 0.06),
            child: InkWell(
              onTap: () {
                push(
                    context,
                    FilteredProductView(
                      filteredModel: categories[index],
                      categoryId: categories[index].id,
                    ));

                // Navigator.pushNamed(context, Routes.categories);
              },
              child: Column(
                children: [
                  Container(
                    width: kHeight * 0.08,
                    height: kHeight * 0.08,
                    decoration: BoxDecoration(
                      color: ColorManager.info.withOpacity(0.5),
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: ColorManager.info.withOpacity(0.5), width: 1),
                    ),
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: categories[index].image,
                        placeholder: (context, url) => const MyLoadingIndicator(
                          circular: true,
                        ),
                      ),
                    ),
                  ),
                  kVSeparator(factor: 0.005),
                  Text(
                    categories[index].name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: kTheme.textTheme.subtitle1,
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          ),
          itemCount: categories.length,
        ),
      ),
    );

Widget lvBrands(context, List<BrandModel> brands) => Padding(
      padding: EdgeInsets.symmetric(horizontal: kWidth * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Top Brands",
            style: kTheme.textTheme.headline2,
          ),
          kVSeparator(factor: 0.03),
          SizedBox(
            height: kHeight * 0.15,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => InkWell(
                onTap: () => push(
                  context,
                  FilteredProductView(
                    filteredModel: brands[index],
                    brandId: brands[index].id,
                  ),
                ),
                child: Container(
                  margin: EdgeInsets.only(right: kWidth * 0.05),
                  child: Column(
                    children: [
                      CachedNetworkImage(
                        imageUrl: brands[index].image,
                        width: kWidth * 0.15,
                        height: kWidth * 0.15,
                        placeholder: (context, url) => const MyLoadingIndicator(
                          circular: true,
                        ),
                      ),
                      kVSeparator(factor: 0.02),
                      Text(
                        brands[index].name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: kTheme.textTheme.subtitle1,
                      ),
                    ],
                  ),
                ),
              ),
              itemCount: brands.length,
            ),
          ),
        ],
      ),
    );

Widget kRatingBar() => RatingBar.builder(
      glow: false,
      initialRating: 3,
      itemSize: 25,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: Colors.amber,
      ),
      unratedColor: ColorManager.gray,
      onRatingUpdate: (rating) {},
    );
Widget kRatingIndicator({double size = 25.0, double rating = 5.0}) =>
    RatingBarIndicator(
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: Colors.amber,
      ),
      itemSize: size,
      direction: Axis.horizontal,
      itemCount: 5,
      unratedColor: ColorManager.gray,
      rating: rating,
    );

Widget validationRow({required bool condition, required String message}) => Row(
      children: [
        Container(
          width: kWidth * 0.04,
          height: kWidth * 0.04,
          decoration: BoxDecoration(
            color: condition ? Colors.green : Colors.red,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              condition ? Icons.check : Icons.clear,
              color: Colors.white,
              size: 15,
            ),
          ),
        ),
        kHSeparator(),
        Text(message,
            style:
                kTheme.textTheme.caption!.copyWith(color: ColorManager.black))
      ],
    );
