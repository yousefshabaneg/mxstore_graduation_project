import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../business_logic/search_cubit/search_cubit.dart';
import '../../business_logic/shop_cubit/shop_cubit.dart';
import '../../business_logic/shop_cubit/shop_states.dart';
import '../../shared/helpers.dart';
import '../../shared/resources/color_manager.dart';
import '../../shared/widgets/filtered_item_view.dart';
import '../../shared/widgets/indicators.dart';
import 'search_category_view.dart';

class CategoriesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) => Scaffold(
        appBar: AppBar(toolbarHeight: 5, elevation: 1),
        backgroundColor: ColorManager.lightGray,
        body: SearchCubit.get(context).isCategorySearching
            ? SearchCategoryView()
            : Padding(
                padding: EdgeInsets.all(kHeight * 0.02),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: GridView.count(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.1,
                    children: ShopCubit.get(context)
                        .categories
                        .map(
                          (category) => InkWell(
                            onTap: () {
                              push(
                                context,
                                FilteredProductView(
                                  filteredModel: category,
                                  categoryId: category.id,
                                ),
                              );
                            },
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: category.image,
                                    width: kWidth * 0.3,
                                    height: kHeight * 0.09,
                                    placeholder: (context, url) =>
                                        const MyLoadingIndicator(
                                            circular: true),
                                  ),
                                  kVSeparator(),
                                  Text(
                                    category.name,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: ColorManager.dark,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                // image: DecorationImage(
                                //   image: AssetImage(entry.value),
                                // ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
      ),
    );
  }
}
