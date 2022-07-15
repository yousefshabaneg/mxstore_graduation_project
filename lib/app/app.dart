import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../business_logic/account_cubit/account_cubit.dart';
import '../business_logic/app_cubit/app_cubit.dart';
import '../business_logic/search_cubit/search_cubit.dart';
import '../business_logic/shop_cubit/shop_cubit.dart';
import '../business_logic/user_cubit/user_cubit.dart';
import '../shared/resources/routes_manager.dart';
import '../shared/resources/theme_manager.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (BuildContext context) => UserCubit(),
          ),
          BlocProvider(
              create: (BuildContext context) => ShopCubit()
                ..getCategories()
                ..getBrands()
                ..getBanners()
                ..getAllProducts()
                ..getProducts()
                ..getOfferedProducts()),
          BlocProvider(
            create: (BuildContext context) => AppCubit(),
          ),
          BlocProvider(
            create: (BuildContext context) => SearchCubit(),
          ),
          BlocProvider(
            create: (BuildContext context) => AccountCubit(),
          ),
        ],
        child: MaterialApp(
          builder: BotToastInit(),
          navigatorObservers: [BotToastNavigatorObserver()],
          debugShowCheckedModeBanner: false,
          onGenerateRoute: RoutesGenerator.getRoute,
          theme: getApplicationTheme(),
        ));
  }
}
