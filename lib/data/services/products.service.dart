import 'package:easy_localization/easy_localization.dart';
import 'package:store/utils/constants_utils/app_strings.constants.dart';

import '../../services/backend/api_services/client_service.interface.dart';
import '../../services/backend/endpoint_service/endpoint.model.dart';
import '../../services/backend/endpoint_service/endpoints.service.dart';
import '../../utils/app_logger.utils.dart';
import '../models/operation_result.model.dart';

class ProductsService {
  ProductsService({
    required ClientServiceInterface clientService,
    required EndpointServices endpoints,
  }) : _clientService = clientService,
       _endpoints = endpoints;
  final ClientServiceInterface _clientService;
  final EndpointServices _endpoints;

  /// Fetches all products from the API
  /// Returns [OperationResult] with list of products or error
  Future<OperationResult<List<Map<String, dynamic>>>> getProducts({
    int? limit,
  }) async {
    try {
      final endpoint = _endpoints.getApiEndpoint(EndpointsNames.products).url;
      final queryParams = limit != null ? {'limit': limit.toString()} : null;

      final url =
          Uri.parse(endpoint).replace(queryParameters: queryParams).toString();

      return await _clientService.get<List<Map<String, dynamic>>>(
        url,
        dataKey: 'response',
        addToken: true,
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        "Error fetching products list",
        error: e,
        stackTrace: stackTrace,
      );
      return OperationResult(
        statusCode: 500,
        success: false,
        message: AppStrings.fetchProductDetailsError.tr(),
      );
    }
  }

  /// Fetches a single product by its ID
  /// [productId]: The ID of the product to fetch
  Future<OperationResult<Map<String, dynamic>>> getProductById({
    required String productId,
  }) async {
    try {
      final endpoint = _endpoints.getApiEndpoint(EndpointsNames.products).url;
      final url = Uri.parse("$endpoint/$productId").toString();

      return await _clientService.get<Map<String, dynamic>>(
        url,
        dataKey: 'response',
        addToken: true,
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        "Error fetching product details",
        error: e,
        stackTrace: stackTrace,
      );
      return OperationResult<Map<String, dynamic>>(
        statusCode: 500,
        success: false,
        message: AppStrings.loadProductDetailsFailed.tr(),
      );
    }
  }
}
