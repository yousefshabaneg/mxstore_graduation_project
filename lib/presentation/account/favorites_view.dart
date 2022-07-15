import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../business_logic/shop_cubit/shop_cubit.dart';
import '../../business_logic/shop_cubit/shop_states.dart';
import '../../shared/constants.dart';
import '../../shared/helpers.dart';
import '../../shared/resources/assets_manager.dart';
import '../../shared/resources/color_manager.dart';
import '../../shared/widgets/app_buttons.dart';
import '../../shared/widgets/app_text.dart';
import '../../shared/widgets/grid_product_item_widget.dart';
import '../../shared/widgets/indicators.dart';

class FavoritesView extends StatelessWidget {
  FavoritesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: customAppBar(context, "My saved items"),
      child: SafeArea(
        child: BlocConsumer<ShopCubit, ShopStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
              backgroundColor:
                  ShopCubit.get(context).favoritesProducts.isNotEmpty
                      ? ColorManager.lightGray
                      : ColorManager.white,
              body: ShopCubit.get(context).favoritesProducts.isNotEmpty
                  ? Stack(
                      children: [
                        ProductsItemsGridBuilder(
                            products: ShopCubit.get(context).favoritesProducts),
                        if (state is ShopLoadingChangeFavoritesState)
                          const MyLoadingIndicator(
                            circular: true,
                          ),
                      ],
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            ImageAssets.wishlist,
                            width: kWidth * 0.4,
                            height: kHeight * 0.2,
                          ),
                          kVSeparator(),
                          BodyText(
                            text: "Your wishlist is empty!",
                            size: 24,
                            color: ColorManager.black,
                          ),
                          kVSeparator(factor: 0.01),
                          SubtitleText(
                            text:
                                "seems like you don't have wishes here. \nMake a wish!",
                            color: ColorManager.subtitle,
                            align: TextAlign.center,
                          ),
                          kVSeparator(),
                          SolidButton(
                            radius: 10,
                            text: "Start Shopping",
                            heightFactor: 0.07,
                            backgroundColor: Colors.white,
                            color: ColorManager.black,
                            widthFactor: 0.9,
                            borderColor: ColorManager.black,
                            onTap: () {
                              tabController.index = 0;
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),
            );
          },
        ),
      ),
    );
  }
}
