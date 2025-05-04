import 'package:flutter/material.dart';

import 'package:gap/gap.dart';
import 'package:sehetna/const.dart';
import 'package:sehetna/constants/apis.dart';

class CustomSpecialityCard extends StatelessWidget {
  final String image, txt;
  const CustomSpecialityCard(
      {super.key, required this.image, required this.txt});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SizedBox(
        height: screenHeight * 0.20,
        width: screenWidth * 0.35,
        child: Stack(
          children: [
            // First Container (1 part)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: screenHeight * 0.20 * 0.2, // 20% of the height (1 part)
              child: Container(
                  // Background color for the first container
                  ),
            ),
            // Second Container (4 parts)
            Positioned(
              top: screenHeight * 0.20 * 0.2, // Start after the first container
              left: 0,
              right: 0,
              height: screenHeight * 0.20 * 0.8, // 80% of the height (4 parts)
              child: Container(
                decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(
                        12)), // Background color for the second container
              ),
            ),
            Positioned.fill(
              child: Column(
                children: [
                  Image(
                    image: NetworkImage("$imagesBaseUrl/$image"),
                    height: screenHeight * 0.12,
                  ),
                  Gap(screenHeight * 0.02),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    child: Container(
                      height: screenHeight * 0.05,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            textAlign: TextAlign.center,
                            txt,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 12),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
