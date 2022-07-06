import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:graduation_project/data/cashe_helper.dart';
import 'package:graduation_project/data/dio_helper.dart';
import 'package:graduation_project/shared/constants.dart';
import 'package:graduation_project/shared/resources/constants_manager.dart';
import 'package:graduation_project/shared/resources/routes_manager.dart';

import 'app/app.dart';
import 'business_logic/bloc_observer.dart';

void chooseStartupWidget({required bool onBoarding, required String token}) {
  if (onBoarding) {
    ConstantsManager.startRoute =
        token.isNotEmpty ? Routes.mainRoute : Routes.accountRoute;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      "pk_test_51Kxv7PFwdR57oThPuTlzfDKHdroSs3XNDo1eoixZjiQj7NcR1i6USD5TCleEksgVIOanMhUdcVmmgIMdMipSpCWQ00XC6KrNeI";
  await Stripe.instance.applySettings();
  HttpOverrides.global = MyHttpOverrides();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await CashHelper.init();
  DioHelper.init();
  bool onBoarding = CashHelper.getData(key: 'onBoarding') ?? false;
  token = CashHelper.getData(key: 'token') ?? "";
  chooseStartupWidget(onBoarding: onBoarding, token: token);
  BlocOverrides.runZoned(
    () {
      runApp(MyApp());
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
