import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/gradient_borders.dart';

class CustomActionButtonWidget extends StatelessWidget {
  final String text;
  final Color? textColor;
  final VoidCallback onPressed;
  final bool isPrimary;
  final Color backgroundColor;
  final double? width;
  final double? height;
  final double borderRadius;
  final bool? isGredient;

  /// only requried when isGredient is [true]
  final List<Color>? gredientColors;

  const CustomActionButtonWidget({
    super.key,
    required this.text,
    this.textColor,
    required this.onPressed,
    required this.backgroundColor,
    this.isPrimary = true,
    this.width,
    this.height,
    this.isGredient,
    this.gredientColors,
    this.borderRadius = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    bool isGredientCheck =
        (isGredient == true) && ((gredientColors?.length ?? 0) >= 2);
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border:
            isGredientCheck && !isPrimary
                ? GradientBoxBorder(
                  gradient: LinearGradient(colors: gredientColors!),
                  width: 0.5,
                )
                : null,
        gradient:
            isGredientCheck && isPrimary
                ? LinearGradient(colors: gredientColors!)
                : null,
        color: isPrimary ? null : Colors.white,
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          elevation: WidgetStateProperty.all(0),
          shadowColor: WidgetStateProperty.all(Colors.transparent),
          backgroundColor: WidgetStateProperty.all(
            (isGredientCheck && isPrimary || isPrimary != true)
                ? Colors.transparent
                : backgroundColor,
          ),
          foregroundColor: WidgetStateProperty.all(
            isPrimary ? Colors.white : backgroundColor,
          ),
          side: WidgetStateProperty.all(
            isPrimary || (isPrimary != true && isGredient == true)
                ? BorderSide.none
                : BorderSide(color: backgroundColor),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
        ),
        child: Center(
          child: AutoSizeText(
            text,
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
              color:
                  textColor ??
                  (isPrimary
                      ? Colors.white
                      : isGredientCheck
                      ? gredientColors!.first
                      : backgroundColor),
            ),
          ),
        ),
      ),
    );
  }
}
