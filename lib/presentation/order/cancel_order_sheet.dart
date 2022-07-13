import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/business_logic/shop_cubit/shop_cubit.dart';
import 'package:graduation_project/business_logic/shop_cubit/shop_states.dart';
import 'package:graduation_project/data/models/order_model.dart';
import 'package:graduation_project/shared/helpers.dart';
import 'package:graduation_project/shared/resources/color_manager.dart';
import 'package:graduation_project/shared/widgets/app_buttons.dart';
import 'package:graduation_project/shared/widgets/app_text.dart';
import 'package:graduation_project/shared/widgets/indicators.dart';

class CancelOrderMaterialSheet extends StatelessWidget {
  const CancelOrderMaterialSheet({Key? key, required this.orderModel})
      : super(key: key);
  final OrderModel orderModel;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Container(
          height: kHeight * 0.3,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 1.0,
                spreadRadius: 1.0,
                offset: Offset(1.0, 1.0),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BodyText(
                      text: "Are you Sure to Cancel this order?",
                      size: 18,
                      color: Colors.black,
                    ),
                    InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Icon(Icons.clear)),
                  ],
                ),
                const Spacer(flex: 4),
                SolidButton(
                  radius: 10,
                  text: "Don't Cancel",
                  color: Colors.black,
                  splashColor: ColorManager.primary,
                  heightFactor: 0.06,
                  widthFactor: 0.9,
                  backgroundColor: Colors.white,
                  borderColor: Colors.black45,
                  onTap: () => Navigator.pop(context),
                ),
                const SizedBox(height: 10),
                SolidButton(
                  radius: 10,
                  text: "Cancel Order",
                  color: ColorManager.error,
                  splashColor: ColorManager.primary,
                  heightFactor: 0.06,
                  widthFactor: 0.9,
                  backgroundColor: Colors.white,
                  borderColor: ColorManager.error,
                  child: state is ShopLoadingCancelOrderState
                      ? const MyLoadingIndicator(height: 20, width: 30)
                      : null,
                  onTap: () async {
                    await ShopCubit.get(context)
                        .cancelOrder(orderModel)
                        .then((value) => Navigator.pop(context));
                  },
                ),
                const Spacer(),
              ],
            ),
          ),
        );
      },
    );
  }
}
