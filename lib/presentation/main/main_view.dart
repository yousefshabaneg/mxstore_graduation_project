import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';

import '../../business_logic/account_cubit/account_cubit.dart';
import '../../business_logic/app_cubit/app_cubit.dart';
import '../../business_logic/app_cubit/app_states.dart';
import '../../business_logic/shop_cubit/shop_cubit.dart';
import '../../business_logic/shop_cubit/shop_states.dart';
import '../../business_logic/user_cubit/user_cubit.dart';
import '../../business_logic/user_cubit/user_states.dart';
import '../../shared/components.dart';
import '../../shared/constants.dart';
import '../../shared/widgets/indicators.dart';
import '../../shared/widgets/no_connection_widget.dart';

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
                    ..getPaymentMethods()
                    ..getUserOrders(),
                  child: BlocConsumer<ShopCubit, ShopStates>(
                    listener: (context, state) {
                      if (state is ShopSuccessChangeFavoritesState) {
                        showToast(
                            msg: ShopCubit.get(context)
                                .changeFavoritesModel!
                                .message!,
                            state: ToastStates.success);
                      }

                      if (state is ShopSuccessAddToCartState ||
                          state is ShopSuccessRemoveFromCartState)
                        showToast(
                            msg: ShopCubit.get(context).successMessage,
                            state: ToastStates.success);

                      if (state is ShopErrorAddToCartState ||
                          state is ShopErrorChangeFavoritesState ||
                          state is ShopErrorRemoveFromCartState)
                        showToast(
                            msg: ShopCubit.get(context).errorMessage,
                            state: ToastStates.error);
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
