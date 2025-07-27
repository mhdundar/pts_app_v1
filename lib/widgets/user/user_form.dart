// lib/screens/users/widgets/user_form.dart

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pts_app_v1/services/user_service.dart';
import 'package:pts_app_v1/constants/order_statuses.dart';
import 'package:pts_app_v1/models/user.dart';

class UserForm extends StatefulWidget {
  final bool isEditMode;
  final String? userId;

  const UserForm({
    super.key,
    required this.isEditMode,
    this.userId,
  });

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  UserRole _selectedRole = UserRole.operator;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.isEditMode && widget.userId != null) {
      _fetchUserDetails(widget.userId!);
    }
  }

  Future<void> _fetchUserDetails(String userId) async {
    setState(() => _isLoading = true);
    final user = await UserService.getById(userId);
    if (user != null) {
      setState(() {
        _usernameController.text = user.username;
        _selectedRole = user.userRole;
      });
    }
    setState(() => _isLoading = false);
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    if (widget.isEditMode) {
      final updatedUser = User(
        id: widget.userId!,
        username: _usernameController.text.trim(),
        userRole: _selectedRole,
        name: '',
        surname: '',
        company: '',
        password: '',
        passwordSalt: '',
        email: '',
        phoneNumber: '',
        isOnline: false,
        userDeviceId: '',
        lastLoginAt: DateTime.now(),
        createdAt: DateTime.now(),
        createdBy: '',
      );
      await UserService.update(updatedUser);
    } else {
      final newUser = User(
        username: _usernameController.text.trim(),
        password: _passwordController.text.trim(),
        userRole: _selectedRole,
        name: '',
        surname: '',
        company: '',
        passwordSalt: '',
        email: '',
        phoneNumber: '',
        isOnline: false,
        userDeviceId: '',
        lastLoginAt: DateTime.now(),
        createdAt: DateTime.now(),
        createdBy: '',
      );
      await UserService.register(newUser);
    }

    if (mounted) Navigator.pop(context, true);
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF0F2027),
                  Color(0xFF203A43),
                  Color(0xFF2C5364)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        width: 500,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.isEditMode
                                    ? 'Kullanıcıyı Güncelle'
                                    : 'Yeni Kullanıcı Oluştur',
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 24),
                              TextFormField(
                                controller: _usernameController,
                                decoration: InputDecoration(
                                  labelText: 'Kullanıcı Adı',
                                  labelStyle: GoogleFonts.poppins(
                                      color: Colors.white70),
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white30),
                                  ),
                                ),
                                style: GoogleFonts.poppins(color: Colors.white),
                                validator: (value) => value!.isEmpty
                                    ? 'Kullanıcı adı gerekli'
                                    : null,
                              ),
                              const SizedBox(height: 16),
                              if (!widget.isEditMode)
                                TextFormField(
                                  controller: _passwordController,
                                  decoration: InputDecoration(
                                    labelText: 'Şifre',
                                    labelStyle: GoogleFonts.poppins(
                                        color: Colors.white70),
                                    enabledBorder: const UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white30),
                                    ),
                                  ),
                                  obscureText: true,
                                  style:
                                      GoogleFonts.poppins(color: Colors.white),
                                  validator: (value) =>
                                      value!.isEmpty ? 'Şifre gerekli' : null,
                                ),
                              if (!widget.isEditMode)
                                const SizedBox(height: 16),
                              DropdownButtonFormField<UserRole>(
                                decoration: InputDecoration(
                                  labelText: 'Rol',
                                  labelStyle: GoogleFonts.poppins(
                                      color: Colors.white70),
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white30),
                                  ),
                                ),
                                dropdownColor: Colors.blueGrey.shade800,
                                style: GoogleFonts.poppins(color: Colors.white),
                                value: _selectedRole,
                                items: UserRole.values
                                    .map((role) => DropdownMenuItem(
                                          value: role,
                                          child: Text(role.label,
                                              style: GoogleFonts.poppins()),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() => _selectedRole = value);
                                  }
                                },
                              ),
                              const SizedBox(height: 32),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _submitForm,
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    backgroundColor: Colors.teal.shade400,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    widget.isEditMode ? 'Güncelle' : 'Oluştur',
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16),
                                  ),
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

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
