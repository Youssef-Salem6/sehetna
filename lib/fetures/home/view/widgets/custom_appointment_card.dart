import 'package:flutter/material.dart';

import 'package:gap/gap.dart';
import 'package:sehetna/const.dart';
import 'package:sehetna/constants/apis.dart';
import 'package:sehetna/constants/details.dart';
import 'package:sehetna/fetures/appointments/models/requests_model.dart';
import 'package:sehetna/fetures/appointments/view/appointment_details_view.dart';
import 'package:sehetna/generated/l10n.dart';

class CustomAppointmentCard extends StatelessWidget {
  final RequestsModel requestsModel;

  const CustomAppointmentCard({super.key, required this.requestsModel});
  // ignore: override_on_non_overriding_member
  String getProviderName({required RequestsModel requestModel}) {
    if (requestModel.status == "cancelled") {
      return "cancelled request";
    } else if (requestModel.status == "pending") {
      return "no Provider Yet";
    } else {
      return requestModel.name!;
    }
  }

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
                      getProviderName(requestModel: requestsModel),
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
              Visibility(
                visible: requestsModel.status != "cancelled" &&
                    requestsModel.status != "pending",
                child: Image(
                  image: NetworkImage(
                      "$imagesBaseUrl/${requestsModel.providerimage}"),
                  width: screenWidth * 0.15,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
