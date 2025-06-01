import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../utils/constants_utils/app_assets.constants.dart';
import '../../../../../utils/constants_utils/app_strings.constants.dart';
import '../../../../core/themes/app_theme.dart';
import '../../view_model/main.viewmodel.dart';

class MainViewBottomnavigationBarWidget extends StatelessWidget {
  final MainViewModel viewModel;

  const MainViewBottomnavigationBarWidget({super.key, required this.viewModel});
  static const double iconSize = 20.0;
  static const TextStyle _primaryTextStyle = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 11.0,
  );
  static const Color _backgroundColor = Colors.white;
  static const Color _selectedItemColor = AppTheme.primaryColor;
  static const Color _unselectedItemColor = Color(0xff757575);
  static const double _elevation = 5.0;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: BottomNavigationBar(
        backgroundColor: _backgroundColor,
        currentIndex: viewModel.selectedIndex,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        onTap: viewModel.changeIndex,
        selectedItemColor: _selectedItemColor,
        unselectedItemColor: _unselectedItemColor,
        selectedLabelStyle: _primaryTextStyle,
        unselectedLabelStyle: _primaryTextStyle,
        elevation: _elevation,
        items: [
          _buildNavItem(
            assetPath: AppAssets.homeBottomBarIcon,
            label: AppStrings.home,
            index: 0,
            iconSize: iconSize,
            selectedItemColor: _selectedItemColor,
            unselectedItemColor: _unselectedItemColor,
          ),
          _buildNavItem(
            assetPath: AppAssets.reportsBottomBarIcon,
            label: AppStrings.favorites,
            index: 1,
            iconSize: iconSize,
            selectedItemColor: _selectedItemColor,
            unselectedItemColor: _unselectedItemColor,
          ),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem({
    required String assetPath,
    required String label,
    required int index,
    required double iconSize,
    required Color selectedItemColor,
    required Color unselectedItemColor,
  }) {
    return BottomNavigationBarItem(
      icon: Container(
        width: iconSize,
        height: iconSize,
        margin: EdgeInsets.only(bottom: 4.0),
        child: SvgPicture.asset(
          assetPath,
          fit: BoxFit.fill,
          colorFilter: ColorFilter.mode(
            viewModel.selectedIndex == index
                ? selectedItemColor
                : unselectedItemColor,
            BlendMode.srcIn,
          ),
        ),
      ),
      label: label.tr(),
    );
  }
}
