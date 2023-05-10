import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:e_commerce/screens/loginscreen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatelessWidget
{
  static String id = "SplashScreen";
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AnimatedSplashScreen(
      nextScreen: LoginScreen(),
      splashTransition: SplashTransition.rotationTransition,
      splashIconSize: 300,
      pageTransitionType: PageTransitionType.bottomToTop,
      animationDuration: Duration(seconds: 1,),
      duration: 1000,
      backgroundColor: Colors.orange,
      splash: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            Icons.shopping_cart,
            size: 250,
          ),
          Text(
            "Welcome To Your Store",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25.0,
              color: Colors.white,
            ),
          ),
          Text(
            "Find Your Needs",
            style: TextStyle(
              fontSize: 15.0,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}