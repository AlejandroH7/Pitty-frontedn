import 'package:flutter/material.dart';

void showAppSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}

const EdgeInsets kPagePadding = EdgeInsets.all(24);
const EdgeInsets kSectionPadding = EdgeInsets.symmetric(vertical: 16);
