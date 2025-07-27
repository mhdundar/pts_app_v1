import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DialogHelpers {
  /// Kullanıcıya galeri mi kamera mı diye sorar.
  static Future<ImageSource?> showPhotoSourceDialog(
      BuildContext context) async {
    return showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Kamera ile Çek'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galeriden Seç'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        );
      },
    );
  }

  /// Tartım miktarı girişi (Tara ve Al)
  static Future<double?> showTaraAlDialog(
      BuildContext context, double maxKg) async {
    final controller = TextEditingController();

    return showDialog<double>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Tartılan Miktarı Gir"),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              hintText: "kg (Max: $maxKg)",
              border: const OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("İptal"),
            ),
            ElevatedButton(
              onPressed: () {
                final val = double.tryParse(controller.text);
                if (val != null && val > 0 && val <= maxKg) {
                  Navigator.pop(context, val);
                }
              },
              child: const Text("Onayla"),
            ),
          ],
        );
      },
    );
  }

  /// Siparişi bölme dialogu
  static Future<double?> showSplitOrderDialog(
      BuildContext context, double maxKg) async {
    final controller = TextEditingController();

    return showDialog<double>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Bölünecek Miktarı Gir"),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              hintText: "kg (Max: $maxKg)",
              border: const OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("İptal"),
            ),
            ElevatedButton(
              onPressed: () {
                final val = double.tryParse(controller.text);
                if (val != null && val > 0 && val < maxKg) {
                  Navigator.pop(context, val);
                }
              },
              child: const Text("Böl"),
            ),
          ],
        );
      },
    );
  }
}
