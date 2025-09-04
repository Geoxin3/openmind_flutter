import 'package:flutter/material.dart';

class MultiSelectDialog extends StatefulWidget {
  final List<String> items;
  final List<String> initiallySelected;

  const MultiSelectDialog({super.key, required this.items, required this.initiallySelected});

  @override
  MultiSelectDialogState createState() => MultiSelectDialogState();
}

class MultiSelectDialogState extends State<MultiSelectDialog> {
  late List<String> selectedItems;

  @override
  void initState() {
    super.initState();
    selectedItems = List.from(widget.initiallySelected);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Specializations'),
      content: SingleChildScrollView(
        child: Column(
          children: widget.items.map((item) {
            return CheckboxListTile(
              title: Text(item),
              value: selectedItems.contains(item),
              onChanged: (bool? value) {
                setState(() {
                  if (value == true) {
                    selectedItems.add(item);
                  } else {
                    selectedItems.remove(item);
                  }
                });
              },
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close dialog without saving
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(selectedItems); // Return selected items
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
