import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pts_app_v1/constants/order_statuses.dart';
import 'package:pts_app_v1/models/user.dart';
import 'package:pts_app_v1/models/company.dart';
import 'package:pts_app_v1/services/user_service.dart';
import 'package:pts_app_v1/services/company_service.dart';
import 'package:pts_app_v1/utils/secure_storage.dart';

class UserCreateScreen extends StatefulWidget {
  final User? userToEdit;

  const UserCreateScreen({super.key, this.userToEdit});

  @override
  State<UserCreateScreen> createState() => _UserCreateScreenState();
}

class _UserCreateScreenState extends State<UserCreateScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  String _selectedRole = 'Employee';
  String? _selectedCompanyId;
  List<Company> _companies = [];

  bool _isSubmitting = false;
  bool _isAdmin = false;

  bool get isEditMode => widget.userToEdit != null;

  final List<String> _roles = [
    'Admin',
    'Manager',
    'Employee',
    'Customer',
    'Operator',
    'Driver',
    'Logistics',
  ];

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  Future<void> _initializeForm() async {
    final user = widget.userToEdit;
    final role = await SecureStorage.readRole();
    _isAdmin = role?.toLowerCase() == 'admin';

    if (_isAdmin) {
      _companies = await CompanyService.getAll();
    }

    if (user != null) {
      _nameController.text = user.name;
      _surnameController.text = user.surname;
      _usernameController.text = user.username;
      _emailController.text = user.email;
      _phoneController.text = user.phoneNumber;
      _selectedRole = user.userRole.name;
      _selectedCompanyId = user.company;
    } else {
      _selectedCompanyId = await SecureStorage.readCompanyId();
    }

    setState(() {});
  }

  UserRole parseUserRole(String role) {
    return UserRole.values.firstWhere(
      (e) => e.name.toLowerCase() == role.toLowerCase(),
      orElse: () => UserRole.employee,
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (!isEditMode &&
        _passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Şifreler eşleşmiyor"),
        backgroundColor: Colors.red,
      ));
      return;
    }

    final currentUserId = await SecureStorage.readUserId();

    final user = User(
      id: widget.userToEdit?.id,
      name: _nameController.text.trim(),
      surname: _surnameController.text.trim(),
      company: _selectedCompanyId ?? "0000",
      username: _usernameController.text.trim(),
      password: isEditMode ? "" : _passwordController.text.trim(),
      passwordSalt: "",
      email: _emailController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      userRole: parseUserRole(_selectedRole),
      isOnline: false,
      userDeviceId: "",
      lastLoginAt: DateTime.now(),
      createdAt: widget.userToEdit?.createdAt ?? DateTime.now(),
      createdBy: widget.userToEdit?.createdBy ?? currentUserId ?? "system",
      updatedAt: DateTime.now(),
      updatedBy: currentUserId,
    );

    setState(() => _isSubmitting = true);

    try {
      if (isEditMode) {
        await UserService.update(user);
      } else {
        await UserService.register(user);
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(isEditMode
              ? "Kullanıcı güncellendi."
              : "Kullanıcı başarıyla eklendi."),
          backgroundColor: Colors.green,
        ));
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Hata oluştu: $e"),
        backgroundColor: Colors.red,
      ));
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool obscure = false,
    int minLength = 1,
    TextInputType? inputType,
    bool enabled = true,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: inputType,
      enabled: enabled,
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
          value == null || value.length < minLength ? "Zorunlu alan" : null,
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
                      color: Colors.white.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isEditMode
                                ? Icons.person_outline
                                : Icons.person_add_alt_1,
                            size: 64,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            isEditMode
                                ? "Kullanıcıyı Güncelle"
                                : "Yeni Kullanıcı Oluştur",
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 24),
                          _buildTextField(
                              controller: _nameController, label: "Ad"),
                          const SizedBox(height: 16),
                          _buildTextField(
                              controller: _surnameController, label: "Soyad"),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: _usernameController,
                            label: "Kullanıcı Adı",
                            enabled: !isEditMode,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: _emailController,
                            label: "E-posta",
                            inputType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: _phoneController,
                            label: "Telefon",
                            inputType: TextInputType.phone,
                          ),
                          const SizedBox(height: 16),
                          if (!isEditMode) ...[
                            _buildTextField(
                              controller: _passwordController,
                              label: "Şifre",
                              obscure: true,
                              minLength: 4,
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              controller: _confirmPasswordController,
                              label: "Şifre Tekrar",
                              obscure: true,
                              minLength: 4,
                            ),
                            const SizedBox(height: 16),
                          ],
                          if (_isAdmin) ...[
                            DropdownButtonFormField<String>(
                              dropdownColor: Colors.blueGrey[900],
                              value: _selectedCompanyId ??
                                  (_companies.isNotEmpty
                                      ? _companies.first.id
                                      : null),
                              items: _companies
                                  .map((c) => DropdownMenuItem(
                                        value: c.id,
                                        child: Text(
                                          c.companyName,
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (val) =>
                                  setState(() => _selectedCompanyId = val),
                              decoration: const InputDecoration(
                                labelText: "Şirket",
                                labelStyle: TextStyle(color: Colors.white),
                                border: OutlineInputBorder(),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white38),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                          DropdownButtonFormField<String>(
                            dropdownColor: Colors.blueGrey[900],
                            value: _roles.contains(_selectedRole)
                                ? _selectedRole
                                : _roles.first,
                            items: _roles
                                .map((role) => DropdownMenuItem(
                                      value: role,
                                      child: Text(
                                        role,
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ))
                                .toList(),
                            onChanged: (val) =>
                                setState(() => _selectedRole = val!),
                            decoration: const InputDecoration(
                              labelText: "Rol",
                              labelStyle: TextStyle(color: Colors.white),
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white38),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          _isSubmitting
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : SizedBox(
                                  width: double.infinity,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      ElevatedButton.icon(
                                        onPressed: () => Navigator.pop(context),
                                        icon: const Icon(Icons.arrow_back),
                                        label: const Text("Back"),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blueAccent,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 24, vertical: 14),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                      ),
                                      ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blueAccent,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 24, vertical: 14),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                        onPressed: _submit,
                                        icon: Icon(isEditMode
                                            ? Icons.edit
                                            : Icons.save),
                                        label: Text(
                                          isEditMode ? "Güncelle" : "Kaydet",
                                          style:
                                              GoogleFonts.poppins(fontSize: 16),
                                        ),
                                      ),
                                    ],
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
}
