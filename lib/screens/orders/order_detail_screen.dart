import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:pts_app_v1/config.dart';
import 'package:pts_app_v1/controllers/order_detail_controller.dart';
import 'package:pts_app_v1/models/order.dart';
import 'package:pts_app_v1/models/order_details_dto.dart';
import 'package:pts_app_v1/services/order_service.dart';
import 'package:pts_app_v1/widgets/order/order_action_buttons.dart';
import 'package:pts_app_v1/widgets/order/order_info_card.dart';
import 'package:pts_app_v1/widgets/order/order_photo_grid.dart';

class OrderDetailScreen extends StatefulWidget {
  final String orderId;

  const OrderDetailScreen({super.key, required this.orderId});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  OrderDetailsDto? orderDetailsDto;
  String? orderId;
  Order? order;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOrder();
  }

  Future<void> _loadOrder() async {
    final fetched = await OrderDetailController.fetchOrder(widget.orderId);
    order = await OrderService.getById(widget.orderId);
    if (mounted) {
      setState(() {
        orderDetailsDto = fetched;
        orderId = widget.orderId;
        isLoading = false;
      });
    }
  }

  Future<void> _uploadPhotos() async {
    final picker = ImagePicker();
    final images = await picker.pickMultiImage(imageQuality: 85);
    if (images.isEmpty) return;

    final files = images.map((x) => File(x.path)).toList();
    final success =
        await OrderDetailController.uploadPhotos(widget.orderId, files);
    if (success) {
      _loadOrder();
    }
  }

  Future<void> _splitOrder() async {
    if (order == null) return;

    final TextEditingController controller = TextEditingController();
    final splitAmount = await showDialog<double>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Siparişi Böl"),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration:
              const InputDecoration(labelText: "Yeni sipariş miktarı (ör. 30)"),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("İptal")),
          TextButton(
              onPressed: () {
                final value = double.tryParse(controller.text);
                if (value != null &&
                    value > 0 &&
                    (order!.productWeight ?? 0) > value) {
                  Navigator.pop(context, value);
                }
              },
              child: const Text("Onayla")),
        ],
      ),
    );

    if (splitAmount != null) {
      final remaining = (order!.productWeight ?? 0) - splitAmount;

      final newOrder = Order(
        customerId: order!.customerId,
        companyId: order!.companyId,
        productName: order!.productName,
        productWeight: splitAmount,
        productType: order!.productType,
        processType: order!.processType,
        isActive: true,
        orderImages: List<String>.from(order!.orderImages),
        status: order!.status,
        createdAt: order!.createdAt,
        createdBy: order!.createdBy,
      );

      final updatedOrder = Order(
        id: order!.id,
        orderNumber: order!.orderNumber,
        customerId: order!.customerId,
        companyId: order!.companyId,
        productName: order!.productName,
        productWeight: remaining,
        productType: order!.productType,
        processType: order!.processType,
        isActive: true,
        orderImages: List<String>.from(order!.orderImages),
        status: order!.status,
        createdAt: order!.createdAt,
        createdBy: order!.createdBy,
      );

      final success = await OrderDetailController.splitAndUpdate(
        updatedOrder,
        newOrder,
      );

      if (success) {
        _loadOrder();
      }
    }
  }

  Future<void> _updateStatus(String newStatus) async {
    final success =
        await OrderDetailController.updateStatus(widget.orderId, newStatus);
    if (success) {
      _loadOrder();
    }
  }

  Future<void> _deletePhoto(String url) async {
    final success =
        await OrderDetailController.deletePhoto(widget.orderId, url);
    if (success) {
      _loadOrder();
    }
  }

  void _showPhotoFullScreen(String path) {
    final normalized = path.startsWith('/') ? path : '/$path';
    final imageUrl = AppConfig.apiBase + normalized;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Center(
                child: PhotoView(imageProvider: NetworkImage(imageUrl)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF203A43),
      appBar: AppBar(
        backgroundColor: const Color(0xFF203A43),
        title: Text(
          "Sipariş Detay",
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : order == null
              ? const Center(
                  child: Text(
                    "Sipariş bulunamadı.",
                    style: TextStyle(color: Colors.white70),
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      OrderInfoCard(order: orderDetailsDto!),
                      const SizedBox(height: 20),
                      OrderActionButtons(
                        order: orderDetailsDto!,
                        onUploadPhoto: _uploadPhotos,
                        onTaraAl: () {},
                        onSplit: _splitOrder,
                        onChangeStatus: _updateStatus,
                      ),
                      const SizedBox(height: 20),
                      OrderPhotoGrid(
                        imagePaths: order!.orderImages,
                        onTap: _showPhotoFullScreen,
                        onDelete: _deletePhoto,
                      ),
                    ],
                  ),
                ),
    );
  }
}
