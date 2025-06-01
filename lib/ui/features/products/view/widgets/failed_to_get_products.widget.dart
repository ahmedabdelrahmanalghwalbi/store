import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../utils/constants_utils/app_strings.constants.dart';
import '../../../../core/shared_widgets/custom_action_button.widget.dart';
import '../../../../core/themes/app_theme.dart';

class FailedToGetProductsWidget extends StatelessWidget {
  final String? errorString;
  final VoidCallback retry;
  const FailedToGetProductsWidget({
    super.key,
    required this.errorString,
    required this.retry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        spacing: 24.0,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(errorString ?? AppStrings.loadProductsFailed.tr()),
          CustomActionButtonWidget(
            isPrimary: true,
            text: AppStrings.retry.tr(),
            backgroundColor: AppTheme.primaryColor,
            width: 200.0,
            onPressed: retry,
          ),
        ],
      ),
    );
  }
}
