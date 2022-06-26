import 'package:flutter/cupertino.dart';

class PaymentView extends StatelessWidget {
  const PaymentView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          child: Text(
            "Payment",
            style: TextStyle(fontSize: 30),
          ),
        ),
      ],
    );
  }
}
