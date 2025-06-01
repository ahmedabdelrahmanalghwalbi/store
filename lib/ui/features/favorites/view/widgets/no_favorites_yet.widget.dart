import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../utils/constants_utils/app_strings.constants.dart';
import '../../../../core/shared_widgets/custom_action_button.widget.dart';
import '../../../../core/themes/app_theme.dart';

class NoFavoritesYetWidget extends StatelessWidget {
  final String? error;
  final VoidCallback refresh;
  const NoFavoritesYetWidget({
    super.key,
    required this.error,
    required this.refresh,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite, size: 64),
          Text(
            error ?? AppStrings.noFavorites.tr(),
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18.0),
          ),
          if (error?.isNotEmpty ?? false)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: CustomActionButtonWidget(
                isPrimary: true,
                text: AppStrings.retry.tr(),
                backgroundColor: AppTheme.primaryColor,
                width: 200.0,
                onPressed: refresh,
              ),
            ),
        ],
      ),
    );
  }
}
