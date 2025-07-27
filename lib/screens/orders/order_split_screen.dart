import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pts_app_v1/models/order_details_dto.dart';
import 'package:pts_app_v1/models/order.dart';
import 'package:pts_app_v1/services/order_service.dart';
import 'package:pts_app_v1/widgets/common/app_scaffold.dart';

class SplitOrderScreen extends StatefulWidget {
  final OrderDetailsDto originalOrder;

  const SplitOrderScreen({super.key, required this.originalOrder});

  @override
  State<SplitOrderScreen> createState() => _SplitOrderScreenState();
}

class _SplitOrderScreenState extends State<SplitOrderScreen> {
  late TextEditingController oldWeightController;
  late TextEditingController newWeightController;
  late TextEditingController oldPieceController;
  late TextEditingController newPieceController;

  bool _saving = false;

  @override
  void initState() {
    super.initState();
    oldWeightController = TextEditingController(
        text: widget.originalOrder.productWeight?.toString() ?? '0');
    newWeightController = TextEditingController();
    oldPieceController = TextEditingController(
        text: widget.originalOrder.productCount?.toString() ?? '0');
    newPieceController = TextEditingController();
  }

  @override
  void dispose() {
    oldWeightController.dispose();
    newWeightController.dispose();
    oldPieceController.dispose();
    newPieceController.dispose();
    super.dispose();
  }

  Future<void> _splitOrder() async {
    final oldWeight = double.tryParse(oldWeightController.text.trim()) ?? 0;
    final newWeight = double.tryParse(newWeightController.text.trim()) ?? 0;
    final oldPiece = int.tryParse(oldPieceController.text.trim()) ?? 0;
    final newPiece = int.tryParse(newPieceController.text.trim()) ?? 0;

    if (newWeight <= 0 && newPiece <= 0) {
      _showMessage("Yeni sipariş için ağırlık veya adet girilmeli",
          isError: true);
      return;
    }

    setState(() => _saving = true);

    try {
      final original = widget.originalOrder;

      final newOrder = Order(
        id: null,
        orderNumber: 0, // backend tarafından atanacak
        productName: original.productName,
        customerId: original.id ?? '',
        companyId: '', // secure storage'dan alınabilir
        orderImages: original.orderImages,
        productWeight: newWeight,
        productCount: newPiece,
        productType: original.productType,
        processType: original.processType,
        status: original.status,
        orderDescription: original.orderDescription,
        estimatedCompletionDate: original.estimatedCompletionDate,
        deliveryStatus: original.deliveryStatus,
        deliveryDate: original.deliveryDate,
        isActive: true,
        createdAt: DateTime.now(),
        createdBy: '', // secure storage'dan alınabilir
      );

      await OrderService.create(newOrder);

      final updatedOldOrder = Order(
        id: original.id,
        orderNumber: original.orderNumber,
        productName: original.productName,
        customerId: '',
        companyId: '',
        orderImages: original.orderImages,
        productWeight: oldWeight,
        productCount: oldPiece,
        productType: original.productType,
        processType: original.processType,
        status: original.status,
        orderDescription: original.orderDescription,
        estimatedCompletionDate: original.estimatedCompletionDate,
        deliveryStatus: original.deliveryStatus,
        deliveryDate: original.deliveryDate,
        isActive: original.isActive,
        createdAt: original.createdAt,
        createdBy: '',
      );

      await OrderService.update(original.id!, updatedOldOrder);

      if (mounted) {
        Navigator.pop(context, true);
        _showMessage("Sipariş başarıyla bölündü");
      }
    } catch (e) {
      _showMessage("Sipariş bölme işlemi başarısız", isError: true);
    } finally {
      setState(() => _saving = false);
    }
  }

  void _showMessage(String msg, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: GoogleFonts.poppins()),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildSection(String title, TextEditingController weightCtrl,
      TextEditingController pieceCtrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        const SizedBox(height: 8),
        TextField(
          controller: weightCtrl,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            labelText: "Ağırlık (kg)",
            labelStyle: TextStyle(color: Colors.white54),
            filled: true,
            fillColor: Colors.white10,
            border: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white30)),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: pieceCtrl,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            labelText: "Adet",
            labelStyle: TextStyle(color: Colors.white54),
            filled: true,
            fillColor: Colors.white10,
            border: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white30)),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: Text("Siparişi Böl", style: GoogleFonts.poppins()),
      ),
      body: SafeArea(
        child: _saving
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSection("Eski Sipariş (güncellenecek)",
                        oldWeightController, oldPieceController),
                    const SizedBox(height: 24),
                    _buildSection("Yeni Sipariş (oluşturulacak)",
                        newWeightController, newPieceController),
                    const SizedBox(height: 24),
                    Text(
                      "Fotoğraflar her iki siparişte de yer alacaktır.",
                      style: GoogleFonts.poppins(color: Colors.white70),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("İptal"),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _splitOrder,
                            child: const Text("Böl ve Kaydet"),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
