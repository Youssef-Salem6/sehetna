import 'package:flutter/material.dart';

import 'package:gap/gap.dart';
import 'package:sehetna/const.dart';
import 'package:sehetna/constants/details.dart';
import 'package:sehetna/fetures/appointments/models/requests_model.dart';
import 'package:sehetna/fetures/appointments/view/appointment_details_view.dart';
import 'package:sehetna/generated/l10n.dart';

class CustomAppointmentCard extends StatelessWidget {
  final RequestsModel requestsModel;

  const CustomAppointmentCard({super.key, required this.requestsModel});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    // double screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: Details.boxShadowList,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: screenWidth * 0.6,
                child: Column(
                  children: [
                    Text(
                      requestsModel.serviceName!,
                      style: const TextStyle(
                          overflow: TextOverflow.ellipsis,
                          color: kPrimaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    Gap(screenWidth * 0.02),
                    Text(
                      requestsModel.name!,
                      style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          color: kPrimaryColor.withOpacity(0.4),
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    Gap(screenWidth * 0.04),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AppointmentDetailsView(
                                id: requestsModel.id!,
                              ),
                            ));
                      },
                      child: Text(
                        S.of(context).viewDetails,
                        style: const TextStyle(
                            color: kPrimaryColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              // SvgPicture.asset(
              //   "assets/images/home/sp1.svg",
              //   height: screenHeight * 0.1,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
