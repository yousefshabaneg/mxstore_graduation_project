import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graduation_project/business_logic/account_cubit/account_cubit.dart';
import 'package:graduation_project/business_logic/shop_cubit/shop_cubit.dart';
import 'package:graduation_project/business_logic/shop_cubit/shop_states.dart';
import 'package:graduation_project/data/models/comment_model.dart';
import 'package:graduation_project/data/models/product_model.dart';
import 'package:graduation_project/shared/constants.dart';
import 'package:graduation_project/shared/helpers.dart';
import 'package:graduation_project/shared/resources/color_manager.dart';
import 'package:graduation_project/shared/resources/font_manager.dart';
import 'package:graduation_project/shared/widgets/app_buttons.dart';
import 'package:graduation_project/shared/widgets/bottom_sheet_widgets/cart_bottom_sheet.dart';
import 'package:graduation_project/shared/widgets/gallery_widget.dart';
import 'package:graduation_project/shared/widgets/indicators.dart';
import 'package:graduation_project/shared/widgets/product_item_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../shared/widgets/product_details_widgets.dart';

class ProductDetailsView extends StatefulWidget {
  ProductDetailsView({Key? key, required this.productId}) : super(key: key);

  final int productId;
  ProductItemModel? product;
  List<CommentModel> comments = [];

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  bool isCartLoading = false;
  late ScrollController scrollController;
  PageController imageController = PageController();
  @override
  void initState() {
    loadData();
    scrollController = ScrollController();
    imageControllers = [PageController()];
    imageController = imageControllers[imageControllers.length - 1];
    delivery = AccountCubit.get(context).deliveryRegionAndCity();
    super.initState();
  }

  loadData() async {
    widget.product = await ShopCubit.get(context).getProduct(widget.productId);
  }

  @override
  void dispose() {
    imageController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  var scaffoldKey = new GlobalKey<ScaffoldState>();
  String delivery = "";

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ConditionalBuilder(
          condition: state is! ShopLoadingGetProductItemState &&
              widget.product != null,
          builder: (context) {
            bool inCart = ShopCubit.get(context)
                .cartProductsIds
                .contains(widget.product!.id!);
            return Scaffold(
              key: scaffoldKey,
              appBar: AppBar(
                actions: [
                  IconButton(
                    onPressed: () {
                      print("Copy Link of Item to Share");
                    },
                    icon: Icon(
                      Icons.ios_share,
                    ),
                  ),
                ],
              ),
              body: SingleChildScrollView(
                controller: scrollController,
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image(
                            image: NetworkImage(ShopCubit.get(context)
                                .brandsMap[widget.product!.brandId]!),
                            width: kWidth * 0.13,
                          ),
                          kVSeparator(),
                          Text(
                            widget.product!.name!,
                            style: kTheme.textTheme.bodyText2!.copyWith(
                              color: ColorManager.dark,
                            ),
                          ),
                          kVSeparator(factor: 0.03),
                          Stack(
                            children: [
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0),
                                    child: Container(
                                      height: kHeight * 0.3,
                                      child: PageView.builder(
                                        scrollDirection: Axis.horizontal,
                                        controller: imageController,
                                        itemBuilder: (context, index) =>
                                            InkWell(
                                          splashColor: Colors.transparent,
                                          onTap: () {
                                            showCupertinoModalBottomSheet(
                                              expand: false,
                                              context: context,
                                              backgroundColor: Colors.white,
                                              barrierColor: Colors.white,
                                              builder: (context) =>
                                                  GalleryWidget(
                                                name: widget.product!.name!,
                                                urlImages:
                                                    widget.product!.gallery,
                                                index: index,
                                              ),
                                            );
                                          },
                                          child: Ink.image(
                                            image: NetworkImage(
                                                widget.product!.gallery[index]),
                                          ),
                                        ),
                                        itemCount:
                                            widget.product!.gallery.length,
                                        physics: BouncingScrollPhysics(),
                                      ),
                                    ),
                                  ),
                                  kVSeparator(),
                                  SmoothPageIndicator(
                                    controller: imageController,
                                    count: widget.product!.gallery.length,
                                    axisDirection: Axis.horizontal,
                                    effect: ScrollingDotsEffect(
                                      activeDotColor: ColorManager.dark,
                                      dotColor: ColorManager.gray,
                                      dotHeight: 8,
                                      dotWidth: 8,
                                      spacing: 10,
                                    ),
                                  ),
                                ],
                              ),
                              Align(
                                alignment: Alignment(0.9, 0),
                                child: InkWell(
                                  onTap: () => ShopCubit.get(context)
                                      .changeFavorites(widget.product!.id!),
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      border: Border.all(
                                          color: ColorManager.gray, width: 2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      ShopCubit.get(context)
                                              .favoritesProductsIds
                                              .contains(widget.product!.id!)
                                          ? Icons.favorite
                                          : Icons.favorite_border_outlined,
                                      color: ShopCubit.get(context)
                                              .favoritesProductsIds
                                              .contains(widget.product!.id!)
                                          ? ColorManager.error
                                          : ColorManager.dark,
                                      size: 25,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          kVSeparator(factor: 0.01),
                          if (widget.product!.discount != 0)
                            Row(
                              children: [
                                kVSeparator(factor: 0.05),
                                Text(
                                  "EGP ${formatPrice(widget.product!.oldPrice!)}",
                                  style: kTheme.textTheme.caption!.copyWith(
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                                kHSeparator(),
                                Text(
                                  "Save ${formatPrice(widget.product!.oldPrice! - widget.product!.price!)}  (${widget.product!.discount}%)",
                                  style: kTheme.textTheme.subtitle2!.copyWith(
                                    color: ColorManager.error,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "EGP  ",
                                  style: kTheme.textTheme.caption!
                                      .copyWith(fontSize: 18),
                                ),
                                TextSpan(
                                  text: formatPrice(widget.product!.price!),
                                  style: kTheme.textTheme.headline2!.copyWith(
                                    color: ColorManager.dark,
                                    letterSpacing: -1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          kVSeparator(factor: 0.04),
                          WarrantyWidget(),
                          kVSeparator(factor: 0.03),
                          ConditionalBuilder(
                            condition: widget.product!.numberInStock > 0,
                            builder: (context) {
                              return SolidButton(
                                withIcon: true,
                                icon: !inCart
                                    ? FontAwesomeIcons.cartShopping
                                    : FontAwesomeIcons.check,
                                radius: 10,
                                text: !inCart ? "Add to cart" : "In Cart",
                                color: !inCart ? Colors.white : Colors.black,
                                splashColor: ColorManager.primary,
                                heightFactor: 0.07,
                                backgroundColor:
                                    !inCart ? ColorManager.black : Colors.white,
                                borderColor: !inCart
                                    ? Colors.transparent
                                    : ColorManager.dark,
                                child: !isCartLoading &&
                                        state is ShopLoadingAddToCartState &&
                                        state.id == widget.productId
                                    ? const MyLoadingIndicator(
                                        height: 20, width: 30)
                                    : null,
                                onTap: () {
                                  ShopCubit.get(context)
                                      .addToCart(widget.product!);
                                },
                              );
                            },
                            fallback: (context) => SolidButton(
                              withIcon: true,
                              icon: FontAwesomeIcons.cartShopping,
                              radius: 10,
                              text: "out of stock",
                              color: Colors.white,
                              heightFactor: 0.07,
                              disabledColor: Colors.black38,
                            ),
                          ),
                          kVSeparator(),
                          if (widget.product!.numberInStock != 0)
                            SolidButton(
                                radius: 10,
                                text: "Buy Now",
                                color: Colors.white,
                                heightFactor: 0.07,
                                backgroundColor: ColorManager.primary,
                                splashColor: ColorManager.dark,
                                child: isCartLoading
                                    ? const MyLoadingIndicator(
                                        height: 20, width: 30)
                                    : null,
                                onTap: () async {
                                  setState(() => isCartLoading = true);
                                  await ShopCubit.get(context)
                                      .addToCart(widget.product!);
                                  setState(() => isCartLoading = false);

                                  tabController.index = 3;
                                })
                          else
                            SolidButton(
                              radius: 10,
                              text: "Notify Me",
                              color: Colors.white,
                              heightFactor: 0.07,
                              backgroundColor: ColorManager.primary,
                              splashColor: ColorManager.dark,
                              withIcon: true,
                              icon: FontAwesomeIcons.solidBell,
                              onTap: () => tabController.index = 3,
                            ),
                          kVSeparator(),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5.0, vertical: 10),
                            child: ProductDetailsHelpers.deliveryAddressWidget(
                                delivery),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5.0, vertical: 10),
                            child: ProductDetailsHelpers.deliveryTime(),
                          ),
                          kDivider(opacity: 0.4),
                          if (widget.product!.numberInStock < 5 &&
                              widget.product!.numberInStock != 0)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              child: Text(
                                "Only ${widget.product!.numberInStock} items left",
                                style: kTheme.textTheme.headline5!.copyWith(
                                  color: Colors.redAccent,
                                  fontSize: 14,
                                  fontWeight: FontWeightManager.medium,
                                ),
                              ),
                            )
                        ],
                      ),
                    ),
                    kGrayDivider(),
                    if (widget.product!.specifications.isNotEmpty)
                      Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Column(
                              children: [
                                SpecificationExpansionList(
                                    specs: widget.product!.specifications),
                              ],
                            ),
                          ),
                          kGrayDivider(),
                        ],
                      ),
                    if (widget.product!.comments.length != 0)
                      Column(
                        children: [
                          UserReviews(
                            product: widget.product!,
                          ),
                          kGrayDivider(),
                        ],
                      ),
                    ProductsHorizontalListBuilder(
                      title: "From Same Brand",
                      size: 18,
                      products: ShopCubit.get(context).similarBrand(
                          brandId: widget.product!.brandId!,
                          productId: widget.productId),
                    ),
                    kGrayDivider(),
                    ProductsHorizontalListBuilder(
                      title: "Customers also viewed",
                      size: 18,
                      products: ShopCubit.get(context).similarCategory(
                        categoryId: widget.product!.categoryId!,
                        productId: widget.productId,
                      ),
                    ),
                    kVSeparator(factor: 0.1),
                  ],
                ),
              ),
              bottomSheet: widget.product!.numberInStock > 0
                  ? CartBottomSheet(
                      controller: scrollController,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "EGP  ",
                                    style: kTheme.textTheme.caption!
                                        .copyWith(fontSize: 18),
                                  ),
                                  TextSpan(
                                    text: formatPrice(widget.product!.price!),
                                    style: kTheme.textTheme.headline2!.copyWith(
                                      color: ColorManager.dark,
                                      letterSpacing: -1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SolidButton(
                              withIcon: true,
                              icon: !ShopCubit.get(context)
                                      .cartProductsIds
                                      .contains(widget.product!.id!)
                                  ? FontAwesomeIcons.cartShopping
                                  : FontAwesomeIcons.check,
                              radius: 10,
                              text: !ShopCubit.get(context)
                                      .cartProductsIds
                                      .contains(widget.product!.id!)
                                  ? "Add to cart"
                                  : "In Cart",
                              color: !ShopCubit.get(context)
                                      .cartProductsIds
                                      .contains(widget.product!.id!)
                                  ? Colors.white
                                  : Colors.black,
                              splashColor: ColorManager.primary,
                              heightFactor: 0.06,
                              widthFactor: 0.4,
                              backgroundColor: !ShopCubit.get(context)
                                      .cartProductsIds
                                      .contains(widget.product!.id!)
                                  ? ColorManager.black
                                  : Colors.white,
                              borderColor: !ShopCubit.get(context)
                                      .cartProductsIds
                                      .contains(widget.product!.id!)
                                  ? Colors.transparent
                                  : ColorManager.dark,
                              child: state is ShopLoadingAddToCartState &&
                                      state.id == widget.productId
                                  ? const MyLoadingIndicator(
                                      height: 20, width: 30)
                                  : null,
                              onTap: () {
                                ShopCubit.get(context)
                                    .addToCart(widget.product!);
                              },
                            ),
                          ],
                        ),
                      ),
                    )
                  : null,
            );
          },
          fallback: (context) => ShimmerProductDetails(),
        );
      },
    );
  }
}

class ShimmerProductDetails extends StatelessWidget {
  const ShimmerProductDetails({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey.withOpacity(0.25),
                highlightColor: Colors.white.withOpacity(0.6),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: kWidth * 0.04, vertical: kHeight * 0.01),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey.withOpacity(0.9),
                  ),
                ),
              ),
            ],
          ),
          Shimmer.fromColors(
            baseColor: Colors.grey.withOpacity(0.25),
            highlightColor: Colors.white.withOpacity(0.6),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: kWidth * 0.04, vertical: kHeight * 0.03),
              child: Container(
                height: kHeight * 0.02,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.grey.withOpacity(0.9),
                ),
              ),
            ),
          ),
          Shimmer.fromColors(
            baseColor: Colors.grey.withOpacity(0.25),
            highlightColor: Colors.white.withOpacity(0.6),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: kWidth * 0.04, vertical: kHeight * 0.03),
              child: Container(
                height: kHeight * 0.02,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.grey.withOpacity(0.9),
                ),
              ),
            ),
          ),
          SizedBox(
            height: kHeight * 0.35,
            child: const MyLoadingIndicator(
              circular: true,
            ),
          ),
          kVSeparator(),
        ],
      ),
    );
  }
}
