import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/customer.dart';
import '../../services/customer_service.dart';

class CustomerCreateScreen extends StatefulWidget {
  const CustomerCreateScreen({super.key});

  @override
  State<CustomerCreateScreen> createState() => _CustomerCreateScreenState();
}

class _CustomerCreateScreenState extends State<CustomerCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _authCtrl = TextEditingController();
  final _contactCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  bool _isActive = true;

  Future<void> _save() async {
    if (_formKey.currentState!.validate()) {
      final now = DateTime.now();
      final customer = Customer(
        customerCompanyCode: "",
        customerCompanyName: _nameCtrl.text,
        customerAuthorizedPerson: _authCtrl.text,
        customerContactInfo: _contactCtrl.text,
        customerAddress: _addressCtrl.text,
        customerEmail: _emailCtrl.text,
        customerPhoneNumber: _phoneCtrl.text,
        customerOrderHistory: [],
        customerIsActive: _isActive,
        customerCreatedAt: now,
        customerCreatedBy: "",
      );
      await CustomerService.create(customer);
      if (!mounted) return;
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _authCtrl.dispose();
    _contactCtrl.dispose();
    _addressCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Yeni Müşteri"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1E1E2C), Color(0xFF2D2D44)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(18),
                    border:
                        Border.all(color: Colors.white.withValues(alpha: 0.1)),
                  ),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        _buildTextField(_nameCtrl, "Firma Adı", true),
                        _buildTextField(_authCtrl, "Yetkili Kişi"),
                        _buildTextField(_contactCtrl, "İletişim"),
                        _buildTextField(_addressCtrl, "Adres"),
                        _buildTextField(_emailCtrl, "Email"),
                        _buildTextField(_phoneCtrl, "Telefon"),
                        SwitchListTile(
                          title: Text("Aktif mi?",
                              style: GoogleFonts.poppins(color: Colors.white)),
                          value: _isActive,
                          onChanged: (val) => setState(() {
                            _isActive = val;
                          }),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _save,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            "Kaydet",
                            style: GoogleFonts.poppins(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        )
                      ],
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

  Widget _buildTextField(TextEditingController controller, String label,
      [bool required = false]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        style: GoogleFonts.poppins(color: Colors.white),
        validator:
            required ? (v) => v == null || v.isEmpty ? "Gerekli" : null : null,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(color: Colors.white70),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white24),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blueAccent),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
