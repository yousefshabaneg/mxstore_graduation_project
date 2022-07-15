import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../business_logic/user_cubit/user_cubit.dart';
import '../../../business_logic/user_cubit/user_states.dart';
import '../../../data/models/identity/user_model.dart';
import '../../../presentation/account/settings_view.dart';
import '../../components.dart';
import '../../constants.dart';
import '../../helpers.dart';
import '../../resources/color_manager.dart';
import '../../validator.dart';
import '../app_buttons.dart';
import '../indicators.dart';
import '../textfield.dart';

class EditPersonalInfoWidget extends StatefulWidget {
  EditPersonalInfoWidget({required this.userModel});
  final UserModel userModel;
  @override
  State<EditPersonalInfoWidget> createState() => _EditPersonalInfoWidgetState();
}

class _EditPersonalInfoWidgetState extends State<EditPersonalInfoWidget> {
  static final formKey = new GlobalKey<FormState>();

  bool _changed() {
    return (nameController.text != widget.userModel.name ||
            phoneController.text != widget.userModel.phone ||
            emailController.text != widget.userModel.email) &&
        (nameController.text.isNotEmpty &&
            phoneController.text.length == 11 &&
            emailController.text.isNotEmpty);
  }

  void _updateProfile(context) {
    String name =
        nameController.text == widget.userModel.name ? "" : nameController.text;
    String email = emailController.text == widget.userModel.email
        ? ""
        : emailController.text;
    String phone = phoneController.text == widget.userModel.phone
        ? ""
        : phoneController.text;
    UserCubit.get(context)
        .changeUserData(name: name, email: email, phone: phone);
    FocusManager.instance.primaryFocus?.unfocus();
  }

  bool isEmailCorrect = true;
  onEmailChanged(String email) {
    final emailReg = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    setState(() {
      isEmailCorrect = false;
      if (emailReg.hasMatch(email)) isEmailCorrect = true;
    });
  }

  bool isPhoneValid = true;
  bool isPhoneElevenDigits = true;
  onPhoneChanged(String phone) {
    final phoneReg = RegExp(r"^01[0125]");
    setState(() {
      isPhoneElevenDigits = false;
      if (phoneController.text.length == 11) isPhoneElevenDigits = true;

      isPhoneValid = false;
      if (phoneReg.hasMatch(phone)) isPhoneValid = true;
    });
  }

  @override
  void initState() {
    nameController.text = widget.userModel.name!;
    phoneController.text = widget.userModel.phone!;
    emailController.text = widget.userModel.email!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar:
          customAppBar(context, "Personal Information", icon: Icons.clear),
      child: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(10),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Full name", style: kTheme.textTheme.caption),
                    AppFormField(
                      hint: "Full Name",
                      type: TextInputType.name,
                      autoFill: [AutofillHints.name],
                      controller: nameController,
                      prefixIcon: FontAwesomeIcons.solidIdBadge,
                      validate: nameValidator,
                      onChanged: (String value) => setState(() {
                        _changed();
                      }),
                    ),
                    kVSeparator(factor: 0.02),
                    Text("Phone number", style: kTheme.textTheme.caption),
                    AppFormField(
                      hint: "Phone mumber",
                      autoFill: [AutofillHints.telephoneNumber],
                      type: TextInputType.phone,
                      controller: phoneController,
                      prefixIcon: FontAwesomeIcons.squarePhone,
                      onChanged: (String value) => setState(() {
                        _changed();
                        onPhoneChanged(value);
                      }),
                    ),
                    phoneController.text.isNotEmpty &&
                            (!isPhoneElevenDigits || !isPhoneValid)
                        ? Container(
                            decoration: BoxDecoration(
                              color: ColorManager.primary.withOpacity(.2),
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
                                        condition: isPhoneElevenDigits,
                                        message:
                                            "Phone must be exactly 11 digits."),
                                  ),
                                  kVSeparator(factor: 0.01),
                                  Container(
                                    child: validationRow(
                                        condition: isPhoneValid,
                                        message:
                                            "phone must start with 010-011-012-015"),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : SizedBox.shrink(),
                    kVSeparator(factor: 0.02),
                    Text("Email address", style: kTheme.textTheme.caption),
                    AppFormField(
                      hint: "Email ID",
                      type: TextInputType.emailAddress,
                      autoFill: [AutofillHints.email],
                      controller: emailController,
                      prefixIcon: FontAwesomeIcons.atlassian,
                      onChanged: (String value) => setState(() {
                        _changed();
                        onEmailChanged(value);
                      }),
                    ),
                    emailController.text.isNotEmpty && !isEmailCorrect
                        ? Container(
                            decoration: BoxDecoration(
                              color: ColorManager.primary.withOpacity(0.2),
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
                    const Spacer(),
                    BlocConsumer<UserCubit, UserStates>(
                      listener: (context, state) {
                        if (state is UpdateUserDataSuccessState) {
                          Navigator.pop(context);
                          showToast(
                              msg: UserCubit.get(context).successMessage,
                              state: ToastStates.success);
                        }
                      },
                      builder: (context, state) => SolidButton(
                        child: state is! UpdateUserDataLoadingState
                            ? Text("Save")
                            : MyLoadingIndicator(
                                height: kHeight * 0.05, width: kWidth * 0.1),
                        color: Colors.white,
                        radius: 20,
                        heightFactor: 0.06,
                        widthFactor: 0.95,
                        size: 12,
                        onTap:
                            _changed() ? () => _updateProfile(context) : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
