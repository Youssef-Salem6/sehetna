import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sehetna/core/custom_text.dart';
import 'package:sehetna/fetures/appointments/models/requests_model.dart';
import 'package:sehetna/fetures/home/view/widgets/custom_appointment_card.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sehetna/const.dart';
import 'package:sehetna/constants/apis.dart';
import 'package:sehetna/constants/details.dart';
import 'package:sehetna/fetures/appointments/manager/getRequests/get_requests_cubit.dart';
import 'package:sehetna/fetures/home/view/widgets/custom_image_row.dart';
import 'package:sehetna/generated/l10n.dart';
import 'package:sehetna/main.dart';

class AppointmentView extends StatefulWidget {
  const AppointmentView({super.key});

  @override
  State<AppointmentView> createState() => _AppointmentViewState();
}

class _AppointmentViewState extends State<AppointmentView> {
  bool isSearchBarOpen = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    BlocProvider.of<GetRequestsCubit>(context).getRequests();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildShimmerLoading(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color.fromARGB(255, 98, 81, 81),
      highlightColor: const Color.fromARGB(255, 25, 23, 23),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
        child: Column(
          children: List.generate(
            5, // Number of shimmer items
            (index) => Padding(
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
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              height: 16,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 8),
                            Container(
                              width: double.infinity,
                              height: 14,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 16),
                            Container(
                              width: 100,
                              height: 14,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<dynamic> _filterRequests(List<dynamic> requests, String query) {
    if (query.isEmpty) return requests;

    return requests.where((request) {
      final requestModel = RequestsModel.fromJson(
        json: request,
        languageCode: Localizations.localeOf(context).languageCode,
      );

      final providerName = requestModel.name!.toLowerCase();
      final serviceName = requestModel.serviceName!.toLowerCase();
      final status = requestModel.status!.toLowerCase();

      return providerName.contains(query.toLowerCase()) ||
          serviceName.contains(query.toLowerCase()) ||
          status.contains(query.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GetRequestsCubit, GetRequestsState>(
      listener: (context, state) {
        if (state is GetRequestsFailure) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.error),
            backgroundColor: Colors.red,
          ));
        }
      },
      builder: (context, state) {
        final cubit = BlocProvider.of<GetRequestsCubit>(context);
        final filteredRequests =
            isSearchBarOpen && _searchController.text.isNotEmpty
                ? _filterRequests(cubit.requests, _searchController.text)
                : cubit.requests;

        return Scaffold(
          body: SafeArea(
            child: ListView(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white, boxShadow: Details.boxShadowList),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 8, right: 8, top: 8, bottom: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomImageRow(
                            name: pref.getString(
                                "firstName")!, // Localized loading text
                            image:
                                "$imagesBaseUrl/${pref.getString("image")!}"),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isSearchBarOpen = !isSearchBarOpen;
                              if (!isSearchBarOpen) {
                                _searchController.clear();
                              }
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: isSearchBarOpen
                                  ? Border.all(
                                      color: kPrimaryColor, width: sqrt1_2)
                                  : null,
                              color: isSearchBarOpen
                                  ? Colors.white
                                  : kPrimaryColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Icon(
                                isSearchBarOpen ? Icons.close : Icons.search,
                                color: !isSearchBarOpen
                                    ? Colors.white
                                    : kPrimaryColor,
                                size: 28,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: isSearchBarOpen,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onChanged: (value) {
                              setState(() {}); // Trigger rebuild on text change
                            },
                            cursorColor: Colors.white,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16),
                            decoration: InputDecoration(
                              hintText: S.of(context).search,
                              filled: true,
                              fillColor: kPrimaryColor.withOpacity(0.8),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.75,
                  child: state is GetRequestsLoading
                      ? _buildShimmerLoading(context)
                      : state is GetRequestsEmpty || filteredRequests.isEmpty
                          ? Center(
                              child: CustomText(
                                txt: isSearchBarOpen &&
                                        _searchController.text.isNotEmpty
                                    ? 'No matching appointments found'
                                    : S.of(context).emptyRequests,
                                size: 20,
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16),
                              itemCount: filteredRequests.length,
                              itemBuilder: (context, index) {
                                final request = RequestsModel.fromJson(
                                  json: filteredRequests[index],
                                  languageCode: Localizations.localeOf(context)
                                      .languageCode,
                                );
                                return CustomAppointmentCard(
                                    requestsModel: request);
                              },
                            ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
