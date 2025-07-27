import 'package:flutter/material.dart';
import 'package:pts_app_v1/models/company.dart';
import 'package:pts_app_v1/services/company_service.dart';
import 'package:pts_app_v1/utils/date_formatter.dart';
import 'package:pts_app_v1/utils/jwt_helper.dart';
import 'package:pts_app_v1/utils/secure_storage.dart';

class CompanyFormModal extends StatefulWidget {
  final Company? initialData;
  final void Function()? onSuccess;

  const CompanyFormModal({super.key, this.initialData, this.onSuccess});

  @override
  State<CompanyFormModal> createState() => _CompanyFormModalState();
}

class _CompanyFormModalState extends State<CompanyFormModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _codeController;
  DateTime? _lsd;
  DateTime? _led;

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.initialData?.companyName ?? '');
    _codeController =
        TextEditingController(text: widget.initialData?.companyCode ?? '');
    _lsd = widget.initialData?.lsd;
    _led = widget.initialData?.led;
  }

  Future<void> _pickDate(BuildContext context, bool isStart) async {
    final initialDate = isStart
        ? _lsd ?? DateTime.now()
        : _led ?? DateTime.now().add(const Duration(days: 30));
    final newDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (newDate != null) {
      setState(() {
        if (isStart) {
          _lsd = newDate;
        } else {
          _led = newDate;
        }
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_lsd == null || _led == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Lisans tarihleri seçilmeli.")));
      return;
    }

    setState(() => _isSubmitting = true);

    final token = await SecureStorage.readAccessToken();
    final userId = JwtHelper.getUserId(token!);

    final company = Company(
      id: widget.initialData?.id,
      companyName: _nameController.text.trim(),
      companyCode: _codeController.text.trim(),
      lsd: _lsd!,
      led: _led!,
      isActive: true,
      createdAt: DateTime.now(),
      createdBy: userId ?? "unknown",
    );

    try {
      if (widget.initialData == null) {
        await CompanyService.create(company);
      } else {
        await CompanyService.update(company.id!, company);
      }

      if (!mounted) return;
      Navigator.of(context).pop();
      widget.onSuccess?.call();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("İşlem başarısız: $e")));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
          widget.initialData == null ? "Yeni Firma Ekle" : "Firma Güncelle"),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Firma Adı"),
              validator: (v) => v == null || v.isEmpty ? "Zorunlu alan" : null,
            ),
            TextFormField(
              controller: _codeController,
              decoration: const InputDecoration(labelText: "Firma Kodu"),
              validator: (v) => v == null || v.isEmpty ? "Zorunlu alan" : null,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _pickDate(context, true),
                    child: InputDecorator(
                      decoration:
                          const InputDecoration(labelText: "Lisans Başlangıç"),
                      child: Text(
                          _lsd != null ? formatDate(_lsd!) : "Tarih seçin"),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: InkWell(
                    onTap: () => _pickDate(context, false),
                    child: InputDecorator(
                      decoration:
                          const InputDecoration(labelText: "Lisans Bitiş"),
                      child: Text(
                          _led != null ? formatDate(_led!) : "Tarih seçin"),
                    ),
                  ),
                ),
              ],
            ),
          ]),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
          child: const Text("İptal"),
        ),
        ElevatedButton(
          onPressed: _isSubmitting ? null : _submit,
          child: Text(_isSubmitting ? "Kaydediliyor..." : "Kaydet"),
        ),
      ],
    );
  }
}
