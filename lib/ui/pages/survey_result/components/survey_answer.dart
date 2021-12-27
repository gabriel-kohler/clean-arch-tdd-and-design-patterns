import 'package:flutter/material.dart';

import '/ui/pages/pages.dart';

class SurveyAnswer extends StatelessWidget {
  const SurveyAnswer({
    Key key,
    @required this.surveyResult,
  }) : super(key: key);

  final SurveyAnswerViewModel surveyResult;

  @override
  Widget build(BuildContext context) {
    List<Widget> buildItems() {
      List<Widget> children = [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              surveyResult.answer,
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
        ),
        Text(
          surveyResult.percent,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColorDark,
          ),
        ),
        surveyResult.isCurrentAnswer ? ActiveIcon() : DisableIcon(),
      ];
      if (surveyResult.image != null)
        children.insert(
            0,
            Image.network(
              surveyResult.image,
              width: 40,
              key: ValueKey('imageUrl'),
            ));
      return children;
    }

    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: buildItems(),
          ),
        ),
        Divider(height: 1),
      ],
    );
  }
}
