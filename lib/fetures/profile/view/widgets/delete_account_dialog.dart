import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sehetna/fetures/auth/view/login_view.dart';
import 'package:sehetna/fetures/profile/manager/deleteAccount/delete_account_cubit.dart';
import 'package:sehetna/generated/l10n.dart';
import 'package:sehetna/main.dart';

class DeleteAccountDialog extends StatefulWidget {
  const DeleteAccountDialog({super.key});

  @override
  State<DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<DeleteAccountDialog> {
  final TextEditingController _confirmationController = TextEditingController();
  bool _isConfirmationValid = false;
  final String _confirmationText = "confirm"; // The text user needs to type

  @override
  void initState() {
    super.initState();
    _confirmationController.addListener(_checkConfirmation);
  }

  void _checkConfirmation() {
    setState(() {
      _isConfirmationValid = _confirmationController.text.toLowerCase() ==
          _confirmationText.toLowerCase();
    });
  }

  @override
  void dispose() {
    _confirmationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DeleteAccountCubit(),
      child: BlocConsumer<DeleteAccountCubit, DeleteAccountState>(
        listener: (context, state) {
          if (state is DeleteAccountSuccess) {
            pref.clear();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginView(),
              ),
              (route) => false,
            );
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Account deleted successfully"),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is DeleteAccountFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          return AlertDialog(
            title: Text(
              S.of(context).deleteAccount,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).deleteDialog,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                    children: [
                      const TextSpan(text: "Type "),
                      TextSpan(
                        text: '"$_confirmationText"',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      const TextSpan(text: " to confirm:"),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _confirmationController,
                  decoration: InputDecoration(
                    hintText: "Type $_confirmationText here...",
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: _isConfirmationValid ? Colors.green : Colors.red,
                        width: 2,
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    // The listener will handle the state update
                  },
                ),
                if (_confirmationController.text.isNotEmpty &&
                    !_isConfirmationValid)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      "Text doesn't match. Please type exactly: $_confirmationText",
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  S.of(context).no,
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
              ElevatedButton(
                onPressed: _isConfirmationValid &&
                        state is! DeleteAccountLoading
                    ? () {
                        BlocProvider.of<DeleteAccountCubit>(context)
                            .deleteAccount();
                      }
                    : null, // Disabled when confirmation is invalid or loading
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _isConfirmationValid ? Colors.red : Colors.grey,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey.shade300,
                  disabledForegroundColor: Colors.grey.shade600,
                ),
                child: state is DeleteAccountLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(S.of(context).yes),
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          );
        },
      ),
    );
  }
}

// Example of how to use this dialog:
// 
// Future<void> showDeleteDialog(BuildContext context) async {
//   final bool? result = await showDialog<bool>(
//     context: context,
//     builder: (BuildContext context) {
//       return const DeleteAccountDialog();
//     },
//   );
//   
//   if (result == true) {
//     // User confirmed deletion
//     // Add your account deletion logic here
//   }
// }