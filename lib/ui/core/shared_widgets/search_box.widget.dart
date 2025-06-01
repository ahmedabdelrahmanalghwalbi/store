import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../themes/app_theme.dart';

class SearchBoxWidget extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final double radius;
  final Color? backgroundColor;
  final TextStyle textStyle;
  final Color borderColor;
  final double height;
  final double borderSize;
  final bool isEnabled;
  final FocusNode? focusNode;
  final bool? isLoading;
  final bool? showSearchField;
  final String? hintText;
  final TextEditingController? controller;
  const SearchBoxWidget({
    super.key,
    required this.onChanged,
    this.radius = 12.0,
    this.borderSize = 1.0,
    this.backgroundColor,
    required this.textStyle,
    required this.borderColor,
    required this.height,
    this.isEnabled = true,
    this.focusNode,
    this.isLoading,
    this.showSearchField,
    this.hintText,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final fieldBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: BorderSide(color: borderColor, width: borderSize),
    );
    final InputDecoration primaryTextFieldDecoration = InputDecoration(
      labelStyle: TextStyle(color: Colors.black),
      filled: true,
      fillColor: backgroundColor ?? Color(0xffEEEEEE),
      contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
      isDense: false,
      hintText: hintText ?? "Search for tankers",
      hintStyle: textStyle,
      prefixIcon: Icon(Icons.search, size: 16.0, color: Color(0xff757575)),
      border: fieldBorder,
      enabledBorder: fieldBorder,
      focusedBorder: fieldBorder,
      disabledBorder: fieldBorder,
      prefixIconConstraints: BoxConstraints(minWidth: 30),
    );
    if (isLoading == true) {
      return SearchBoxShimmer(
        radius: radius,
        color: backgroundColor ?? Color(0xffEEEEEE),
        height: height,
      );
    }
    if (showSearchField == false) return const SizedBox.shrink();
    return SizedBox(
      height: height,
      child: TextFormField(
        focusNode: focusNode,
        onChanged: onChanged,
        decoration: primaryTextFieldDecoration,
        style: textStyle,
        enabled: isEnabled,
        controller: controller,
      ),
    );
  }
}

class SearchBoxShimmer extends StatelessWidget {
  final double radius;
  final Color color;
  final double height;

  const SearchBoxShimmer({
    super.key,
    this.radius = 12.0,
    required this.color,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppTheme.shimmerBaseColor,
      highlightColor: AppTheme.shimmerHighlightColor,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: Colors.grey, width: 1.0),
        ),
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Icon(Icons.search, size: 16.0, color: Colors.grey.shade400),
            SizedBox(width: 8),
            Expanded(child: Container(height: 16.0, color: color)),
          ],
        ),
      ),
    );
  }
}
