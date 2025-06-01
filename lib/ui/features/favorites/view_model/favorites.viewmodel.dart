import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:store/data/models/product.model.dart';
import 'package:store/data/repositories/favorites.repository.dart';
import 'package:store/utils/app_logger.utils.dart';
import 'package:store/utils/constants_utils/app_strings.constants.dart';

import '../../../../utils/toast.utils.dart';

class FavoritesViewModel extends ChangeNotifier {
  final FavoritesRepository _favoritesRepo;

  FavoritesViewModel({required FavoritesRepository favoritesRepo})
    : _favoritesRepo = favoritesRepo {
    init();
  }

  // State variables
  List<ProductModel> _favorites = [];
  bool _isLoading = true;
  bool _isInitialLoad = true;
  bool _disposed = false;
  String? _error;

  // Getters
  List<ProductModel> get favorites => _favorites;
  bool get isLoading => _isLoading;
  bool get isInitialLoad => _isInitialLoad;
  String? get error => _error;
  bool get hasData => _favorites.isNotEmpty;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  Future<void> init() async {
    await _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
      _error = null;
      _isLoading = true;
      safeNotifyListeners();

      _favorites = await _favoritesRepo.getFavorites();
    } catch (e) {
      _error = e.toString();
      AppLogger.error("Failed to load favorites: $e");
    } finally {
      _isLoading = false;
      _isInitialLoad = false;
      safeNotifyListeners();
    }
  }

  Future<void> refresh() async {
    _isLoading = true;
    safeNotifyListeners();
    await _loadFavorites();
  }

  Future<void> removeFavorite(ProductModel product) async {
    try {
      if (product.id == null) return;

      await _favoritesRepo.toggleFavorite(product);
      await _loadFavorites();
      ToastUtils.showSuccess("Product ${product.title} removed from favorites");
    } catch (e) {
      AppLogger.error("Failed to remove favorite: $e");
      ToastUtils.showError(AppStrings.removeFavoriteFailed.tr());
      rethrow;
    }
  }

  void safeNotifyListeners() {
    if (!_disposed) notifyListeners();
  }
}
