import 'package:flutter/material.dart';

import '/ui/mixins/mixins.dart';

import 'splash.dart';

class SplashPage extends StatelessWidget with NavigationManager {

  final SplashPresenter splashPresenter;

  SplashPage({@required this.splashPresenter});

  @override
  Widget build(BuildContext context) {
    splashPresenter.checkAccount();
    return Scaffold(
      body: Builder(
        builder: (context) {
          handleNavigation(splashPresenter.navigateToStream, clearNavigation: true);
          return Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      ),
    );
  }
}