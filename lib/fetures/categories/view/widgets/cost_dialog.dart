import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sehetna/fetures/appointments/manager/appointmentDetails/appointment_details_cubit.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sehetna/const.dart';
import 'package:sehetna/fetures/appointments/manager/addServiceToRequest/add_service_to_request_cubit.dart';
import 'package:sehetna/fetures/categories/manager/servicesList/services_list_cubit.dart';
import 'package:sehetna/fetures/categories/view/request_data_view.dart';

class CostDialog extends StatefulWidget {
  final bool isFromHome;
  final String requestId;

  const CostDialog({
    super.key,
    required this.isFromHome,
    required this.requestId,
  });

  @override
  State<CostDialog> createState() => _CostDialogState();
}

class _CostDialogState extends State<CostDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isClosing = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _closeDialog({bool success = false}) {
    if (_isClosing) return;
    setState(() {
      _isClosing = true;
    });

    _animationController.reverse().then((_) {
      Navigator.pop(context);
      if (success) {
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppointmentDetailsCubit, AppointmentDetailsState>(
      builder: (context, state) {
        return BlocBuilder<ServicesListCubit, ServicesListState>(
          builder: (context, state) {
            return BlocProvider(
              create: (context) => AddServiceToRequistCubit(),
              child: BlocConsumer<AddServiceToRequistCubit,
                  AddServiceToRequistState>(
                listener: (context, state) {
                  if (state is AddServiceToRequistFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.errorMessage),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } else if (state is AddServiceToRequistSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: kPrimaryColor,
                      ),
                    );
                    BlocProvider.of<AppointmentDetailsCubit>(context)
                        .getRequestDetails(id: widget.requestId);
                    _closeDialog(success: true);
                  }
                },
                builder: (context, state) {
                  final bool isLoading = state is AddServiceToRequistLoading;

                  return ScaleTransition(
                    scale: _scaleAnimation,
                    child: Dialog(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      child: Container(
                        width: 300,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Theme.of(context).dialogBackgroundColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Header
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.monetization_on_outlined,
                                    color: kPrimaryColor,
                                    size: 28,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Payment Confirmation',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: kPrimaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(height: 20),
                            // Cost display
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Column(
                                children: [
                                  const Text(
                                    'Total Cost',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  isLoading
                                      ? _buildShimmerCost(context)
                                      : Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 24,
                                            vertical: 12,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primaryContainer,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            BlocProvider.of<ServicesListCubit>(
                                                    context)
                                                .cost
                                                .toString(),
                                            style: const TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: kSecondaryColor,
                                            ),
                                          ),
                                        ),
                                  const SizedBox(height: 20),
                                  const Text(
                                    'Do you want to proceed with this Cost?',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Buttons
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // Cancel button
                                ElevatedButton.icon(
                                  onPressed:
                                      isLoading ? null : () => _closeDialog(),
                                  icon: const Icon(Icons.close),
                                  label: const Text('Cancel'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey.shade200,
                                    foregroundColor: Colors.black87,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    disabledBackgroundColor:
                                        Colors.grey.shade100,
                                    disabledForegroundColor: Colors.grey,
                                  ),
                                ),

                                // Confirm button
                                ElevatedButton.icon(
                                  onPressed: isLoading
                                      ? null
                                      : () {
                                          if (widget.isFromHome) {
                                            // _closeDialog(); // This closes the dialog
                                            Navigator.push(
                                              // This pushes a new page
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => RequestDataView(
                                                    selectedServices: BlocProvider
                                                            .of<ServicesListCubit>(
                                                                context)
                                                        .selectedServices,
                                                    requirements: const []),
                                              ),
                                            );
                                          } else {
                                            BlocProvider.of<
                                                        AddServiceToRequistCubit>(
                                                    context)
                                                .addServiceToRequist(
                                                    requestId: widget.requestId,
                                                    selectedServices: BlocProvider
                                                            .of<ServicesListCubit>(
                                                                context)
                                                        .selectedServices);
                                          }
                                        },
                                  icon: isLoading
                                      ? const SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Icon(Icons.check),
                                  label: Text(
                                    isLoading ? 'Processing...' : 'Confirm',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: kPrimaryColor,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    disabledBackgroundColor:
                                        kPrimaryColor.withOpacity(0.6),
                                    disabledForegroundColor: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildShimmerCost(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: 150,
        height: 50,
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
