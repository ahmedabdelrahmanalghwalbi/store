import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store/utils/constants_utils/app_strings.constants.dart';
import '../../../../data/repositories/favorites.repository.dart';
import '../../../../data/repositories/products.repository.dart';
import '../../../core/shared_widgets/search_box.widget.dart';
import '../../../core/themes/app_theme.dart';
import '../view_model/products.viewmodel.dart';
import 'widgets/failed_to_get_products.widget.dart';
import 'widgets/products_grid/products_grid.widget.dart';
import 'widgets/products_grid/products_grid_shimmer.widget.dart';
import 'widgets/search_not_found.widget.dart';

class ProductsView extends StatelessWidget {
  const ProductsView({super.key});
  static const double _componentsRadius = 8.0;
  static const double _componentsHeight = 40.0;
  static const double _componentsBorderWidth = 1.0;
  static const Color _componentsBorderColor = Color(0xffE0E0E0);
  static const TextStyle _componentsTextStyle = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 12.0,
    color: Color(0xff616161),
  );

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      lazy: true,
      create: (context) {
        final productsRepo = context.read<ProductsRepository>();
        final favoritesRepo = context.read<FavoritesRepository>();
        return ProductsViewModel(
          productsRepo: productsRepo,
          favoritesRepo: favoritesRepo,
        );
      },
      child: Consumer<ProductsViewModel>(
        builder: (context, viewModel, child) {
          // Loading state
          if (viewModel.isInitialLoad) {
            return const ProductsShimmerWidget();
          }

          // Error state
          if (viewModel.error != null || !viewModel.hasData) {
            FailedToGetProductsWidget(
              errorString: viewModel.error,
              retry: viewModel.retry,
            );
          }

          // Success state
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: AppTheme.pagePadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 12.0,
              children: [
                // Search App Bar
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: SearchBoxWidget(
                    hintText: AppStrings.search.tr(),
                    onChanged: viewModel.searchProducts,
                    textStyle: _componentsTextStyle,
                    radius: _componentsRadius,
                    borderColor: _componentsBorderColor,
                    height: _componentsHeight,
                    borderSize: _componentsBorderWidth,
                    showSearchField: true,
                    backgroundColor: Colors.white,
                    controller: viewModel.searchController,
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: viewModel.refresh,
                    backgroundColor: Colors.white,
                    color: AppTheme.primaryColor,
                    child:
                        viewModel.filteredProducts.isEmpty
                            ? SearchNotFoundWidget(
                              clearSearch: viewModel.clearSearch,
                              searchQuery: viewModel.searchQuery,
                            )
                            : ProductsGridWidget(
                              products: viewModel.filteredProducts,
                              isFavorite: viewModel.isFavorite,
                              onFavoritePressed: viewModel.toggleFavorite,
                              radius: _componentsRadius,
                              borderColor: _componentsBorderColor,
                              borderWidth: _componentsBorderWidth,
                            ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
