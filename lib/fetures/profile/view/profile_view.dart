import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sehetna/const.dart';
import 'package:sehetna/constants/apis.dart';
import 'package:sehetna/fetures/profile/manager/profileImage/update_profile_image_cubit.dart';
import 'package:sehetna/fetures/profile/view/widgets/profile_body_view.dart';
import 'package:sehetna/main.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    return BlocProvider(
      create: (context) => UpdateProfileImageCubit(),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: ListView(
              children: [
                Gap(screenSize.height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BlocConsumer<UpdateProfileImageCubit,
                        UpdateProfileImageState>(
                      listener: (context, state) {
                        if (state is UpdateProfileImageSuccess) {
                          pref.setString("image", state.imageUrl);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('Profile image updated successfully'),
                            ),
                          );
                        } else if (state is UpdateProfileImageFailure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.error),
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        return Column(
                          children: [
                            Stack(
                              alignment: Alignment.bottomCenter,
                              clipBehavior: Clip.none,
                              children: [
                                GestureDetector(
                                  onTap: () => _showImagePickerOptions(context),
                                  child: Container(
                                    width: screenSize.width * 0.25,
                                    height: screenSize.width * 0.25,
                                    decoration: BoxDecoration(
                                      color:
                                          kSecondaryColor, // Background color
                                      border: Border.all(
                                        color: kSecondaryColor,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        image: pref.getString('image') != ""
                                            ? NetworkImage(
                                                "$imagesBaseUrl/${pref.getString('image')}")
                                            : AssetImage(pref
                                                        .getString("gender") ==
                                                    "male"
                                                ? "assets/images/users/man (1).png"
                                                : "assets/images/users/woman (1).png"),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: -12, // Half outside the container
                                  child: Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: kSecondaryColor,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                                height: 12), // Space for the plus icon
                            CustomTxt(
                              txt:
                                  "${pref.getString("firstName")} ${pref.getString("lastName")}",
                              size: 20,
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
                const ProfileBodyView(),
                Gap(screenSize.height * 0.03),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showImagePickerOptions(BuildContext context) {
    final cubit = context.read<UpdateProfileImageCubit>();

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera),
              title: const Text('Take Photo'),
              onTap: () async {
                Navigator.pop(context);
                final image = await cubit.pickImageFromCamera();
                if (image != null) {
                  await cubit.updateProfileImage(image);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text('Choose from Gallery'),
              onTap: () async {
                Navigator.pop(context);
                final image = await cubit.pickImageFromGallery();
                if (image != null) {
                  await cubit.updateProfileImage(image);
                }
              },
            ),
          ],
        );
      },
    );
  }
}

class CustomTxt extends StatelessWidget {
  final String txt;
  final double size;
  const CustomTxt({
    super.key,
    required this.txt,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      txt,
      style: TextStyle(
        color: kSecondaryColor,
        fontSize: size,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
