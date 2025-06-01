import 'package:easy_localization/easy_localization.dart';
import 'package:store/data/models/product.model.dart';
import 'package:store/utils/app_logger.utils.dart';
import 'package:store/utils/constants_utils/app_strings.constants.dart';
import 'package:store/utils/toast.utils.dart';
import '../services/favorites.service.dart';

class FavoritesRepository {
  final FavoritesService _favoritesService;

  FavoritesRepository({required FavoritesService favoritesService})
    : _favoritesService = favoritesService;

  /// Toggles favorite status for a product
  Future<void> toggleFavorite(ProductModel product) async {
    try {
      if (product.id == null) return;

      final isFav = await _favoritesService.isFavorite(productId: product.id!);

      if (isFav) {
        await _favoritesService.removeFavorite(productId: product.id!);
      } else {
        await _favoritesService.addFavorite(product: product);
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        "Failed to update favorites",
        error: e,
        stackTrace: stackTrace,
      );
      ToastUtils.showError(AppStrings.updateFavoritesFailed.tr());
      rethrow;
    }
  }

  /// Checks if a product is favorited
  Future<bool> isFavorite({required int? productId}) async {
    if (productId == null) return false;
    return await _favoritesService.isFavorite(productId: productId);
  }

  /// Gets all favorite products
  Future<List<ProductModel>> getFavorites() async {
    return await _favoritesService.getFavorites();
  }
}
