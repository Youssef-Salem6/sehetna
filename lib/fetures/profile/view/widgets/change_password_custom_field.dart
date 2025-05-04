import 'package:flutter/material.dart';
import 'package:sehetna/const.dart';

// ignore: must_be_immutable
class ChangePasswordCustomField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType type;
  final String? Function(String?)? validator;
  const ChangePasswordCustomField({
    super.key,
    required this.controller,
    required this.hint,
    required this.type,
    required this.validator,
  });

  @override
  State<ChangePasswordCustomField> createState() =>
      _ChangePasswordCustomFieldState();
}

class _ChangePasswordCustomFieldState extends State<ChangePasswordCustomField> {
  bool hide = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: widget.validator,
      keyboardType: widget.type,
      obscureText: hide,
      controller: widget.controller,
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        suffixIcon: GestureDetector(
          onTap: () {
            setState(
              () {
                hide = !hide;
              },
            );
          },
          child: Icon(
            hide ? Icons.visibility : Icons.visibility_off,
            color: kPrimaryColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(8),
        ),
        hintText: widget.hint,
        hintStyle: const TextStyle(color: kSecondaryColor),
      ),
    );
  }
}
