import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SmartInfoCard extends StatelessWidget {
  final String title;
  final String value;
  final String? imageUrl;
  final VoidCallback? onTap;

  const SmartInfoCard({
    Key? key,
    required this.title,
    required this.value,
    this.imageUrl,
    this.onTap,
  }) : super(key: key);

  bool _isSvg(String url) {
    return url.toLowerCase().endsWith(".svg");
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// 🔹 Top Title
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
          
              const SizedBox(height: 16),
          
              /// 🔹 Center Image
              _buildImage(),
          
              const SizedBox(height: 16),
          
              /// 🔹 Bottom Value Text
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return const Icon(Icons.image_not_supported, size: 70);
    }

    if (_isSvg(imageUrl!)) {
      return SvgPicture.network(
        imageUrl!,
        width: 70,
        height: 70,
        placeholderBuilder: (context) =>
        const CircularProgressIndicator(strokeWidth: 2),
      );
    } else {
      return Image.network(
        imageUrl!,
        width: 70,
        height: 70,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) =>
        const Icon(Icons.broken_image, size: 70),
      );
    }
  }
}