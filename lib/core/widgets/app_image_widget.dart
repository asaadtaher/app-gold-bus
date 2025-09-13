import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../constants/app_images.dart';

/// ويدجت مخصص لعرض الصور مع دعم التخزين المؤقت
class AppImageWidget extends StatelessWidget {
  final String imageName;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final bool isNetworkImage;
  final String? networkUrl;

  const AppImageWidget({
    super.key,
    required this.imageName,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.isNetworkImage = false,
    this.networkUrl,
  });

  @override
  Widget build(BuildContext context) {
    if (isNetworkImage && networkUrl != null) {
      return CachedNetworkImage(
        imageUrl: networkUrl!,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) => placeholder ?? _buildDefaultPlaceholder(),
        errorWidget: (context, url, error) => errorWidget ?? _buildDefaultError(),
      );
    }

    return Image.asset(
      AppImages.getImagePath(imageName),
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return errorWidget ?? _buildDefaultError();
      },
    );
  }

  Widget _buildDefaultPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[300],
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildDefaultError() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[300],
      child: const Icon(
        Icons.error,
        color: Colors.red,
      ),
    );
  }
}

/// ويدجت مخصص لعرض الأيقونات
class AppIconWidget extends StatelessWidget {
  final String iconName;
  final double? size;
  final Color? color;

  const AppIconWidget({
    super.key,
    required this.iconName,
    this.size,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppImages.getImagePath(iconName),
      width: size,
      height: size,
      color: color,
      errorBuilder: (context, error, stackTrace) {
        return Icon(
          Icons.error,
          size: size,
          color: Colors.red,
        );
      },
    );
  }
}

/// ويدجت مخصص لعرض الصور الدائرية
class AppCircularImageWidget extends StatelessWidget {
  final String imageName;
  final double radius;
  final Color? borderColor;
  final double borderWidth;

  const AppCircularImageWidget({
    super.key,
    required this.imageName,
    required this.radius,
    this.borderColor,
    this.borderWidth = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: borderColor != null
            ? Border.all(color: borderColor!, width: borderWidth)
            : null,
      ),
      child: ClipOval(
        child: AppImageWidget(
          imageName: imageName,
          width: radius * 2,
          height: radius * 2,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
