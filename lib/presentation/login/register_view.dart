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
import '../../shared/validator.dart';
import '../../shared/widgets/app_buttons.dart';
import '../../shared/widgets/app_text.dart';
import '../../shared/widgets/indicators.dart';
import '../../shared/widgets/textfield.dart';
import 'account_view.dart';

class RegisterView extends StatefulWidget {
  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  var formKey = GlobalKey<FormState>();

  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  var nameController = TextEditingController();

  var phoneController = TextEditingController();

  _register() {
    UserCubit.get(context).userRegister(
      email: emailController.text,
      name: nameController.text,
      phone: phoneController.text,
      password: passwordController.text,
    );
    FocusManager.instance.primaryFocus?.unfocus();
  }

  bool valid() {
    return emailController.text.isNotEmpty &&
        nameController.text.isNotEmpty &&
        this.isPasswordValid() &&
        this.isPhoneValid();
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

  bool isPasswordValid() =>
      _isPasswordEightCharacters &&
      _isPasswordHasSpecialCharacter &&
      _isPasswordHasUpperAndLower;

  bool isEmailCorrect = false;
  onEmailChanged(String email) {
    final emailReg = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    setState(() {
      isEmailCorrect = false;
      if (emailReg.hasMatch(email)) isEmailCorrect = true;
    });
  }

  bool isPhoneCorrect = false;
  bool isPhoneElevenDigits = false;
  bool isPhoneValid() => isPhoneCorrect && isPhoneElevenDigits;

  onPhoneChanged(String phone) {
    final phoneReg = RegExp(r"^01[0125]");
    setState(() {
      isPhoneElevenDigits = false;
      if (phoneController.text.length == 11) isPhoneElevenDigits = true;

      isPhoneCorrect = false;
      if (phoneReg.hasMatch(phone)) isPhoneCorrect = true;
    });
  }

  @override
  void initState() {
    super.initState();
    AppCubit.get(context).resetVisibilityPassword();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return BlocConsumer<UserCubit, UserStates>(
            listener: (context, state) {
              if (state is RegisterSuccessState) {
                CashHelper.saveData(key: 'token', value: state.loginModel.token)
                    .then((value) {
                  token = state.loginModel.token!;
                  tabController.index = 0;
                  Navigator.pushReplacementNamed(context, Routes.mainRoute);
                  showToast(
                      msg: UserCubit.get(context).successMessage,
                      state: ToastStates.success);
                });
              } else if (state is RegisterErrorState ||
                  state is EmailExistSuccessState ||
                  state is EmailExistErrorState) {
                showToast(
                    msg: UserCubit.get(context).errorMessage,
                    state: ToastStates.error);
              }
            },
            builder: (context, state) => SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: kHeight * 0.1),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        ImageAssets.register,
                        height: kHeight * 0.2,
                        width: kWidth * 0.2,
                      ),
                      ConstrainedBox(
                        constraints: new BoxConstraints(
                          minHeight: kHeight * 0.75,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Text(
                                  "Create new account",
                                  style: kTheme.textTheme.headline1!
                                      .copyWith(color: ColorManager.black),
                                ),
                                kVSeparator(),
                                SubtitleText(
                                  text:
                                      "Register now, and enjoy with our products.",
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
                                  inputAction: TextInputAction.next,
                                  autoFill: [AutofillHints.email],
                                  padding: kHeight * 0.015,
                                  controller: emailController,
                                  prefixIcon: FontAwesomeIcons.atlassian,
                                  validate: emailValidator,
                                  onChanged: (email) => setState(() {
                                    valid();
                                    onEmailChanged(email);
                                  }),
                                ),
                                emailController.text.isNotEmpty &&
                                        !isEmailCorrect
                                    ? Container(
                                        decoration: BoxDecoration(
                                          color: ColorManager.primary
                                              .withOpacity(0.2),
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(15),
                                              bottomRight: Radius.circular(15)),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Container(
                                                child: validationRow(
                                                    condition: isEmailCorrect,
                                                    message:
                                                        "Email must contain '@' and '.'"),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : SizedBox.shrink(),
                                kVSeparator(factor: 0.015),
                                AppFormField(
                                  hint: "Full Name",
                                  type: TextInputType.name,
                                  inputAction: TextInputAction.next,
                                  autoFill: [AutofillHints.name],
                                  padding: kHeight * 0.015,
                                  controller: nameController,
                                  prefixIcon: FontAwesomeIcons.solidIdBadge,
                                  onChanged: (name) => setState(() => valid()),
                                ),
                                kVSeparator(factor: 0.015),
                                AppFormField(
                                  hint: "Phone Number",
                                  autoFill: [AutofillHints.telephoneNumber],
                                  inputAction: TextInputAction.next,
                                  type: TextInputType.number,
                                  padding: kHeight * 0.015,
                                  controller: phoneController,
                                  prefixIcon: FontAwesomeIcons.squarePhone,
                                  onChanged: (phone) => setState(() {
                                    onPhoneChanged(phone);
                                    valid();
                                  }),
                                ),
                                phoneController.text.isNotEmpty &&
                                        (!isPhoneElevenDigits ||
                                            !isPhoneCorrect)
                                    ? Container(
                                        decoration: BoxDecoration(
                                          color: ColorManager.primary
                                              .withOpacity(.2),
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(5),
                                              bottomRight: Radius.circular(5)),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Column(
                                            children: [
                                              Container(
                                                child: validationRow(
                                                    condition:
                                                        isPhoneElevenDigits,
                                                    message:
                                                        "Phone must be exactly 11 digits."),
                                              ),
                                              kVSeparator(factor: 0.01),
                                              Container(
                                                child: validationRow(
                                                    condition: isPhoneCorrect,
                                                    message:
                                                        "phone must start with 010-011-012-015"),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : SizedBox.shrink(),
                                kVSeparator(factor: 0.015),
                                AppFormField(
                                  hint: "Password",
                                  type: TextInputType.visiblePassword,
                                  autoFill: [AutofillHints.password],
                                  padding: kHeight * 0.015,
                                  controller: passwordController,
                                  prefixIcon: FontAwesomeIcons.lock,
                                  inputAction: TextInputAction.done,
                                  suffixIcon: AppCubit.get(context).suffix,
                                  isPassword: AppCubit.get(context).isPassword,
                                  onPressed: () {
                                    AppCubit.get(context)
                                        .changePasswordVisibility();
                                  },
                                  onChanged: (password) => setState(
                                    () {
                                      onPasswordChanged(password);
                                      valid();
                                    },
                                  ),
                                  onSubmit: (value) =>
                                      TextInput.finishAutofillContext(),
                                ),
                                passwordController.text.length > 0 &&
                                        (!_isPasswordHasSpecialCharacter ||
                                            !_isPasswordHasUpperAndLower ||
                                            !_isPasswordEightCharacters)
                                    ? Container(
                                        decoration: BoxDecoration(
                                          color: ColorManager.primary
                                              .withOpacity(0.2),
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(15),
                                              bottomRight: Radius.circular(15)),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
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
                                                    condition:
                                                        _isPasswordEightCharacters,
                                                    message:
                                                        "Contains at least 8 characters"),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : SizedBox.shrink(),
                                kVSeparator(factor: 0.015),
                              ],
                            ),
                            Column(
                              children: [
                                SolidButton(
                                  color: Colors.white,
                                  heightFactor: 0.06,
                                  size: 20,
                                  onTap: valid() ? () => _register() : null,
                                  child: state is EmailExistLoadingState ||
                                          state is RegisterLoadingState
                                      ? const MyLoadingIndicator(
                                          height: 20, width: 30)
                                      : null,
                                  text: "Create Account",
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
                                  onTap: () => accountController.previousPage(
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.easeOutSine,
                                  ),
                                  text: "Log in",
                                ),
                              ],
                            ),
                            kVSeparator(factor: 0.015),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
