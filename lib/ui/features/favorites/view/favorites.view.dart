import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../data/repositories/favorites.repository.dart';
import '../../../core/themes/app_theme.dart';
import '../view_model/favorites.viewmodel.dart';
import 'widgets/favorite_product_card.widget.dart';
import 'widgets/no_favorites_yet.widget.dart';

class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        final favoritesRepo = context.read<FavoritesRepository>();
        return FavoritesViewModel(favoritesRepo: favoritesRepo);
      },
      child: Consumer<FavoritesViewModel>(
        builder: (context, viewModel, child) {
          // Loading state
          if (viewModel.isInitialLoad) {
            return const Center(
              child: CircularProgressIndicator(color: AppTheme.primaryColor),
            );
          }

          // Error state
          if (viewModel.error != null || !viewModel.hasData) {
            return NoFavoritesYetWidget(
              error: viewModel.error,
              refresh: viewModel.refresh,
            );
          }

          // Success state
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: AppTheme.pagePadding),
            child: RefreshIndicator(
              onRefresh: viewModel.refresh,
              backgroundColor: Colors.white,
              color: AppTheme.primaryColor,
              child: ListView.builder(
                itemCount: viewModel.favorites.length,
                itemBuilder: (context, index) {
                  final product = viewModel.favorites[index];
                  return FavoriteProductCard(
                    product: product,
                    onRemove: () => viewModel.removeFavorite(product),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
