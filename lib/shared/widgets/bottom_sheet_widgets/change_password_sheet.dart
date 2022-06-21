import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:graduation_project/business_logic/app_cubit/app_cubit.dart';
import 'package:graduation_project/business_logic/app_cubit/app_states.dart';
import 'package:graduation_project/business_logic/user_cubit/user_cubit.dart';
import 'package:graduation_project/business_logic/user_cubit/user_states.dart';
import 'package:graduation_project/presentation/main/main_view.dart';
import 'package:graduation_project/shared/components.dart';
import 'package:graduation_project/shared/constants.dart';
import 'package:graduation_project/shared/helpers.dart';
import 'package:graduation_project/shared/resources/assets_manager.dart';
import 'package:graduation_project/shared/resources/color_manager.dart';
import 'package:graduation_project/shared/widgets/app_text.dart';
import 'package:graduation_project/shared/widgets/textfield.dart';
import 'package:loading_indicator/loading_indicator.dart';
import '../../../presentation/account/settings_view.dart';
import '../app_buttons.dart';
import '../indicators.dart';

class EditPasswordWidget extends StatefulWidget {
  @override
  State<EditPasswordWidget> createState() => _EditPasswordWidgetState();
}

class _EditPasswordWidgetState extends State<EditPasswordWidget> {
  static final formKey = new GlobalKey<FormState>();
  void _changePassword(context) {
    UserCubit.get(context).changePassword(
      oldPassword: passwordController.text.trim(),
      newPassword: newPasswordController.text.trim(),
    );
    FocusManager.instance.primaryFocus?.unfocus();
  }

  bool changed() {
    return (passwordController.text.isNotEmpty &&
            newPasswordController.text.isNotEmpty) &&
        passwordController.text != newPasswordController.text;
  }

  void clearControllers() {
    passwordController.clear();
    newPasswordController.clear();
    confirmNewPasswordController.clear();
  }

  @override
  void initState() {
    super.initState();
    AppCubit.get(context).resetVisibilityPassword();
  }

  bool _isPasswordEightCharacters = false;
  bool _isPasswordHasSpecialCharacter = false;
  bool _isPasswordHasUpperAndLower = false;
  onPasswordChanged(String password) {
    final upperLower = RegExp(r"(?=.*[a-z])(?=.*[A-Z])\w+");
    final specialCharacter = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
    setState(() {
      _isPasswordEightCharacters = false;
      if (password.length >= 8) _isPasswordEightCharacters = true;

      _isPasswordHasUpperAndLower = false;
      if (upperLower.hasMatch(password)) _isPasswordHasUpperAndLower = true;

      _isPasswordHasSpecialCharacter = false;
      if (specialCharacter.hasMatch(password))
        _isPasswordHasSpecialCharacter = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, index) {},
      builder: (context, index) => CupertinoPageScaffold(
        navigationBar: customAppBarWithNoTitle(context,
            icon: Icons.arrow_back_ios, onPressed: () => clearControllers()),
        child: SafeArea(
          child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Padding(
              padding: EdgeInsets.only(bottom: kHeight * 0.02),
              child: Scaffold(
                body: BlocConsumer<UserCubit, UserStates>(
                  listener: (context, state) {
                    if (state is ChangePasswordSuccessState) {
                      push(context, PasswordChangedSuccessfully(), root: true);
                      clearControllers();
                    } else if (state is ChangePasswordErrorState) {
                      showToast(
                          msg: UserCubit.get(context).errorMessage,
                          state: ToastStates.ERROR);
                    }
                  },
                  builder: (context, state) => SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Container(
                      height: kHeight * 0.78,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BodyText(
                                text: "Create new password",
                                size: 30,
                                color: ColorManager.black,
                              ),
                              kVSeparator(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Current password",
                                      style: kTheme.textTheme.headline5),
                                  AppFormField(
                                    hint: "Please enter your current password",
                                    type: TextInputType.visiblePassword,
                                    controller: passwordController,
                                    suffixIcon: AppCubit.get(context).suffix,
                                    isPassword:
                                        AppCubit.get(context).isPassword,
                                    onPressed: () {
                                      AppCubit.get(context)
                                          .changePasswordVisibility();
                                    },
                                    onChanged: (value) => setState(() {
                                      changed();
                                    }),
                                  ),
                                  kVSeparator(factor: 0.02),
                                  Text("New Password",
                                      style: kTheme.textTheme.headline5),
                                  AppFormField(
                                    hint:
                                        "Please enter your new shiny password",
                                    type: TextInputType.visiblePassword,
                                    controller: newPasswordController,
                                    suffixIcon:
                                        AppCubit.get(context).newPasswordSuffix,
                                    isPassword:
                                        AppCubit.get(context).isNewPassword,
                                    onPressed: () {
                                      AppCubit.get(context)
                                          .changeNewPasswordVisibility();
                                    },
                                    onChanged: (value) => setState(() {
                                      changed();
                                      onPasswordChanged(value);
                                    }),
                                  ),
                                  kVSeparator(factor: 0.02),
                                  Text("Confirm Password",
                                      style: kTheme.textTheme.headline5),
                                  AppFormField(
                                    hint:
                                        "Please confirm your new shiny password",
                                    type: TextInputType.visiblePassword,
                                    controller: confirmNewPasswordController,
                                    suffixIcon: AppCubit.get(context)
                                        .confirmNewPasswordSuffix,
                                    isPassword: AppCubit.get(context)
                                        .isConfirmNewPassword,
                                    onPressed: () {
                                      AppCubit.get(context)
                                          .changeConfirmNewPasswordVisibility();
                                    },
                                    onChanged: (value) => setState(() {
                                      changed();
                                    }),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: kHeight * 0.02),
                                child: Column(
                                  children: [
                                    Align(
                                      child: BodyText(
                                          text:
                                              "Hints for create a strong password:"),
                                      alignment: Alignment.topLeft,
                                    ),
                                    kVSeparator(factor: 0.01),
                                    Container(
                                      child: validationRow(
                                          condition:
                                              _isPasswordHasUpperAndLower,
                                          message:
                                              "Contains upper and lower case"),
                                    ),
                                    kVSeparator(factor: 0.01),
                                    Container(
                                      child: validationRow(
                                          condition:
                                              _isPasswordHasSpecialCharacter,
                                          message:
                                              "Contains one special character"),
                                    ),
                                    kVSeparator(factor: 0.01),
                                    Container(
                                      child: validationRow(
                                          condition: _isPasswordEightCharacters,
                                          message:
                                              "Contains at least 8 characters"),
                                    ),
                                    kVSeparator(factor: 0.01),
                                    Container(
                                      child: validationRow(
                                          condition:
                                              confirmNewPasswordController
                                                          .text ==
                                                      newPasswordController
                                                          .text &&
                                                  confirmNewPasswordController
                                                      .text.isNotEmpty,
                                          message:
                                              "Please make sure your new passwords match"),
                                    ),
                                    kVSeparator(factor: 0.01),
                                    Container(
                                      child: validationRow(
                                          condition:
                                              confirmNewPasswordController
                                                          .text !=
                                                      passwordController.text &&
                                                  passwordController.text !=
                                                      newPasswordController
                                                          .text,
                                          message:
                                              "Different from your previous password"),
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              SolidButton(
                                child: state is! ChangePasswordLoadingState
                                    ? Text(
                                        "Change Password".toUpperCase(),
                                      )
                                    : MyLoadingIndicator(
                                        height: kHeight * 0.05,
                                        width: kWidth * 0.1,
                                        indicatorType: Indicator.ballBeat,
                                      ),
                                color: Colors.white,
                                radius: 20,
                                size: 12,
                                heightFactor: 0.06,
                                widthFactor: 0.95,
                                onTap: changed()
                                    ? () => _changePassword(context)
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PasswordChangedSuccessfully extends StatelessWidget {
  const PasswordChangedSuccessfully({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CupertinoPageScaffold(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 60.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  ImageAssets.passwordSuccessfully,
                  width: kWidth * 0.7,
                ),
                kVSeparator(factor: 0.1),
                BodyText(
                  text: "Password Updated",
                  size: 24,
                  color: ColorManager.dark,
                ),
                kVSeparator(),
                BodyText(
                  text: "Your password has been updated successfully",
                  color: ColorManager.subtitle,
                ),
                kVSeparator(factor: 0.05),
                Container(
                  width: kWidth * 0.9,
                  child: SolidButton(
                    color: ColorManager.white,
                    backgroundColor: ColorManager.primary,
                    heightFactor: 0.06,
                    size: 20,
                    onTap: () {
                      push(context, MainView());
                    },
                    text: "Start Shopping",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
