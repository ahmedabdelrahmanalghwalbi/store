import 'package:flutter/material.dart';
import '../themes/app_theme.dart';

class GeneralAppbarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final bool? showBackArrowButton;
  const GeneralAppbarWidget({
    super.key,
    required this.title,
    this.showBackArrowButton,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 17.0,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      backgroundColor: AppTheme.primaryColor,
      centerTitle: true,
      leading: showBackArrowButton == true ? null : const SizedBox.shrink(),
      iconTheme: const IconThemeData(color: Colors.white),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
