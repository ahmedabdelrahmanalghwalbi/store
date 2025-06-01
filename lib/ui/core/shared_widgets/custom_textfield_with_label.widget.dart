import 'package:flutter/material.dart';
import '../themes/app_theme.dart';

class CustomTextFieldColumn extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String hintText;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final double spacing;
  final TextStyle? labelStyle;
  final bool? isPassword;

  const CustomTextFieldColumn({
    super.key,
    required this.label,
    required this.controller,
    required this.validator,
    required this.hintText,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.spacing = 8.0,
    this.labelStyle,
    this.isPassword,
  });

  @override
  State<CustomTextFieldColumn> createState() => _CustomTextFieldColumnState();
}

class _CustomTextFieldColumnState extends State<CustomTextFieldColumn> {
  bool _isObscured = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: widget.mainAxisAlignment,
      crossAxisAlignment: widget.crossAxisAlignment,
      spacing: widget.spacing,
      children: [
        Text(
          widget.label,
          style:
              widget.labelStyle ??
              TextStyle(
                color: Color(0xff000000),
                fontSize: AppTheme.inputFontSize,
                fontWeight: FontWeight.w500,
              ),
        ),
        TextFormField(
          controller: widget.controller,
          obscureText: (widget.isPassword == true) ? _isObscured : false,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            hintText: widget.hintText,
            suffixIcon:
                (widget.isPassword == true)
                    ? IconButton(
                      icon: Icon(
                        _isObscured ? Icons.visibility_off : Icons.visibility,
                        color: Color(0xffBDBDBD),
                        size: 16.0,
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscured = !_isObscured;
                        });
                      },
                    )
                    : null,
          ),
          validator: widget.validator,
        ),
      ],
    );
  }
}
