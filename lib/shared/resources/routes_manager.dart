import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../presentation/categories/categories_view.dart';
import '../../presentation/checkout/checkout_view.dart';
import '../../presentation/login/account_view.dart';
import '../../presentation/login/login_view.dart';
import '../../presentation/login/register_view.dart';
import '../../presentation/main/main_view.dart';
import '../../presentation/onboarding/onboarding.dart';
import '../../presentation/splash/splash.dart';
import 'color_manager.dart';
import 'strings_manager.dart';
import 'styles_manager.dart';

class Routes {
  static const String root = "/";
  static const String mainRoute = "/main";
  static const String onBoardingRoute = "/onboarding";
  static const String accountRoute = "/accountRoute";
  static const String loginRoute = "/login";
  static const String registerRoute = "/register";
  static const String forgotPasswordRoute = "/forgotPassword";
  static const String categories = "/categories";
  static const String categoryItem = "/categoryItem";
  static const String checkout = "/checkout";
}

class RoutesGenerator {
  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.root:
        return CupertinoPageRoute(builder: (_) => SplashView());
      case Routes.loginRoute:
        return CupertinoPageRoute(builder: (_) => LoginView());
      case Routes.accountRoute:
        return CupertinoPageRoute(builder: (_) => AccountPageView());
      case Routes.registerRoute:
        return CupertinoPageRoute(builder: (_) => RegisterView());
      case Routes.onBoardingRoute:
        return CupertinoPageRoute(builder: (_) => OnBoardingView());
      case Routes.mainRoute:
        return CupertinoPageRoute(builder: (_) => MainView());
      case Routes.categories:
        return CupertinoPageRoute(builder: (_) => CategoriesView());
      case Routes.checkout:
        return CupertinoPageRoute(builder: (_) => CheckoutView());
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
