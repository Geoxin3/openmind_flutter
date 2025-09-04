import 'package:flutter/material.dart';

class SearchField extends StatefulWidget {
  final Function(String)? onSearch;
  final String hintText;
  final TextEditingController? controller;
  final bool autofocus;

  const SearchField({
    super.key,
    this.onSearch,
    this.hintText = "Search...",
    this.controller,
    this.autofocus = false,
  });

  @override
  SearchFieldState createState() => SearchFieldState();
}

class SearchFieldState extends State<SearchField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onTextChanged() {
    if (widget.onSearch != null) {
      widget.onSearch!(_controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      autofocus: widget.autofocus,
      decoration: InputDecoration(
        hintText: widget.hintText,
        prefixIcon:const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      onChanged: (_) => _onTextChanged(),
    );
  }
}
