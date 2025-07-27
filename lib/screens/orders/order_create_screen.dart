import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pts_app_v1/models/order.dart';
import 'package:pts_app_v1/services/order_service.dart';
import 'package:pts_app_v1/constants/order_statuses.dart';
import 'package:pts_app_v1/helpers/dialog_helpers.dart';
import 'package:pts_app_v1/widgets/order/order_photo_grid.dart';
import 'package:pts_app_v1/widgets/common/app_scaffold.dart';

class OrderCreateScreen extends StatefulWidget {
  const OrderCreateScreen({super.key});

  @override
  State<OrderCreateScreen> createState() => _OrderCreateScreenState();
}

class _OrderCreateScreenState extends State<OrderCreateScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productWeightController =
      TextEditingController();
  final TextEditingController _productCountController = TextEditingController();
  final TextEditingController _orderDescriptionController =
      TextEditingController();
  final TextEditingController _estimatedCompletionDateController =
      TextEditingController();
  final TextEditingController _companySearchController =
      TextEditingController();

  String? selectedCustomerId;
  String? selectedCompanyId;
  String? selectedProductType;
  String? selectedProcessType;

  final List<String> productTypes = ['Kilo', 'Palet', 'Kasa', 'Çuval'];
  final List<String> processTypes = [
    'CR3',
    '6',
    'Mavi',
    'Sarı',
    'Lak',
    'Kumlama'
  ];

  List<String> _pickedImagePaths = [];

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final order = Order(
        customerId: selectedCustomerId ?? '',
        companyId: selectedCompanyId ?? '',
        orderImages: _pickedImagePaths,
        productName: _productNameController.text,
        productWeight: double.tryParse(_productWeightController.text),
        productCount: int.tryParse(_productCountController.text),
        productType: selectedProductType,
        processType: selectedProcessType,
        status: OrderStatuses.receivedFromCustomer,
        orderDescription: _orderDescriptionController.text,
        estimatedCompletionDate:
            _estimatedCompletionDateController.text.isNotEmpty
                ? DateFormat('yyyy-MM-dd')
                    .parse(_estimatedCompletionDateController.text)
                : null,
        isActive: true,
        createdAt: DateTime.now(),
        createdBy: 'system',
      );

      await OrderService.create(order);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sipariş başarıyla oluşturuldu')),
      );
      Navigator.of(context).pop();
    }
  }

  void _scanQrForCompany() async {
    setState(() {
      selectedCompanyId = "qr_scanned_company_id";
    });
  }

  void _searchCompanyByName(String query) async {
    if (query.isNotEmpty) {
      setState(() {
        selectedCompanyId = "searched_company_id_based_on_name";
      });
    }
  }

  void _pickImages() async {
    final source = await DialogHelpers.showPhotoSourceDialog(context);
    if (source != null) {
      final picker = ImagePicker();
      final pickedFiles = source == ImageSource.camera
          ? [await picker.pickImage(source: source)].whereType<XFile>().toList()
          : await picker.pickMultiImage();

      if (pickedFiles.isNotEmpty) {
        setState(() {
          _pickedImagePaths = pickedFiles.map((e) => e.path).toList();
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _companySearchController.addListener(() {
      _searchCompanyByName(_companySearchController.text);
    });
  }

  @override
  void dispose() {
    _companySearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: Text('Yeni Sipariş Oluştur', style: GoogleFonts.poppins()),
        backgroundColor: const Color(0xFF203A43),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      TextFormField(
                        controller: _companySearchController,
                        style: GoogleFonts.poppins(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Firma Adı ile Ara',
                          labelStyle:
                              GoogleFonts.poppins(color: Colors.white70),
                          filled: true,
                          fillColor: Colors.white12,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.qr_code_scanner,
                                color: Colors.white),
                            onPressed: _scanQrForCompany,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildTextField('Ürün Adı', _productNameController),
                  const SizedBox(height: 16),
                  _buildTextField('Ağırlık (kg)', _productWeightController,
                      keyboardType: TextInputType.number),
                  const SizedBox(height: 16),
                  _buildTextField('Adet', _productCountController,
                      keyboardType: TextInputType.number),
                  const SizedBox(height: 16),
                  _buildDropdown('Birim', selectedProductType, productTypes,
                      (val) => setState(() => selectedProductType = val)),
                  const SizedBox(height: 16),
                  _buildDropdown('İşlem', selectedProcessType, processTypes,
                      (val) => setState(() => selectedProcessType = val)),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        _estimatedCompletionDateController.text =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                      }
                    },
                    child: AbsorbPointer(
                      child: _buildTextField(
                          'Tahmini Bitiş Tarihi (yyyy-MM-dd)',
                          _estimatedCompletionDateController),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildTextField('Açıklama', _orderDescriptionController,
                      maxLines: 3),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _pickImages,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    icon: const Icon(Icons.photo_library),
                    label: const Text("Fotoğraf Ekle"),
                  ),
                  if (_pickedImagePaths.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    OrderPhotoGrid(
                      imagePaths: _pickedImagePaths,
                      onTap: (path) => debugPrint('Tapped: $path'),
                      onDelete: (url) async {},
                    ),
                  ],
                  const SizedBox(height: 32),
                  Center(
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 16),
                      ),
                      child: Text('Kaydet',
                          style: GoogleFonts.poppins(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      style: GoogleFonts.poppins(color: Colors.white),
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(color: Colors.white70),
        filled: true,
        fillColor: Colors.white12,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (value) =>
          value == null || value.isEmpty ? 'Zorunlu alan' : null,
    );
  }

  Widget _buildDropdown(String label, String? value, List<String> items,
      Function(String?) onChanged,
      {bool isRequired = true}) {
    return DropdownButtonFormField<String>(
      value: value,
      dropdownColor: const Color(0xFF203A43),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(color: Colors.white70),
        filled: true,
        fillColor: Colors.white12,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      style: GoogleFonts.poppins(color: Colors.white),
      iconEnabledColor: Colors.white,
      items: items
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: onChanged,
      validator: isRequired
          ? (val) => val == null || val.isEmpty ? 'Zorunlu alan' : null
          : null,
    );
  }
}
