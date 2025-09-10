import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
// ignore: depend_on_referenced_packages
import 'package:http_parser/http_parser.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:sehetna/constants/apis.dart';

part 'create_service_state.dart';

class CreateServiceCubit extends Cubit<CreateServiceState> {
  CreateServiceCubit() : super(CreateServiceInitial());

  Future<void> createRequest({
    required Map<String, String> formData,
    required Map<String, File> files,
  }) async {
    emit(CreateServiceLoading());

    try {
      final request = http.MultipartRequest('POST', Uri.parse(getRequestsApi));
      request.headers.addAll(header);

      // Extract the requirements from the form data
      final List<Map<String, dynamic>> requirements = [];
      final Set<String> requirementKeys =
          formData.keys.where((key) => key.startsWith('requirements[')).toSet();

      // Group requirements by index
      final Map<int, Map<String, String>> requirementsMap = {};

      for (final key in requirementKeys) {
        // Extract the index and property name from the key
        // Format: requirements[0][requirement_id]
        final indexMatch = RegExp(r'requirements\[(\d+)\]').firstMatch(key);
        if (indexMatch != null) {
          final index = int.parse(indexMatch.group(1)!);

          if (!requirementsMap.containsKey(index)) {
            requirementsMap[index] = {};
          }

          if (key.contains('[requirement_id]')) {
            requirementsMap[index]!['requirement_id'] = formData[key]!;
          } else if (key.contains('[value]')) {
            requirementsMap[index]!['value'] = formData[key]!;
          }
        }
      }

      // Convert map to list format required by API
      requirementsMap.forEach((index, data) {
        final Map<String, dynamic> requirement = {
          'requirement_id': data['requirement_id']!
        };

        // Only add value if it exists
        if (data.containsKey('value')) {
          requirement['value'] = data['value']!;
        }

        requirements.add(requirement);
      });

      // Add basic form fields (excluding requirements)
      formData.forEach((key, value) {
        if (!key.startsWith('requirements[')) {
          request.fields[key] = value;
        }
      });

      // Add requirements as array (not string)
      request.fields['requirements'] = jsonEncode(requirements);

      // Add files with proper naming convention
      for (var entry in files.entries) {
        final requirementId = entry.key;
        final file = entry.value;

        final String fileKey = 'file_$requirementId';
        final String mimeType = _getMimeType(file.path);
        final fileStream = http.ByteStream(file.openRead());
        final length = await file.length();

        final multipartFile = http.MultipartFile(
          fileKey,
          fileStream,
          length,
          filename: file.path.split('/').last,
          contentType:
              MediaType(mimeType.split('/')[0], mimeType.split('/')[1]),
        );

        request.files.add(multipartFile);
      }

      // Debug logging
      


      final response = await request.send();
      final responseString = await response.stream.bytesToString();

      // Safe JSON parsing
      Map<String, dynamic> responseData;
      try {
        responseData = jsonDecode(responseString);
      } catch (e) {
        emit(CreateServiceFailure('Invalid response from server'));
        return;
      }



      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseData.containsKey('data') &&
            responseData['data'].containsKey('request') &&
            responseData['data']['request'].containsKey('id')) {
          emit(CreateServiceSuccess(
            requestId: responseData["data"]["request"]["id"].toString(),
          ));
        } else {
          emit(CreateServiceSuccess(
            requestId: "unknown", // Fallback if ID not found in response
          ));
        }
      } else {
        String errorMessage = 'Failed to create request';
        if (responseData.containsKey('message')) {
          errorMessage = responseData['message'];
        } else if (responseData.containsKey('error')) {
          errorMessage = responseData['error'];
        }
        emit(CreateServiceFailure(errorMessage));
      }
    } catch (e) {
      emit(CreateServiceFailure(e.toString()));
    }
  }

  // Helper function to determine MIME type based on file extension
  String _getMimeType(String path) {
    final extension = path.split('.').last.toLowerCase();
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'pdf':
        return 'application/pdf';
      case 'doc':
        return 'application/msword';
      case 'docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      default:
        return 'application/octet-stream';
    }
  }
}
