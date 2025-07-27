import 'package:flutter/material.dart';
import 'package:pts_app_v1/config.dart';

class OrderPhotoGrid extends StatelessWidget {
  final List<String> imagePaths;
  final void Function(String imagePath) onTap;

  const OrderPhotoGrid({
    super.key,
    required this.imagePaths,
    required this.onTap,
    required Future<void> Function(String url) onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (imagePaths.isEmpty) {
      return const Center(child: Text('Fotoğraf bulunamadı.'));
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: imagePaths.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        final imagePath = imagePaths[index];

        // 🔧 URL güvenli oluşturuluyor
        final normalizedPath =
            imagePath.startsWith('/') ? imagePath : '/$imagePath';

        final imageUrl = '${AppConfig.apiBase}$normalizedPath';

        // 🪵 Hatalı veya beklenmeyen yolları logla
        if (!imageUrl.startsWith('http')) {
          debugPrint('[PhotoGrid] HATALI URL: $imageUrl');
        }

        return GestureDetector(
          onTap: () => onTap(imagePath),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(child: CircularProgressIndicator());
              },
              errorBuilder: (context, error, stackTrace) {
                debugPrint(
                    '[PhotoGrid] YÜKLEME HATASI: $imageUrl\nHata: $error');
                return const Icon(Icons.broken_image);
              },
            ),
          ),
        );
      },
    );
  }
}
