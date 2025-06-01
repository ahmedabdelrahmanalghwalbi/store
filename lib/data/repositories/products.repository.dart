import 'package:easy_localization/easy_localization.dart';
import 'package:store/data/models/product.model.dart';
import 'package:store/utils/constants_utils/app_strings.constants.dart';
import '../../utils/app_logger.utils.dart';
import '../../utils/toast.utils.dart';
import '../services/products.service.dart';

/// Handles business logic for product operations
/// Acts as a mediator between services and view models
class ProductsRepository {
  final ProductsService _productsService;

  ProductsRepository({required ProductsService productsService})
    : _productsService = productsService;

  /// Fetches a product by its ID
  /// [productId]: ID of the product to fetch
  /// [showToastMessage]: Whether to show error toasts
  Future<ProductModel?> getProductById({
    required String productId,
    bool showToastMessage = false,
  }) async {
    try {
      AppLogger.info("Fetching product by ID: $productId");

      final result = await _productsService.getProductById(
        productId: productId,
      );

      if (!result.success) {
        _handleError(result.message, showToastMessage);
        return null;
      }

      final data = result.data;
      if (data == null || data.isEmpty) {
        _handleError(AppStrings.productDataNotFound.tr(), showToastMessage);
        return null;
      }

      return ProductModel.fromJson(data);
    } catch (e, stackTrace) {
      _logError("Failed to fetch product", e, stackTrace);
      if (showToastMessage) {
        ToastUtils.showError(AppStrings.loadProductDetailsFailed.tr());
      }
      return null;
    }
  }

  /// Fetches all products
  /// [showToastMessage]: Whether to show error toasts
  Future<List<ProductModel>?> getProducts({
    int? limit,
    bool showToastMessage = false,
  }) async {
    try {
      AppLogger.info("Fetching all products");

      final result = await _productsService.getProducts(limit: limit);

      if (result.success && (result.data?.isNotEmpty ?? false)) {
        return result.data!.map((e) => ProductModel.fromJson(e)).toList();
      } else {
        _handleError(result.message, showToastMessage);
        return null;
      }
    } catch (e, stackTrace) {
      _logError("Failed to fetch products", e, stackTrace);
      if (showToastMessage) {
        ToastUtils.showError(AppStrings.loadProductsFailed.tr());
      }
      return null;
    }
  }

  // Helper method for error handling
  void _handleError(String? message, bool showToast) {
    AppLogger.error(message ?? "Unknown error occurred");
    if (showToast) {
      ToastUtils.showError(message ?? "Operation failed");
    }
  }

  // Helper method for error logging
  void _logError(String message, dynamic e, StackTrace stackTrace) {
    AppLogger.error(message, error: e, stackTrace: stackTrace);
  }
}
