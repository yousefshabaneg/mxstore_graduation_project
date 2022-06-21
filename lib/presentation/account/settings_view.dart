import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/business_logic/user_cubit/user_cubit.dart';
import 'package:graduation_project/business_logic/user_cubit/user_states.dart';
import 'package:graduation_project/data/models/identity/user_model.dart';
import 'package:graduation_project/shared/constants.dart';
import 'package:graduation_project/shared/helpers.dart';
import 'package:graduation_project/shared/resources/color_manager.dart';
import 'package:graduation_project/shared/widgets/app_buttons.dart';
import 'package:graduation_project/shared/widgets/bottom_sheet_widgets/change_password_sheet.dart';
import 'package:graduation_project/shared/widgets/bottom_sheet_widgets/edit_personal_info_sheet.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

var emailController = TextEditingController();
var passwordController = TextEditingController();
var newPasswordController = TextEditingController();
var confirmNewPasswordController = TextEditingController();
var nameController = TextEditingController();
var phoneController = TextEditingController();

class SettingsView extends StatelessWidget {
  SettingsView({Key? key, this.user}) : super(key: key);
  UserModel? user;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCubit, UserStates>(
      listener: (context, state) {},
      builder: (context, state) {
        user = UserCubit.get(context).userModel;
        return CupertinoPageScaffold(
          navigationBar: customAppBar(context, "Account Settings"),
          child: SafeArea(
            child: Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(kHeight * 0.015),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Personal Information".toUpperCase(),
                                style: kTheme.textTheme.headline5!.copyWith(
                                  color: ColorManager.subtitle,
                                  fontSize: 12,
                                ),
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  minimumSize: Size.zero,
                                  padding: EdgeInsets.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                onPressed: () => showEditInfoSheet(
                                  context,
                                  child: EditPersonalInfoWidget(
                                    userModel: user!,
                                  ),
                                ),
                                child: Text(
                                  "Edit",
                                  style: TextStyle(color: Colors.blue),
                                ),
                              )
                            ],
                          ),
                          kVSeparator(),
                          AccountRowWidget(
                            title: "Your name",
                            subtitle: user!.name!,
                          ),
                          kDivider(),
                          AccountRowWidget(
                            title: "Your phone",
                            subtitle: user!.phone!,
                          ),
                          kDivider(),
                          AccountRowWidget(
                            title: "Email address",
                            subtitle: user!.email!,
                          ),
                        ],
                      ),
                    ),
                    kGrayDivider(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: kWidth * 0.05),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Security Information".toUpperCase(),
                            style: kTheme.textTheme.headline5,
                          ),
                          kVSeparator(factor: 0.01),
                          SolidButton(
                            text: "Change Password".toUpperCase(),
                            heightFactor: 0.06,
                            widthFactor: 0.5,
                            size: 14,
                            onTap: () {
                              showEditInfoSheet(
                                context,
                                child: EditPasswordWidget(),
                              );
                            },
                            color: ColorManager.white,
                          )
                        ],
                      ),
                    ),
                    kGrayDivider(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class AccountRowWidget extends StatelessWidget {
  const AccountRowWidget({
    Key? key,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: kTheme.textTheme.headline5,
            ),
            SizedBox(
              width: kWidth * 0.7,
              child: Text(
                subtitle,
                style: kTheme.textTheme.caption,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
