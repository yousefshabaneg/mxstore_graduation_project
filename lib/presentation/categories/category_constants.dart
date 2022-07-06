import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graduation_project/business_logic/search_cubit/search_cubit.dart';
import 'package:graduation_project/shared/constants.dart';
import 'package:graduation_project/shared/helpers.dart';
import 'package:graduation_project/shared/resources/color_manager.dart';

CupertinoNavigationBar categoryAppBar(context) => CupertinoNavigationBar(
      padding: EdgeInsetsDirectional.only(start: 0),
      leading: SearchCubit.get(context).isCategorySearching
          ? CupertinoButton(
              padding: EdgeInsets.all(0),
              child: Icon(
                CupertinoIcons.left_chevron,
                color: ColorManager.dark,
                size: 20,
              ),
              onPressed: () {
                Navigator.pop(context);
                SearchCubit.get(context).clearCategorySearch();
              },
            )
          : null,
      middle: SearchCubit.get(context).isCategorySearching
          ? searchingCategoryField(context)
          : searchCategoryContainer(context),
      backgroundColor: Colors.white,
      trailing: appBarCategoryTrailing(context),
      border: Border(bottom: BorderSide(color: Colors.transparent)),
    );

Widget searchCategoryContainer(context) => Material(
      color: Colors.white,
      child: InkWell(
        onTap: () => SearchCubit.get(context).startCategorySearch(context),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: kHeight * 0.01),
          child: Container(
            height: AppBar().preferredSize.height * 0.7,
            decoration: BoxDecoration(
              color: ColorManager.lightGray,
              borderRadius: BorderRadius.circular(10),
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

Widget? appBarCategoryTrailing(context) {
  return SearchCubit.get(context).isCategorySearching ||
          SearchCubit.get(context).searchCategoryController.text.isNotEmpty
      ? CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            SearchCubit.get(context).clearCategorySearch();
          },
          child: Icon(
            Icons.clear,
            color: ColorManager.subtitle,
          ),
        )
      : null;
}

Widget searchingCategoryField(context) => Material(
      color: Colors.white,
      child: TextField(
        controller: SearchCubit.get(context).searchCategoryController,
        autofocus: true,
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
          SearchCubit.get(context).getSearchedCategoryProducts(
            searchWord: searchedCharacter,
          );
        },
      ),
    );
