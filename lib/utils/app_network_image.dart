
import 'package:cached_network_image/cached_network_image.dart';
import 'package:bookfast_customer/utils/app_images.dart';
import 'package:flutter/material.dart';
import 'package:bookfast_customer/utils/app_colors.dart';

class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({Key? key, required this.imageUrl,  this.placeholder, this.radius = 0.0, this.placeHolderPadding = 0.0, this.height, this.width}) : super(key: key);
  final String? imageUrl;
  final String? placeholder;
  final double radius;
  final double? height;
  final double? width;
  final double placeHolderPadding;

  @override
  Widget build(BuildContext context) {
    // print("imageUrl -->> ${imageUrl}");
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: CachedNetworkImage(
          height: height,
          width: width,
          imageUrl: imageUrl!,
          imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                    // colorFilter: ColorFilter.mode(Colors.red, BlendMode.colorBurn)
                  ),
                ),
              ),
          // progressIndicatorBuilder: (context, url, progress) =>
          //     CircularProgressIndicator(),
          placeholder: (context, url) => Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(child: CircularProgressIndicator(strokeWidth: 1,)),
          ),
          // placeholder: (context, url) => Container(
          //       padding: EdgeInsets.all(placeHolderPadding),
          //       color: AppColors.secondaryColor100,
          //       child: Image.asset(
          //         placeholder!,
          //       ),
          //     ),
          errorWidget: (context, url, error) => Container(
                padding: EdgeInsets.all(placeHolderPadding),
                //color: AppColors.secondaryColor100,
                child: Image.asset(
                  placeholder?? AppImages.imgPlaceHolder,
                ),
              ) //Icon(Icons.error),
          ),
    );
  }

}
