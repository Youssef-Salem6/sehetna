import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sehetna/const.dart';
import 'package:sehetna/fetures/categories/manager/createService/create_service_cubit.dart';
import 'package:sehetna/fetures/categories/view/service_wating_view.dart';
import 'package:sehetna/fetures/categories/view/widgets/custom_request_data_field.dart';
import 'package:sehetna/fetures/home/manager/getLocation/get_location_cubit.dart';
import 'package:sehetna/fetures/profile/view/profile_view.dart';
import 'package:sehetna/fetures/profile/view/widgets/bloc_list.dart';
import 'package:sehetna/generated/l10n.dart';
import 'package:sehetna/main.dart';
import 'package:shimmer/shimmer.dart';

class RequestDataView extends StatefulWidget {
  final List<String> selectedServices;
  final List requirements;
  const RequestDataView({
    super.key,
    required this.selectedServices,
    required this.requirements,
  });

  @override
  State<RequestDataView> createState() => _RequestDataViewState();
}

class _RequestDataViewState extends State<RequestDataView> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController additionalInfoController =
      TextEditingController();
  String selectedGender = 'male';
  final Map<String, TextEditingController> _requirementTextControllers = {};
  final Map<String, File?> _uploadedFiles = {};
  final Map<String, String> _requirementTypes = {};
  final Map<String, String> _requirementValues =
      {}; // Add this to store values directly

  @override
  void initState() {
    BlocProvider.of<GetLocationCubit>(context).getLocation();
    _initializeRequirementControllers();
    nameController.text =
        "${pref.getString("firstName")} ${pref.getString("lastName")}";
    phoneController.text = pref.getString("phone") ?? "";
    super.initState();
  }

  void _initializeRequirementControllers() {
    for (var req in widget.requirements) {
      final id = req["id"].toString();
      final type = req["type"];
      _requirementTypes[id] = type;
      if (type == 'input') {
        _requirementTextControllers[id] = TextEditingController();
        // Add listener to update values map when text changes
        _requirementTextControllers[id]!.addListener(() {
          _requirementValues[id] = _requirementTextControllers[id]!.text;
        });
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    additionalInfoController.dispose();
    for (var controller in _requirementTextControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _handleFileUpload(String requirementId) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _uploadedFiles[requirementId] = File(pickedFile.path);
      });
    }
  }

  Widget _buildRequirementsBox() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xffE5F1F7),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(8),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widget.requirements.length,
        itemBuilder: (context, index) {
          final req = widget.requirements[index];
          final id = req["id"].toString();
          final name =
              req["name"][Localizations.localeOf(context).languageCode];
          final type = req["type"];

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name ?? 'Untitled Requirement',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                if (type == 'input')
                  TextFormField(
                    controller: _requirementTextControllers[id],
                    decoration: InputDecoration(
                      hintText: 'Enter $name',
                      hintStyle: TextStyle(
                        color: Colors.grey.withOpacity(0.7),
                        fontSize: 14,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    onChanged: (value) {
                      // Store value directly in the map
                      setState(() {
                        _requirementValues[id] = value;
                      });
                    },
                  )
                else if (type == 'file')
                  InkWell(
                    onTap: () => _handleFileUpload(id),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      height: 56,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              _uploadedFiles[id]?.path.split('/').last ??
                                  'Upload $name',
                              style: TextStyle(
                                color: _uploadedFiles[id] != null
                                    ? Colors.black
                                    : Colors.grey.withOpacity(0.7),
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Icon(
                            Icons.upload,
                            color: Colors.grey.withOpacity(0.7),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateServiceCubit, CreateServiceState>(
      listener: (context, state) {
        if (state is CreateServiceSuccess) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ServiceWaitingView(
                requestId: state.requestId,
                customerId: pref.getString("id")!,
              ),
            ),
          );
        } else if (state is CreateServiceFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        return BlocBuilder<GetLocationCubit, GetLocationState>(
          builder: (context, locationState) {
            if (locationState is GetLocationLoading ||
                state is CreateServiceLoading) {
              return _buildLoadingState();
            }

            if (locationState is GetLocationFailure) {
              return _buildErrorState(locationState.errorMessage);
            }

            final location = locationState as GetLocationLoaded;
            return _buildForm(context, location, state);
          },
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Column(
              children: [
                BlocList(
                  title: S.of(context).informationDetails,
                  children: [
                    Container(
                      height: 60,
                      width: double.infinity,
                      color: Colors.white,
                    ),
                    const Gap(8),
                    Row(
                      children: [
                        Expanded(
                          child: Container(height: 60, color: Colors.white),
                        ),
                        const Gap(8),
                        Expanded(
                          child: Container(height: 60, color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(error)),
      ),
    );
  }

  Widget _buildForm(BuildContext context, GetLocationLoaded location,
      CreateServiceState state) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              BlocList(
                title: S.of(context).informationDetails,
                children: [
                  CustomRequestDataField(
                    max: 1,
                    keyboardType: TextInputType.name,
                    hint: S.of(context).fullName,
                    controller: nameController,
                    validator: (value) {
                      if (value!.isEmpty) return S.of(context).emptyNameError;
                      if (value.length < 5) return S.of(context).shortNameError;
                      return null;
                    },
                  ),
                  CustomRequestDataField(
                    max: 1,
                    hint: S.of(context).age,
                    controller: ageController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return S.of(context).emptyAgeError;
                      }
                      final age = int.tryParse(value);
                      if (age == null) {
                        return S.of(context).invalidAgeError;
                      }
                      if (age < 1 || age > 120) {
                        return S.of(context).ageRangeError;
                      }
                      return null;
                    },
                  ),
                  CustomRequestDataField(
                    max: 1,
                    hint: S.of(context).phone,
                    controller: phoneController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return S.of(context).embtyPhoneWarning;
                      }
                      if (value.length < 11) {
                        return S.of(context).shortPhoneWarning;
                      }
                      return null;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        S.of(context).gender,
                        style: const TextStyle(color: kSecondaryColor),
                      ),
                    ),
                  ),
                  const Gap(8),
                  _buildGenderSelector(),
                  const Gap(8),
                ],
              ),
              const Gap(20),
              if (widget.requirements.isNotEmpty) ...[
                CustomTxt(txt: S.of(context).additionalInfo, size: 16),
                const Gap(8),
                _buildRequirementsBox(),
                const Gap(12),
                BlocList(title: S.of(context).addnote, children: [
                  CustomRequestDataField(
                    max: 5,
                    hint: S.of(context).additionalNote,
                    controller: additionalInfoController,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      return null;
                    },
                  ),
                ]),
                const Gap(20),
              ],
              ElevatedButton(
                onPressed: state is CreateServiceLoading
                    ? null
                    : () => _submitForm(location),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: state is CreateServiceLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(S.of(context).submit),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenderSelector() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => selectedGender = 'male'),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color:
                      selectedGender == 'male' ? kPrimaryColor : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.withOpacity(0.5)),
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
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => selectedGender = 'female'),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: selectedGender == 'female'
                      ? const Color(0xFFFFC0CB)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.withOpacity(0.5)),
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
    );
  }

  void _submitForm(GetLocationLoaded location) {
    // Validate basic fields
    if (nameController.text.isEmpty || ageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).fillAllFields),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Validate age
    final age = int.tryParse(ageController.text);
    if (age == null || age < 1 || age > 120) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).invalidAgeError),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Prepare form data
    final formData = {
      'service_ids': widget.selectedServices.toString(),
      'latitude': location.latitude.toString(),
      'longitude': location.longitude.toString(),
      'phone':
          pref.getString("phone") ?? "", // Get user's phone from preferences
      'gender': selectedGender,
      'additional_info': additionalInfoController.text.isNotEmpty
          ? additionalInfoController.text
          : "", // Use empty string instead of null
      'name': nameController.text,
      'age': ageController.text,
    };

    // Check if phone is available
    if (formData['phone']!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).embtyPhoneWarning),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final Map<String, File> filesToUpload = {};
    bool hasEmptyRequirements = false;

    // Process requirements
    for (int i = 0; i < widget.requirements.length; i++) {
      final req = widget.requirements[i];
      final id = req["id"].toString();
      final type = req["type"];
      final name = req["name"][Localizations.localeOf(context).languageCode];

      if (type == 'input') {
        // Use the values stored in _requirementValues map instead of controller text
        final value = _requirementValues[id] ??
            _requirementTextControllers[id]?.text ??
            "";

        if (value.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Please fill in: $name'),
              backgroundColor: Colors.red,
            ),
          );
          hasEmptyRequirements = true;
          break;
        }

        // Add form data entries for this requirement
        formData['requirements[$i][requirement_id]'] = id;
        formData['requirements[$i][value]'] = value;
      } else if (type == 'file') {
        final file = _uploadedFiles[id];
        if (file == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Please upload: $name'),
              backgroundColor: Colors.red,
            ),
          );
          hasEmptyRequirements = true;
          break;
        }

        // Add file to be uploaded
        filesToUpload[id] = file;

        // Only add requirement_id for file types, value will be empty
        formData['requirements[$i][requirement_id]'] = id;
        formData['requirements[$i][value]'] =
            ''; // Empty string instead of null
      }
    }

    if (hasEmptyRequirements) {
      return;
    }

    // Debug print all form data before submission
    print("Final form data:");
    formData.forEach((key, value) {
      print("$key: $value");
    });

    print("Files to upload:");
    filesToUpload.forEach((key, file) {
      print("file_$key: ${file.path}");
    });

    // Submit the request
    BlocProvider.of<CreateServiceCubit>(context).createRequest(
      formData: formData,
      files: filesToUpload,
    );
  }
}
