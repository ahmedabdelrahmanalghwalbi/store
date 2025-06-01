import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../../data/models/product.model.dart';
import '../../../../../core/shared_widgets/custom_animated_popup/custom_animated_popup.dart';
import '../../../../../core/themes/app_theme.dart';
import 'product_details_card.widget.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final bool isFavorite;
  final VoidCallback onFavoritePressed;
  final double radius;
  final double borderWidth;
  final Color borderColor;

  const ProductCard({
    super.key,
    required this.product,
    required this.isFavorite,
    required this.onFavoritePressed,
    required this.radius,
    required this.borderColor,
    required this.borderWidth,
  });

  @override
  Widget build(BuildContext context) {
    return CustomAnimatedPopup(
      popupKey: 'ProductDetailsPopup${product.id}',
      borderRadius: BorderRadius.circular(radius),
      color: Colors.transparent,
      popupMarginFromScreen: AppTheme.pagePadding,
      shrinkedWidget: Card(
        elevation: 2,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: 8.0,
          children: [
            // Product Image
            Expanded(
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(radius),
                      border: Border.all(
                        color: borderColor,
                        width: borderWidth,
                      ),
                    ),
                    width: double.infinity,
                    clipBehavior: Clip.antiAlias,
                    margin: EdgeInsets.all(8.0),
                    padding: EdgeInsets.all(8.0),
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

                  if (product.rating?.rate != null)
                    Positioned(
                      top: 16.0,
                      right: 16.0,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 4.0,
                          vertical: 2.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(radius),
                        ),
                        child: Row(
                          spacing: 2.0,
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 15,
                            ),
                            Text(
                              product.rating!.rate.toStringAsFixed(1),
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Product Details
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 6.0,
                children: [
                  if (product.title?.isNotEmpty ?? false)
                    Text(
                      product.title!,
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 13.0,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (product.price != null)
                        Expanded(
                          child: Text(
                            '\$ ${product.price!.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 13.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      // Favorite Button
                      InkWell(
                        onTap: onFavoritePressed,
                        child: Container(
                          padding: EdgeInsets.all(6.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppTheme.primaryColor,
                          ),
                          child: Center(
                            child: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
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
      expandedWidget: ProductDetailsCardWidget(
        borderColor: borderColor,
        borderWidth: borderWidth,
        product: product,
        radius: radius,
      ),
      dismissible: true,
    );
  }
}
