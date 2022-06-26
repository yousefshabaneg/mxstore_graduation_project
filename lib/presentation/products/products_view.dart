import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/business_logic/search_cubit/search_cubit.dart';
import 'package:graduation_project/business_logic/shop_cubit/shop_cubit.dart';
import 'package:graduation_project/business_logic/shop_cubit/shop_states.dart';
import 'package:graduation_project/business_logic/user_cubit/user_cubit.dart';
import 'package:graduation_project/presentation/search/search_view.dart';
import 'package:graduation_project/shared/components.dart';
import 'package:graduation_project/shared/constants.dart';
import 'package:graduation_project/shared/helpers.dart';
import 'package:graduation_project/shared/resources/assets_manager.dart';
import 'package:graduation_project/shared/resources/color_manager.dart';
import 'package:graduation_project/shared/widgets/product_item_widget.dart';
import 'package:graduation_project/shared/widgets/shimmer_loading.dart';

class ProductsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = ShopCubit.get(context);
        var userModel = UserCubit.get(context).userModel;
        return ConditionalBuilder(
          condition: cubit.everythingIsLoaded(),
          builder: (context) => Scaffold(
            appBar: AppBar(toolbarHeight: 5, elevation: 1),
            body: SearchCubit.get(context).isSearching
                ? SearchView()
                : SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: kWidth * 0.04,
                              vertical: kHeight * 0.01),
                          child: SizedBox(
                            width: kWidth * 0.7,
                            child: Text(
                              "${greetingMessage()}, ${nameHandler(userModel?.name ?? "")}",
                              style: kTheme.textTheme.headline3!.copyWith(
                                color: ColorManager.info,
                              ),
                              maxLines: 1,
                            ),
                          ),
                        ),
                        Container(
                          height: kHeight * 0.23,
                          child: Swiper(
                            itemBuilder: (BuildContext context, int index) =>
                                CachedNetworkImage(
                              imageUrl: cubit.banners[index].image,
                              width: double.infinity,
                              fit: BoxFit.fill,
                            ),
                            itemCount: ImageAssets.banners.length,
                            pagination: SwiperPagination(
                                margin: const EdgeInsets.all(0),
                                builder: DotSwiperPaginationBuilder(
                                  color: ColorManager.gray,
                                  size: 7,
                                  activeColor: ColorManager.warning,
                                  activeSize: 10,
                                  space: 7,
                                )),
                            autoplay: true,
                            duration: 700,
                            curve: Curves.easeInOut,
                            autoplayDelay: 10000,
                          ),
                        ),
                        Container(
                            height: kHeight * 0.008,
                            color: ColorManager.primary.withOpacity(0.3)),
                        kVSeparator(factor: 0.03),
                        lvCategories(context, cubit.categories),
                        kDivider(factor: 0.01),
                        lvBrands(context, cubit.brands),
                        kDivider(factor: 0.01),
                        ProductsHorizontalListBuilder(
                          title: "Best Seller",
                          products: cubit.products,
                          categoryId: 6,
                        ),
                        kVSeparator(factor: 0.03),
                        kDivider(factor: 0.02),
                        ProductsHorizontalListBuilder(
                          title: "Hot Deals",
                          products: cubit.offeredProducts,
                          categoryId: 1,
                        ),
                        kVSeparator(factor: 0.1),
                      ],
                    ),
                  ),
          ),
          fallback: (context) => ShimmerHomeLoading(),
        );
      },
    );
  }
}
