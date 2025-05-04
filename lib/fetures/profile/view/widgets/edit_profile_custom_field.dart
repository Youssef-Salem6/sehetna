import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditProfileCustomField extends StatelessWidget {
  final TextEditingController controller;
  final String title;
  final bool isReadOnly;

  const EditProfileCustomField({
    super.key,
    required this.controller,
    required this.title,
    this.isReadOnly = false,
  });

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      controller.text = DateFormat('dd/MM/yyyy').format(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isReadOnly ? Colors.black.withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.black.withOpacity(0.4),
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
            TextFormField(
              controller: controller,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 8),
              ),
              readOnly: isReadOnly, // Always read-only for date fields
            ),
          ],
        ),
      ),
    );
  }
}
