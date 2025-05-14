import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:sehetna/const.dart';

class RequestDetailsRow extends StatelessWidget {
  final String image, title, value;
  const RequestDetailsRow({
    super.key,
    required this.image,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          SvgPicture.asset(image, width: 20),
          const Gap(8),
          Text(
            title,
            style: const TextStyle(
              color: kPrimaryColor,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: Text(
              textDirection: TextDirection.rtl,
              overflow: TextOverflow.ellipsis,
              value,
              style: TextStyle(
                color: Colors.black.withOpacity(0.4),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
