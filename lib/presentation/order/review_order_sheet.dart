import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../business_logic/shop_cubit/shop_cubit.dart';
import '../../business_logic/shop_cubit/shop_states.dart';
import '../../data/models/order_model.dart';
import '../../shared/helpers.dart';
import '../../shared/resources/color_manager.dart';
import '../../shared/widgets/app_buttons.dart';
import 'order_details_summary.dart';
import 'submit_review_wiget.dart';

class ReviewOrderMaterialSheet extends StatelessWidget {
  const ReviewOrderMaterialSheet({Key? key, required this.orderModel})
      : super(key: key);
  final OrderModel orderModel;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(),
          body: Padding(
            padding: const EdgeInsets.all(12.0),
            child: ListView.separated(
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OrderDetailsSummaryItem(
                    orderItem: orderModel.orderItems![index],
                    orderModel: orderModel,
                  ),
                  kVSeparator(),
                  SolidButton(
                    color: ColorManager.white,
                    backgroundColor: ColorManager.blue,
                    withIcon: true,
                    icon: FontAwesomeIcons.thumbsUp,
                    heightFactor: 0.04,
                    widthFactor: 0.35,
                    radius: 4,
                    size: 12,
                    text: "Submit Review",
                    isBold: false,
                    onTap: () {
                      push(
                          context,
                          SubmitReviewWidget(
                            orderItem: orderModel.orderItems![index],
                            orderModel: orderModel,
                          ));
                    },
                  ),
                ],
              ),
              separatorBuilder: (context, index) =>
                  kDivider(factor: 0.02, opacity: 0.3),
              itemCount: orderModel.orderItems!.length,
            ),
          ),
        );
      },
    );
  }
}
