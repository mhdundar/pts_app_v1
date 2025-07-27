import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pts_app_v1/constants/order_statuses.dart';
import 'package:pts_app_v1/models/order_details_dto.dart';

class OrderActionButtons extends StatelessWidget {
  final OrderDetailsDto order;
  final VoidCallback onUploadPhoto;
  final VoidCallback onTaraAl;
  final VoidCallback onSplit;
  final Function(String newStatus) onChangeStatus;

  const OrderActionButtons({
    super.key,
    required this.order,
    required this.onUploadPhoto,
    required this.onTaraAl,
    required this.onSplit,
    required this.onChangeStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        ElevatedButton.icon(
          onPressed: onUploadPhoto,
          icon: const Icon(Icons.add_a_photo),
          label: const Text("Fotoğraf Ekle"),
          style: _buttonStyle(),
        ),
        ElevatedButton.icon(
          onPressed: onTaraAl,
          icon: const Icon(Icons.scale),
          label: const Text("Tara + Al"),
          style: _buttonStyle(),
        ),
        ElevatedButton.icon(
          onPressed: onSplit,
          icon: const Icon(Icons.call_split),
          label: const Text("Siparişi Böl"),
          style: _buttonStyle(),
        ),
        PopupMenuButton<String>(
          onSelected: (status) => onChangeStatus(status),
          color: Colors.white,
          itemBuilder: (context) {
            return OrderStatuses.all.map((status) {
              return PopupMenuItem<String>(
                value: status,
                child: Text(OrderStatuses.label(status)),
              );
            }).toList();
          },
          child: ElevatedButton.icon(
            icon: const Icon(Icons.sync),
            label: Text("Statü Değiştir"),
            style: _buttonStyle(),
            onPressed: null, // Menu button kullanıldığı için burada null
          ),
        ),
      ],
    );
  }

  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFF5F5F5),
      foregroundColor: Colors.black87,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      textStyle: GoogleFonts.poppins(),
    );
  }
}
