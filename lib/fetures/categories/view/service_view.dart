import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:sehetna/const.dart';
import 'package:sehetna/constants/apis.dart';
import 'package:sehetna/fetures/categories/manager/createService/create_service_cubit.dart';
import 'package:sehetna/fetures/categories/manager/servicesList/services_list_cubit.dart';
import 'package:sehetna/fetures/categories/models/service_model.dart';
import 'package:sehetna/fetures/categories/view/request_data_view.dart';
import 'package:sehetna/fetures/categories/view/widgets/category_custom_app_bar.dart';
import 'package:sehetna/generated/l10n.dart';

class ServiceView extends StatefulWidget {
  final ServiceModel serviceModel;
  const ServiceView({super.key, required this.serviceModel});

  @override
  State<ServiceView> createState() => _ServiceViewState();
}

class _ServiceViewState extends State<ServiceView> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return BlocBuilder<ServicesListCubit, ServicesListState>(
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                CategoryCustomAppBar(
                  categoryName: widget.serviceModel.name!,
                  isNeeded: false,
                ),
                const Gap(10),
                Image(
                  image: NetworkImage(
                      "$imagesBaseUrl/${widget.serviceModel.cover}"),
                  width: size.width * 0.9,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.serviceModel.name!,
                      style: const TextStyle(
                        fontSize: 16,
                        color: kSecondaryColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.serviceModel.description!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: kSecondaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                          "assets/images/Icons/fluent_money-24-filled.svg"),
                      const Gap(8),
                      Text(
                        S.of(context).price,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: kSecondaryColor,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        "${widget.serviceModel.price!} EGP",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: kSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                  create: (context) => CreateServiceCubit(),
                                  child: RequestDataView(
                                    selectedServices:
                                        BlocProvider.of<ServicesListCubit>(
                                                context)
                                            .selectedServices,
                                    requirements:
                                        widget.serviceModel.requirements!,
                                  ),
                                ),
                              ),
                            );
                          },
                          style: ButtonStyle(
                              backgroundColor:
                                  const WidgetStatePropertyAll(kPrimaryColor),
                              foregroundColor:
                                  const WidgetStatePropertyAll(Colors.white),
                              shape: WidgetStatePropertyAll<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)))),
                          child: Text(
                            S.of(context).makeRequest,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
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
    );
  }
}
