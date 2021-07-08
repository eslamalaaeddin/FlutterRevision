import 'package:flutter/material.dart';
import 'package:flutter_json_place_holder/helpers/Constants.dart';
import 'package:flutter_json_place_holder/screens/PostScreen.dart';
import 'package:flutter_json_place_holder/screens/PostsScreen.dart';
import 'package:flutter_json_place_holder/screens/SplashScreen.dart';
import 'package:flutter_json_place_holder/screens/TestScreen.dart';

import 'helpers/ServiceLocator.dart';

Future<void> main() async {

  // Register the database service before the app starts
  await setupLocator();

  runApp(
      MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: POSTS_ROUTE,
    // initialRoute: TEST_ROUTE,
    routes: {
      SPLASH_ROUTE : (context) => (SplashScreen()),
      POSTS_ROUTE: (context) => (PostsScreen()),
      POST_ROUTE : (context) => (PostScreen()),
      TEST_ROUTE: (context) => (HomePage())
    },
  ));
}

