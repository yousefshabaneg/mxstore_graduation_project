import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:graduation_project/business_logic/shop_cubit/shop_cubit.dart';
import 'package:graduation_project/business_logic/shop_cubit/shop_states.dart';
import 'package:graduation_project/business_logic/user_cubit/user_cubit.dart';
import 'package:graduation_project/data/models/order_model.dart';
import 'package:graduation_project/presentation/order/review_success_widget.dart';
import 'package:graduation_project/shared/constants.dart';
import 'package:graduation_project/shared/helpers.dart';
import 'package:graduation_project/shared/resources/color_manager.dart';
import 'package:graduation_project/shared/widgets/app_buttons.dart';
import 'package:graduation_project/shared/widgets/app_text.dart';
import 'package:graduation_project/shared/widgets/indicators.dart';
import 'package:graduation_project/shared/widgets/product_details_widgets.dart';
import 'package:graduation_project/shared/widgets/textfield.dart';

class SubmitReviewWidget extends StatefulWidget {
  const SubmitReviewWidget(
      {Key? key, required this.orderItem, required this.orderModel})
      : super(key: key);
  final OrderModel orderModel;
  final OrderItems orderItem;

  @override
  State<SubmitReviewWidget> createState() => _SubmitReviewWidgetState();
}

class _SubmitReviewWidgetState extends State<SubmitReviewWidget> {
  double rating = 0;
  var commentController = TextEditingController();
  var usernameController = TextEditingController();
  String comment = "";
  String userName = "";
  bool isAnonymous = false;

  @override
  void initState() {
    super.initState();
    userName = UserCubit.get(context).userModel!.name ?? "";
    usernameController.text = userName;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) => Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: ColorManager.lightGray,
                width: kWidth,
                padding: const EdgeInsets.all(12),
                child: BodyText(
                  text: "Review your purchase",
                  color: ColorManager.dark,
                ),
              ),
              kVSeparator(),
              Container(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BodyText(
                      text: "You bought the following item",
                      color: ColorManager.black,
                      size: 14,
                    ),
                    kVSeparator(),
                    Container(
                      width: kWidth,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 30),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.teal, width: 1),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(15),
                          bottomLeft: Radius.circular(15),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image(
                            image:
                                NetworkImage(widget.orderItem.pictureUrl ?? ""),
                            width: kWidth * 0.1,
                            height: kHeight * 0.05,
                          ),
                          kHSeparator(factor: 0.05),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: kWidth * 0.6,
                                child: SubtitleText(
                                  text: widget.orderItem.productName ?? "",
                                  color: ColorManager.dark,
                                  size: 14,
                                  maxLines: 1,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  BodyText(
                                    text: "Delivered on ",
                                    color: Colors.black87,
                                    size: 12,
                                  ),
                                  BodyText(
                                      text: ProductDetailsHelpers.shippingDate(
                                          dateTime: DateTime.parse(
                                              widget.orderModel.orderDate!),
                                          Duration(days: 5)),
                                      size: 12,
                                      color: ColorManager.success),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              kGrayDivider(),
              Center(
                child: Column(
                  children: [
                    BodyText(text: "Rate this item", color: ColorManager.dark),
                    kVSeparator(),
                    RatingBar.builder(
                      initialRating: 0,
                      minRating: 1,
                      itemSize: 48,
                      direction: Axis.horizontal,
                      unratedColor: ColorManager.gray,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        setState(() => this.rating = rating);
                      },
                    ),
                  ],
                ),
              ),
              kDivider(),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BodyText(
                        text: "Tell us your feedback about this item",
                        color: ColorManager.dark),
                    kVSeparator(),
                    TextField(
                      controller: commentController,
                      maxLines: 2, //or null
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 15) -
                            const EdgeInsets.only(top: 5),
                        hintText: "Type your comment ...",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black45),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black45),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black45),
                        ),
                      ),
                      style: kTheme.textTheme.headline4,
                      onChanged: (str) => setState(() => this.comment = str),
                    ),
                  ],
                ),
              ),
              kVSeparator(),
              Container(
                color: ColorManager.lightGray,
                width: kWidth,
                padding: const EdgeInsets.all(12),
                child: BodyText(
                  text: "Preview",
                  color: ColorManager.dark,
                ),
              ),
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BodyText(
                      text: isAnonymous ? "Anonymous" : this.userName,
                      color: ColorManager.black,
                      size: 14,
                    ),
                    const SizedBox(height: 5),
                    RatingBarIndicator(
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      itemSize: 18,
                      direction: Axis.horizontal,
                      itemCount: 5,
                      unratedColor: ColorManager.gray,
                      rating: rating,
                    ),
                    SubtitleText(
                      text: this.comment,
                      color: ColorManager.black,
                    ),
                  ],
                ),
              ),
              kGrayDivider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: isAnonymous,
                        onChanged: (value) =>
                            setState(() => isAnonymous = value!),
                        activeColor: ColorManager.blue,
                      ),
                      SubtitleText(text: "Post anonymously", size: 14),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: MyTextButton(
                      color: ColorManager.blue,
                      text: "Change Display Name",
                      size: 14,
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (_) {
                            return SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0) +
                                    MediaQuery.of(context).viewInsets,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SubtitleText(text: "Your display name"),
                                    AppFormField(
                                      hint: "Type display name..",
                                      type: TextInputType.emailAddress,
                                      autoFill: [AutofillHints.email],
                                      inputAction: TextInputAction.next,
                                      padding: kHeight * 0.015,
                                      controller: usernameController,
                                      onChanged: (value) =>
                                          setState(() => userName = value),
                                    ),
                                    kVSeparator(),
                                    SubtitleText(
                                      text:
                                          "This name will appear on this review",
                                      size: 12,
                                    ),
                                    kVSeparator(),
                                    SolidButton(
                                      radius: 5,
                                      text: "SAVE DISPLAY NAME",
                                      color: Colors.white,
                                      splashColor: Colors.white,
                                      heightFactor: 0.06,
                                      size: 12,
                                      backgroundColor: ColorManager.blue,
                                      onTap: () {
                                        this.userName = usernameController.text;
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
              kVSeparator(factor: 0.1),
            ],
          ),
        ),
        bottomSheet: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
            child: SolidButton(
              radius: 5,
              text: "Submit Item Review",
              color: Colors.white,
              splashColor: ColorManager.primary,
              heightFactor: 0.06,
              backgroundColor: ColorManager.blue,
              disabledColor: ColorManager.gray,
              child: state is ShopLoadingRateProductState
                  ? const MyLoadingIndicator(height: 20, width: 30)
                  : null,
              onTap: false
                  ? null
                  : () async {
                      print(this.rating.toInt());
                      print(this.comment);
                      await ShopCubit.get(context)
                          .rateProduct(
                        productId: widget.orderItem.productId!,
                        name: isAnonymous ? "Anonymous" : this.userName,
                        rating: this.rating.toInt(),
                        commentDescription: this.comment,
                      )
                          .then((value) {
                        if (value) {
                          push(context, ReviewSuccessfullyWidget(), root: true);
                        }
                      });
                    },
            ),
          ),
        ),
      ),
    );
  }
}
