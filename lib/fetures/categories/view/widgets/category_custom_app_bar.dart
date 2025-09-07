import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:sehetna/const.dart';
import 'package:sehetna/fetures/categories/manager/servicesList/services_list_cubit.dart';

class CategoryCustomAppBar extends StatelessWidget {
  final String categoryName;
  final bool isNeeded;
  const CategoryCustomAppBar(
      {super.key, required this.categoryName, required this.isNeeded});

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return BlocBuilder<ServicesListCubit, ServicesListState>(
      builder: (context, state) {
        return Container(
          width: double.infinity,
          height: screenSize.height * 0.09,
          decoration: const BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(8)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    if (isNeeded) {
                    }
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    size: 30,
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
                const Gap(10),
                Text(
                  categoryName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
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
