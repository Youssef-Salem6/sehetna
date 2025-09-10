import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:sehetna/const.dart';
import 'package:sehetna/fetures/categories/manager/servicesList/services_list_cubit.dart';
import 'package:sehetna/fetures/categories/view/widgets/category_body_view.dart';
import 'package:sehetna/fetures/categories/view/widgets/category_custom_app_bar.dart';
import 'package:sehetna/fetures/categories/view/widgets/cost_dialog.dart';
import 'package:sehetna/generated/l10n.dart';

class CategoriesView extends StatefulWidget {
  final String categoryId;
  final String categoryName;
  final int isMultiable;
  final bool isFromHome;
  final String requestId;
  const CategoriesView({
    super.key,
    required this.categoryId,
    required this.categoryName,
    required this.isMultiable,
    required this.isFromHome,
    required this.requestId,
  });

  @override
  State<CategoriesView> createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              children: [
                CategoryCustomAppBar(
                  isNeeded: true,
                  categoryName: widget.categoryName,
                ),
                const Gap(10),
                CategoryBodyView(
                  isMultiable: widget.isMultiable,
                  categoryId: widget.categoryId,
                )
              ],
            ),
            // Fixed positioning issue
            if (widget.isMultiable == 1)
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      minimumSize: Size(screenSize.width * 0.4, 40),
                    ),
                    onPressed: () {
                      if (BlocProvider.of<ServicesListCubit>(context)
                          .selectedServices
                          .isNotEmpty) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => CostDialog(
                            requestId: widget.requestId,
                            isFromHome: widget.isFromHome,
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please select a service"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    child: Text(
                      S.of(context).requestReview,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
