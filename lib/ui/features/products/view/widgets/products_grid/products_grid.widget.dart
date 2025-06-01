import 'package:flutter/material.dart';
import 'package:store/data/models/product.model.dart';
import 'package:store/ui/features/products/view/widgets/products_grid/product_card.widget.dart';

class ProductsGridWidget extends StatelessWidget {
  final List<ProductModel>? products;
  final double radius;
  final double borderWidth;
  final Color borderColor;
  final void Function(ProductModel product) onFavoritePressed;
  final bool Function(ProductModel product) isFavorite;
  const ProductsGridWidget({
    super.key,
    required this.products,
    required this.radius,
    required this.borderColor,
    required this.borderWidth,
    required this.onFavoritePressed,
    required this.isFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.6,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: products?.length,
      itemBuilder: (context, index) {
        final product = products?[index];
        if (product == null) return const SizedBox.shrink();
        return ProductCard(
          product: product,
          isFavorite: isFavorite(product),
          onFavoritePressed: () => onFavoritePressed(product),
          radius: radius,
          borderColor: borderColor,
          borderWidth: borderWidth,
        );
      },
    );
  }
}
