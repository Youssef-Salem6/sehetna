import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sehetna/const.dart';
import 'package:sehetna/constants/apis.dart';
import 'package:sehetna/constants/details.dart';
import 'package:sehetna/fetures/categories/manager/servicesList/services_list_cubit.dart';
import 'package:sehetna/fetures/categories/models/service_model.dart';
import 'package:sehetna/fetures/categories/view/service_view.dart';

class ServiceCard extends StatefulWidget {
  final ServiceModel serviceModel;
  final int isMultiable;
  const ServiceCard({
    super.key,
    required this.serviceModel,
    required this.isMultiable,
  });

  @override
  State<ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  bool ischoosen = false;
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return BlocBuilder<ServicesListCubit, ServicesListState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            if (widget.isMultiable == 0) {
              BlocProvider.of<ServicesListCubit>(context).addServiceToList(
                id: widget.serviceModel.id!,
                price: double.parse(widget.serviceModel.price!),
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ServiceView(serviceModel: widget.serviceModel),
                ),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: screenSize.height * 0.2,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: Details.boxShadowList,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Visibility(
                    visible: widget.isMultiable == 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Checkbox(
                          value: ischoosen,
                          onChanged: (value) {
                            setState(
                              () {
                                ischoosen = value!;
                                if (ischoosen) {
                                  BlocProvider.of<ServicesListCubit>(context)
                                      .addServiceToList(
                                          price: double.parse(
                                              widget.serviceModel.price!),
                                          id: widget.serviceModel.id!);
                                } else {
                                  BlocProvider.of<ServicesListCubit>(context)
                                      .removeServiceFromList(
                                    price: double.parse(
                                        widget.serviceModel.price!),
                                    id: widget.serviceModel.id!,
                                  );
                                }
                              },
                            );
                          },
                        )
                      ],
                    ),
                  ),

                  // Top spacing
                  SizedBox(height: widget.isMultiable == 1 ? 10 : 20),

                  // Image section
                  Image(
                    width: screenSize.width * 0.1,
                    image: NetworkImage(
                        "$imagesBaseUrl/${widget.serviceModel.icon}"),
                  ),

                  const SizedBox(height: 8),

                  // Service name section with expanded layout
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Center(
                        child: Text(
                          widget.serviceModel.name!,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: kPrimaryColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Description section with expanded layout
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      child: Text(
                        widget.serviceModel.description!,
                        style: TextStyle(
                          color: kSecondaryColor.withOpacity(0.7),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          height: 1.3,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 4,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  // Bottom padding
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
