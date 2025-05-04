import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sehetna/const.dart';
import 'package:sehetna/core/assets.dart';
import 'package:sehetna/core/nav_view.dart';
import 'package:sehetna/fetures/auth/view/login_view.dart';
import 'package:sehetna/fetures/home/manager/getLocation/get_location_cubit.dart';
import 'package:sehetna/fetures/onBoarding/view/on_boarding_view.dart';
import 'package:sehetna/main.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // Fetch location first
      final locationCubit = BlocProvider.of<GetLocationCubit>(context);
      await locationCubit.getLocation();

      // Then check auth state after delay
      Timer(const Duration(seconds: 3), _navigateBasedOnAuth);
    } catch (e) {
      // If location fails, still check auth
      Timer(const Duration(seconds: 3), _navigateBasedOnAuth);
    }
  }

  void _navigateBasedOnAuth() {
    final isFirstTime = pref.getBool("isFirstTime") ?? true;
    final hasToken = isLoggedIn;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => isFirstTime
            ? const OnBoardingView()
            : (hasToken ? const NavView() : const LoginView()),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: SafeArea(
        child: Center(
          child: SvgPicture.asset(
            Assets.logo,
            width: 200,
          ),
        ),
      ),
    );
  }
}
