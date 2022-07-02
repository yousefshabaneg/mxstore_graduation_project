import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:graduation_project/business_logic/shop_cubit/shop_cubit.dart';
import 'package:graduation_project/business_logic/shop_cubit/shop_states.dart';
import 'package:graduation_project/shared/constants.dart';
import 'package:graduation_project/shared/helpers.dart';
import 'package:graduation_project/shared/resources/color_manager.dart';
import 'package:graduation_project/shared/widgets/app_text.dart';

class CreditCardPage extends StatefulWidget {
  const CreditCardPage({Key? key}) : super(key: key);

  @override
  _CreditCardPageState createState() => _CreditCardPageState();
}

class _CreditCardPageState extends State<CreditCardPage> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) => Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                  child: SingleChildScrollView(
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: BodyText(
                            text: "Pay With Card",
                            color: ColorManager.dark,
                            size: 20,
                          ),
                        ),
                        CreditCardForm(
                          cardNumber: ShopCubit.get(context).cardNumber,
                          expiryDate: ShopCubit.get(context).expiryDate,
                          cardHolderName: ShopCubit.get(context).cardHolderName,
                          cvvCode: ShopCubit.get(context).cvvCode,
                          onCreditCardModelChange: onCreditCardModelChange,
                          themeColor: Colors.blue,
                          formKey: ShopCubit.get(context).cardFormKey,
                          cursorColor: ColorManager.primary,
                          obscureCvv: true,
                          cardNumberDecoration: InputDecoration(
                              hintStyle: kTheme.textTheme.headline5!
                                  .copyWith(color: Colors.grey.shade500),
                              border: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.black87)),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: ColorManager.primaryOpacity70),
                              ),
                              errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: ColorManager.error, width: 0.5),
                              ),
                              focusedErrorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: ColorManager.error, width: 0.5),
                              ),
                              hintText: 'Enter your card number'),
                          expiryDateDecoration: InputDecoration(
                              hintStyle: kTheme.textTheme.headline5!
                                  .copyWith(color: Colors.grey.shade500),
                              border: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.black87)),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: ColorManager.primaryOpacity70),
                              ),
                              errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: ColorManager.error, width: 0.5),
                              ),
                              focusedErrorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: ColorManager.error, width: 0.5),
                              ),
                              hintText: 'MM/YY'),
                          cvvCodeDecoration: InputDecoration(
                              hintStyle: kTheme.textTheme.headline5!
                                  .copyWith(color: Colors.grey.shade500),
                              border: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.black87)),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: ColorManager.primaryOpacity70),
                              ),
                              errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: ColorManager.error, width: 0.5),
                              ),
                              focusedErrorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: ColorManager.error, width: 0.5),
                              ),
                              hintText: 'Secure Code'),
                          cardHolderDecoration: InputDecoration(
                              hintStyle: kTheme.textTheme.headline5!
                                  .copyWith(color: Colors.grey.shade500),
                              border: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.black87)),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: ColorManager.primaryOpacity70),
                              ),
                              errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: ColorManager.error, width: 0.5),
                              ),
                              focusedErrorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: ColorManager.error, width: 0.5),
                              ),
                              hintText: 'Enter card holder name'),
                        ),
                      ],
                    ),
                    kVSeparator(),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        padding: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          color: ColorManager.primary.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            BodyText(
                              text: "Order Total",
                              color: ColorManager.black,
                            ),
                            Row(
                              children: [
                                SubtitleText(text: "EGP "),
                                BodyText(
                                  text: ShopCubit.get(context)
                                      .getPriceWithDelivery()
                                      .toString(),
                                  color: ColorManager.black,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    ShopCubit.get(context).setCardInfo(
      cardNumber: creditCardModel.cardNumber,
      expiryDate: creditCardModel.expiryDate,
      cardHolderName: creditCardModel.cardHolderName,
      cvvCode: creditCardModel.cvvCode,
    );
  }
}
