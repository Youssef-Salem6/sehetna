import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sehetna/const.dart';
import 'package:sehetna/generated/l10n.dart';
import 'package:sehetna/main.dart';

class CustomImageRow extends StatelessWidget {
  final String name, image;
  const CustomImageRow({
    super.key,
    required this.name,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            border: Border.all(width: 2, color: kSecondaryColor),
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: pref.getString("image") == ""
                  ? AssetImage(pref.getString("gender") == "male"
                      ? "assets/images/users/man (1).png"
                      : "assets/images/users/woman (1).png")
                  : NetworkImage(image),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const Gap(20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  S.of(context).hello,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w400),
                ),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: kSecondaryColor,
                  ),
                ),
              ],
            ),
            Text(
              S.of(context).checkYourHealth,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
          ],
        )
      ],
    );
  }
}
