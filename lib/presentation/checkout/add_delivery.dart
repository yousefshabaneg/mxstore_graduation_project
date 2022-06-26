import 'package:flutter/material.dart';

class DeliveryMethodView extends StatelessWidget {
  const DeliveryMethodView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          child: Text(
            "Choose delivery method",
            style: TextStyle(fontSize: 30),
          ),
        ),
      ],
    );
  }
}
