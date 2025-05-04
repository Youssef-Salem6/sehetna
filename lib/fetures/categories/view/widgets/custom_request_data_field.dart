import 'package:flutter/material.dart';
import 'package:sehetna/const.dart';

class CustomRequestDataField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final int max; // Add this

  const CustomRequestDataField({
    super.key,
    required this.hint,
    required this.controller,
    required this.validator,
    required this.keyboardType,
    required this.max, // Add this
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        maxLines: max,
        validator: validator,
        controller: controller,
        keyboardType: keyboardType, // Add this
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: kSecondaryColor.withOpacity(0.7),
            fontSize: 14,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(12),
          ),
          fillColor: Colors.white,
          filled: true,
        ),
      ),
    );
  }
}
