import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:sehetna/core/custom_text.dart';
import 'package:sehetna/fetures/auth/manager/resetPassword/reset_password_cubit.dart';
import 'package:sehetna/fetures/auth/view/login_view.dart';
import 'package:sehetna/fetures/auth/view/widget/Custom_Button.dart';
import 'package:sehetna/fetures/auth/view/widget/authPassField.dart';
import 'package:sehetna/generated/l10n.dart';

class NewPasswordView extends StatefulWidget {
  final String email;
  const NewPasswordView({super.key, required this.email});

  @override
  State<NewPasswordView> createState() => _NewPasswordViewState();
}

class _NewPasswordViewState extends State<NewPasswordView> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return BlocProvider(
      create: (context) => ResetPasswordCubit(),
      child: BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
        listener: (context, state) {
          if (state is ResetPasswordSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: const Color.fromARGB(255, 111, 187, 113),
                content: Text(
                  state.message,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            );
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginView()),
              (route) => false,
            );
          } else if (state is ResetPasswordFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: const Color.fromARGB(255, 248, 117, 107),
                content: Text(
                  state.errorMessage,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.center, // Center the gradient
                      colors: [
                        Color(0xff3499c5),
                        Color(0xff256c8b),
                        Color(0xff194a5f),
                      ],
                      stops: [
                        0.1,
                        0.4,
                        0.8,
                      ], // Adjust the stops for smooth transitions
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: screenHeight,
                      child: Column(
                        children: [
                          Gap(screenHeight * 0.02),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                "assets/images/Logo.svg",
                                height: 65,
                              ),
                            ],
                          ),
                          Gap(screenHeight * 0.04),
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
                                        height: screenHeight * 0.73,
                                        child: ListView(
                                          children: [
                                            Gap(screenHeight * 0.03),
                                            Align(
                                              alignment: Alignment.center,
                                              child: CustomText(
                                                  txt: S
                                                      .of(context)
                                                      .ForgetPassword,
                                                  size: 24),
                                            ),
                                            Gap(screenHeight * 0.03),
                                            SvgPicture.asset(
                                              "assets/images/forgetPasswordVector.svg",
                                              width: 182,
                                            ),
                                            Gap(screenHeight * 0.03),
                                            Text(
                                              S.of(context).newPasswordInfo,
                                              style: TextStyle(
                                                  color: Colors.white
                                                      .withOpacity(0.5),
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Gap(screenHeight * 0.03),
                                            CustomText(
                                                txt: S.of(context).newPassword,
                                                size: 16),
                                            const Gap(8),
                                            AuthPassField(
                                              controller:
                                                  confirmPasswordController,
                                              hint: S.of(context).Password,
                                              type: TextInputType.emailAddress,
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
                                            Gap(screenHeight * 0.03),
                                            CustomText(
                                                txt: S
                                                    .of(context)
                                                    .confermationPassword,
                                                size: 16),
                                            const Gap(8),
                                            AuthPassField(
                                              controller: passwordController,
                                              hint: S.of(context).Password,
                                              type: TextInputType.emailAddress,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return S
                                                      .of(context)
                                                      .embtyPasswordWarning;
                                                }
                                                if (value !=
                                                    passwordController.text) {
                                                  return S
                                                      .of(context)
                                                      .confermationPasswordError;
                                                }
                                                return null;
                                              },
                                            ),
                                            Gap(screenHeight * 0.05),
                                            GestureDetector(
                                              onTap: () {
                                                if (_formKey.currentState!
                                                        .validate() &&
                                                    passwordController.text ==
                                                        confirmPasswordController
                                                            .text) {
                                                  BlocProvider.of<
                                                              ResetPasswordCubit>(
                                                          context)
                                                      .resetPassword(
                                                          email: widget.email,
                                                          password:
                                                              passwordController
                                                                  .text,
                                                          confirmationPassword:
                                                              confirmPasswordController
                                                                  .text);
                                                }
                                              },
                                              child: CustomButton(
                                                  isLoading: state
                                                      is ResetPasswordLoading,
                                                  title:
                                                      S.of(context).conttinue),
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
              ),
            ),
          );
        },
      ),
    );
  }
}
