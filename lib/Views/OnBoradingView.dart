import 'package:flutter/cupertino.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_rings/Views/HomePageView.dart';

class OnBoarding extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      home: OnBoardingSlider(
        headerBackgroundColor: Color(0xFF572177),
        finishButtonText: 'Start',

        finishButtonStyle: FinishButtonStyle(
          backgroundColor: Colors.black,
        ),
        skipTextButton: Text('Skip', style: Theme.of(context).textTheme.bodyMedium,),
        trailing: Text('Start', style: Theme.of(context).textTheme.bodyMedium),
    trailingFunction: () {
          Get.offAll(HomePageView());
    },
        speed: 2,
        pageBackgroundColor: Color(0xFF572177),
        background: [
           Image.asset(
            'assets/images/onboarding-1.jpeg',
            height: 300,
            width: 350,
          ),

          Image.asset(
            'assets/images/onboarding-2.jpeg',
            height: 300,
            width: 350,
          ),
          Image.asset(
            'assets/images/onboarding-3.jpeg',
            height: 300,
            width: 350,
          ),
          Image.asset(
            'assets/images/onboarding-4.jpeg',
            height: 300,
            width: 350,
          ),
        ],
        totalPage: 4,
        pageBodies: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center content
              children: <Widget>[
                const SizedBox(
                  height: 420,
                ),
                Text(
                  'Find the perfect ringtone from a vast collection. Search by name, genre, or trending sounds to match your vibe.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center content
              children: <Widget>[
                const SizedBox(
                  height: 420,
                ),
                Text(
                  'Easily listen to ringtone previews before downloading. Save your favorites to your phone storage with just one tap!',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center content
              children: <Widget>[
                const SizedBox(
                  height: 420,
                ),
                Text(
                  'Browse through categories like Pop, Classical, Funny, and more. No more endless scrolling—get the best sounds instantly!',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center content
              children: <Widget>[
                const SizedBox(
                  height: 420,
                ),
                Text(
                  'Set your favorite ringtone and give your phone a unique sound. Download now and personalize your experience!',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
        onFinish: () {
          Get.offAll(HomePageView());
        },
      ),
    );
  }
}
