import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

class _SplashViewState extends State<SplashView> with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  late AnimationController _shimmerController;

  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoOpacityAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _shimmerAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
    _initializeApp();
  }

  void _initializeAnimations() {
    // Main logo animation controller
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Pulse animation controller
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Rotation animation controller
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Shimmer animation controller
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Logo scale animation with elastic curve
    _logoScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));

    // Logo opacity animation
    _logoOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
    ));

    // Slide animation
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.bounceOut,
    ));

    // Pulse animation
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Rotation animation
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.easeInOut,
    ));

    // Shimmer animation
    _shimmerAnimation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _shimmerController,
      curve: Curves.easeInOut,
    ));
  }

  void _startAnimations() {
    // Start main logo animation
    _logoController.forward();

    // Start pulse animation after logo animation completes
    _logoController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _pulseController.repeat(reverse: true);

        // Start subtle rotation
        Timer(const Duration(milliseconds: 500), () {
          _rotationController.repeat();
        });

        // Start shimmer effect
        Timer(const Duration(milliseconds: 800), () {
          _shimmerController.repeat();
        });
      }
    });
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
  void dispose() {
    _logoController.dispose();
    _pulseController.dispose();
    _rotationController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/Splash  screen.png"),
              fit: BoxFit.cover),
          // gradient: LinearGradient(
          //   begin: Alignment.topCenter,
          //   end: Alignment.bottomCenter,
          //   colors: [
          //     kPrimaryColor,
          //     kPrimaryColor.withOpacity(0.8),
          //     kPrimaryColor.withOpacity(0.9),
          //   ],
          // ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Animated background circles
              ...List.generate(
                3,
                (index) => AnimatedBuilder(
                  animation: _rotationController,
                  builder: (context, child) {
                    return Positioned(
                      top: 100 + (index * 150.0),
                      left: -50 + (index * 30.0),
                      child: Transform.rotate(
                        angle: _rotationAnimation.value *
                            2 *
                            3.14159 *
                            (index + 1) *
                            0.5,
                        child: Container(
                          width: 120 + (index * 20.0),
                          height: 120 + (index * 20.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.05),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.1),
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Main logo container
              Center(
                child: AnimatedBuilder(
                  animation: Listenable.merge([
                    _logoController,
                    _pulseController,
                    _shimmerController,
                  ]),
                  builder: (context, child) {
                    return SlideTransition(
                      position: _slideAnimation,
                      child: Transform.scale(
                        scale:
                            _logoScaleAnimation.value * _pulseAnimation.value,
                        child: Opacity(
                          opacity: _logoOpacityAnimation.value,
                          child: Container(
                            padding: const EdgeInsets.all(30),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.1),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Shimmer effect overlay
                                ClipOval(
                                  child: Container(
                                    width: 200,
                                    height: 200,
                                    child: Stack(
                                      children: [
                                        SvgPicture.asset(
                                          "assets/images/Simplification.svg",
                                          width: 200,
                                          height: 200,
                                        ),
                                        // Shimmer overlay
                                        AnimatedBuilder(
                                          animation: _shimmerAnimation,
                                          builder: (context, child) {
                                            return Container(
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment.centerLeft,
                                                  end: Alignment.centerRight,
                                                  colors: [
                                                    Colors.transparent,
                                                    Colors.white
                                                        .withOpacity(0.3),
                                                    Colors.transparent,
                                                  ],
                                                  stops: [
                                                    _shimmerAnimation.value -
                                                        0.3,
                                                    _shimmerAnimation.value,
                                                    _shimmerAnimation.value +
                                                        0.3,
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Loading indicator at bottom
              Positioned(
                bottom: 100,
                left: 0,
                right: 0,
                child: AnimatedBuilder(
                  animation: _logoController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _logoOpacityAnimation.value,
                      child: Column(
                        children: [
                          // Animated dots loading indicator
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(3, (index) {
                              return AnimatedBuilder(
                                animation: _pulseController,
                                builder: (context, child) {
                                  final delay = index * 0.2;
                                  final animationValue =
                                      (_pulseController.value + delay) % 1.0;

                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white.withOpacity(
                                        0.3 + (animationValue * 0.7),
                                      ),
                                    ),
                                  );
                                },
                              );
                            }),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            '',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
