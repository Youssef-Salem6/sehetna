import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:sehetna/const.dart';
import 'package:sehetna/constants/details.dart';
import 'package:sehetna/fetures/profile/manager/updateProfile/update_profile_cubit.dart';
import 'package:sehetna/fetures/profile/view/widgets/Custom_app_bar.dart';
import 'package:sehetna/fetures/profile/view/widgets/edit_profile_custom_field.dart';
import 'package:sehetna/fetures/profile/view/widgets/location_container.dart';
import 'package:sehetna/generated/l10n.dart';
import 'package:sehetna/main.dart';
import 'package:shimmer/shimmer.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  String selectedGender = "male";

  @override
  void initState() {
    super.initState();
    firstNameController.text = pref.getString("firstName") ?? "";
    lastNameController.text = pref.getString("lastName") ?? "";
    emailController.text = pref.getString("email") ?? "";
    phoneController.text = pref.getString("phone") ?? "";
    addressController.text = pref.getString("address") ?? "";
    selectedGender = pref.getString("gender") ?? "male";
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    return BlocProvider(
      create: (context) => UpdateProfileCubit(),
      child: BlocConsumer<UpdateProfileCubit, UpdateProfileState>(
        listener: (context, state) {
          if (state is UpdateProfileSuccess) {
            pref.setString("firstName", firstNameController.text);
            pref.setString("lastName", lastNameController.text);
            pref.setString("phone", phoneController.text);
            pref.setString("address", addressController.text);
            pref.setString("gender", selectedGender);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: const Color.fromARGB(255, 111, 187, 113),
                content: Text(
                  state.message,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            );
          } else if (state is UpdateProfileFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.red,
                content: Text(
                  state.error,
                  style: const TextStyle(fontSize: 16),
                ),
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
                    title: S.of(context).editProfile,
                  ),
                  Gap(screenSize.height * 0.03),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xffE5F1F7),
                        boxShadow: Details.boxShadowList,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: EditProfileCustomField(
                                    controller: firstNameController,
                                    title: S.of(context).firstName,
                                  ),
                                ),
                                const Gap(8),
                                Expanded(
                                  child: EditProfileCustomField(
                                    controller: lastNameController,
                                    title: S.of(context).lastName,
                                  ),
                                ),
                              ],
                            ),
                            const Gap(8),
                            EditProfileCustomField(
                              controller: phoneController,
                              title: S.of(context).phone,
                            ),
                            const Gap(8),
                            EditProfileCustomField(
                              controller: emailController,
                              title: S.of(context).email,
                            ),
                            const Gap(8),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Gender",
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.3),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            const Gap(8),
                            Row(
                              children: [
                                // Male Button
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedGender = 'male';
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      decoration: BoxDecoration(
                                        color: selectedGender == 'male'
                                            ? kPrimaryColor
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: Colors.grey.withOpacity(0.5),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          S.of(context).male,
                                          style: TextStyle(
                                            color: selectedGender == 'male'
                                                ? Colors.white
                                                : Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const Gap(8),
                                // Female Button
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedGender = 'female';
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      decoration: BoxDecoration(
                                        color: selectedGender == 'female'
                                            ? const Color(0xFFFFC0CB)
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: Colors.grey.withOpacity(0.5),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          S.of(context).female,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  LocationContainer(
                    controller: addressController,
                  ),
                  const Gap(16),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: screenSize.width * 0.125),
                    child: ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<UpdateProfileCubit>(context)
                            .updateProfile(body: {
                          "first_name": firstNameController.text,
                          "last_name": lastNameController.text,
                          "phone": phoneController.text,
                          "address": addressController.text,
                          "gender": selectedGender,
                        });
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
                      child: state is UpdateProfileLoading
                          ? Shimmer.fromColors(
                              baseColor: Colors.white.withOpacity(0.6),
                              highlightColor: Colors.white,
                              child: const Text(
                                "Save",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            )
                          : const Text(
                              "Save",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
