import 'package:flutter/material.dart';
import 'package:graduation_project/data/models/basket_model.dart';
import 'package:graduation_project/shared/helpers.dart';
import 'package:graduation_project/shared/resources/color_manager.dart';
import 'package:graduation_project/shared/widgets/app_text.dart';
import 'package:graduation_project/shared/widgets/product_details_widgets.dart';

class OrderSummaryItem extends StatelessWidget {
  OrderSummaryItem({Key? key, required this.product}) : super(key: key);
  final BasketProductModel product;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: kWidth * 0.6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SubtitleText(
                    text: product.brandName!,
                    color: ColorManager.subtitle,
                    size: 14,
                  ),
                  SizedBox(height: 5),
                  BodyText(
                    text: product.name!,
                    color: ColorManager.dark,
                    size: 14,
                  ),
                  SizedBox(height: 5),
                  Text(
                    "EGP ${formatPrice(product.price!)}",
                    style: TextStyle(
                      fontSize: 20,
                      color: ColorManager.dark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SubtitleText(text: "QTY ${this.product.quantity}"),
                ],
              ),
            ),
            Image(
              image: NetworkImage(product.imageUrl!),
              width: kWidth * 0.25,
              height: kHeight * 0.1,
            ),
          ],
        ),
        kVSeparator(),
        ProductDetailsHelpers.deliveryTime(),
      ],
    );
  }
}
