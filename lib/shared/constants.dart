import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../business_logic/account_cubit/account_cubit.dart';
import '../business_logic/search_cubit/search_cubit.dart';
import '../business_logic/user_cubit/user_cubit.dart';
import '../data/cashe_helper.dart';
import '../presentation/account/account_view.dart';
import '../presentation/cart/cart_view.dart';
import '../presentation/categories/categories_view.dart';
import '../presentation/categories/category_constants.dart';
import '../presentation/products/products_view.dart';
import 'helpers.dart';
import 'resources/color_manager.dart';
import 'resources/routes_manager.dart';
import 'widgets/app_text.dart';

String token = '';
String basketId = '';
ThemeData kTheme = ThemeData();
CupertinoTabController tabController = CupertinoTabController();
List<PageController> imageControllers = [PageController()];

Future<void> signOut(context) async {
  await CashHelper.removeData(key: 'token').then((value) {
    if (value) {
      Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
          Routes.accountRoute, (Route<dynamic> route) => false);
    }
  }).then((value) async {
    UserCubit.get(context).userModel = null;
    AccountCubit.get(context).clearAddressData();
  });
}

List<Widget> bottomScreens = [
  ProductsView(),
  CategoriesView(),
  AccountView(),
  CartView(),
];

List<BottomNavigationBarItem> bottomItems = [
  const BottomNavigationBarItem(
      icon: FaIcon(FontAwesomeIcons.house), label: "Home"),
  const BottomNavigationBarItem(
      icon: FaIcon(FontAwesomeIcons.shapes), label: "Categories"),
  const BottomNavigationBarItem(
      icon: FaIcon(FontAwesomeIcons.solidUser), label: "Account"),
  const BottomNavigationBarItem(
      icon: FaIcon(FontAwesomeIcons.cartShopping), label: "Cart"),
];

CupertinoTabBar kCupertinoTabBar(int index) => CupertinoTabBar(
      items: bottomItems,
      iconSize: 18,
      activeColor: ColorManager.primary,
      inactiveColor: ColorManager.subtitle,
      currentIndex: index,
      backgroundColor: Colors.white,
    );

CupertinoTabView kCupertinoTabBuilder(context, index) {
  switch (index) {
    case 0:
      return CupertinoTabView(
        builder: (context) => CupertinoPageScaffold(
          navigationBar: homeAppBar(context),
          child: ProductsView(),
        ),
      );
    case 1:
      return CupertinoTabView(
          builder: (context) => CupertinoPageScaffold(
                navigationBar: categoryAppBar(context),
                child: CategoriesView(),
              ));
    case 2:
      return CupertinoTabView(
          builder: (context) => CupertinoPageScaffold(child: AccountView()));
    case 3:
      return CupertinoTabView(
          builder: (context) => CupertinoPageScaffold(child: CartView()));
    default:
      return const CupertinoTabView();
  }
}

CupertinoNavigationBar customAppBar(context, title,
        {icon = CupertinoIcons.left_chevron, onPressed}) =>
    CupertinoNavigationBar(
      leading: CupertinoButton(
        padding: const EdgeInsets.all(0),
        child: Icon(
          icon,
          color: ColorManager.dark,
          size: 20,
        ),
        onPressed: () {
          Navigator.pop(context);
          if (onPressed != null) onPressed();
        },
      ),
      middle: Text(title, style: kTheme.textTheme.headline4),
      backgroundColor: Colors.white,
      padding: const EdgeInsetsDirectional.only(start: 0),
    );

CupertinoNavigationBar customAppBarWithNoTitle(context,
        {icon = CupertinoIcons.left_chevron, onPressed}) =>
    CupertinoNavigationBar(
      leading: CupertinoButton(
        padding: const EdgeInsets.all(0),
        child: Row(
          children: [
            Icon(
              icon,
              color: ColorManager.dark,
              size: 20,
            ),
            const SizedBox(width: 10),
            const BodyText(text: "Back"),
          ],
        ),
        onPressed: () {
          Navigator.pop(context);
          if (onPressed != null) onPressed();
        },
      ),
      backgroundColor: Colors.white,
    );

// Home AppBar
CupertinoNavigationBar homeAppBar(context) => CupertinoNavigationBar(
      padding: const EdgeInsetsDirectional.only(start: 0),
      leading: SearchCubit.get(context).isSearching
          ? CupertinoButton(
              padding: const EdgeInsets.all(0),
              child: Icon(
                CupertinoIcons.left_chevron,
                color: ColorManager.dark,
                size: 20,
              ),
              onPressed: () {
                Navigator.pop(context);
                SearchCubit.get(context).clearSearch();
              },
            )
          : null,
      middle: SearchCubit.get(context).isSearching
          ? searchingField(context)
          : searchContainer(context),
      border: const Border(bottom: BorderSide(color: Colors.transparent)),
      backgroundColor: Colors.white,
      trailing: appBarTrailing(context),
    );

Widget searchContainer(context) => Material(
      color: Colors.white,
      child: InkWell(
        onTap: () => SearchCubit.get(context).startSearch(context),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: kHeight * 0.01),
          child: Container(
            height: AppBar().preferredSize.height * 0.7,
            decoration: BoxDecoration(
              color: ColorManager.lightGray,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: kWidth * 0.05),
              child: Row(
                children: [
                  FaIcon(
                    FontAwesomeIcons.magnifyingGlass,
                    size: 14,
                    color: ColorManager.subtitle,
                  ),
                  kHSeparator(),
                  Text(
                    "Search for products or brands",
                    style: kTheme.textTheme.subtitle1!.copyWith(fontSize: 14),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );

Widget? appBarTrailing(context) {
  return SearchCubit.get(context).isSearching ||
          SearchCubit.get(context).searchController.text.isNotEmpty
      ? CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            SearchCubit.get(context).clearSearch();
          },
          child: Icon(
            Icons.clear,
            color: ColorManager.subtitle,
          ),
        )
      : null;
}

Widget searchingField(context) => Material(
      color: Colors.white,
      child: TextField(
        controller: SearchCubit.get(context).searchController,
        autofocus: true,
        textInputAction: TextInputAction.search,
        cursorColor: ColorManager.subtitle,
        decoration: InputDecoration(
          hintText: 'Search for products, brands...',
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          hintStyle: TextStyle(
            color: ColorManager.subtitle,
            fontSize: 18,
          ),
        ),
        style: TextStyle(
          color: ColorManager.subtitle,
          fontSize: 18,
        ),
        onSubmitted: (searchedCharacter) {
          SearchCubit.get(context).getSearchedProducts(
            searchWord: searchedCharacter,
          );
        },
      ),
    );
