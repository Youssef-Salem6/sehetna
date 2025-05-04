import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:sehetna/const.dart';
import 'package:sehetna/constants/details.dart';
import 'package:sehetna/fetures/profile/view/widgets/edit_profile_custom_field.dart';
import 'package:sehetna/generated/l10n.dart';

class LocationContainer extends StatefulWidget {
  final TextEditingController controller;

  const LocationContainer({
    super.key,
    required this.controller,
  });

  @override
  State<LocationContainer> createState() => _LocationContainerState();
}

class _LocationContainerState extends State<LocationContainer>
    with TickerProviderStateMixin {
  bool isOpen = false;
  late AnimationController _controller;
  late AnimationController _fieldController;
  late Animation<double> _heightAnimation;
  late Animation<double> _arrowAnimation;
  late Animation<double> _fieldOpacity;

  final double collapsedHeight = 72.0;
  final double expandedHeight = 170.0; // Increased to accommodate submit button

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );

    _fieldController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _heightAnimation = Tween<double>(
      begin: collapsedHeight,
      end: expandedHeight,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _arrowAnimation = Tween<double>(
      begin: 0,
      end: 0.5,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _fieldOpacity = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _fieldController,
      curve: Curves.easeIn,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    _fieldController.dispose();
    super.dispose();
  }

  void _toggle() async {
    setState(() {
      isOpen = !isOpen;
    });

    if (isOpen) {
      await _controller.forward();
      await Future.delayed(const Duration(milliseconds: 150)); // Reduced delay
      if (mounted) {
        await _fieldController.forward();
      }
    } else {
      await _fieldController.reverse();
      await _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: AnimatedBuilder(
        animation: Listenable.merge([_controller, _fieldController]),
        builder: (context, child) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16.0),
            child: SizedBox(
              height: _heightAnimation.value,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: const Color(0xffE5F1F7),
                  boxShadow: Details.boxShadowList,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: collapsedHeight,
                      maxHeight: expandedHeight,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Header row
                        Row(
                          children: [
                            SvgPicture.asset(
                                "assets/images/Icons/location.svg"),
                            const Gap(16),
                            Text(
                              S.of(context).address,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Spacer(),
                            RotationTransition(
                              turns: _arrowAnimation,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: _toggle,
                                icon: const Icon(
                                  Icons.arrow_drop_down_rounded,
                                  color: kPrimaryColor,
                                  size: 30,
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Content that appears when expanded
                        if (_heightAnimation.value > collapsedHeight + 10)
                          FadeTransition(
                            opacity: _fieldOpacity,
                            child: Column(
                              children: [
                                const Gap(12),
                                SizedBox(
                                  height: 80,
                                  child: EditProfileCustomField(
                                    controller: widget.controller,
                                    title: S.of(context).address,
                                  ),
                                ),
                                // const Gap(12),
                                // SizedBox(
                                //   width:
                                //       MediaQuery.of(context).size.width * 0.5,
                                //   child: ElevatedButton(
                                //     style: ElevatedButton.styleFrom(
                                //       backgroundColor: kPrimaryColor,
                                //       shape: RoundedRectangleBorder(
                                //         borderRadius: BorderRadius.circular(8),
                                //       ),
                                //       padding: const EdgeInsets.symmetric(
                                //           vertical: 14),
                                //     ),
                                //     onPressed: () {},
                                //     child: Text(
                                //       S.of(context).submit,
                                //       style: const TextStyle(
                                //         color: Colors.white,
                                //         fontSize: 16,
                                //         fontWeight: FontWeight.w600,
                                //       ),
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
