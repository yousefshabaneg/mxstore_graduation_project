import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graduation_project/data/cashe_helper.dart';
import 'package:graduation_project/data/models/boarding_model.dart';
import 'package:graduation_project/presentation/login/login.dart';
import 'package:graduation_project/shared/helpers.dart';
import 'package:graduation_project/shared/resources/assets_manager.dart';
import 'package:graduation_project/shared/resources/color_manager.dart';
import 'package:graduation_project/shared/resources/routes_manager.dart';
import 'package:graduation_project/shared/resources/strings_manager.dart';
import 'package:graduation_project/shared/resources/values_manager.dart';
import 'package:graduation_project/shared/widgets/app_buttons.dart';
import 'package:graduation_project/shared/widgets/app_text.dart';
import 'package:graduation_project/shared/widgets/boarding_item_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

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
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Color(0xFF3594DD),
          statusBarIconBrightness: Brightness.dark,
        ),
        backgroundColor: Color(0xFF3594DD),
        actions: [
          TextButton(
              onPressed: goToLogin,
              child: BodyText(text: "Skip", color: Colors.white))
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.1, 0.4, 0.7, 0.9],
            colors: [
              Color(0xFF3594DD),
              Color(0xFF4563DB),
              Color(0xFF5036D5),
              Color(0xFF5B16D0),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppPadding.p20),
          child: Column(children: [
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SmoothPageIndicator(
                  controller: _controller,
                  count: boardingModels.length,
                  axisDirection: Axis.horizontal,
                  effect: ScrollingDotsEffect(
                    activeDotColor: ColorManager.white,
                    dotColor: ColorManager.subtitle,
                    dotHeight: 10,
                    dotWidth: 10,
                    spacing: 10,
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            isLast()
                ? SolidButton(
                    heightFactor: 0.06,
                    radius: 25,
                    color: ColorManager.white,
                    borderColor: Colors.white,
                    backgroundColor: Color(0xFF5B16D0),
                    splashColor: ColorManager.white,
                    text: "Get Started",
                    size: 20,
                    onTap: goToLogin,
                  )
                : Align(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                      onPressed: () => _controller.nextPage(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeOutSine,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          BodyText(text: "Next", color: Colors.white, size: 20),
                          SizedBox(width: 10),
                          Icon(Icons.arrow_forward,
                              color: Colors.white, size: 20)
                        ],
                      ),
                    ),
                  ),
          ]),
        ),
      ),
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

  void goToLogin() {
    CashHelper.saveData(key: 'onBoarding', value: true).then((value) {
      if (value) {
        pushReplacement(context, LoginView());
      }
    });
  }
}
