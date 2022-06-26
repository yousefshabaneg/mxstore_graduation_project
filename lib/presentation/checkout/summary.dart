import 'package:flutter/cupertino.dart';

class SummaryView extends StatelessWidget {
  const SummaryView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          child: Text(
            "Summary",
            style: TextStyle(fontSize: 30),
          ),
        ),
      ],
    );
  }
}
