import 'package:flutter/material.dart';

class CustomWrapSelected extends StatefulWidget {
  final List<String> childrenList;

  const CustomWrapSelected({super.key, required this.childrenList});

  @override
  State<CustomWrapSelected> createState() => _CustomWrapSelectedState();
}

class _CustomWrapSelectedState extends State<CustomWrapSelected> {
  final Set<String> _selectedItems = {};

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children:
          widget.childrenList.map((subject) {
            return FilterChip(
              label: Text(subject),
              selected: _selectedItems.contains(subject),
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedItems.add(subject);
                  } else {
                    _selectedItems.remove(subject);
                  }
                });
              },
            );
          }).toList(),
    );
  }
}
