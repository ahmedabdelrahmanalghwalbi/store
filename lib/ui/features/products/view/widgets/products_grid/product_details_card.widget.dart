import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:store/data/models/product.model.dart';
import 'package:store/route/app_navigator.service.dart';
import '../../../../../core/themes/app_theme.dart';

class ProductDetailsCardWidget extends StatelessWidget {
  final ProductModel product;
  final double radius;
  final Color borderColor;
  final double borderWidth;
  const ProductDetailsCardWidget({
    super.key,
    required this.product,
    required this.radius,
    required this.borderColor,
    required this.borderWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height * .6,
      width: double.infinity,
      padding: EdgeInsets.all(AppTheme.pagePadding),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        spacing: 12.0,
        children: [
          /// Product Image
          Expanded(
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(radius),
                    border: Border.all(color: borderColor, width: borderWidth),
                  ),
                  width: double.infinity,
                  clipBehavior: Clip.antiAlias,
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

                Positioned(
                  top: 16.0,
                  right: 16.0,
                  left: 16.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
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
                              product.rating?.rate.toStringAsFixed(1) ?? '0',
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),

                      InkWell(
                        onTap: () => AppNavigator.goBack(),
                        child: Container(
                          padding: EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: 1.0,
                            ),
                          ),
                          child: Icon(Icons.close, color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          /// Product Details
          if (product.title?.isNotEmpty ?? false)
            Text(
              product.title!,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          if (product.price != null)
            Text(
              '\$ ${product.price!.toStringAsFixed(2)}',
              style: TextStyle(
                color: AppTheme.primaryColor,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          if (product.description?.isNotEmpty ?? false)
            Text(
              product.description!,
              style: TextStyle(
                color: Colors.black54,
                fontSize: 12.0,
                fontWeight: FontWeight.w400,
              ),
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    );
  }
}
