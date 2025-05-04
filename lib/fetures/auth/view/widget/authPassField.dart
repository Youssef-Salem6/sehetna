import 'package:flutter/material.dart';
import 'package:sehetna/const.dart';

// ignore: must_be_immutable
class AuthPassField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType type;
  final String? Function(String?)? validator;

  AuthPassField({
    super.key,
    required this.controller,
    required this.hint,
    required this.type,
    required this.validator,
  });

  @override
  State<AuthPassField> createState() => _AuthPassFieldState();
  bool hide = true;
}

class _AuthPassFieldState extends State<AuthPassField> {


  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: widget.validator,
      keyboardType: widget.type,
      style: const TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      obscureText: widget.hide,
      controller: widget.controller,
      decoration: InputDecoration(
        fillColor: Colors.white.withOpacity(0.2),
        filled: true,
        suffixIconColor: Colors.white.withOpacity(0.8),
        suffixIcon: GestureDetector(
          onTap: () {
            setState(
              () {
                widget.hide = !widget.hide;
              },
            );
          },
          child: Icon(
            widget.hide ? Icons.visibility : Icons.visibility_off,
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
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
      ),
    );
  }
}
