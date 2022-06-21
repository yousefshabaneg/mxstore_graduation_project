import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graduation_project/business_logic/account_cubit/account_cubit.dart';
import 'package:graduation_project/business_logic/account_cubit/account_states.dart';
import 'package:graduation_project/business_logic/user_cubit/user_cubit.dart';
import 'package:graduation_project/business_logic/user_cubit/user_states.dart';
import 'package:graduation_project/presentation/account/address_view.dart';
import 'package:graduation_project/presentation/account/favorites_view.dart';
import 'package:graduation_project/presentation/account/settings_view.dart';
import 'package:graduation_project/shared/constants.dart';
import 'package:graduation_project/shared/helpers.dart';
import 'package:graduation_project/shared/resources/color_manager.dart';
import 'package:graduation_project/shared/widgets/error_page.dart';

class AccountView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AccountCubit, AccountStates>(
      listener: (context, state) {},
      builder: (context, state) => BlocConsumer<UserCubit, UserStates>(
          listener: (context, state) {},
          builder: (context, index) {
            var userModel = UserCubit.get(context).userModel;
            return SafeArea(
              child: Scaffold(
                backgroundColor: ColorManager.lightGray,
                body: ConditionalBuilder(
                    condition: userModel != null,
                    builder: (context) => SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                color: ColorManager.white,
                                child: Row(
                                  children: [
                                    kHSeparator(factor: 0.03),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        kVSeparator(factor: 0.01),
                                        SizedBox(
                                          width: kWidth * 0.7,
                                          child: Text(
                                            "Hi, ${nameHandler(userModel!.name!)}",
                                            style: kTheme.textTheme.headline2!
                                                .copyWith(
                                              color: ColorManager.black,
                                            ),
                                            maxLines: 1,
                                          ),
                                        ),
                                        kVSeparator(),
                                        Text("+20 ${userModel.phone}",
                                            style: kTheme.textTheme.subtitle1),
                                        kVSeparator(),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              kVSeparator(factor: 0.03),
                              buildAccountRow(
                                  FontAwesomeIcons.cube, "My Orders"),
                              buildAccountRow(
                                FontAwesomeIcons.gratipay,
                                "Saved items",
                                onTap: () => push(context, FavoritesView()),
                              ),
                              buildAccountRow(
                                  FontAwesomeIcons.gear, "Account Settings",
                                  onTap: () => push(
                                      context,
                                      SettingsView(
                                        user: userModel,
                                      ))),
                              buildAccountRow(
                                  FontAwesomeIcons.locationCrosshairs,
                                  "Addresses",
                                  onTap: () => push(
                                      context,
                                      AddressView(
                                        user: userModel,
                                      ))),
                              kVSeparator(factor: 0.03),
                              InkWell(
                                onTap: () => signOut(context),
                                child: Container(
                                  height: kHeight * 0.08,
                                  color: ColorManager.white,
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      kHSeparator(factor: 0.02),
                                      FaIcon(FontAwesomeIcons.rightFromBracket,
                                          color: ColorManager.primary),
                                      kHSeparator(factor: 0.08),
                                      Text(
                                        "Log out",
                                        style: TextStyle(
                                          color: ColorManager.primary,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    fallback: (BuildContext context) => Error404Page()),
              ),
            );
          }),
    );
  }

  Widget buildAccountRow(icon, text, {onTap}) => Column(
        children: [
          InkWell(
            onTap: onTap,
            child: Container(
              height: kHeight * 0.08,
              color: ColorManager.white,
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  kHSeparator(factor: 0.02),
                  FaIcon(icon, color: ColorManager.black),
                  kHSeparator(factor: 0.08),
                  Text(
                    text,
                    style: kTheme.textTheme.caption!
                        .copyWith(color: ColorManager.black),
                  ),
                ],
              ),
            ),
          ),
          Divider(
            height: kHeight * 0.001,
            color: ColorManager.gray.withOpacity(0.3),
          ),
        ],
      );
}
