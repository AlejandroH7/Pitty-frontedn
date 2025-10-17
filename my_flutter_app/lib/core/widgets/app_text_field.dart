import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    this.keyboardType,
    this.validator,
    this.maxLength,
    this.textInputAction,
    this.enabled = true,
  });

  final TextEditingController controller;
  final String label;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;
  final TextInputAction? textInputAction;
  final int? maxLength;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      textInputAction: textInputAction,
      maxLength: maxLength,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        counterText: '',
      ),
    );
  }
}
