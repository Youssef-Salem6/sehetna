import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sehetna/const.dart';
import 'package:sehetna/constants/details.dart';
import 'package:sehetna/fetures/appointments/view/appointment_details_view.dart';
import 'package:sehetna/fetures/home/manager/ongoingRequests/ongoing_requests_cubit.dart';
import 'package:sehetna/generated/l10n.dart';

class OngoingRequests extends StatefulWidget {
  const OngoingRequests({super.key});

  @override
  State<OngoingRequests> createState() => _OngoingRequestsState();
}

class _OngoingRequestsState extends State<OngoingRequests> {
  @override
  void initState() {
    BlocProvider.of<OngoingRequestsCubit>(context).getOngoningRequests();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.sizeOf(context);
    return BlocConsumer<OngoingRequestsCubit, OngoingRequestsState>(
      listener: (context, state) {
        if (state is OngoingRequestsFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        var cubit = BlocProvider.of<OngoingRequestsCubit>(context);

        if (state is OngoingRequestsLoading) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: SizedBox(
              height: screenSize.height * 0.18,
              child: ListView.builder(
                itemCount: 3, // Show 3 shimmer items
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: Details.boxShadowList,
                    ),
                    height: 80,
                  );
                },
              ),
            ),
          );
        }

        if (state is OngoingRequestsEmpty) {
          return Center(
            child: Text(
              S.of(context).emptyOngoingRequests,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
          );
        }

        if (state is OngoingRequestsSuccess) {
          return SizedBox(
            height: screenSize.height * 0.18,
            child: ListView.builder(
              itemCount: cubit.ongoingRequests.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
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
                          width: screenSize.width * 0.6,
                          child: Column(
                            children: [
                              Text(
                                cubit.ongoingRequests[index]["services"][0]["name"][
                                    Localizations.localeOf(context)
                                        .languageCode],
                                style: const TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    color: kPrimaryColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                              Gap(screenSize.width * 0.02),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            AppointmentDetailsView(
                                          id: cubit.ongoingRequests[index]["id"]
                                              .toString(),
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
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
        if (state is OngoingRequestsFailure) {
          return const Center(
            child: Text(
              "Failed to load requests",
              style: TextStyle(
                color: Colors.red,
                fontSize: 16,
              ),
            ),
          );
        }

        return Container(); // Fallback
      },
    );
  }
}
