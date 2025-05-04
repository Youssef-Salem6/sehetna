import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sehetna/core/custom_text.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.title,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white),
      ),
      child: isLoading
          ? _buildShimmerButton()
          : Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomText(txt: title, size: 18),
              ),
            ),
    );
  }

  Widget _buildShimmerButton() {
    return Shimmer.fromColors(
      baseColor: Colors.white.withOpacity(0.3),
      highlightColor: Colors.white.withOpacity(0.1),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white.withOpacity(0.5),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomText(
              txt: title,
              size: 18,
              // color: Colors.transparent,
            ),
          ),
        ),
      ),
    );
  }
}
