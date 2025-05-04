import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:sehetna/fetures/categories/manager/servicesList/services_list_cubit.dart';
import 'package:sehetna/fetures/categories/view/categories_view.dart';

import 'package:sehetna/fetures/home/manager/getAllCategories/get_all_categories_cubit.dart';
import 'package:sehetna/fetures/home/models/categories_model.dart';
import 'package:sehetna/fetures/home/view/widgets/Custom_speciality_card.dart';
import 'package:shimmer/shimmer.dart'; // Add this import

class CategoryList extends StatefulWidget {
  const CategoryList({super.key});

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  @override
  void initState() {
    _loadCategories();
    super.initState();
  }

  void _loadCategories() {
    BlocProvider.of<GetAllCategoriesCubit>(context).getAllCategories();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // This will trigger when locale changes
    _loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    return BlocBuilder<GetAllCategoriesCubit, GetAllCategoriesState>(
      builder: (context, state) {
        var cubit = BlocProvider.of<GetAllCategoriesCubit>(context);
        final currentLocale = Localizations.localeOf(context).languageCode;

        return BlocBuilder<ServicesListCubit, ServicesListState>(
          builder: (context, state) {
            return SliverToBoxAdapter(
              child: SizedBox(
                height: screenSize.height * 0.22,
                child: state is GetAllCategoriesLoading
                    ? _buildShimmerLoading() // Use shimmer loading widget
                    : ListView.builder(
                        itemCount: cubit.categories.length,
                        itemBuilder: (context, index) {
                          CategoriesModel category = CategoriesModel.fromJson(
                              json: cubit.categories[index],
                              languageCode: currentLocale);
                          return GestureDetector(
                            onTap: () {
                              BlocProvider.of<ServicesListCubit>(context)
                                  .clearList();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CategoriesView(
                                      requestId: "",
                                      isFromHome: true,
                                      isMultiable: category.isMultiaple!,
                                      categoryId: category.id!,
                                      categoryName: category.name!,
                                    ),
                                  ));
                            },
                            child: CustomSpecialityCard(
                              image: category.icon!,
                              txt: category.name!,
                            ),
                          );
                        },
                        scrollDirection: Axis.horizontal,
                      ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      itemCount: 5, // Show 5 shimmer items while loading
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.20,
              width: MediaQuery.of(context).size.width * 0.35,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: MediaQuery.of(context).size.height * 0.20 * 0.2,
                    child: Container(),
                  ),
                  // Second Container (4 parts)
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.20 * 0.2,
                    left: 0,
                    right: 0,
                    height: MediaQuery.of(context).size.height * 0.20 * 0.8,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Column(
                      children: [
                        Gap(MediaQuery.of(context).size.height * 0.02),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6.0),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.05,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
