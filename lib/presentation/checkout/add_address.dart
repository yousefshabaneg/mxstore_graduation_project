import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graduation_project/business_logic/account_cubit/account_cubit.dart';
import 'package:graduation_project/business_logic/account_cubit/account_states.dart';
import 'package:graduation_project/presentation/account/address_view.dart';
import 'package:graduation_project/shared/helpers.dart';
import 'package:graduation_project/shared/resources/assets_manager.dart';
import 'package:graduation_project/shared/resources/color_manager.dart';
import 'package:graduation_project/shared/widgets/app_buttons.dart';
import 'package:graduation_project/shared/widgets/app_text.dart';
import 'package:graduation_project/shared/widgets/indicators.dart';
import 'package:loading_indicator/loading_indicator.dart';

class AddAddressView extends StatelessWidget {
  const AddAddressView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
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
        return ConditionalBuilder(
          condition: cubit.addressModel != null,
          builder: (context) => Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: ColorManager.blue, width: 2),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.locationDot,
                          color: ColorManager.subtitle,
                          size: 16,
                        ),
                        kHSeparator(),
                        BodyText(text: "My Address", color: ColorManager.error),
                        const Spacer(),
                        MyTextButton(
                          text: "Edit",
                          withIcon: true,
                          icon: Icons.edit,
                          color: ColorManager.blue,
                          size: 16,
                          onTap: () =>
                              showEditInfoSheet(context, child: AddressView()),
                        ),
                      ],
                    ),
                    kVSeparator(),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SubtitleText(
                                color: ColorManager.subtitle, text: "Name"),
                            kVSeparator(),
                            SubtitleText(
                                color: ColorManager.subtitle, text: "Phone"),
                            kVSeparator(),
                            SubtitleText(
                                color: ColorManager.subtitle, text: "Region"),
                            kVSeparator(),
                            SubtitleText(
                                color: ColorManager.subtitle, text: "City"),
                            kVSeparator(),
                            SubtitleText(
                                color: ColorManager.subtitle, text: "ZipCode"),
                            if (cubit.addressModel!.details!.length > 1) ...[
                              kVSeparator(),
                              SubtitleText(
                                  color: ColorManager.subtitle,
                                  text: "Details"),
                            ]
                          ],
                        ),
                        kHSeparator(factor: 0.2),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: kWidth * 0.5,
                              child: BodyText(
                                color: ColorManager.black,
                                text: cubit.addressModel?.name ?? "",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            kVSeparator(),
                            BodyText(
                                color: ColorManager.black,
                                text: cubit.addressModel?.phone ?? ""),
                            kVSeparator(),
                            BodyText(
                                color: ColorManager.black,
                                text: cubit.addressModel?.region ?? ""),
                            kVSeparator(),
                            BodyText(
                                color: ColorManager.black,
                                text: cubit.addressModel?.city ?? ""),
                            kVSeparator(),
                            BodyText(
                                color: ColorManager.black,
                                text: cubit.addressModel?.zipCode ?? ""),
                            if (cubit.addressModel!.details!.length > 1) ...[
                              kVSeparator(),
                              SizedBox(
                                width: kWidth * 0.5,
                                child: BodyText(
                                    color: ColorManager.black,
                                    text: cubit.addressModel?.details ?? ""),
                              ),
                            ]
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          fallback: (context) => Expanded(
              child: const MyLoadingIndicator(
                  indicatorType: Indicator.ballSpinFadeLoader)),
        );
      },
    );
  }
}
