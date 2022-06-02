import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/presentation/categories/categories_view.dart';
import 'package:graduation_project/shared/widgets/filtered_item_view.dart';
import '../../presentation/login/login.dart';
import '../../presentation/main/main_view.dart';
import '../../presentation/onboarding/onboarding.dart';
import '../../presentation/register/register.dart';
import '../../presentation/splash/splash.dart';
import 'color_manager.dart';
import 'strings_manager.dart';
import 'styles_manager.dart';

class Routes {
  static const String root = "/";
  static const String mainRoute = "/main";
  static const String onBoardingRoute = "onboarding";
  static const String loginRoute = "/login";
  static const String registerRoute = "register";
  static const String forgotPasswordRoute = "forgotPassword";
  static const String categories = "categories";
  static const String categoryItem = "categoryItem";
}

class RoutesGenerator {
  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.root:
        return CupertinoPageRoute(builder: (_) => SplashView());
      case Routes.loginRoute:
        return CupertinoPageRoute(builder: (_) => LoginView());
      case Routes.registerRoute:
        return CupertinoPageRoute(builder: (_) => RegisterView());
      case Routes.onBoardingRoute:
        return CupertinoPageRoute(builder: (_) => OnBoardingView());
      case Routes.mainRoute:
        return CupertinoPageRoute(builder: (_) => MainView());
      case Routes.categories:
        return CupertinoPageRoute(builder: (_) => CategoriesView());
      default:
        return undefinedRoute();
    }
  }

  static Route<dynamic> undefinedRoute() => CupertinoPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: Text(AppStrings.noRouteFound)),
          body: Center(
            child: Text(
              AppStrings.noRouteFound,
              style: getBoldStyle(
                color: ColorManager.error,
              ),
            ),
          ),
        ),
      );
}
