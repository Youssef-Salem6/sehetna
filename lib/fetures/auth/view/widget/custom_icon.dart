import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sehetna/const.dart';

class CustomIcon extends StatelessWidget {
  final String image;
  const CustomIcon({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: kPrimaryColor.withOpacity(0.25)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SvgPicture.asset(
          image,
          height: 32,
        ),
      ),
    );
  }
}
