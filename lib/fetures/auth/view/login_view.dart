import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
// import 'package:sehetna/core/faceook_logins_service.dart';
import 'package:sehetna/core/nav_view.dart';
import 'package:sehetna/core/social_auth_service.dart';
import 'package:sehetna/fetures/auth/manager/login/login_cubit.dart';
import 'package:sehetna/fetures/auth/view/forget_password_view.dart';
import 'package:sehetna/fetures/auth/view/widget/Custom_Button.dart';
import 'package:sehetna/fetures/auth/view/widget/authPassField.dart';
import 'package:sehetna/fetures/auth/view/widget/authTextField.dart';
import 'package:sehetna/core/custom_text.dart';
import 'package:sehetna/fetures/auth/view/register_view.dart';
import 'package:sehetna/fetures/auth/view/widget/custom_icon.dart';
import 'package:sehetna/fetures/auth/manager/sendFcmToken/send_fcm_token_cubit.dart';
import 'package:sehetna/generated/l10n.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();
  SocialAuthService _socialAuthService = SocialAuthService();
  // FaceBookAuthService _faceBookAuthService = FaceBookAuthService();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginCubit(),
        ),
        BlocProvider(
          create: (context) => SendFcmTokenCubit(),
        ),
      ],
      child: BlocBuilder<SendFcmTokenCubit, SendFcmTokenState>(
        builder: (context, state) {
          return BlocConsumer<LoginCubit, LoginState>(
            listener: (context, state) {
              if (state is LoginSuccess) {
                // Send the FCM token after successful login
                BlocProvider.of<SendFcmTokenCubit>(context).sendToken();
                // Navigate to the next screen after sending the token
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const NavView()),
                );
              } else if (state is LoginFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.red,
                    content: Text(state.message),
                  ),
                );
              }
            },
            builder: (context, state) {
              return Scaffold(
                body: SafeArea(
                  child: ListView(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          gradient: RadialGradient(
                            center: Alignment.center, // Center the gradient
                            colors: [
                              Color(0xff015CCC),
                              Color.fromARGB(255, 0, 86, 157),
                              Color(0xff004075),
                            ],
                            stops: [
                              0.05,
                              0.6,
                              3,
                            ], // Adjust the stops for smooth transitions
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: screenHeight,
                            child: ListView(
                              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Gap(screenHeight * 0.03),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/images/Logo.svg",
                                      height: 65,
                                    ),
                                  ],
                                ),
                                Gap(screenHeight * 0.06),
                                // Blurred Container
                                Center(
                                  child: ClipRect(
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 6,
                                          sigmaY: 6), // Adjust blur intensity
                                      child: Container(
                                        width: screenWidth * 0.88,
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.2),
                                          // Semi-transparent background
                                          borderRadius: BorderRadius.circular(
                                              8), // Rounded corners
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Form(
                                            key: _formKey,
                                            child: SizedBox(
                                              height: screenHeight * 0.685,
                                              child: ListView(
                                                children: [
                                                  const Gap(10),
                                                  Align(
                                                    alignment: Alignment.center,
                                                    child: CustomText(
                                                        txt: S
                                                            .of(context)
                                                            .loginTitle,
                                                        size: 24),
                                                  ),
                                                  Gap(screenHeight * 0.04),
                                                  CustomText(
                                                      txt: S.of(context).email,
                                                      size: 16),
                                                  const Gap(12),
                                                  AuthTextField(
                                                    controller: emailController,
                                                    hint: S.of(context).email,
                                                    type: TextInputType
                                                        .emailAddress,
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return S
                                                            .of(context)
                                                            .embtyEmailWarning;
                                                      }
                                                      if (!RegExp(
                                                              r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}')
                                                          .hasMatch(value)) {
                                                        return S
                                                            .of(context)
                                                            .inValidMailWarning;
                                                      }
                                                      return null;
                                                    },
                                                    backColor: Colors.white,
                                                  ),
                                                  const Gap(25),
                                                  CustomText(
                                                      txt: S
                                                          .of(context)
                                                          .Password,
                                                      size: 16),
                                                  const Gap(12),
                                                  AuthPassField(
                                                    controller:
                                                        passwordController,
                                                    hint:
                                                        S.of(context).Password,
                                                    type: TextInputType
                                                        .emailAddress,
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return S
                                                            .of(context)
                                                            .embtyPasswordWarning;
                                                      }
                                                      if (value.length < 6) {
                                                        return S
                                                            .of(context)
                                                            .shortPasswordWarning;
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                  const Gap(12),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  const ForgetPasswordView(),
                                                            ),
                                                          );
                                                        },
                                                        child: Text(
                                                          S
                                                              .of(context)
                                                              .ForgetPassword,
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            decoration:
                                                                TextDecoration
                                                                    .underline,
                                                            decorationColor:
                                                                Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const Gap(30),
                                                  GestureDetector(
                                                      onTap: () {
                                                        if (_formKey
                                                            .currentState!
                                                            .validate()) {
                                                          context
                                                              .read<
                                                                  LoginCubit>()
                                                              .login(
                                                                  emailController
                                                                      .text,
                                                                  passwordController
                                                                      .text);
                                                        }
                                                      },
                                                      child: CustomButton(
                                                          isLoading: state
                                                              is LoginLoading,
                                                          title: S
                                                              .of(context)
                                                              .login)),
                                                  const Gap(50),
                                                  Align(
                                                    alignment: Alignment.center,
                                                    child: CustomText(
                                                        txt: S
                                                            .of(context)
                                                            .orLoginWith,
                                                        size: 16),
                                                  ),
                                                  const Gap(20),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      // GestureDetector(
                                                      //   onTap: () async {
                                                      //     try {
                                                      //       await _faceBookAuthService
                                                      //           .initiateFacebookLogin(
                                                      //               context);
                                                      //     } catch (e) {
                                                      //       ScaffoldMessenger
                                                      //               .of(context)
                                                      //           .showSnackBar(
                                                      //         SnackBar(
                                                      //           content: Text(
                                                      //               'FaceBook login failed: $e'),
                                                      //         ),
                                                      //       );
                                                      //     }
                                                      //   },
                                                      //   child: const CustomIcon(
                                                      //       image:
                                                      //           "assets/images/faceBookLogo.svg"),
                                                      // ),
                                                      // CustomIcon(
                                                      //     image:
                                                      //         "assets/images/appleLogo.svg"),
                                                      GestureDetector(
                                                        onTap: () async {
                                                          try {
                                                            await _socialAuthService
                                                                .initiateGoogleLogin(
                                                                    context);
                                                          } catch (e) {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              SnackBar(
                                                                content: Text(
                                                                    'FaceBook login failed: $e'),
                                                              ),
                                                            );
                                                          }
                                                        },
                                                        child: const CustomIcon(
                                                            image:
                                                                "assets/images/akar-icons_google-contained-fill.svg"),
                                                      ),
                                                    ],
                                                  ),
                                                  const Gap(30),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        S
                                                            .of(context)
                                                            .dontHaveAccount,
                                                        style: TextStyle(
                                                          color: Colors.white
                                                              .withOpacity(0.3),
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  const RegisterView(),
                                                            ),
                                                          );
                                                        },
                                                        child: CustomText(
                                                            txt: S
                                                                .of(context)
                                                                .signUp,
                                                            size: 16),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
