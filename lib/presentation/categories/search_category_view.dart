import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/business_logic/search_cubit/search_cubit.dart';
import 'package:graduation_project/business_logic/search_cubit/search_states.dart';
import 'package:graduation_project/shared/widgets/grid_product_item_widget.dart';
import 'package:graduation_project/shared/widgets/indicators.dart';
import 'package:graduation_project/shared/widgets/shimmer_loading.dart';

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
            builder: (context) => ProductsItemsGridBuilder(
                products: cubit.searchedCategoryProducts),
            fallback: (context) => ShimmerGridViewLoading(),
          ),
        );
      },
    );
  }
}
