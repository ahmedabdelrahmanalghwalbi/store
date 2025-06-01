import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../data/models/product.model.dart';
import '../../../../core/themes/app_theme.dart';

class FavoriteProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onRemove;

  const FavoriteProductCard({
    super.key,
    required this.product,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          spacing: 12.0,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Container(
              height: 120.0,
              width: 100.0,
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.grey.shade300),
                color: Colors.white,
              ),
              child: Center(
                child: CachedNetworkImage(
                  imageUrl: product.image ?? '',
                  fit: BoxFit.cover,
                  placeholder:
                      (context, url) => Shimmer.fromColors(
                        baseColor: AppTheme.shimmerBaseColor,
                        highlightColor: AppTheme.shimmerHighlightColor,
                        child: Container(color: Colors.grey[300]),
                      ),
                  errorWidget:
                      (context, url, error) => const Center(
                        child: Icon(
                          Icons.broken_image,
                          size: 40,
                          color: Colors.grey,
                        ),
                      ),
                  fadeInDuration: const Duration(milliseconds: 300),
                  fadeOutDuration: const Duration(milliseconds: 100),
                ),
              ),
            ),

            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8.0,
                children: [
                  if (product.title?.isNotEmpty ?? false)
                    Text(
                      product.title!,
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  if (product.description?.isNotEmpty ?? false)
                    Text(
                      product.description!,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 10.0,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                    ),
                  if (product.price != null)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            '\$${product.price!.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // Remove Favorite Button
                        InkWell(
                          onTap: onRemove,
                          child: Container(
                            padding: EdgeInsets.all(6.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppTheme.primaryColor,
                            ),
                            child: Center(
                              child: Icon(
                                Icons.favorite,
                                color: Colors.white,
                                size: 18.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
