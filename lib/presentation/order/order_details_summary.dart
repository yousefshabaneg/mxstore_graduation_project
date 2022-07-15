import 'package:flutter/material.dart';

import '../../data/models/order_model.dart';
import '../../shared/helpers.dart';
import '../../shared/resources/color_manager.dart';
import '../../shared/widgets/app_text.dart';
import '../../shared/widgets/product_details_widgets.dart';

class OrderDetailsSummaryItem extends StatelessWidget {
  const OrderDetailsSummaryItem(
      {Key? key, required this.orderItem, required this.orderModel})
      : super(key: key);
  final OrderItems orderItem;
  final OrderModel orderModel;
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
                  BodyText(
                    text: orderItem.productName ?? "",
                    color: ColorManager.dark,
                    size: 14,
                  ),
                  SizedBox(height: 5),
                  Text(
                    "EGP ${formatPrice(orderItem.price!.toInt())}",
                    style: TextStyle(
                      fontSize: 20,
                      color: ColorManager.dark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SubtitleText(text: "QTY ${this.orderItem.quantity}"),
                ],
              ),
            ),
            Image(
              image: NetworkImage(orderItem.pictureUrl ?? ""),
              width: kWidth * 0.25,
              height: kHeight * 0.1,
            ),
          ],
        ),
        if (orderModel.orderStatus != OrderStatus.cancelled &&
            orderModel.orderStatus != OrderStatus.delivered) ...[
          kVSeparator(),
          ProductDetailsHelpers.deliverBy(),
        ]
      ],
    );
  }
}
