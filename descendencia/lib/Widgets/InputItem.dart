import 'package:flutter/material.dart';

class InputItem extends StatefulWidget {
  const InputItem(
      {super.key,
      required this.controller,
      this.labelText,
      this.hintText,
      this.validator,
      this.icon,
      this.obscureText = false,
      this.suffixIcon});

  final TextEditingController controller;
  final String? labelText;
  final String? hintText;
  final Icon? icon;
  final bool obscureText;
  final Widget? suffixIcon;

  final String? Function(String?)? validator;

  @override
  State<InputItem> createState() => _InputItemState();
}

class _InputItemState extends State<InputItem> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: widget.validator,
      obscureText: widget.obscureText,
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        icon: widget.icon,
        suffixIcon: widget.suffixIcon,
      ),
    );
  }
}
