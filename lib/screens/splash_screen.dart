import 'package:educonnect/helpers/colors.dart';
import 'package:educonnect/screens/home_screen.dart';
import 'package:educonnect/screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../helpers/images.dart';

class SplashScreen extends StatefulWidget {
  static const String id = "splashScreen";

  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var isSignedIn = FirebaseAuth.instance.currentUser != null;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      if (isSignedIn) {
        Navigator.pushReplacementNamed(context, HomeScreen.id);
      } else {
        Navigator.pushReplacementNamed(context, WelcomeScreen.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: green,
        child: Center(
          child: logo,
        ));
  }
}
