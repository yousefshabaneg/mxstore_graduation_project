import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:graduation_project/shared/helpers.dart';
import 'package:graduation_project/shared/resources/assets_manager.dart';
import 'package:graduation_project/shared/widgets/app_text.dart';

class NoConnectionWidget extends StatelessWidget {
  const NoConnectionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(ImageAssets.noConnection, height: kHeight * 0.4),
              const SizedBox(height: 20),
              const BodyText(text: "Oops!", color: Colors.black87, size: 24),
              const SizedBox(height: 10),
              const Text(
                'No connection ... Check your Internet',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
