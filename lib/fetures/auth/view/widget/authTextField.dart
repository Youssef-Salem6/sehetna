import 'package:flutter/material.dart';

class AuthTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType type;
  final String? Function(String?)? validator;
  final Color backColor;

  const AuthTextField(
      {super.key,
      required this.controller,
      required this.hint,
      required this.type,
      required this.validator,
      required this.backColor});

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: widget.validator,
      keyboardType: widget.type,
      style: const TextStyle(color: Colors.white),
      cursorColor: widget.backColor,
      controller: widget.controller,
      decoration: InputDecoration(
        fillColor: Colors.white.withOpacity(0.2),
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none),
        hintText: widget.hint,
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
      ),
    );
  }
}
