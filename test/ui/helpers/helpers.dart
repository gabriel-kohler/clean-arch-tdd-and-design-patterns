import 'package:get/get.dart';

import 'package:flutter/material.dart';

import 'package:practice/utils/utils.dart';

Widget makePage({@required String initialRoute, @required Widget Function() page}) {
  final routeObserver = Get.put<RouteObserver>(RouteObserver<PageRoute>());

  final getPages = [
    GetPage(name: initialRoute, page: page),
    GetPage(
      name: '/any_route',
      page: () => Scaffold(
        appBar: AppBar(
          title: Text('any_title'),
        ),
        body: Text('navigation test'),
      ),
    ),
  ];

  if (initialRoute != AppRoute.LoginPage)
    getPages.add(
      GetPage(
        name: '/login',
        page: () => Scaffold(
          body: Text('fake login'),
        ),
      ),
    );

  return GetMaterialApp(
    navigatorObservers: [routeObserver],
    initialRoute: initialRoute,
    getPages: getPages,
  );
}

String get currentRoute => Get.currentRoute;
