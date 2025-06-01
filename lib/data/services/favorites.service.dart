import 'package:store/data/models/product.model.dart';
import 'package:store/utils/app_logger.utils.dart';
import 'package:store/services/local_storage/shared_preference.service.dart';

class FavoritesService {
  final SharedPreferenceService _sharedPrefs;
  static const String _favoritesKey = 'favorites_map';

  FavoritesService({required SharedPreferenceService sharedPrefs})
    : _sharedPrefs = sharedPrefs;

  /// Adds a product to favorites
  Future<void> addFavorite({required ProductModel product}) async {
    try {
      // Get current favorites
      final favorites = await _getFavoritesMap();

      // Add new favorite
      favorites[product.id.toString()] = product.toJson();

      // Save back to shared preferences
      await _sharedPrefs.setValueMap(key: _favoritesKey, value: favorites);

      AppLogger.info("Added product ${product.id} to favorites");
    } catch (e, stackTrace) {
      AppLogger.error(
        "Failed to add favorite",
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Removes a product from favorites
  Future<void> removeFavorite({required int productId}) async {
    try {
      // Get current favorites
      final favorites = await _getFavoritesMap();

      // Remove the product
      favorites.remove(productId.toString());

      // Save back to shared preferences
      await _sharedPrefs.setValueMap(key: _favoritesKey, value: favorites);

      AppLogger.info("Removed product $productId from favorites");
    } catch (e, stackTrace) {
      AppLogger.error(
        "Failed to remove favorite",
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Checks if a product is favorited
  Future<bool> isFavorite({required int productId}) async {
    try {
      final favorites = await _getFavoritesMap();
      return favorites.containsKey(productId.toString());
    } catch (e, stackTrace) {
      AppLogger.error(
        "Failed to check favorite",
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  /// Gets all favorite products
  Future<List<ProductModel>> getFavorites() async {
    try {
      final favorites = await _getFavoritesMap();
      return favorites.values
          .map((json) => ProductModel.fromJson(json))
          .toList();
    } catch (e, stackTrace) {
      AppLogger.error(
        "Failed to get favorites",
        error: e,
        stackTrace: stackTrace,
      );
      return [];
    }
  }

  /// Helper method to get favorites map
  Future<Map<String, dynamic>> _getFavoritesMap() async {
    final favorites = await _sharedPrefs.getValueMap(key: _favoritesKey);
    return favorites ?? {};
  }
}
