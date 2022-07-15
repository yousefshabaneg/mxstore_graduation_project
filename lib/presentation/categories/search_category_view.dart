import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../business_logic/search_cubit/search_cubit.dart';
import '../../business_logic/search_cubit/search_states.dart';
import '../../shared/widgets/grid_product_item_widget.dart';
import '../../shared/widgets/search_not_found_widget.dart';
import '../../shared/widgets/shimmer_loading.dart';

class SearchCategoryView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SearchCubit, SearchStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = SearchCubit.get(context);
        return Scaffold(
          body: ConditionalBuilder(
            condition: state is! LoadingSearchedProductsState,
            builder: (context) => ConditionalBuilder(
              condition: !cubit.notCategoryFound,
              builder: (context) => ProductsItemsGridBuilder(
                  products: cubit.searchedCategoryProducts),
              fallback: (context) => SearchNotFoundWidget(),
            ),
            fallback: (context) => ShimmerGridViewLoading(),
          ),
        );
      },
    );
  }
}
