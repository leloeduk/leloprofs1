import 'package:flutter/material.dart';

class CustomWrapSelected extends StatefulWidget {
  final List<String> childrenList;
  final ValueChanged<List<String>> onSelected;
  final List<String>? initialSelected;

  const CustomWrapSelected({
    super.key,
    required this.childrenList,
    required this.onSelected,
    this.initialSelected,
  });

  @override
  State<CustomWrapSelected> createState() => _CustomWrapSelectedState();
}

class _CustomWrapSelectedState extends State<CustomWrapSelected> {
  late Set<String> _selectedItems;

  @override
  void initState() {
    super.initState();
    _selectedItems = Set<String>.from(widget.initialSelected ?? []);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children:
          widget.childrenList.map((item) {
            final bool isSelected = _selectedItems.contains(item);
            return FilterChip(
              label: Text(
                item,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              selected: isSelected,
              backgroundColor: Colors.grey.shade200,
              selectedColor: Colors.red.shade400,
              checkmarkColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color:
                      isSelected ? Colors.red.shade400 : Colors.grey.shade400,
                  width: 1.2,
                ),
              ),
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedItems.add(item);
                  } else {
                    _selectedItems.remove(item);
                  }
                  widget.onSelected(_selectedItems.toList());
                });
              },
            );
          }).toList(),
    );
  }
}
