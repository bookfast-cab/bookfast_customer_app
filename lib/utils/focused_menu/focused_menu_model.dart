import 'package:flutter/material.dart';

class FocusedMenuItem {
  Color? backgroundColor;
  Widget title;
  Widget? trailingWidget;
  Widget? leadingWidget;
  Function onPressed;

  FocusedMenuItem(
      {this.backgroundColor,
      required this.title,
      this.trailingWidget,
      this.leadingWidget,
      required this.onPressed});
}
