import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pts_app_v1/models/company.dart';
import 'package:pts_app_v1/services/company_service.dart';
import 'package:pts_app_v1/utils/secure_storage.dart';
import 'package:pts_app_v1/widgets/common/app_scaffold.dart';

class CompanyEditScreen extends StatefulWidget {
  final Company company;

  const CompanyEditScreen({super.key, required this.company});

  @override
  State<CompanyEditScreen> createState() => _CompanyEditScreenState();
}

class _CompanyEditScreenState extends State<CompanyEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  DateTime? _lsd;
  DateTime? _led;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.company.companyName);
    _lsd = widget.company.lsd;
    _led = widget.company.led;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _lsd == null || _led == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Tüm alanları doldurun")));
      return;
    }

    final updatedBy = await SecureStorage.readUserId();

    final updatedCompany = Company(
      id: widget.company.id,
      companyName: _nameController.text.trim(),
      companyCode: widget.company.companyCode, // 🔒 değiştirilemez
      lsd: _lsd!,
      led: _led!,
      isActive: widget.company.isActive,
      createdAt: widget.company.createdAt,
      createdBy: widget.company.createdBy,
      updatedAt: DateTime.now(),
      updatedBy: updatedBy,
    );

    await CompanyService.update(updatedCompany.id!, updatedCompany);

    if (mounted) Navigator.pop(context, true);
  }

  Future<void> _pickDate(BuildContext context, bool isStart) async {
    final initial = isStart ? _lsd : _led;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _lsd = picked;
        } else {
          _led = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('dd.MM.yyyy');

    return AppScaffold(
      appBar: AppBar(title: const Text("Şirket Güncelle")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Şirket Adı"),
                validator: (val) =>
                    val == null || val.isEmpty ? "Zorunlu alan" : null,
              ),
              const SizedBox(height: 12),
              ListTile(
                title: Text("Kod: ${widget.company.companyCode}"),
                leading: const Icon(Icons.qr_code),
              ),
              ListTile(
                title: Text("Lisans Başlangıç: ${df.format(_lsd!)}"),
                trailing: const Icon(Icons.edit_calendar),
                onTap: () => _pickDate(context, true),
              ),
              ListTile(
                title: Text("Lisans Bitiş: ${df.format(_led!)}"),
                trailing: const Icon(Icons.edit_calendar),
                onTap: () => _pickDate(context, false),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text("Kaydet"),
                onPressed: _submit,
              )
            ],
          ),
        ),
      ),
    );
  }
}
