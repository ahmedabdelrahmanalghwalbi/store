import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:store/data/models/product.model.dart';
import 'package:store/data/repositories/favorites.repository.dart';
import 'package:store/data/repositories/products.repository.dart';
import 'package:store/utils/constants_utils/app_strings.constants.dart';
import 'package:store/utils/toast.utils.dart';
import '../../../../utils/app_logger.utils.dart';

class ProductsViewModel extends ChangeNotifier {
  final ProductsRepository _productsRepo;
  final FavoritesRepository _favoritesRepo;
  final TextEditingController searchController = TextEditingController();

  ProductsViewModel({
    required ProductsRepository productsRepo,
    required FavoritesRepository favoritesRepo,
  }) : _productsRepo = productsRepo,
       _favoritesRepo = favoritesRepo {
    init();
  }

  // State variables
  List<ProductModel> _products = [];
  Set<int> _favoriteIds = {};
  String _searchQuery = '';
  bool _isLoading = true;
  bool _isInitialLoad = true;
  bool _disposed = false;
  String? _error;

  // Getters
  List<ProductModel> get filteredProducts =>
      _searchQuery.isEmpty
          ? _products
          : _products
              .where(
                (p) =>
                    p.title?.toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    ) ??
                    false,
              )
              .toList();

  bool get isLoading => _isLoading;
  bool get isInitialLoad => _isInitialLoad;
  String? get error => _error;
  String get searchQuery => _searchQuery;
  bool get hasData => _products.isNotEmpty;

  @override
  void dispose() {
    searchController.dispose();
    _disposed = true;
    super.dispose();
  }

  Future<void> init() async {
    await _loadFavorites();
    await _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      _error = null;
      _isLoading = true;
      safeNotifyListeners();

      final products = await _productsRepo.getProducts();
      if (products != null) {
        _products = products;
      } else {
        _error = AppStrings.loadProductsFailed.tr();
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      _isInitialLoad = false;
      safeNotifyListeners();
    }
  }

  Future<void> _loadFavorites() async {
    try {
      final favorites = await _favoritesRepo.getFavorites();
      _favoriteIds = Set.from(favorites.map((p) => p.id ?? -1));
    } catch (e) {
      AppLogger.error("Failed to load favorites: $e");
      _favoriteIds = {};
    }
  }

  Future<void> refresh() async {
    _isLoading = true;
    safeNotifyListeners();
    await _loadProducts();
  }

  void retry() {
    _error = null;
    _isInitialLoad = true;
    _isLoading = true;
    safeNotifyListeners();
    _loadProducts();
  }

  void searchProducts(String query) {
    _searchQuery = query.trim();
    safeNotifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    searchController.clear();
    FocusManager.instance.primaryFocus?.unfocus();
    safeNotifyListeners();
  }

  Future<void> toggleFavorite(ProductModel product) async {
    try {
      await _favoritesRepo.toggleFavorite(product);

      // Update local cache
      if (_favoriteIds.contains(product.id)) {
        _favoriteIds.remove(product.id);
        ToastUtils.showSuccess(
          'Product ${product.title} removed from favorites',
        );
      } else {
        _favoriteIds.add(product.id ?? -1);
        ToastUtils.showSuccess('Product ${product.title} added to favorites');
      }

      safeNotifyListeners();
    } catch (e) {
      ToastUtils.showError(AppStrings.updateFavoriteStatusFailed.tr());
    }
  }

  bool isFavorite(ProductModel product) {
    return _favoriteIds.contains(product.id);
  }

  void safeNotifyListeners() {
    if (!_disposed) notifyListeners();
  }
}
