import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:sehetna/const.dart';
import 'package:sehetna/constants/details.dart';
import 'package:sehetna/fetures/profile/manager/changePaswword/change_password_cubit.dart';
import 'package:sehetna/fetures/profile/view/widgets/Custom_app_bar.dart';
import 'package:sehetna/fetures/profile/view/widgets/change_password_custom_field.dart';
import 'package:sehetna/generated/l10n.dart';
import 'package:shimmer/shimmer.dart'; // Import shimmer package

class ChangePaswwordView extends StatefulWidget {
  const ChangePaswwordView({super.key});

  @override
  State<ChangePaswwordView> createState() => _ChangePaswwordViewState();
}

class _ChangePaswwordViewState extends State<ChangePaswwordView> {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    return BlocProvider(
      create: (context) => ChangePasswordCubit(),
      child: BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
        listener: (context, state) {
          if (state is ChangePasswordSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(S.of(context).passwordChangedSuccessfully),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          } else if (state is ChangePasswordFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: SafeArea(
              child: ListView(
                children: [
                  CustomAppBar(
                    title: S.of(context).changePassword,
                  ),
                  Gap(screenSize.height * 0.02),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xffE5F1F7),
                        boxShadow: Details.boxShadowList,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 16),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              ChangePasswordCustomField(
                                controller: oldPasswordController,
                                hint: S.of(context).oldPassword,
                                type: TextInputType.visiblePassword,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return S.of(context).embtyPasswordWarning;
                                  }
                                  if (value.length < 6) {
                                    return S.of(context).shortPasswordWarning;
                                  }
                                  return null;
                                },
                              ),
                              Gap(screenSize.height * 0.02),
                              ChangePasswordCustomField(
                                  controller: newPasswordController,
                                  hint: S.of(context).newPassword,
                                  type: TextInputType.visiblePassword,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return S.of(context).embtyPasswordWarning;
                                    }
                                    if (value.length < 6) {
                                      return S.of(context).shortPasswordWarning;
                                    }
                                    return null;
                                  }),
                              Gap(screenSize.height * 0.02),
                              ChangePasswordCustomField(
                                controller: confirmPasswordController,
                                hint: S.of(context).confermationPassword,
                                type: TextInputType.visiblePassword,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return S.of(context).embtyPasswordWarning;
                                  }
                                  if (value.length < 6) {
                                    return S.of(context).shortPasswordWarning;
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Gap(screenSize.height * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: state is ChangePasswordLoading
                            ? null // Disable button when loading
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  // Perform password change action
                                  BlocProvider.of<ChangePasswordCubit>(context)
                                      .changePassword(body: {
                                    "old_password": oldPasswordController.text,
                                    "new_password": newPasswordController.text,
                                    "new_password_confirmation":
                                        confirmPasswordController.text,
                                  });
                                }
                              },
                        style: ButtonStyle(
                          backgroundColor:
                              const WidgetStatePropertyAll(kPrimaryColor),
                          padding: const WidgetStatePropertyAll(
                            EdgeInsets.symmetric(vertical: 12),
                          ),
                          shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: state is ChangePasswordLoading
                              ? SizedBox(
                                  width: 131, // Fixed width for shimmer effect
                                  child: Shimmer.fromColors(
                                    baseColor: Colors.white.withOpacity(0.4),
                                    highlightColor: Colors.white,
                                    child: Text(
                                      S.of(context).changePassword,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                              : Text(
                                  S.of(context).changePassword,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                  Gap(screenSize.height * 0.02),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
