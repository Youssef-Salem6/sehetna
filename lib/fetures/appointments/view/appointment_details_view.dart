import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:sehetna/const.dart';
import 'package:sehetna/core/custom_text.dart';
import 'package:sehetna/fetures/appointments/manager/appointmentDetails/appointment_details_cubit.dart';
import 'package:sehetna/fetures/appointments/models/feedback_model.dart';
import 'package:sehetna/fetures/appointments/models/requests_model.dart';
import 'package:sehetna/fetures/appointments/view/complain_review_view.dart';
import 'package:sehetna/fetures/appointments/view/complain_view.dart';
import 'package:sehetna/fetures/appointments/view/feedback_review_view.dart';
import 'package:sehetna/fetures/appointments/view/feedback_view.dart';
import 'package:sehetna/fetures/appointments/view/widgets/appointment_details_row.dart';
import 'package:sehetna/fetures/appointments/view/widgets/cancel_request_dialog.dart';
import 'package:sehetna/fetures/categories/manager/servicesList/services_list_cubit.dart';
import 'package:sehetna/fetures/categories/view/categories_view.dart';
import 'package:sehetna/generated/l10n.dart';

class AppointmentDetailsView extends StatefulWidget {
  final String id;
  const AppointmentDetailsView({super.key, required this.id});

  @override
  State<AppointmentDetailsView> createState() => _AppointmentDetailsViewState();
}

class _AppointmentDetailsViewState extends State<AppointmentDetailsView> {
  @override
  void initState() {
    BlocProvider.of<AppointmentDetailsCubit>(context).getRequestDetails(
      id: widget.id.toString(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isPortrait = mediaQuery.orientation == Orientation.portrait;

    return BlocBuilder<ServicesListCubit, ServicesListState>(
      builder: (context, state) {
        return BlocConsumer<AppointmentDetailsCubit, AppointmentDetailsState>(
          listener: (context, state) {
            if (state is AppointmentDetailsFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error!),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            // Show loading indicator while waiting for data
            if (state is! AppointmentDetailsSuccess ||
                BlocProvider.of<AppointmentDetailsCubit>(context)
                    .data
                    .isEmpty) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            // Only build UI when we have valid data
            final requestsModel = RequestsModel.fromJson(
              json: BlocProvider.of<AppointmentDetailsCubit>(context).data,
              languageCode: Localizations.localeOf(context).languageCode,
            );

            return Scaffold(
              body: SafeArea(
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight:
                          mediaQuery.size.height - mediaQuery.padding.top,
                    ),
                    child: Column(
                      children: [
                        // Header Section
                        Container(
                          width: double.infinity,
                          height: isPortrait
                              ? mediaQuery.size.height * 0.1
                              : mediaQuery.size.height * 0.2,
                          decoration: const BoxDecoration(color: kPrimaryColor),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: mediaQuery.size.width * 0.04,
                              vertical: mediaQuery.size.height * 0.01,
                            ),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Colors.white),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(
                                          mediaQuery.size.width * 0.03),
                                      child: SvgPicture.asset(
                                        "assets/images/Icons/arrowBack.svg",
                                        width: mediaQuery.size.width * 0.03,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: mediaQuery.size.width * 0.05),
                                CustomText(
                                  txt: S.of(context).appointmentDetails,
                                  size: mediaQuery.size.width * 0.045,
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Content Section
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: mediaQuery.size.width * 0.05,
                            vertical: isPortrait
                                ? mediaQuery.size.height * 0.02
                                : mediaQuery.size.height * 0.01,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Doctor Image
                              Center(
                                child: Container(
                                  width: isPortrait
                                      ? mediaQuery.size.width * 0.9
                                      : mediaQuery.size.width * 0.4,
                                  height: isPortrait
                                      ? mediaQuery.size.height * 0.25
                                      : mediaQuery.size.height * 0.5,
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage("assets/images/1.png"),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: mediaQuery.size.height * 0.02),

                              // Doctor Name
                              Text(
                                "${requestsModel.providerFirstName} ${requestsModel.providerLastName}",
                                style: TextStyle(
                                  color: kPrimaryColor,
                                  fontSize: mediaQuery.size.width * 0.055,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),

                              SizedBox(height: mediaQuery.size.height * 0.01),

                              // Speciality
                              Text(
                                requestsModel.providerType!,
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.4),
                                  fontSize: mediaQuery.size.width * 0.04,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),

                              SizedBox(height: mediaQuery.size.height * 0.03),

                              // Appointment Details Rows
                              AppointmentDetailsRow(
                                image: "assets/images/Icons/callender.svg",
                                title: S.of(context).date,
                                value: DateFormat('d - M - y').format(
                                    DateTime.parse(requestsModel.createdAt!)),
                              ),
                              AppointmentDetailsRow(
                                image: "assets/images/Icons/location.svg",
                                title: S.of(context).status,
                                value: requestsModel.status ?? "",
                              ),
                              AppointmentDetailsRow(
                                image:
                                    "assets/images/Icons/flowbite_cash-solid.svg",
                                title: S.of(context).fees,
                                value: "${requestsModel.price} EGP",
                              ),
                              AppointmentDetailsRow(
                                image:
                                    "assets/images/Icons/fluent_call-12-filled.svg",
                                title: S.of(context).callDoctor,
                                value: requestsModel.providerPhone!,
                              ),

                              // Spacer to push buttons to bottom
                              if (isPortrait)
                                SizedBox(height: mediaQuery.size.height * 0.1),
                              // Buttons Section
                              Column(
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    child: Row(
                                      children: [
                                        Visibility(
                                          visible: requestsModel.status ==
                                              "completed",
                                          child: Expanded(
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: kPrimaryColor,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                  vertical:
                                                      mediaQuery.size.height *
                                                          0.02,
                                                ),
                                              ),
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          requestsModel
                                                                  .feedbacks!
                                                                  .isEmpty
                                                              ? FeedbackView(
                                                                  requestId:
                                                                      widget.id,
                                                                )
                                                              : FeedbackReviewView(
                                                                  feedbackModel:
                                                                      FeedbackModel
                                                                          .fromJson(
                                                                    json: requestsModel
                                                                        .feedbacks![0],
                                                                  ),
                                                                ),
                                                    ));
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SvgPicture.asset(
                                                    "assets/images/Icons/feedBack.svg",
                                                    width:
                                                        mediaQuery.size.width *
                                                            0.04,
                                                  ),
                                                  const Gap(10),
                                                  Text(
                                                    S.of(context).feedBack,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: mediaQuery
                                                              .size.width *
                                                          0.038,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        const Gap(10),
                                        Expanded(
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: kSecondaryColor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                vertical:
                                                    mediaQuery.size.height *
                                                        0.02,
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      requestsModel.complaints!
                                                              .isEmpty
                                                          ? ComplainView(
                                                              requestId:
                                                                  widget.id,
                                                            )
                                                          : ComplainReviewView(
                                                              id: requestsModel
                                                                  .id!,
                                                            ),
                                                ),
                                              );
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  S.of(context).complain,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        mediaQuery.size.width *
                                                            0.038,
                                                  ),
                                                ),
                                                const Gap(10),
                                                SvgPicture.asset(
                                                  "assets/images/Icons/complain.svg",
                                                  width: mediaQuery.size.width *
                                                      0.04,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Gap(requestsModel.status == "accepted"
                                            ? 10
                                            : 0),
                                        Visibility(
                                          visible: requestsModel.status ==
                                                  "accepted" &&
                                              requestsModel.isMultiaple == 1,
                                          child: Expanded(
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: kPrimaryColor,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                  vertical:
                                                      mediaQuery.size.height *
                                                          0.02,
                                                ),
                                              ),
                                              onPressed: () {
                                                BlocProvider.of<
                                                    ServicesListCubit>(
                                                  context,
                                                ).clearList();
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        CategoriesView(
                                                      requestId: requestsModel
                                                          .id
                                                          .toString(),
                                                      isFromHome: false,
                                                      categoryId: requestsModel
                                                          .categoryId
                                                          .toString(),
                                                      categoryName:
                                                          requestsModel
                                                              .categoryName!,
                                                      isMultiable: requestsModel
                                                          .isMultiaple!,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const Icon(
                                                    Icons.add,
                                                    color: Colors.white,
                                                  ),
                                                  const Gap(10),
                                                  Text(
                                                    S.of(context).addService,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: mediaQuery
                                                              .size.width *
                                                          0.038,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                      height: mediaQuery.size.height * 0.02),
                                  Visibility(
                                    visible:
                                        requestsModel.status == "pending" ||
                                            requestsModel.status == "accepted",
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          side: const BorderSide(
                                              color: kPrimaryColor),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            vertical:
                                                mediaQuery.size.height * 0.02,
                                          ),
                                        ),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) =>
                                                CancelRequestDialog(
                                                    requestId:
                                                        requestsModel.id!),
                                          );
                                        },
                                        child: Text(
                                          S.of(context).cancelAppointment,
                                          style: TextStyle(
                                            color: kPrimaryColor,
                                            fontSize:
                                                mediaQuery.size.width * 0.04,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // Additional bottom padding for landscape
                              if (!isPortrait)
                                SizedBox(height: mediaQuery.size.height * 0.02),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
