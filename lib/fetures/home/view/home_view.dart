import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:sehetna/constants/apis.dart';
import 'package:sehetna/fetures/home/manager/ongoingRequests/ongoing_requests_cubit.dart';
import 'package:sehetna/fetures/home/view/widgets/category_list.dart';
import 'package:sehetna/fetures/home/view/widgets/ongoiong_requests.dart';
import 'package:sehetna/main.dart';
import 'package:sehetna/const.dart';
import 'package:sehetna/fetures/home/manager/getLocation/get_location_cubit.dart';
import 'package:sehetna/fetures/home/view/widgets/custom_image_row.dart';
import 'package:sehetna/fetures/home/view/widgets/schedule_home_container.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  @override
  Widget build(BuildContext context) {
    super.build(context);
    // ignore: unused_local_variable
    final screenSize = MediaQuery.sizeOf(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: CustomScrollView(slivers: [
            SliverList(
              delegate: SliverChildListDelegate([
                CustomImageRow(
                    name: pref.getString("firstName") ??"",
                    image: "$imagesBaseUrl/${pref.getString("image")!}"),
                const Gap(12),
                BlocSelector<GetLocationCubit, GetLocationState, String>(
                  selector: (state) {
                    return state is GetLocationLoaded
                        ? "${state.village} - ${state.city} - ${state.country}"
                        : "Loading location...";
                  },
                  builder: (context, locationText) {
                    return Container();
                  },
                ),
                const Gap(16),
                const ScheduleHomeContainer(),
                const Gap(12),
              ]),
            ),
            const CategoryList(),
            SliverList(
              delegate: SliverChildListDelegate([
                const Gap(12),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Ongoing Request",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: kPrimaryColor,
                    ),
                  ),
                ),
                const Gap(8),
                BlocProvider(
                  // Wrap with BlocProvider
                  create: (context) => OngoingRequestsCubit(),
                  child: const OngoingRequests(),
                ),
              ]),
            ),
          ]),
        ),
      ),
    );
  }
}
