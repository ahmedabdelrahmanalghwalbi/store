import 'package:flutter/material.dart';
import '../../../utils/app_logger.utils.dart';
import '../themes/app_theme.dart';

class CustomElevatedButton extends StatefulWidget {
  final Future<void> Function() onPressed;
  final String title;
  final ButtonStyle? buttonStyle;
  final Widget? titleWidget;
  final double? width;
  final double? height;
  final TextStyle? titleStyle;
  final double? radius;
  final Color? backgroundColor;
  final bool? isFuture;
  final bool? isPrimaryBackground;

  const CustomElevatedButton({
    super.key,
    required this.onPressed,
    required this.title,
    this.buttonStyle,
    this.titleWidget,
    this.titleStyle,
    this.backgroundColor,
    this.radius,
    this.width,
    this.height,
    this.isFuture = true,
    this.isPrimaryBackground = true,
  });

  @override
  CustomElevatedButtonState createState() => CustomElevatedButtonState();
}

class CustomElevatedButtonState extends State<CustomElevatedButton>
    with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  late AnimationController _controller;
  final int duration = 200;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: duration),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handlePressed() async {
    setState(() {
      _isLoading = true;
    });
    await _controller.forward();
    try {
      await widget.onPressed();
    } catch (err, t) {
      AppLogger.error(
        "📦 Error in animated loading button future",
        error: err,
        stackTrace: t,
      );
    }
    await _controller.reverse();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return AnimatedContainer(
          duration: Duration(milliseconds: duration),
          width: _isLoading ? 75.0 : (widget.width ?? 200.0),
          height: widget.height ?? 50.0,
          child: ElevatedButton(
            style:
                widget.buttonStyle ??
                ElevatedButton.styleFrom(
                  backgroundColor:
                      widget.backgroundColor ??
                      (widget.isPrimaryBackground == true
                          ? null
                          : AppTheme.primaryColor),
                  foregroundColor: Colors.white,
                  disabledForegroundColor: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      _isLoading ? 26.0 : (widget.radius ?? 28.0),
                    ),
                  ),
                ),
            onPressed:
                widget.isFuture == true
                    ? _isLoading
                        ? () {}
                        : _handlePressed
                    : widget.onPressed,
            child:
                widget.isFuture == true && _isLoading
                    ? const Center(
                      child: SizedBox(
                        width: 22.0,
                        height: 22.0,
                        child: CircularProgressIndicator.adaptive(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      ),
                    )
                    : widget.titleWidget ??
                        Text(
                          widget.title,
                          style:
                              widget.titleStyle ??
                              TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w600,
                                overflow: TextOverflow.ellipsis,
                                color: Colors.white,
                              ),
                          textAlign: TextAlign.center,
                        ),
          ),
        );
      },
    );
  }
}
