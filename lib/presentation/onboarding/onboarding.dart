import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graduation_project/data/cashe_helper.dart';
import 'package:graduation_project/data/models/boarding_model.dart';
import 'package:graduation_project/presentation/login/login_view.dart';
import 'package:graduation_project/shared/helpers.dart';
import 'package:graduation_project/shared/resources/assets_manager.dart';
import 'package:graduation_project/shared/resources/color_manager.dart';
import 'package:graduation_project/shared/resources/routes_manager.dart';
import 'package:graduation_project/shared/resources/strings_manager.dart';
import 'package:graduation_project/shared/widgets/app_buttons.dart';
import 'package:graduation_project/shared/widgets/boarding_item_widget.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({Key? key}) : super(key: key);

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  PageController _controller = PageController();
  int _currentPage = 0;
  List<OnBoardingModel> boardingModels = [
    OnBoardingModel(
      title: AppStrings.onBoardingTitle1,
      subTitle: AppStrings.onBoardingSubTitle1,
      image: ImageAssets.onBoarding1,
    ),
    OnBoardingModel(
      title: AppStrings.onBoardingTitle2,
      subTitle: AppStrings.onBoardingSubTitle2,
      image: ImageAssets.onBoarding2,
    ),
    OnBoardingModel(
      title: AppStrings.onBoardingTitle3,
      subTitle: AppStrings.onBoardingSubTitle3,
      image: ImageAssets.onBoarding3,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        systemOverlayStyle:
            SystemUiOverlayStyle(statusBarColor: Colors.transparent),
      ),
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.teal,
      body: Column(children: [
        Expanded(
          child: PageView.builder(
            scrollDirection: Axis.horizontal,
            controller: _controller,
            onPageChanged: _onChanged,
            itemBuilder: (context, index) =>
                BoardingItem(model: boardingModels[index]),
            itemCount: 3,
            physics: BouncingScrollPhysics(),
          ),
        ), //Image
        SolidButton(
          heightFactor: 0.07,
          widthFactor: 0.9,
          color: ColorManager.white,
          backgroundColor: ColorManager.primary,
          splashColor: ColorManager.white,
          text: isLast() ? "Get Started" : "Next",
          size: 20,
          onTap: nextPage,
        ),

        kVSeparator(factor: 0.04),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 2,
              width: kWidth * 0.3,
              decoration: BoxDecoration(
                color: ColorManager.white,
              ),
            ),
            SizedBox(width: 5),
            Container(
              height: 2,
              width: kWidth * 0.3,
              decoration: BoxDecoration(
                color: _currentPage > 0 ? Colors.white : Colors.grey,
              ),
            ),
            SizedBox(width: 5),
            Container(
              height: 2,
              width: kWidth * 0.3,
              decoration: BoxDecoration(
                color: _currentPage > 1 ? Colors.white : Colors.grey,
              ),
            ),
          ],
        ),
        kVSeparator(factor: 0.04),
      ]),
    );
  }

  bool isLast() {
    return _currentPage == (boardingModels.length - 1);
  }

  _onChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void nextPage() {
    if (isLast()) {
      CashHelper.saveData(key: 'onBoarding', value: true).then((value) {
        if (value) {
          pushReplacementNamed(context, Routes.accountRoute);
        }
      });
    } else {
      _controller.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutSine);
    }
  }
}
