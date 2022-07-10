import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:graduation_project/business_logic/account_cubit/account_cubit.dart';
import 'package:graduation_project/business_logic/app_cubit/app_cubit.dart';
import 'package:graduation_project/business_logic/app_cubit/app_states.dart';
import 'package:graduation_project/business_logic/shop_cubit/shop_cubit.dart';
import 'package:graduation_project/business_logic/shop_cubit/shop_states.dart';
import 'package:graduation_project/business_logic/user_cubit/user_cubit.dart';
import 'package:graduation_project/business_logic/user_cubit/user_states.dart';
import 'package:graduation_project/shared/components.dart';
import 'package:graduation_project/shared/constants.dart';
import 'package:graduation_project/shared/helpers.dart';
import 'package:graduation_project/shared/resources/assets_manager.dart';
import 'package:graduation_project/shared/widgets/app_text.dart';
import 'package:graduation_project/shared/widgets/indicators.dart';
import 'package:graduation_project/shared/widgets/no_connection_widget.dart';

class MainView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OfflineBuilder(
      connectivityBuilder: (
        BuildContext context,
        ConnectivityResult connectivity,
        Widget child,
      ) {
        final bool connected = connectivity != ConnectivityResult.none;
        if (connected) {
          return BlocProvider.value(
            value: BlocProvider.of<UserCubit>(context)..getUserData(),
            child: BlocConsumer<UserCubit, UserStates>(
              listener: (context, state) {
                if (state is GetUserDataSuccessState) {
                  ShopCubit.get(context).getBasket();
                }
              },
              builder: (context, state) => BlocProvider.value(
                value: BlocProvider.of<AccountCubit>(context)
                  ..getUserAddress(context),
                child: BlocProvider.value(
                  value: BlocProvider.of<ShopCubit>(context)
                    ..getEverything()
                    ..getFavorites()
                    ..getDeliveryMethods()
                    ..getPaymentMethods(),
                  child: BlocConsumer<ShopCubit, ShopStates>(
                    listener: (context, state) {
                      if (state is ShopSuccessChangeFavoritesState) {
                        showToast(
                            msg: ShopCubit.get(context)
                                .changeFavoritesModel!
                                .message!,
                            state: ToastStates.SUCCESS);
                      }

                      if (state is ShopSuccessAddToCartState ||
                          state is ShopSuccessRemoveFromCartState)
                        showToast(
                            msg: ShopCubit.get(context).successMessage,
                            state: ToastStates.SUCCESS);

                      if (state is ShopErrorAddToCartState ||
                          state is ShopErrorChangeFavoritesState ||
                          state is ShopErrorRemoveFromCartState)
                        showToast(
                            msg: ShopCubit.get(context).errorMessage,
                            state: ToastStates.ERROR);
                    },
                    builder: (context, state) =>
                        BlocConsumer<AppCubit, AppStates>(
                      listener: (context, state) {},
                      builder: (context, state) {
                        var cubit = AppCubit.get(context);
                        return CupertinoTabScaffold(
                          controller: tabController,
                          tabBar: kCupertinoTabBar(cubit.currentIndex),
                          tabBuilder: (context, index) =>
                              kCupertinoTabBuilder(context, index),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          );
        }
        return NoConnectionWidget();
      },
      child: MyLoadingIndicator(),
    );
  }
}
