import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sehetna/constants/details.dart';
import 'package:sehetna/fetures/profile/view/profile_view.dart';

class BlocList extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const BlocList({super.key, required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTxt(txt: title, size: 16),
        Gap(screenSize.height * 0.01),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xffE5F1F7),
            boxShadow: Details.boxShadowList,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(children: children),
        )
      ],
    );
  }
}
