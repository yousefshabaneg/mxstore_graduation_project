import 'package:flutter/material.dart';

import 'login_view.dart';
import 'register_view.dart';

PageController accountController = PageController();

class AccountPageView extends StatefulWidget {
  const AccountPageView({Key? key}) : super(key: key);

  @override
  State<AccountPageView> createState() => _AccountPageViewState();
}

class _AccountPageViewState extends State<AccountPageView> {
  List<Widget> pages = [
    LoginView(),
    RegisterView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        scrollDirection: Axis.horizontal,
        controller: accountController,
        itemBuilder: (context, index) => pages[index],
        itemCount: 2,
        physics: BouncingScrollPhysics(),
      ),
    );
  }
}
