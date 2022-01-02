import 'package:flutter/material.dart';

import '/ui/helpers/helpers.dart';

class ReloadScreen extends StatelessWidget {

  final String error;
  final Future<void> Function() reload;

  const ReloadScreen({required this.error, required this.reload});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(error),
          ElevatedButton(
            onPressed: reload,
            child: Text(R.strings.reload),
          ),
        ],
      ),
    );
  }
}