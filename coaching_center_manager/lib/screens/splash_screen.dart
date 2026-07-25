import 'dart:async';

import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
//import '../auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (_) => const LoginScreen()),
      // );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,

        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,

            end: Alignment.bottomRight,

            colors: [AppColors.primary, AppColors.primaryDark],
          ),
        ),

        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              Image.asset("assets/images/logo.png", height: 130),

              const SizedBox(height: 25),

              const Text(
                AppStrings.appName,

                style: TextStyle(
                  color: Colors.white,

                  fontSize: 30,

                  fontWeight: FontWeight.bold,

                  letterSpacing: 1,
                ),
              ),

              const SizedBox(height: 10),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),

                child: Text(
                  AppStrings.splashTagline,

                  textAlign: TextAlign.center,

                  style: TextStyle(color: Colors.white70, fontSize: 15),
                ),
              ),

              const SizedBox(height: 50),

              const SizedBox(
                width: 35,

                height: 35,

                child: CircularProgressIndicator(
                  strokeWidth: 3,

                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
