import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:sehetna/core/custom_text.dart';
import 'package:sehetna/fetures/auth/manager/forgetPassword/forget_password_cubit.dart';
import 'package:sehetna/fetures/auth/view/otp_view.dart';
import 'package:sehetna/fetures/auth/view/widget/Custom_Button.dart';
import 'package:sehetna/fetures/auth/view/widget/authTextField.dart';
import 'package:sehetna/generated/l10n.dart';

class ForgetPasswordView extends StatefulWidget {
  const ForgetPasswordView({super.key});

  @override
  State<ForgetPasswordView> createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends State<ForgetPasswordView> {
  TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return BlocProvider(
      create: (context) => ForgetPasswordCubit(),
      child: BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
        listener: (context, state) {
          if (state is ForgetPasswordSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Color.fromARGB(255, 111, 187, 113),
                content: Text(
                  'Reset code sent to your email.',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OtpView(
                  email: emailController.text,
                ),
              ),
            );
          } else if (state is ForgetPasswordFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Color.fromARGB(255, 248, 117, 107),
                content: Text(
                  'This Email is Not Exist',
                  style: TextStyle(fontSize: 16),
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
                        Color(0xff015CCC),
                        Color.fromARGB(255, 0, 86, 157),
                        Color(0xff004075),
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
                          Gap(screenHeight * 0.05),
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
                                        height: screenHeight * 0.63,
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
                                              S.of(context).forgetPasswordInfo,
                                              style: TextStyle(
                                                  color: Colors.white
                                                      .withOpacity(0.5),
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Gap(screenHeight * 0.03),
                                            CustomText(
                                                txt: S.of(context).email,
                                                size: 16),
                                            const Gap(8),
                                            AuthTextField(
                                                controller: emailController,
                                                hint: S.of(context).email,
                                                type:
                                                    TextInputType.emailAddress,
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
                                                backColor: Colors.white),
                                            Gap(screenHeight * 0.05),
                                            GestureDetector(
                                              onTap: () {
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  BlocProvider.of<
                                                              ForgetPasswordCubit>(
                                                          context)
                                                      .forgetPassword(
                                                          email: emailController
                                                              .text);
                                                }
                                              },
                                              child: CustomButton(
                                                  isLoading: state
                                                      is ForgetPasswordLoading,
                                                  title:
                                                      S.of(context).sendCode),
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
