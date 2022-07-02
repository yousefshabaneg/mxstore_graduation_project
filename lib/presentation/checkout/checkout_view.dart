import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graduation_project/business_logic/account_cubit/account_cubit.dart';
import 'package:graduation_project/business_logic/account_cubit/account_states.dart';
import 'package:graduation_project/business_logic/shop_cubit/shop_cubit.dart';
import 'package:graduation_project/business_logic/shop_cubit/shop_states.dart';
import 'package:graduation_project/presentation/account/address_view.dart';
import 'package:graduation_project/presentation/checkout/add_address.dart';
import 'package:graduation_project/presentation/checkout/add_delivery.dart';
import 'package:graduation_project/presentation/checkout/order_confirmed_view.dart';
import 'package:graduation_project/presentation/checkout/payment_view.dart';
import 'package:graduation_project/presentation/checkout/summary.dart';
import 'package:graduation_project/shared/constants.dart';
import 'package:graduation_project/shared/helpers.dart';
import 'package:graduation_project/shared/resources/color_manager.dart';
import 'package:graduation_project/shared/widgets/app_buttons.dart';
import 'package:graduation_project/shared/widgets/app_text.dart';
import 'package:im_stepper/stepper.dart';

class CheckoutView extends StatefulWidget {
  const CheckoutView({Key? key}) : super(key: key);

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  @override
  Widget build(BuildContext context) {
    return IconStepperDemo();
  }
}

class IconStepperDemo extends StatefulWidget {
  @override
  _IconStepperDemo createState() => _IconStepperDemo();
}

class _IconStepperDemo extends State<IconStepperDemo> {
  int activeStep = 0;
  int upperBound = 3;

  Widget stepsContent(index) {
    switch (index) {
      case 1:
        return const DeliveryMethodView();
      case 2:
        return const SummaryView();
      case 3:
        return const CreditCardPage();
      default:
        return isHaveAddress()
            ? const AddressInfoView()
            : const AddAddressView();
    }
  }

  bool isHaveAddress() {
    return AccountCubit.get(context).isHaveRegionAndCity();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AccountCubit, AccountStates>(
      listener: (context, state) {},
      builder: (context, state) => BlocConsumer<ShopCubit, ShopStates>(
        listener: (context, state) {},
        builder: (context, state) => Scaffold(
          appBar: AppBar(
            leading: BackButton(
              onPressed: () {
                if (activeStep > 0) {
                  setState(() {
                    activeStep--;
                  });
                } else
                  Navigator.pop(context);
              },
            ),
            actions: [
              IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.clear))
            ],
            centerTitle: true,
            title: BodyText(
                text: headerText(), color: ColorManager.black, size: 18),
            elevation: 2,
            shadowColor: ColorManager.blue,
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: stepsContent(activeStep),
          ),
          bottomSheet: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isHaveAddress()) nextButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Returns the next button.
  Widget nextButton() {
    return SolidButton(
      text: (ShopCubit.get(context).paymentMethodId == 1 && activeStep == 2) ||
              (ShopCubit.get(context).paymentMethodId == 2 && activeStep == 3)
          ? "Place Order"
          : "Continue",
      color: Colors.white,
      heightFactor: 0.06,
      widthFactor: 0.9,
      radius: 5,
      onTap: () async {
        if (ShopCubit.get(context).paymentMethodId == 1 && activeStep == 2) {
          await ShopCubit.get(context)
              .placeOrderCash(AccountCubit.get(context).addressModel!)
              .then((value) {
            // if(value != null){
            push(context, OrderConfirmedView(orderId: value));
            // }
          });
        } else if (ShopCubit.get(context).paymentMethodId == 2 &&
            activeStep == 3) {
          if (ShopCubit.get(context).cardFormKey.currentState!.validate()) {
            ShopCubit.get(context).payWithCard();
            FocusManager.instance.primaryFocus?.unfocus();
          }
        } else if (activeStep < upperBound) {
          setState(() {
            activeStep++;
          });
        }
      },
    );
  }

  /// Returns the header text based on the activeStep.
  String headerText() {
    switch (activeStep) {
      case 1:
        return 'Delivery Method';

      case 2:
        return 'Summary';

      case 3:
        return 'Payment';

      default:
        return 'Address Details';
    }
  }
}
