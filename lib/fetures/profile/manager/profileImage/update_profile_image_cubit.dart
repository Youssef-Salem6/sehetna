import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:sehetna/constants/apis.dart';
import 'package:sehetna/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'update_profile_image_state.dart';

class UpdateProfileImageCubit extends Cubit<UpdateProfileImageState> {
  UpdateProfileImageCubit() : super(UpdateProfileImageInitial());
  final ImagePicker _picker = ImagePicker();

  Future<void> updateProfileImage(File imageFile) async {
    emit(UpdateProfileImageLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(updateProfileImageApi),
      );

      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
        ),
      );

      var response = await request.send();
      final responseString = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(responseString);

        final String? imageUrl = responseData['data']['profile_image'];

        if (imageUrl != null) {
          // Update both local SharedPreferences and global pref
          await prefs.setString('profile_image', imageUrl);
          pref.setString('profile_image', imageUrl);
          print(responseData);
          emit(UpdateProfileImageSuccess(imageUrl: imageUrl));
        } else {
          emit(UpdateProfileImageFailure(error: 'No image URL in response'));
        }
      } else {
        final errorData = jsonDecode(responseString);
        emit(UpdateProfileImageFailure(
          error: errorData['message'] ?? 'Failed to update profile image',
        ));
      }
    } catch (e) {
      emit(UpdateProfileImageFailure(error: e.toString()));
    }
  }

  Future<File?> pickImageFromGallery() async {
    try {
      final XFile? xImage =
          await _picker.pickImage(source: ImageSource.gallery);
      if (xImage != null) {
        return File(xImage.path);
      }
    } catch (e) {
      emit(UpdateProfileImageFailure(
          error: 'Failed to pick image from gallery'));
    }
    return null;
  }

  Future<File?> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        return File(image.path);
      }
    } catch (e) {
      emit(UpdateProfileImageFailure(
          error: 'Failed to capture image from camera'));
    }
    return null;
  }
}
