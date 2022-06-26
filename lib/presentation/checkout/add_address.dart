import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:graduation_project/business_logic/account_cubit/account_cubit.dart';
import 'package:graduation_project/business_logic/account_cubit/account_states.dart';
import 'package:graduation_project/presentation/account/address_view.dart';
import 'package:graduation_project/shared/helpers.dart';
import 'package:graduation_project/shared/resources/assets_manager.dart';
import 'package:graduation_project/shared/resources/color_manager.dart';
import 'package:graduation_project/shared/widgets/app_buttons.dart';
import 'package:graduation_project/shared/widgets/app_text.dart';

class AddAddressView extends StatelessWidget {
  const AddAddressView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              ImageAssets.deliveryMan,
              height: kHeight * 0.3,
            ),
            kVSeparator(),
            const BodyText(
              align: TextAlign.center,
              text: "No address record here, Please add one to continue.",
              color: Color(0xff333333),
            ),
            kVSeparator(factor: 0.04),
            SolidButton(
              text: "Add Your Address",
              color: Colors.white,
              heightFactor: 0.06,
              widthFactor: 0.8,
              onTap: () => showEditInfoSheet(
                context,
                child: const AddressView(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddressInfoView extends StatelessWidget {
  const AddressInfoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AccountCubit, AccountStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final cubit = AccountCubit.get(context);
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BodyText(text: "My Address", color: ColorManager.primary),
              kVSeparator(),
              Row(
                children: [
                  SubtitleText(color: ColorManager.info, text: "Name: "),
                  kHSeparator(),
                  BodyText(
                    color: ColorManager.black,
                    text: cubit.addressModel?.name ?? "",
                  ),
                ],
              ),
              kVSeparator(),
              Row(
                children: [
                  SubtitleText(color: ColorManager.info, text: "Phone: "),
                  kHSeparator(),
                  BodyText(
                      color: ColorManager.black,
                      text: cubit.addressModel?.phone ?? ""),
                ],
              ),
              kVSeparator(),
              Row(
                children: [
                  SubtitleText(color: ColorManager.info, text: "Region: "),
                  kHSeparator(),
                  BodyText(
                      color: ColorManager.black,
                      text: cubit.addressModel?.region ?? ""),
                ],
              ),
              kVSeparator(),
              Row(
                children: [
                  SubtitleText(color: ColorManager.info, text: "City: "),
                  kHSeparator(),
                  BodyText(
                      color: ColorManager.black,
                      text: cubit.addressModel?.city ?? ""),
                ],
              ),
              kVSeparator(),
              Row(
                children: [
                  SubtitleText(color: ColorManager.info, text: "ZipCode: "),
                  kHSeparator(),
                  BodyText(
                      color: ColorManager.black,
                      text: cubit.addressModel?.zipCode ?? ""),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
