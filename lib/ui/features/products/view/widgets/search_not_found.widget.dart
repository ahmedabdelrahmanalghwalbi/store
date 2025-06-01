import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:store/utils/constants_utils/app_strings.constants.dart';
import '../../../../core/shared_widgets/custom_action_button.widget.dart';
import '../../../../core/themes/app_theme.dart';

class SearchNotFoundWidget extends StatelessWidget {
  final String searchQuery;
  final VoidCallback clearSearch;
  const SearchNotFoundWidget({
    super.key,
    required this.searchQuery,
    required this.clearSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 8.0,
        children: [
          Icon(Icons.search_off, size: 64),
          Text(
            searchQuery.isEmpty
                ? AppStrings.noProductsAvailable.tr()
                : AppStrings.noProductsFound.tr(),
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18.0),
          ),
          if (searchQuery.isNotEmpty)
            CustomActionButtonWidget(
              isPrimary: true,
              text: AppStrings.clearSearch.tr(),
              backgroundColor: AppTheme.primaryColor,
              width: 200.0,
              onPressed: clearSearch,
            ),
        ],
      ),
    );
  }
}
