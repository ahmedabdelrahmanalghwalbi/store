import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../utils/constants_utils/app_assets.constants.dart';
import '../../../../core/shared_widgets/logout_button.widget.dart';
import '../../../../core/themes/app_theme.dart';

class MainViewAppbarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  const MainViewAppbarWidget({super.key});
  static const Color _appBarBackgroundColor = AppTheme.primaryColor;
  static const Color _surfaceTintColor = Colors.transparent;
  static const double _elevation = 5.0;
  static const double _appBarIconSize = 24.0;
  static const double _appBarActionSize = 32.0;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: _appBarBackgroundColor,
      surfaceTintColor: _surfaceTintColor,
      elevation: _elevation,
      title: Row(
        spacing: 8.0,
        children: [
          SizedBox(
            height: _appBarIconSize,
            width: _appBarIconSize,
            child: Center(child: FlutterLogo()),
          ),
        ],
      ),
      actions: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 4.0),
          child: Badge.count(
            count: 9,
            isLabelVisible: 9 > 0,
            backgroundColor: Colors.white,
            textColor: AppTheme.primaryColor,
            alignment: Alignment.topRight,
            offset: const Offset(1, -1),
            child: Container(
              height: _appBarActionSize,
              width: _appBarActionSize,
              margin: EdgeInsets.all(4.0),
              decoration: const BoxDecoration(
                color: Colors.black12,
                shape: BoxShape.circle,
              ),
              child: SizedBox(
                width: _appBarIconSize,
                height: _appBarIconSize,
                child: Center(
                  child: SvgPicture.asset(
                    AppAssets.notificationAppbarIcon,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 4.0),
          child: LogoutButtonWidget(
            backgroundColor: Colors.black12,
            buttonSize: _appBarActionSize,
            iconSize: _appBarIconSize,
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
