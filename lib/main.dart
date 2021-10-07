import 'package:flutter/material.dart';
import 'package:questions_for_couples/tools/app_constant.dart';
import 'package:splash_screen_view/SplashScreenView.dart';
import 'package:questions_for_couples/screens/HomePage.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Future<InitializationStatus> _initGoogleMobileAds() {
  //   // TODO: Initialize Google Mobile Ads SDK
  //   return MobileAds.instance.initialize();
  // }

  @override
  Widget build(BuildContext context) {
    // _initGoogleMobileAds();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Ubuntu',
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
