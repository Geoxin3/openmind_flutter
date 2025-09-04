import 'package:flutter/material.dart';

class CustomTextformfield extends StatelessWidget {
  //constructors 
  final TextEditingController controller;
  final String labeltext;
  final String? validateText;
  final TextInputType? keyboard;
  final bool obscuretext;

  const CustomTextformfield({super.key,
  required this.controller,
  required this.labeltext,
  this.validateText,
  required this.obscuretext,
  this.keyboard});

  @override
  Widget build(BuildContext context) {
    return 
        TextFormField(controller: controller,
        obscureText: obscuretext,
        decoration: InputDecoration(labelText: labeltext),
        keyboardType: keyboard,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return validateText;
          }
          return null;
        },);

  }
}