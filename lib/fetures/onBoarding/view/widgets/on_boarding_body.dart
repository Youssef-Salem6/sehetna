import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sehetna/const.dart';

class OnBoardingBody extends StatelessWidget {
  final Map body;
  const OnBoardingBody({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                body["image"],
                width: 343,
              ),
            ],
          ),
          Text(
            body["txt1"],
            style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: kSecondaryColor),
            textAlign: TextAlign.center,
          ),
          Text(
            body["txt2"],
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: kSecondaryColor.withOpacity(0.5)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
