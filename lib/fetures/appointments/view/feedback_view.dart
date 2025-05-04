import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sehetna/const.dart';
import 'package:sehetna/fetures/appointments/manager/feedBack/feed_back_cubit.dart';
import 'package:sehetna/fetures/profile/view/widgets/Custom_app_bar.dart';
import 'package:sehetna/generated/l10n.dart';

class FeedbackView extends StatefulWidget {
  final String requestId;
  const FeedbackView({super.key, required this.requestId});

  @override
  State<FeedbackView> createState() => _FeedbackViewState();
}

class _FeedbackViewState extends State<FeedbackView> {
  double _rating = 3.0;
  final TextEditingController _feedbackController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    return BlocProvider(
      create: (context) => FeedBackCubit(),
      child: BlocConsumer<FeedBackCubit, FeedBackState>(
        listener: (context, state) {
          if (state is FeedBackSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          } else if (state is FeedBackFailure) {
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
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    CustomAppBar(title: S.of(context).feedBack),
                    Gap(size.height * 0.02),
                    // Rating Section
                    Center(
                      child: Text(
                        S.of(context).howWouldYouRateYourExperience,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Gap(10),
                    Center(
                      child: RatingBar.builder(
                        initialRating: _rating,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 50,
                        itemPadding: const EdgeInsets.symmetric(horizontal: 8),
                        itemBuilder: (context, index) {
                          switch (index) {
                            case 0:
                              return const Icon(
                                Icons.sentiment_very_dissatisfied,
                                color: Colors.red,
                              );
                            case 1:
                              return const Icon(
                                Icons.sentiment_dissatisfied,
                                color: Colors.redAccent,
                              );
                            case 2:
                              return const Icon(
                                Icons.sentiment_neutral,
                                color: Colors.amber,
                              );
                            case 3:
                              return const Icon(
                                Icons.sentiment_satisfied,
                                color: Colors.lightGreen,
                              );
                            case 4:
                              return const Icon(
                                Icons.sentiment_very_satisfied,
                                color: Colors.green,
                              );
                            default:
                              return const Icon(Icons.star);
                          }
                        },
                        onRatingUpdate: (rating) {
                          setState(() {
                            _rating = rating;
                          });
                        },
                      ),
                    ),
                    // Rating Label
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          _getRatingLabel(_rating),
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: _getRatingColor(_rating),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Gap(size.height * 0.05),
                    // Feedback Form
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            S.of(context).shareYourFeedback,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Gap(10),
                          TextFormField(
                            controller: _feedbackController,
                            maxLines: 5,
                            decoration: InputDecoration(
                              hintText: S.of(context).tellUsWhatYouThink,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return S.of(context).feedbackRequired;
                              }
                              return null;
                            },
                          ),
                          const Gap(20),
                          // Submit Button with Shimmer Effect
                          if (state is FeedBackLoading)
                            Shimmer.fromColors(
                              baseColor: kPrimaryColor.withOpacity(0.3),
                              highlightColor: kSecondaryColor.withOpacity(0.3),
                              child: Container(
                                width: double.infinity,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            )
                          else
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    BlocProvider.of<FeedBackCubit>(context)
                                        .submitFeedBack(
                                      rating: _rating.toString(),
                                      feedback: _feedbackController.text,
                                      requestId: widget.requestId,
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: kPrimaryColor,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  S.of(context).submitFeedback,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _getRatingLabel(double rating) {
    if (rating >= 4.5) return S.of(context).excellent;
    if (rating >= 3.5) return S.of(context).good;
    if (rating >= 2.5) return S.of(context).average;
    if (rating >= 1.5) return S.of(context).poor;
    return S.of(context).veryPoor;
  }

  Color _getRatingColor(double rating) {
    if (rating >= 4.5) return Colors.green;
    if (rating >= 3.5) return Colors.lightGreen;
    if (rating >= 2.5) return Colors.amber;
    if (rating >= 1.5) return Colors.redAccent;
    return Colors.red;
  }
}
