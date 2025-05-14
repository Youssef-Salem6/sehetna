import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sehetna/constants/apis.dart';
import 'package:sehetna/fetures/appointments/models/feedback_model.dart';
import 'package:sehetna/fetures/profile/view/widgets/Custom_app_bar.dart';
import 'package:sehetna/generated/l10n.dart';

class FeedbackReviewView extends StatefulWidget {
  final FeedbackModel feedbackModel;
  const FeedbackReviewView({super.key, required this.feedbackModel});

  @override
  State<FeedbackReviewView> createState() => _FeedbackReviewViewState();
}

class _FeedbackReviewViewState extends State<FeedbackReviewView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: SafeArea(
          child: Column(
            children: [
              CustomAppBar(title: S.of(context).myFeedback),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildUserCard(),
                      const SizedBox(height: 24),
                      _buildFeedbackCard(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: widget.feedbackModel.userImage != null
                  ? NetworkImage(
                      "$imagesBaseUrl/${widget.feedbackModel.userImage}")
                  : const AssetImage('assets/default_avatar.png')
                      as ImageProvider,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.feedbackModel.userName ?? 'Anonymous User',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatDate(widget.feedbackModel.createdAt),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedbackCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Your Feedback',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _buildStarRating(
                    double.tryParse(widget.feedbackModel.rating ?? '0') ?? 0),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              widget.feedbackModel.comment ?? 'No comment provided',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[800],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            if (widget.feedbackModel.comment != null &&
                widget.feedbackModel.comment!.isNotEmpty)
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Thank you for your feedback!',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.grey[600],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStarRating(double rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating.round() ? Icons.star : Icons.star_border,
          color: _getRatingColor(rating),
          size: 28,
        );
      }),
    );
  }

  Color _getRatingColor(double rating) {
    if (rating >= 4) return Colors.green;
    if (rating >= 3) return Colors.orange;
    return Colors.red;
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'No date';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMMM d, y').format(date);
    } catch (e) {
      return dateString;
    }
  }
}
