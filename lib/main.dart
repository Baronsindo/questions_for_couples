import 'package:flutter/material.dart';
import 'package:questions_for_couples/tools/app_constant.dart';
import 'package:splash_screen_view/SplashScreenView.dart';
import 'package:questions_for_couples/screens/HomePage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Ubuntu',
        // This is the theme of your
        //theme: ThemeData(fontFamily: 'Raleway'), application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        // primarySwatch: AppConstant.clicked_button,
      ),
      home: SplashScreenView(
        navigateRoute: MyHomePage(),
        duration: 3000,
        imageSize: 165,
        imageSrc: "assets/images/splash_logo.png",
        backgroundColor: AppConstant.main,
        text: "QueMe",
        textStyle: TextStyle(
          fontSize: 30,
          color: Colors.white,
        ),
      ),
    );
  }
}
