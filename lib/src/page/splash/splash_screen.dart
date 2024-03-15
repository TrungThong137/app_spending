import 'dart:async';

import 'package:app_spending/src/configs/widget/text/paragraph.dart';
import 'package:app_spending/src/page/bottom_navigator/bottom_navigator_screen.dart';
import 'package:app_spending/src/page/login/login.dart';
import 'package:app_spending/src/utils/shared_preferences.dart';
import 'package:flutter/material.dart';

import '../../configs/constants/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startDelay();
  }

  Timer _startDelay() => _timer = Timer(const Duration(seconds: 2), _init);

  Future<void> goToLogin(BuildContext context) async {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ));
  }
  // =>
  //     Navigator.pushNamed(context, Routers.signIn);

  Future<void> goToHome(BuildContext context) async {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const BottomNavigationBarScreen(),
        ));
  }

  Future<void> _init() async {
    // _goToSignIn(context);
    final id = await AppPref.getDataUSer('id');
    // final pref = await AppPref.getPage('$id') ?? true;
    final token = await AppPref.getToken();
    if (token == null || token.isEmpty) {
      await goToLogin(context);
    } else {
      await goToHome(context);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.COLOR_PINK_200,
      body: SafeArea(
        child: Center(
          child: Paragraph(
            content: 'Task List',
            style: STYLE_MEDIUM.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 50.0,
                color: Colors.white),
          ),
        ),
      ),
    );
  }
}
