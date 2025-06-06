import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.prefixIcon,
  });

  final TextEditingController controller;
  final String label;
  final Icon? prefixIcon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          prefixIcon: prefixIcon,
        ),
        validator:
            (value) =>
                value == null || value.isEmpty
                    ? 'Ce champ est obligatoire'
                    : null,
      ),
    );
  }
}
