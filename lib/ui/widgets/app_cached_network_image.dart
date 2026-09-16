import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bookfast_customer/utils/app_colors.dart';
import 'package:bookfast_customer/utils/app_images.dart';

class AppCachedNetworkImage extends StatelessWidget {
  AppCachedNetworkImage(this.imageUrl,
      {Key? key,
      this.placeholder,
      this.errorPlaceholder,
      this.radius = 0.0,
      this.isBase64 = false,
      required this.height,
      required this.width,
      this.padding = EdgeInsets.zero,
      this.errorImagePadding = EdgeInsets.zero,
      this.fit = BoxFit.cover})
      : super(key: key);
  final String? imageUrl;
  final String? placeholder;
  final String? errorPlaceholder;
  final double radius;
  final double? height;
  final double? width;
  final BoxFit fit;
  final bool isBase64;
  EdgeInsets padding;
  EdgeInsets errorImagePadding;

  @override
  Widget build(BuildContext context) {
    // print("imageUrl -->> ${imageUrl}");

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: imageUrl == null
          ? Padding(
              padding: errorImagePadding,
              child: Image.asset(
                errorPlaceholder ?? AppImages.imgNoImage,
                height: height,
                width: width,
                fit: BoxFit.contain,
              ),
            )
          : Padding(
              padding: padding,
              child: imageUrl!.startsWith('http')
                  ? CachedNetworkImage(
                      height: height,
                      width: width,
                      imageUrl: imageUrl!,
                      imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: fit,
                                // colorFilter: ColorFilter.mode(Colors.red, BlendMode.colorBurn)
                              ),
                            ),
                          ),
                      progressIndicatorBuilder: (context, url, progress) => Center(
                            child: SizedBox(
                                height: width == null ? null : width! / 2.5,
                                width: width == null ? null : width! / 2.5,
                                child: Center(
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 1,
                                    color: AppColors.primaryColor100,
                                  ),
                                )),
                          ),
                      // placeholder: (context, url) => Padding(
                      //   padding: const EdgeInsets.all(10.0),
                      //   child: CircularProgressIndicator(strokeWidth: 1,),
                      // ),
                      // placeholder: (context, url) => Container(
                      //   color: AppColors.extraLightGrey,
                      //   child: Image.asset(
                      //     placeholder ?? AppImages.imgLogo,
                      //   ),
                      // ),
                      errorWidget: (context, url, error) => Container(
                            color: AppColors.secondaryColor100,
                            child: Image.asset(
                              errorPlaceholder ?? AppImages.imgNoImage,
                              height: height,
                              width: width,
                              fit: BoxFit.fill,
                            ),
                          ) //Icon(Icons.error),
                      )
                  : Image.file(File(imageUrl!),
                      fit: BoxFit.cover,
                      height: height,
                      width: width,
                      errorBuilder: (context, url, error) => Container(
                            color: AppColors.secondaryColor100,
                            child: Image.asset(
                              errorPlaceholder ?? AppImages.imgNoImage,
                              height: height,
                              width: width,
                              fit: BoxFit.fill,
                            ),
                          ) //Icon(Icons.error),

                      ),
            ),
    );
  }
}
