import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sehetna/const.dart';
import 'package:sehetna/fetures/appointments/view/complain_view.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sehetna/fetures/appointments/manager/getComplanits/get_complaints_cubit.dart';
import 'package:sehetna/fetures/appointments/models/complain_model.dart';
import 'package:sehetna/generated/l10n.dart';

class ComplainReviewView extends StatefulWidget {
  final String id;
  const ComplainReviewView({super.key, required this.id});

  @override
  State<ComplainReviewView> createState() => _ComplainReviewViewState();
}

class _ComplainReviewViewState extends State<ComplainReviewView> {
  @override
  void initState() {
    BlocProvider.of<GetComplaintsCubit>(context).getComplaints(id: widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GetComplaintsCubit, GetComplaintsState>(
      listener: (context, state) {
        if (state is GetComplaintsFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is GetComplaintsLoading) {
          return _buildShimmerLoading(context);
        }

        var cubit = BlocProvider.of<GetComplaintsCubit>(context);
        return Scaffold(
          backgroundColor: Colors.grey[50],
          floatingActionButton: FloatingActionButton(
            backgroundColor: kPrimaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ComplainView(requestId: widget.id),
                ),
              );
            },
            child: const Icon(Icons.add, color: Colors.white, size: 28),
          ),
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 120,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      S.of(context).complaintsTitle,
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
                if (cubit.complaints.isEmpty)
                  SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inbox_outlined,
                            size: 60,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            S.of(context).noComplaintsTitle,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            S.of(context).addComplaintPrompt,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final complaint = ComplainModel.fromjson(
                            json: cubit.complaints[index]);
                        return _buildComplaintCard(complaint, context);
                      },
                      childCount: cubit.complaints.length,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildShimmerLoading(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                S.of(context).complaintsTitle,
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
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    height: 180,
                  ),
                );
              },
              childCount: 3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComplaintCard(ComplainModel complaint, BuildContext context) {
    final isResolved = complaint.status?.toLowerCase() == 'resolved';
    final isPending = complaint.status?.toLowerCase() == 'pending';

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 12,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with date and status
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(complaint.status).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isResolved
                            ? Icons.check_circle
                            : isPending
                                ? Icons.access_time
                                : Icons.info,
                        size: 16,
                        color: _getStatusColor(complaint.status),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _getLocalizedStatus(complaint.status),
                        style: TextStyle(
                          color: _getStatusColor(complaint.status),
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  DateFormat("MMM dd, yyyy - hh:mm a")
                      .format(DateTime.parse(complaint.createdAt!)),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          // Subject
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text(
              complaint.subject ?? S.of(context).noSubjectText,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
          ),
          // Description
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Text(
              complaint.description ?? S.of(context).noDescriptionText,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 14,
              ),
            ),
          ),
          // Response section
          Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey[200]!,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.message,
                        size: 18,
                        color: kPrimaryColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        S.of(context).responseTitle,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  child: Text(
                    complaint.response?.isNotEmpty == true
                        ? complaint.response!
                        : S.of(context).noResponseText,
                    style: TextStyle(
                      color: complaint.response?.isNotEmpty == true
                          ? Colors.grey[700]
                          : Colors.grey[500],
                      fontSize: 14,
                      fontStyle: complaint.response?.isNotEmpty == true
                          ? FontStyle.normal
                          : FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'resolved':
        return Colors.green;
      case 'closed':
        return Colors.red;
      case 'open':
        return Colors.orange;
      case "in progress":
        return Colors.blueAccent;
      default:
        return const Color(0xFF3599C5);
    }
  }

  String _getLocalizedStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'resolved':
        return S.of(context).statusResolved;
      case 'closed':
        return S.of(context).statusClosed;
      case 'open':
        return S.of(context).statusOpen;
      case "in progress":
        return S.of(context).statusInProgress;
      default:
        return S.of(context).statusPending;
    }
  }
}
