import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../utils/constants_utils/app_strings.constants.dart';
import '../themes/app_theme.dart';

class PoweredByStoreWidget extends StatelessWidget {
  const PoweredByStoreWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      AppStrings.poweredByStore.tr(),
      style: TextStyle(
        color: AppTheme.primaryColor,
        fontWeight: FontWeight.w400,
        fontSize: 10.0,
      ),
      textAlign: TextAlign.center,
      maxLines: 1,
    );
  }
}
