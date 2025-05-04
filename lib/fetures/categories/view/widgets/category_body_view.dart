import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:sehetna/fetures/categories/view/widgets/service_card.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sehetna/const.dart';
import 'package:sehetna/fetures/categories/manager/getCategory/get_category_services_cubit.dart';
import 'package:sehetna/fetures/categories/models/service_model.dart';

class CategoryBodyView extends StatefulWidget {
  final String categoryId;
  final int isMultiable;
  const CategoryBodyView(
      {super.key, required this.categoryId, required this.isMultiable});

  @override
  State<CategoryBodyView> createState() => _CategoryBodyViewState();
}

class _CategoryBodyViewState extends State<CategoryBodyView> {
  @override
  void initState() {
    BlocProvider.of<GetCategoryServicesCubit>(context)
        .getCategoryServices(id: widget.categoryId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return BlocConsumer<GetCategoryServicesCubit, GetCategoryServicesState>(
      listener: (context, state) {
        if (state is GetCategoryServicesFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        var cubit = BlocProvider.of<GetCategoryServicesCubit>(context);

        // Show shimmer when loading
        if (state is GetCategoryServicesLoading) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: screenSize.height * 0.82,
              decoration: BoxDecoration(
                color: const Color(0xffe5f1f7),
                border: Border.all(color: kPrimaryColor, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.78,
                    ),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: screenSize.height * 0.2,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              const Gap(20),
                              Container(
                                width: 32,
                                height: 32,
                                color: Colors.white,
                              ),
                              const Gap(10),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 16,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                height: screenSize.height * 0.11,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: 6, // Show 6 shimmer items
                  ),
                ),
              ),
            ),
          );
        }

        // Show actual content when loaded
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: screenSize.height * 0.82,
            decoration: BoxDecoration(
              color: const Color(0xffe5f1f7),
              border: Border.all(color: kPrimaryColor, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: screenSize.height * 0.8,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: widget.isMultiable == 1 ? 0.65 : 0.72,
                  ),
                  itemBuilder: (context, index) {
                    ServiceModel serviceModel = ServiceModel.fromJson(
                        json: cubit.services[index],
                        languageCode:
                            Localizations.localeOf(context).languageCode);
                    return ServiceCard(
                      serviceModel: serviceModel,
                      isMultiable: widget.isMultiable,
                    );
                  },
                  itemCount: cubit.services.length,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
