import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/business_logic/account_cubit/account_cubit.dart';
import 'package:graduation_project/business_logic/account_cubit/account_states.dart';
import 'package:graduation_project/business_logic/user_cubit/user_cubit.dart';
import 'package:graduation_project/data/models/address_model.dart';
import 'package:graduation_project/data/models/identity/user_model.dart';
import 'package:graduation_project/shared/components.dart';
import 'package:graduation_project/shared/constants.dart';
import 'package:graduation_project/shared/helpers.dart';
import 'package:graduation_project/shared/resources/color_manager.dart';
import 'package:graduation_project/shared/validator.dart';
import 'package:graduation_project/shared/widgets/app_buttons.dart';
import 'package:graduation_project/shared/widgets/indicators.dart';
import 'package:graduation_project/shared/widgets/textfield.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

class AddressView extends StatefulWidget {
  const AddressView({Key? key}) : super(key: key);

  @override
  State<AddressView> createState() => _AddressViewState();
}

class _AddressViewState extends State<AddressView> {
  static final formKey = new GlobalKey<FormState>();
  var detailsController = TextEditingController();
  var addressNameController = TextEditingController();
  var addressPhoneController = TextEditingController();
  var zipCodeController = TextEditingController();
  void _changeAddress(context) {
    if (formKey.currentState!.validate()) {
      AccountCubit.get(context).updateUserAddress(
        name: addressNameController.text,
        details: detailsController.text,
        zipCode: zipCodeController.text,
        phone: addressPhoneController.text,
      );
    }
    FocusManager.instance.primaryFocus?.unfocus();
  }

  AddressModel? addressModel;
  UserModel? userModel;

  bool _changed() {
    bool isEmpty = addressNameController.text.isEmpty ||
        addressPhoneController.text.isEmpty ||
        zipCodeController.text.isEmpty ||
        AccountCubit.get(context).selectedCity == null ||
        AccountCubit.get(context).selectedRegion == null;

    bool isChanged = addressNameController.text != addressModel!.name ||
        addressPhoneController.text != addressModel!.phone ||
        zipCodeController.text != addressModel!.zipCode ||
        detailsController.text != addressModel!.details ||
        addressModel!.region != AccountCubit.get(context).getRegionNameById();

    bool isCityChanged = addressModel!.city == null
        ? false
        : addressModel!.city! != AccountCubit.get(context).getCityNameById();

    return (!isEmpty && isChanged) || isCityChanged;
  }

  @override
  void initState() {
    userModel = UserCubit.get(context).userModel;
    addressModel = AccountCubit.get(context).addressModel;
    addressNameController.text =
        addressModel!.name ?? UserCubit.get(context).userModel!.name!;
    addressPhoneController.text =
        addressModel!.phone ?? UserCubit.get(context).userModel!.phone!;
    zipCodeController.text = addressModel!.zipCode ?? "";
    detailsController.text = addressModel!.details ?? "";
    if (AccountCubit.get(context).selectedCity != null)
      AccountCubit.get(context).getRegionCities();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AccountCubit, AccountStates>(
      listener: (context, state) {
        if (state is ShopSuccessUpdateAddressState) {
          Navigator.pop(context);
          showToast(
              msg: AccountCubit.get(context).successMessage,
              state: ToastStates.SUCCESS);
        } else if (state is ShopErrorUpdateAddressState) {
          showToast(
              msg: AccountCubit.get(context).errorMessage,
              state: ToastStates.ERROR);
        }
      },
      builder: (context, state) {
        var cubit = AccountCubit.get(context);
        return CupertinoPageScaffold(
          navigationBar:
              customAppBar(context, "Address Settings", onPressed: () {
            if (cubit.addressModel!.region != null &&
                cubit.addressModel!.city != null) {
              cubit.getSelectedRegionId();
              cubit.getSelectedCityId();
            }
          }),
          child: ConditionalBuilder(
            condition: cubit.isAddressLoaded() &&
                state is! ShopLoadingGetAddressState &&
                userModel != null,
            builder: (context) => SafeArea(
              child: GestureDetector(
                onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                child: Padding(
                  padding: EdgeInsets.only(bottom: kHeight * 0.02),
                  child: Scaffold(
                    resizeToAvoidBottomInset: false,
                    body: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Form(
                                key: formKey,
                                child: Column(
                                  children: [
                                    Text(
                                      "Location Information".toUpperCase(),
                                      style:
                                          kTheme.textTheme.headline5!.copyWith(
                                        color: ColorManager.info,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Region *",
                                            style: kTheme.textTheme.caption!
                                                .copyWith(
                                              color: ColorManager.dark
                                                  .withOpacity(0.6),
                                            )),
                                        FormHelper.dropDownWidget(
                                          context,
                                          "--Select your Region",
                                          cubit.selectedRegion,
                                          cubit.regions,
                                          (onChangedVal) {
                                            setState(() {
                                              cubit.selectedRegion =
                                                  onChangedVal;
                                              cubit.selectedCity = null;
                                              cubit.getRegionCities();
                                            });
                                          },
                                          (onValidateVal) {
                                            if (onValidateVal == null)
                                              return "Please Select a region";
                                            return null;
                                          },
                                          borderRadius: 5,
                                          borderColor: ColorManager.dark,
                                          borderFocusColor: ColorManager.dark,
                                          contentPadding: 10,
                                          hintColor: ColorManager.subtitle,
                                          paddingLeft: 0,
                                          paddingRight: 0,
                                          paddingTop: 10,
                                        ),
                                        kVSeparator(),
                                        Text("City *",
                                            style: kTheme.textTheme.caption!
                                                .copyWith(
                                                    color: ColorManager.dark
                                                        .withOpacity(0.6))),
                                        FormHelper.dropDownWidget(
                                          context,
                                          "--Select your City",
                                          cubit.selectedCity,
                                          cubit.regionCities,
                                          (onChangedVal) {
                                            cubit.selectedCity = onChangedVal;
                                            setState(() {
                                              cubit.selectedRegion = cubit
                                                  .regionCities[0]["ParentId"]
                                                  .toString();
                                            });
                                          },
                                          (onValidateVal) {
                                            if (onValidateVal == null)
                                              return "Please Select a region";
                                            return null;
                                          },
                                          borderRadius: 5,
                                          borderColor: ColorManager.dark,
                                          borderFocusColor: ColorManager.dark,
                                          contentPadding: 10,
                                          hintColor: ColorManager.subtitle,
                                          paddingLeft: 0,
                                          paddingRight: 0,
                                          paddingTop: 10,
                                          optionValue: "ID",
                                          optionLabel: "Name",
                                        ),
                                        kVSeparator(),
                                        Text("Additional address details",
                                            style: kTheme.textTheme.caption!
                                                .copyWith(
                                                    color: ColorManager.dark
                                                        .withOpacity(0.6))),
                                        AppFormField(
                                          hint:
                                              "Where do you want us to drop the package?",
                                          type: TextInputType.name,
                                          controller: detailsController,
                                          onChanged: (String value) =>
                                              setState(() {
                                            _changed();
                                          }),
                                        ),
                                      ],
                                    ),
                                    kVSeparator(factor: 0.04),
                                    Text(
                                      "Personal Information".toUpperCase(),
                                      style:
                                          kTheme.textTheme.headline5!.copyWith(
                                        color: ColorManager.info,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Your name *",
                                            style: kTheme.textTheme.caption!
                                                .copyWith(
                                                    color: ColorManager.dark
                                                        .withOpacity(0.6))),
                                        AppFormField(
                                          hint: "Please enter your name",
                                          type: TextInputType.name,
                                          controller: addressNameController,
                                          onChanged: (String value) =>
                                              setState(() {
                                            _changed();
                                          }),
                                          validate: nameValidator,
                                        ),
                                        kVSeparator(),
                                        Text("Your phone number",
                                            style: kTheme.textTheme.caption!
                                                .copyWith(
                                                    color: ColorManager.dark
                                                        .withOpacity(0.6))),
                                        AppFormField(
                                          hint: "what is your phone number?",
                                          type: TextInputType.name,
                                          enabled: false,
                                          controller: addressPhoneController,
                                          onChanged: (String value) =>
                                              setState(() {
                                            _changed();
                                          }),
                                          validate: phoneValidator,
                                        ),
                                        kVSeparator(),
                                        Text("Zip code *",
                                            style: kTheme.textTheme.caption!
                                                .copyWith(
                                                    color: ColorManager.dark
                                                        .withOpacity(0.6))),
                                        AppFormField(
                                          hint: "Please enter your zip code",
                                          type: TextInputType.name,
                                          controller: zipCodeController,
                                          onChanged: (String value) =>
                                              setState(() {
                                            _changed();
                                          }),
                                          validate: zipValidator,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            kVSeparator(),
                            SolidButton(
                              child: state is! ShopLoadingUpdateAddressState
                                  ? Text(
                                      "Update your Address".toUpperCase(),
                                    )
                                  : const MyLoadingIndicator(
                                      height: 20, width: 30),
                              color: Colors.white,
                              radius: 20,
                              size: 12,
                              heightFactor: 0.06,
                              widthFactor: 0.95,
                              onTap: _changed()
                                  ? () => _changeAddress(context)
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
            fallback: (context) => Center(
                child: const MyLoadingIndicator(
              circular: true,
            )),
          ),
        );
      },
    );
  }
}
