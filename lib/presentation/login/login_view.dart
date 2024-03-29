import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../business_logic/app_cubit/app_cubit.dart';
import '../../business_logic/app_cubit/app_states.dart';
import '../../business_logic/user_cubit/user_cubit.dart';
import '../../business_logic/user_cubit/user_states.dart';
import '../../data/cashe_helper.dart';
import '../../shared/components.dart';
import '../../shared/constants.dart';
import '../../shared/helpers.dart';
import '../../shared/resources/assets_manager.dart';
import '../../shared/resources/color_manager.dart';
import '../../shared/resources/routes_manager.dart';
import '../../shared/widgets/app_buttons.dart';
import '../../shared/widgets/app_text.dart';
import '../../shared/widgets/indicators.dart';
import '../../shared/widgets/textfield.dart';
import 'account_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  var formKey = GlobalKey<FormState>();
  bool isValid = true;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var scrollController = ScrollController();
  _login() {
    scrollController.animateTo(0,
        duration: Duration(milliseconds: 200), curve: Curves.easeInCubic);
    if (formKey.currentState!.validate()) {
      UserCubit.get(context).userLogin(
          email: emailController.text, password: passwordController.text);
    }
    FocusManager.instance.primaryFocus?.unfocus();
  }

  bool valid() {
    return emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    AppCubit.get(context).resetVisibilityPassword();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      builder: (context, state) =>
          BlocConsumer<UserCubit, UserStates>(listener: (context, state) {
        if (state is LoginSuccessState) {
          CashHelper.saveData(key: 'token', value: state.loginModel.token)
              .then((value) {
            token = state.loginModel.token!;
            tabController.index = 0;
            Navigator.pushReplacementNamed(context, Routes.mainRoute);
            showToast(
                msg: UserCubit.get(context).successMessage,
                state: ToastStates.success);
          });
        } else if (state is LoginErrorState) {
          showToast(
              msg: UserCubit.get(context).errorMessage,
              state: ToastStates.error);
        }
      }, builder: (context, state) {
        return GestureDetector(
          onTap: () {
            scrollController.animateTo(0,
                duration: Duration(milliseconds: 200),
                curve: Curves.easeInCubic);
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: SingleChildScrollView(
            controller: scrollController,
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 20.0, vertical: kHeight * 0.1),
              child: Column(
                children: [
                  SvgPicture.asset(
                    ImageAssets.login,
                    height: kHeight * 0.3,
                  ),
                  Container(
                    height: kHeight * 0.6,
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(
                                "Hello Again!",
                                style: kTheme.textTheme.headline1!
                                    .copyWith(color: ColorManager.black),
                              ),
                              kVSeparator(),
                              SubtitleText(
                                text: "Welcome back you've been missed!",
                                size: 18,
                                color: ColorManager.subtitle.withOpacity(0.7),
                                align: TextAlign.center,
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              AppFormField(
                                hint: "Email ID",
                                type: TextInputType.emailAddress,
                                autoFill: [AutofillHints.email],
                                inputAction: TextInputAction.next,
                                padding: kHeight * 0.015,
                                controller: emailController,
                                prefixIcon: FontAwesomeIcons.atlassian,
                                onChanged: (value) => setState(() => valid()),
                              ),
                              kVSeparator(),
                              AppFormField(
                                hint: "Password",
                                type: TextInputType.visiblePassword,
                                padding: kHeight * 0.015,
                                autoFill: [AutofillHints.password],
                                inputAction: TextInputAction.done,
                                onSubmit: (val) =>
                                    TextInput.finishAutofillContext(),
                                controller: passwordController,
                                prefixIcon: FontAwesomeIcons.lock,
                                suffixIcon: AppCubit.get(context).suffix,
                                isPassword: AppCubit.get(context).isPassword,
                                onPressed: () {
                                  AppCubit.get(context)
                                      .changePasswordVisibility();
                                },
                                onChanged: (value) => setState(() => valid()),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              kVSeparator(factor: 0.04),
                              SolidButton(
                                color: Colors.white,
                                heightFactor: 0.06,
                                size: 20,
                                onTap: valid()
                                    ? () => _login()
                                    : () => showRequiredFieldsDialog(context),
                                child: state is! LoginLoadingState
                                    ? null
                                    : const MyLoadingIndicator(
                                        height: 20, width: 30),
                                text: "Log in",
                              ),
                              kVSeparator(factor: 0.01),
                              Row(
                                children: [
                                  Expanded(
                                    child: Divider(
                                      color: ColorManager.primary,
                                      thickness: 1,
                                      endIndent: 20,
                                      indent: 10,
                                    ),
                                  ),
                                  BodyText(
                                      text: "OR",
                                      color: ColorManager.primary,
                                      size: 12),
                                  Expanded(
                                    child: Divider(
                                      color: ColorManager.primary,
                                      thickness: 1,
                                      indent: 20,
                                      endIndent: 10,
                                    ),
                                  ),
                                ],
                              ),
                              kVSeparator(factor: 0.01),
                              SolidButton(
                                color: ColorManager.subtitle,
                                splashColor: ColorManager.subtitle,
                                borderColor: ColorManager.subtitle,
                                heightFactor: 0.06,
                                size: 20,
                                backgroundColor: ColorManager.white,
                                onTap: () {
                                  CashHelper.saveData(
                                      key: 'onBoarding', value: false);
                                  accountController.nextPage(
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.easeOutSine,
                                  );
                                },
                                text: "Sign up",
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
      listener: (context, state) {},
    );
  }
}
