import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sehetna/const.dart';
import 'package:sehetna/core/custom_text.dart';
import 'package:sehetna/fetures/categories/view/request_data_view.dart';
import 'package:sehetna/generated/l10n.dart';

class ScheduleHomeContainer extends StatelessWidget {
  const ScheduleHomeContainer({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: const LinearGradient(
          colors: [
            kSecondaryColor,
            kPrimaryColor,
          ],
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                    txt: S.of(context).emergencyMedicalService, size: 16),
                Gap(screenWidth * 0.03),
                SizedBox(
                  width: screenWidth * 0.45,
                  child: Text(
                    S.of(context).emergencyCardInfo,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 16,
                    ),
                  ),
                ),
                Gap(screenWidth * 0.03),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RequestDataView(
                            requirements: [],
                            selectedServices: ["7"],
                          ),
                        ));
                  },
                  style: ButtonStyle(
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide.none),
                    ),
                  ),
                  child: Text(
                    S.of(context).emergency,
                    style: const TextStyle(
                        color: kSecondaryColor, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            const Image(image: AssetImage("assets/images/home/amico.png"))
          ],
        ),
      ),
    );
  }
}
