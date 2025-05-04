import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sehetna/const.dart';
import 'package:sehetna/fetures/appointments/manager/getComplanits/get_complaints_cubit.dart';
import 'package:sehetna/fetures/appointments/manager/submitComplain/submit_complain_cubit.dart';
import 'package:sehetna/generated/l10n.dart';

class ComplainView extends StatefulWidget {
  final String requestId;
  const ComplainView({
    super.key,
    required this.requestId,
  });

  @override
  State<ComplainView> createState() => _ComplainViewState();
}

class _ComplainViewState extends State<ComplainView> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SubmitComplainCubit(),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 120,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    S.of(context).complainTitle,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          kPrimaryColor.withOpacity(0.9),
                          kPrimaryColor.withOpacity(0.7),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),
                pinned: true,
                elevation: 4,
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: BlocBuilder<GetComplaintsCubit, GetComplaintsState>(
                    builder: (context, getState) {
                      if (getState is GetComplaintsLoading) {
                        return _buildShimmerLoading();
                      }

                      return BlocConsumer<SubmitComplainCubit,
                          SubmitComplainState>(
                        listener: (context, submitState) {
                          if (submitState is SubmitComplainSuccess) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(S
                                    .of(context)
                                    .complaintSubmittedSuccessfully),
                                backgroundColor: Colors.green,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
                            BlocProvider.of<GetComplaintsCubit>(context)
                                .getComplaints(id: widget.requestId);
                            Navigator.pop(context);
                          } else if (submitState is SubmitComplainFailure) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(submitState.error),
                                backgroundColor: Colors.red,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
                          }
                        },
                        builder: (context, submitState) {
                          return Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Header
                                Text(
                                  S.of(context).submitYourComplaint,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  S.of(context).weWillReviewYourComplaintPrompt,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 32),

                                // Subject Field
                                Text(
                                  S.of(context).subjectFieldLabel,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[800],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _subjectController,
                                  decoration: InputDecoration(
                                    hintText: S.of(context).subjectFieldHint,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: Colors.grey[300]!,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: Colors.grey[300]!,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: kPrimaryColor,
                                        width: 2,
                                      ),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    prefixIcon: const Icon(
                                      Icons.title,
                                      color: kPrimaryColor,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 14,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return S
                                          .of(context)
                                          .subjectValidationError;
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 24),

                                // Description Field
                                Text(
                                  S.of(context).descriptionFieldLabel,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[800],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _descriptionController,
                                  decoration: InputDecoration(
                                    hintText:
                                        S.of(context).descriptionFieldHint,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: Colors.grey[300]!,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: Colors.grey[300]!,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: kPrimaryColor,
                                        width: 2,
                                      ),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    alignLabelWithHint: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 16,
                                    ),
                                  ),
                                  maxLines: 6,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return S
                                          .of(context)
                                          .descriptionValidationEmptyError;
                                    }
                                    if (value.length < 10) {
                                      return S
                                          .of(context)
                                          .descriptionValidationLengthError;
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 32),

                                // Submit Button with Shimmer Loading
                                if (submitState is SubmitComplainLoading)
                                  _buildShimmerButton()
                                else
                                  SizedBox(
                                    width: double.infinity,
                                    height: 52,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          context
                                              .read<SubmitComplainCubit>()
                                              .submitComplain(
                                                requestId: widget.requestId,
                                                subject:
                                                    _subjectController.text,
                                                description:
                                                    _descriptionController.text,
                                              );
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: kPrimaryColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        elevation: 2,
                                      ),
                                      child: Text(
                                        S.of(context).submitButtonLabel,
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
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Shimmer
          Container(
            width: 200,
            height: 24,
            color: Colors.white,
            margin: const EdgeInsets.only(bottom: 8),
          ),
          Container(
            width: double.infinity,
            height: 16,
            color: Colors.white,
            margin: const EdgeInsets.only(bottom: 32),
          ),

          // Subject Field Shimmer
          Container(
            width: 80,
            height: 16,
            color: Colors.white,
            margin: const EdgeInsets.only(bottom: 8),
          ),
          Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.only(bottom: 24),
          ),

          // Description Field Shimmer
          Container(
            width: 100,
            height: 16,
            color: Colors.white,
            margin: const EdgeInsets.only(bottom: 8),
          ),
          Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.only(bottom: 32),
          ),

          // Submit Button Shimmer
          Container(
            width: double.infinity,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerButton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: double.infinity,
        height: 52,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
