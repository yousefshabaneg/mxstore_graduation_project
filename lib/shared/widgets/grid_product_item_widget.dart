import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graduation_project/business_logic/shop_cubit/shop_cubit.dart';
import 'package:graduation_project/business_logic/shop_cubit/shop_states.dart';
import 'package:graduation_project/data/models/product_model.dart';
import 'package:graduation_project/presentation/products/product_details_view.dart';
import 'package:graduation_project/shared/constants.dart';
import 'package:graduation_project/shared/resources/assets_manager.dart';
import 'package:graduation_project/shared/resources/color_manager.dart';
import 'package:graduation_project/shared/helpers.dart';
import 'package:graduation_project/shared/widgets/indicators.dart';
import 'package:graduation_project/shared/widgets/shimmer_loading.dart';

class GridProductItem extends StatelessWidget {
  ProductItemModel? model;
  late double rating;
  late int buyers;
  GridProductItem({
    this.model,
    this.rating = 5.0,
    this.buyers = 1,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        push(context, ProductDetailsView(productId: model!.id!));
      },
      child: Container(
        padding: EdgeInsets.all(10),
        width: kWidth * 0.3,
        decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          border: Border.all(color: ColorManager.gray, width: 0.1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () => ShopCubit.get(context).changeFavorites(model!.id!),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: ColorManager.gray.withOpacity(0.4), width: 1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Icon(
                      ShopCubit.get(context)
                              .favoritesProductsIds
                              .contains(model!.id!)
                          ? Icons.favorite
                          : Icons.favorite_border_outlined,
                      color: ColorManager.info,
                      size: 15,
                    ),
                  ),
                ),
              ),
            ),
            kVSeparator(),
            Align(
              alignment: Alignment.center,
              child: true
                  ? FadeInImage.assetNetwork(
                      placeholder: ImageAssets.loading,
                      image: model!.imageUrl!,
                      width: kWidth * 0.2,
                      height: kHeight * 0.15,
                      fadeInCurve: Curves.easeOutCubic,
                    )
                  : Image(image: AssetImage(ImageAssets.noImage)),
            ),
            kVSeparator(factor: 0.05),
            Container(
              height: kHeight * 0.06,
              child: Text(
                model!.name!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: kTheme.textTheme.caption,
              ),
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "EGP  ",
                    style: kTheme.textTheme.caption,
                  ),
                  TextSpan(
                    text: formatPrice(model!.price!),
                    style: kTheme.textTheme.headline3,
                  ),
                ],
              ),
            ),
            kVSeparator(factor: 0.001),
            if (model!.discount != 0)
              Row(
                children: [
                  Text(
                    "EGP ${formatPrice(model!.oldPrice!)}",
                    style: kTheme.textTheme.subtitle2!.copyWith(
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  kHSeparator(factor: 0.03),
                  Text(
                    "${model!.discount}% OFF",
                    style: kTheme.textTheme.subtitle2!.copyWith(
                      color: ColorManager.success,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FaIcon(
                  FontAwesomeIcons.solidStar,
                  color: ColorManager.warning,
                  size: 10,
                ),
                Text(
                  "$rating ",
                  style: kTheme.textTheme.headline5!.copyWith(
                    fontSize: 10,
                    color: ColorManager.warning,
                  ),
                ),
                Text(
                  "($buyers)",
                  style: kTheme.textTheme.subtitle2!.copyWith(
                    fontSize: 10,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class ProductsItemsGridBuilder extends StatefulWidget {
  ProductsItemsGridBuilder({
    Key? key,
    required this.products,
    this.categoryId,
    this.brandId,
  }) : super(key: key);
  List<ProductItemModel> products = [];
  int? categoryId;
  int? brandId;

  @override
  State<ProductsItemsGridBuilder> createState() =>
      _ProductsItemsGridBuilderState();
}

class _ProductsItemsGridBuilderState extends State<ProductsItemsGridBuilder> {
  final controller = ScrollController();
  int pageIndex = 1;
  final int pageSize = 10;
  bool hasMore = true;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        fetch();
      }
    });
  }

  Future fetch() async {
    if (isLoading) return;
    isLoading = true;
    pageIndex++;
    await ShopCubit.get(context)
        .getFilteredProducts(
            pageIndex: pageIndex,
            categoryId: widget.categoryId,
            brandId: widget.brandId,
            pageSize: pageSize)
        .then((value) {
      isLoading = false;
      widget.products.addAll(value);
      print(widget.products.length);
      if (value.length < pageSize) hasMore = false;
    });
  }

  Future refresh() async {
    if (widget.products.length > pageSize) {
      setState(() {
        isLoading = false;
        hasMore = true;
        pageIndex = 0;
        widget.products.clear();
      });
      fetch();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refresh,
      color: ColorManager.white,
      backgroundColor: ColorManager.primary,
      child: GridView.builder(
        controller: controller,
        shrinkWrap: true,
        primary: false,
        physics: BouncingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 1,
          mainAxisSpacing: 1,
          childAspectRatio: .6,
          crossAxisCount: 2,
        ),
        itemBuilder: (context, index) {
          if (index < widget.products.length)
            return Container(
                color: Colors.white,
                child: GridProductItem(
                  model: widget.products[index],
                ));
          else if (widget.products.length < pageSize)
            return SizedBox.shrink();
          else
            return hasMore ? ShimmerGridItemLoading() : SizedBox.shrink();
        },
        itemCount: itemCount(),
      ),
    );
  }

  int itemCount() {
    return widget.products.length +
        (widget.products.length >= pageSize
            ? (widget.products.length % 2 == 0 ? 2 : 1)
            : 0);
  }
}
