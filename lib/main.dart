import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:phone_rings/Services/redirectAuth.dart';
import 'package:phone_rings/Views/OnBoradingView.dart';
import 'package:phone_rings/Views/homePageView.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';
void main() {
  runApp(ToastificationWrapper(child: MyApp()));
}
final ThemeData myTheme = ThemeData(
  textTheme: ThemeData.light().textTheme.copyWith(
    displayLarge: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
    displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: Colors.white),
    displaySmall: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
    bodyLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black),
    bodyMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
    bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w300, color: Colors.white),
  ),
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
);
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    AppLinks applink = AppLinks();
    final redirectAuth = RedirectAuthHandler();
    final uriresponse = applink.getInitialLink();
    print(uriresponse);
    redirectAuth.initRedirectListener(context, applink);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
        title: 'Phone Rings',
        theme: myTheme,
        home: OnBoarding()
    );
  }
}
