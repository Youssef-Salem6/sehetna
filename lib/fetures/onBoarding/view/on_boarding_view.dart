import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sehetna/const.dart';
import 'package:sehetna/fetures/auth/view/login_view.dart';
import 'package:sehetna/fetures/onBoarding/view/widgets/on_boarding_body.dart';
import 'package:sehetna/generated/l10n.dart';
import 'package:sehetna/main.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({super.key});

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> body = [
      {
        "image": "assets/images/amico.svg",
        "txt1": S.of(context).onBoarding1Title,
        "txt2": S.of(context).onBoarding1description,
      },
      {
        "image": "assets/images/amico2.svg",
        "txt1": S.of(context).onBoarding2Title,
        "txt2": S.of(context).onBoarding2description,
      },
      {
        "image": "assets/images/amico3.svg",
        "txt1": S.of(context).onBoarding3Title,
        "txt2": S.of(context).onBoarding3description,
      }
    ];
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      pref.setBool("isFirstTime", true);
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginView(),
                        ),
                        (route) => false,
                      );
                    },
                    child: Text(
                      S.of(context).skip,
                      style: const TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: 16,
                        color: kSecondaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: OnBoardingBody(
                  body: body[index],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (index == 2) {
                          pref.setBool("isFirstTime", true);
                          // Send the FCM token to the server
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginView(),
                            ),
                            (route) => false,
                          );
                        } else {
                          setState(() {
                            index++;
                          });
                        }
                      },
                      style: const ButtonStyle(
                          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)))),
                          foregroundColor: WidgetStatePropertyAll(Colors.white),
                          backgroundColor:
                              WidgetStatePropertyAll(kPrimaryColor)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          index != 2
                              ? S.of(context).conttinue
                              : S.of(context).finish,
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(25),
            ],
          ),
        ),
      ),
    );
  }
}
