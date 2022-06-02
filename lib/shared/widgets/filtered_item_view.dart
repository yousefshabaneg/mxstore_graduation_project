import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/business_logic/search_cubit/search_cubit.dart';
import 'package:graduation_project/business_logic/shop_cubit/shop_cubit.dart';
import 'package:graduation_project/business_logic/shop_cubit/shop_states.dart';
import 'package:graduation_project/data/models/product_model.dart';
import 'package:graduation_project/presentation/search/search_view.dart';
import 'package:graduation_project/shared/constants.dart';
import 'package:graduation_project/shared/resources/color_manager.dart';
import 'package:graduation_project/shared/widgets/grid_product_item_widget.dart';
import 'package:graduation_project/shared/widgets/shimmer_loading.dart';

class FilteredProductView extends StatefulWidget {
  FilteredProductView({
    required this.filteredModel,
    this.categoryId,
    this.brandId,
    Key? key,
  }) : super(key: key);

  var filteredModel;
  int? brandId;
  int? categoryId;
  List<ProductItemModel> products = [];

  @override
  State<FilteredProductView> createState() => _FilteredProductViewState();
}

class _FilteredProductViewState extends State<FilteredProductView> {
  loadData() async {
    widget.products = await ShopCubit.get(context).getFilteredProducts(
        categoryId: widget.categoryId, brandId: widget.brandId);
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return CupertinoPageScaffold(
          navigationBar: customAppBar(context, "${widget.filteredModel.name}"),
          child: Scaffold(
            backgroundColor: ColorManager.lightGray,
            body: SearchCubit.get(context).isSearching
                ? SearchView()
                : ConditionalBuilder(
                    condition: state is! ShopLoadingFilteredProductsState ||
                        widget.products.length != 0,
                    builder: (context) => ProductsItemsGridBuilder(
                      products: widget.products,
                      brandId: widget.brandId,
                      categoryId: widget.categoryId,
                    ),
                    fallback: (context) => ShimmerGridViewLoading(),
                  ),
          ),
        );
      },
    );
  }
}
