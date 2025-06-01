import 'package:flutter/material.dart';
import 'animations/custom_rect_tween.dart';
import 'animations/hero_dialog_route.dart';

class CustomAnimatedPopup extends StatelessWidget {
  final String popupKey;
  final Widget shrinkedWidget;
  final Widget expandedWidget;
  final ShapeBorder? shapeBorder;
  final BorderRadius? borderRadius;
  final Color? color;
  final String? tooltip;
  final bool? isScrollable;
  final Axis? scrollDirection;
  final double? popupMarginFromScreen;
  final bool dismissible;
  final VoidCallback? onDismiss;

  const CustomAnimatedPopup({
    required this.popupKey,
    required this.expandedWidget,
    required this.shrinkedWidget,
    this.popupMarginFromScreen = 8.0,
    super.key,
    this.shapeBorder,
    this.color,
    this.isScrollable,
    this.tooltip,
    this.borderRadius,
    this.scrollDirection,
    this.dismissible = true,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip ?? '',
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            HeroDialogRoute(
              builder:
                  (context) => PopScope(
                    canPop: dismissible,
                    onPopInvokedWithResult: (didPop, result) {
                      if (didPop && onDismiss != null) {
                        onDismiss!();
                      }
                    },
                    child: GestureDetector(
                      onTap:
                          dismissible
                              ? () {
                                if (onDismiss != null) onDismiss!();
                                Navigator.of(context).pop();
                              }
                              : null,
                      behavior: HitTestBehavior.opaque,
                      child: Center(
                        child: Hero(
                          tag: popupKey,
                          createRectTween: (begin, end) {
                            return CustomRectTween(begin: begin!, end: end!);
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: popupMarginFromScreen ?? 8.0,
                            ),
                            child: Material(
                              borderRadius: borderRadius,
                              color: color,
                              shape: shapeBorder,
                              child:
                                  isScrollable == true
                                      ? SingleChildScrollView(
                                        scrollDirection:
                                            scrollDirection ?? Axis.vertical,
                                        child: expandedWidget,
                                      )
                                      : expandedWidget,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
            ),
          );
        },
        child: Hero(
          createRectTween: (begin, end) {
            return CustomRectTween(begin: begin!, end: end!);
          },
          tag: popupKey,
          child: Material(
            borderRadius: borderRadius,
            color: color,
            shape: shapeBorder,
            child: shrinkedWidget,
          ),
        ),
      ),
    );
  }
}
