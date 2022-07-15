import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graduation_project/business_logic/shop_cubit/shop_cubit.dart';
import 'package:graduation_project/business_logic/shop_cubit/shop_states.dart';
import 'package:graduation_project/data/models/basket_model.dart';
import 'package:graduation_project/data/models/product_model.dart';
import 'package:graduation_project/presentation/cart/cart_items.dart';
import 'package:graduation_project/presentation/products/product_details_view.dart';
import 'package:graduation_project/shared/constants.dart';
import 'package:graduation_project/shared/helpers.dart';
import 'package:graduation_project/shared/resources/assets_manager.dart';
import 'package:graduation_project/shared/resources/color_manager.dart';
import 'package:graduation_project/shared/widgets/app_buttons.dart';
import 'package:graduation_project/shared/widgets/indicators.dart';
import 'package:graduation_project/shared/widgets/shimmer_loading.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ProductItemWidget extends StatelessWidget {
  ProductItemModel? model;
  bool cartProduct = false;
  ProductItemWidget({
    Key? key,
    this.model,
    this.cartProduct = false,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.white30,
      onTap: () {
        push(context, ProductDetailsView(productId: model!.id!));
      },
      child: Container(
        padding: EdgeInsets.all(10),
        width: kWidth * (cartProduct ? 0.45 : 0.38),
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
            const SizedBox(height: 5),
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
            const SizedBox(height: 5),
            if (model!.rating > 0)
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
                ],
              ),
            Spacer(),
            if (cartProduct)
              BlocConsumer<ShopCubit, ShopStates>(
                listener: (context, state) {},
                builder: (context, state) {
                  bool inCart = ShopCubit.get(context)
                      .cartProductsIds
                      .contains(model!.id!);
                  return SolidButton(
                    size: 12,
                    heightFactor: 0.04,
                    radius: 5,
                    text: inCart ? "Remove from cart" : "Add to cart",
                    color: !inCart ? Colors.black : ColorManager.error,
                    withIcon: true,
                    icon: !inCart
                        ? FontAwesomeIcons.cartShopping
                        : FontAwesomeIcons.trash,
                    splashColor: Colors.white54,
                    backgroundColor: Colors.white,
                    borderColor:
                        !inCart ? ColorManager.dark : ColorManager.error,
                    onTap: () {
                      if (!inCart) {
                        ShopCubit.get(context).addToCart(model!);
                      } else {
                        showMaterialModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          useRootNavigator: true,
                          builder: (context) => RemoveProductMaterialSheet(
                              product: BasketProductModel.mapProductToBasket(
                                  model!)),
                        );
                      }
                    },
                    child: state is ShopLoadingAddToCartState &&
                            state.id == model!.id
                        ? const MyLoadingIndicator(height: 20, width: 30)
                        : null,
                  );
                },
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
    this.cartProduct = false,
    required this.products,
    this.categoryId,
    this.brandId,
  }) : super(key: key);
  List<ProductItemModel> products = [];
  int? brandId;
  int? categoryId;
  final String title;
  final double size;
  bool cartProduct = false;

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
      if (controller.position.maxScrollExtent < (controller.offset - 60)) {
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
            height: kHeight * (widget.cartProduct ? 0.4 : 0.35),
            child: ListView.builder(
              controller: controller,
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                if (index < widget.products.length)
                  return ProductItemWidget(
                    model: widget.products[index],
                    cartProduct: this.widget.cartProduct,
                  );
                else if (widget.products.length < pageSize)
                  return SizedBox.shrink();
                else
                  return (hasMore &&
                          (controller.position.maxScrollExtent <
                              (controller.offset - 60)))
                      ? ShimmerListProducts()
                      : SizedBox.shrink();
              },
              itemCount: widget.products.length + 1,
            ),
          ),
        ],
      ),
    );
  }
}
