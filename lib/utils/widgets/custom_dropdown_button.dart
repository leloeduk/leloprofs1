import 'package:flutter/material.dart';

class CustomDropdownButton extends StatefulWidget {
  final String title;
  final List<String> listes;
  final String? selectedItem;
  final ValueChanged<String?> onChanged;

  const CustomDropdownButton({
    super.key,
    required this.title,
    required this.listes,
    this.selectedItem,
    required this.onChanged,
  });

  @override
  State<CustomDropdownButton> createState() => _CustomDropdownButtonState();
}

class _CustomDropdownButtonState extends State<CustomDropdownButton> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: widget.title,
        border: const OutlineInputBorder(),
      ),
      value: widget.selectedItem,
      items:
          widget.listes
              .map((item) => DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
      onChanged: widget.onChanged,
    );
  }
}
