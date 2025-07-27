import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pts_app_v1/models/company.dart';
import 'package:pts_app_v1/services/company_service.dart';
import 'package:pts_app_v1/utils/secure_storage.dart';

class CompanyCreateScreen extends StatefulWidget {
  final Company? companyToEdit;
  const CompanyCreateScreen({super.key, this.companyToEdit});

  @override
  State<CompanyCreateScreen> createState() => _CompanyCreateScreenState();
}

class _CompanyCreateScreenState extends State<CompanyCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  DateTime? _lsd;
  DateTime? _led;
  bool _isSubmitting = false;

  bool get isEditMode => widget.companyToEdit != null;

  @override
  void initState() {
    super.initState();
    if (isEditMode) {
      final c = widget.companyToEdit!;
      _nameController.text = c.companyName;
      _lsd = c.lsd;
      _led = c.led;
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _lsd == null || _led == null) {
      return;
    }

    final currentUserId = await SecureStorage.readUserId();

    final newCompany = Company(
      id: widget.companyToEdit?.id,
      companyName: _nameController.text.trim(),
      companyCode: widget.companyToEdit?.companyCode ?? "", // backend set
      lsd: _lsd!,
      led: _led!,
      isActive: true,
      createdBy: widget.companyToEdit?.createdBy ?? currentUserId ?? "system",
      createdAt: widget.companyToEdit?.createdAt ?? DateTime.now(),
      updatedBy: currentUserId,
      updatedAt: DateTime.now(),
    );

    setState(() => _isSubmitting = true);
    try {
      if (isEditMode) {
        await CompanyService.update(newCompany.id!, newCompany);
      } else {
        await CompanyService.create(newCompany);
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text(isEditMode ? "Şirket güncellendi." : "Şirket oluşturuldu."),
          backgroundColor: Colors.green,
        ));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Hata: $e"),
          backgroundColor: Colors.red,
        ));
      }
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  Future<void> _pickDate(bool isStart) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? (_lsd ?? now) : (_led ?? now),
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 10),
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

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        border: const OutlineInputBorder(),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white38),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
      validator: (value) =>
          value == null || value.isEmpty ? "Zorunlu alan" : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    width: 450,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isEditMode ? Icons.edit : Icons.business,
                            size: 64,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            isEditMode
                                ? "Şirketi Güncelle"
                                : "Yeni Şirket Oluştur",
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 24),
                          _buildTextField("Şirket Adı", _nameController),
                          const SizedBox(height: 16),
                          _buildDatePicker("Lisans Başlangıç Tarihi", _lsd,
                              () => _pickDate(true)),
                          const SizedBox(height: 16),
                          _buildDatePicker("Lisans Bitiş Tarihi", _led,
                              () => _pickDate(false)),
                          const SizedBox(height: 24),
                          _isSubmitting
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: _submit,
                                    icon: Icon(
                                        isEditMode ? Icons.save : Icons.add),
                                    label: Text(
                                        isEditMode ? "Güncelle" : "Oluştur"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blueAccent,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 14),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker(String label, DateTime? date, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white),
          border: const OutlineInputBorder(),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white38),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
        child: Text(
          date != null
              ? date.toLocal().toString().split(" ")[0]
              : "Tarih seçin",
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
