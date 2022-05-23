import 'package:flutter/material.dart';
import 'package:pre_proyecto_universales/util/app_style.dart';

class InputText extends StatefulWidget {
  VoidCallback? onTap;
  bool obscureText;
  TextInputType keyboardType;
  Icon icon;
  bool? isDense;
  String labelText;
  String? helperText;
  TextEditingController? controller;
  String? Function(String?) validator;

  InputText(
      {Key? key,
      this.onTap,
      this.obscureText = false,
      required this.icon,
      this.isDense,
      required this.labelText,
      this.helperText,
      this.controller,
      required this.validator,
      required this.keyboardType})
      : super(key: key);

  @override
  State<InputText> createState() => _InputTextState();
}

class _InputTextState extends State<InputText> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      onTap: widget.onTap,
      obscureText: widget.obscureText,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        hintStyle: AppStyle.shared.fonts.inputText(context),
        labelStyle: AppStyle.shared.fonts.inputText(context),
        icon: widget.icon,
        labelText: widget.labelText,
        helperText: widget.helperText,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        isDense: widget.isDense,
        contentPadding: const EdgeInsets.all(10),
      ),
    );
  }
}
