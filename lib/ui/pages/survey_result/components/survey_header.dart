import 'package:flutter/material.dart';

class SurveyHeader extends StatelessWidget {
  
  final String question;

  const SurveyHeader({Key key, @required this.question}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.only(top: 40, bottom: 20, left: 20, right: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).disabledColor.withAlpha(15),
      ),
      child: Text(question),
    );
  }
}