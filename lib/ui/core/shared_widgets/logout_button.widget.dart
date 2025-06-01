import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../../../../utils/constants_utils/app_assets.constants.dart';
import '../../../data/repositories/users.repository.dart';
import '../../../route/app_navigator.service.dart';
import '../../../utils/app_logger.utils.dart';
import '../../../utils/constants_utils/app_strings.constants.dart';
import '../themes/app_theme.dart';

class LogoutButtonWidget extends StatelessWidget {
  final double? buttonSize;
  final double? iconSize;
  final Color? backgroundColor;
  const LogoutButtonWidget({
    super.key,
    this.backgroundColor,
    this.iconSize,
    this.buttonSize,
  });
  static const double _logoutButtonSize = 40.0;
  static const double _logoutButtonIconSize = 24.0;
  static const String _logoutButtonIcon = AppAssets.homeLogoutIcon;
  static const Color _logoutButtonBackgroundColor = Color(0xffFEEBEE);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        bool isConfirmed = await AppNavigator.showConfirmMessage(
          title: AppStrings.areYouSure.tr(),
          message: AppStrings.actionCannotBeUndone.tr(),
          imageSvgAsset: AppAssets.homeLogoutIcon,
          confirmText: AppStrings.yes.tr(),
          denyText: AppStrings.no.tr(),
          confirmButtonColor: Colors.red,
          denyButtonColor: AppTheme.primaryColor,
        );
        if (isConfirmed && context.mounted) {
          try {
            AppLogger.info("🔄 Logging out user...");
            await (Provider.of<UsersRepository>(
              context,
              listen: false,
            ).logout());
          } catch (e, stackTrace) {
            AppLogger.error(
              "❌ Error during logout",
              error: e,
              stackTrace: stackTrace,
            );
          }
        }
      },
      child: Container(
        width: buttonSize ?? _logoutButtonSize,
        height: buttonSize ?? _logoutButtonSize,
        decoration: BoxDecoration(
          color: backgroundColor ?? _logoutButtonBackgroundColor,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: SvgPicture.asset(
            _logoutButtonIcon,
            fit: BoxFit.cover,
            height: iconSize ?? _logoutButtonIconSize,
            width: iconSize ?? _logoutButtonIconSize,
          ),
        ),
      ),
    );
  }
}
