import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graduation_project/business_logic/shop_cubit/shop_cubit.dart';
import 'package:graduation_project/data/models/product_model.dart';
import 'package:graduation_project/presentation/products/product_details_view.dart';
import 'package:graduation_project/shared/components.dart';
import 'package:graduation_project/shared/constants.dart';
import 'package:graduation_project/shared/helpers.dart';
import 'package:graduation_project/shared/resources/assets_manager.dart';
import 'package:graduation_project/shared/resources/color_manager.dart';
import 'package:graduation_project/shared/widgets/indicators.dart';
import 'package:graduation_project/shared/widgets/shimmer_loading.dart';
import 'package:shimmer/shimmer.dart';

class ProductItemWidget extends StatelessWidget {
  ProductItemModel? model;
  ProductItemWidget({
    this.model,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.white30,
      onTap: () {
        push(context, ProductDetailsView(productId: model!.id!));
      },
      child: Container(
        padding: EdgeInsets.all(5),
        width: kWidth * 0.3,
        decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          border: Border.all(color: ColorManager.gray, width: 0.2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () => ShopCubit.get(context).changeFavorites(model!.id!),
                child: Icon(
                  ShopCubit.get(context)
                          .favoritesProductsIds
                          .contains(model!.id!)
                      ? Icons.favorite
                      : Icons.favorite_border_outlined,
                  color: ShopCubit.get(context)
                          .favoritesProductsIds
                          .contains(model!.id!)
                      ? ColorManager.error
                      : ColorManager.dark,
                  size: 18,
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
                      height: kHeight * 0.1,
                    )
                  : Image(image: AssetImage(ImageAssets.noImage)),
            ),
            kVSeparator(factor: 0.05),
            Text(
              model!.name!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: kTheme.textTheme.subtitle1,
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "EGP ",
                    style: kTheme.textTheme.subtitle1,
                  ),
                  TextSpan(
                    text: formatPrice(model!.price!),
                    style: kTheme.textTheme.headline5,
                  ),
                ],
              ),
            ),
            kVSeparator(factor: 0.001),
            if (model!.discount != 0)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "EGP ${formatPrice(model!.oldPrice!)}",
                    style: kTheme.textTheme.subtitle2!.copyWith(
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
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
              children: [
                FaIcon(
                  FontAwesomeIcons.solidStar,
                  color: ColorManager.warning,
                  size: 10,
                ),
                Text(
                  "${model!.rating} ",
                  style: kTheme.textTheme.headline5!.copyWith(
                    fontSize: 8,
                    color: ColorManager.warning,
                  ),
                ),
                Text(
                  "(51)",
                  style: kTheme.textTheme.subtitle2!.copyWith(
                    fontSize: 8,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ProductsHorizontalListBuilder extends StatefulWidget {
  ProductsHorizontalListBuilder({
    Key? key,
    this.title = "",
    this.size = 24,
    required this.products,
    this.categoryId,
    this.brandId,
  }) : super(key: key);
  List<ProductItemModel> products = [];
  int? brandId;
  int? categoryId;
  final String title;
  final double size;

  @override
  State<ProductsHorizontalListBuilder> createState() =>
      _ProductsHorizontalListBuilderState();
}

class _ProductsHorizontalListBuilderState
    extends State<ProductsHorizontalListBuilder> {
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
    final newProducts = await ShopCubit.get(context).getFilteredProducts(
      pageIndex: pageIndex,
      categoryId: widget.categoryId,
      brandId: widget.brandId,
      pageSize: pageSize,
    );
    setState(() {
      isLoading = false;
      widget.products.addAll(newProducts);
      print(widget.products.length);
      if (newProducts.length < pageSize) hasMore = false;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: kWidth * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: kTheme.textTheme.headline2!.copyWith(fontSize: widget.size),
          ),
          kVSeparator(factor: 0.02),
          Container(
            height: kHeight * .32,
            child: ListView.builder(
              controller: controller,
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                if (index < widget.products.length)
                  return ProductItemWidget(
                    model: widget.products[index],
                  );
                else if (widget.products.length < pageSize)
                  return SizedBox.shrink();
                else
                  return hasMore ? ShimmerListProducts() : SizedBox.shrink();
              },
              itemCount: widget.products.length + 1,
            ),
          ),
        ],
      ),
    );
  }
}
