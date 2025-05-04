import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String txt;
  final double size;
  const CustomText({
    super.key,
    required this.txt,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      txt,
      style: TextStyle(
        color: Colors.white,
        fontSize: size,
        fontWeight: FontWeight.w700,
        fontFamily: "Inter",
      ),
    );
  }
}
