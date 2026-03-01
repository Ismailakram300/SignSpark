import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SmartNetworkImage extends StatelessWidget {
  final String? imageUrl;
  final double width;
  final double height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final BorderRadius? borderRadius;

  const SmartNetworkImage({
    Key? key,
    required this.imageUrl,
    this.width = 70,
    this.height = 70,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.borderRadius,
  }) : super(key: key);

  bool _isSvg(String url) {
    return url.toLowerCase().endsWith('.svg');
  }

  bool _isValidUrl(String url) {
    return Uri.tryParse(url)?.hasAbsolutePath ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final Widget defaultPlaceholder = placeholder ??
        const Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        );

    final Widget defaultError =
        errorWidget ?? const Icon(Icons.broken_image, size: 50);

    // 🔥 HANDLE NULL OR EMPTY IMAGE
    if (imageUrl == null || imageUrl!.trim().isEmpty) {
      return _wrap(
        errorWidget ??
            const Icon(Icons.image_not_supported, size: 50),
      );
    }

    // 🔥 HANDLE INVALID URL
    if (!_isValidUrl(imageUrl!)) {
      return _wrap(defaultError);
    }

    if (_isSvg(imageUrl!)) {
      return _wrap(
        SvgPicture.network(
          imageUrl!,
          width: width,
          height: height,
          placeholderBuilder: (_) => defaultPlaceholder,
        ),
      );
    }

    return _wrap(
      Image.network(
        imageUrl!,
        width: width,
        height: height,
        fit: fit,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return defaultPlaceholder;
        },
        errorBuilder: (_, __, ___) => defaultError,
      ),
    );
  }

  Widget _wrap(Widget child) {
    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: child,
      );
    }
    return child;
  }
}