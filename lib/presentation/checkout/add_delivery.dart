import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graduation_project/business_logic/shop_cubit/shop_cubit.dart';
import 'package:graduation_project/business_logic/shop_cubit/shop_states.dart';
import 'package:graduation_project/shared/helpers.dart';
import 'package:graduation_project/shared/resources/color_manager.dart';
import 'package:graduation_project/shared/widgets/app_text.dart';
import 'package:graduation_project/shared/widgets/indicators.dart';

class DeliveryMethodView extends StatelessWidget {
  const DeliveryMethodView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) => ConditionalBuilder(
        condition: ShopCubit.get(context).deliveryMethods.isNotEmpty,
        builder: (context) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: BodyText(
                  text: "Choose Shipping Method",
                  color: ColorManager.error,
                  size: 18,
                ),
              ),
              SizedBox(
                height: kHeight * 0.5,
                child: ListView.separated(
                  itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: RadioListTile<int>(
                        value:
                            ShopCubit.get(context).deliveryMethods[index].id ??
                                1,
                        groupValue: ShopCubit.get(context).deliveryId,
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            BodyText(
                                text: ShopCubit.get(context)
                                    .deliveryMethods[index]
                                    .shortName!,
                                color: ColorManager.dark),
                            BodyText(
                              text:
                                  "${ShopCubit.get(context).deliveryMethods[index].price} EGP",
                              color: ColorManager.black,
                            ),
                          ],
                        ),
                        subtitle: SubtitleText(
                            text: ShopCubit.get(context)
                                .deliveryMethods[index]
                                .description!),
                        onChanged: (int? value) {
                          ShopCubit.get(context).changeDeliveryId(value);
                        },
                        contentPadding: EdgeInsets.zero,
                      )),
                  separatorBuilder: (context, state) => kDivider(factor: 0.001),
                  itemCount: ShopCubit.get(context).deliveryMethods.length,
                ),
              )
            ],
          ),
        ),
        fallback: (context) => Expanded(child: const MyLoadingIndicator()),
      ),
    );
  }
}
