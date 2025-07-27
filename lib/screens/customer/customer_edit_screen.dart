import 'package:flutter/material.dart';
import '../../models/customer.dart';
import '../../services/customer_service.dart';
import 'package:pts_app_v1/widgets/common/app_scaffold.dart';

class CustomerEditScreen extends StatefulWidget {
  final Customer customer;

  const CustomerEditScreen({super.key, required this.customer});

  @override
  State<CustomerEditScreen> createState() => _CustomerEditScreenState();
}

class _CustomerEditScreenState extends State<CustomerEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _authCtrl;
  late TextEditingController _contactCtrl;
  late TextEditingController _addressCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _phoneCtrl;
  late bool _isActive;

  @override
  void initState() {
    final c = widget.customer;
    _nameCtrl = TextEditingController(text: c.customerCompanyName);
    _authCtrl = TextEditingController(text: c.customerAuthorizedPerson);
    _contactCtrl = TextEditingController(text: c.customerContactInfo);
    _addressCtrl = TextEditingController(text: c.customerAddress);
    _emailCtrl = TextEditingController(text: c.customerEmail);
    _phoneCtrl = TextEditingController(text: c.customerPhoneNumber);
    _isActive = c.customerIsActive;
    super.initState();
  }

  Future<void> _update() async {
    if (_formKey.currentState!.validate()) {
      final updated = Customer(
        customerId: widget.customer.customerId,
        customerCompanyCode: widget.customer.customerCompanyCode,
        customerCompanyName: _nameCtrl.text,
        customerAuthorizedPerson: _authCtrl.text,
        customerContactInfo: _contactCtrl.text,
        customerAddress: _addressCtrl.text,
        customerEmail: _emailCtrl.text,
        customerPhoneNumber: _phoneCtrl.text,
        customerOrderHistory: widget.customer.customerOrderHistory,
        customerIsActive: _isActive,
        customerCreatedAt: widget.customer.customerCreatedAt,
        customerCreatedBy: widget.customer.customerCreatedBy,
        customerUpdatedAt: DateTime.now(),
        customerUpdatedBy: null, // opsiyonel
      );

      await CustomerService.update(widget.customer.customerId!, updated);
      if (mounted) Navigator.pop(context, true);
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
    return AppScaffold(
      appBar: AppBar(title: const Text("Müşteri Güncelle")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(children: [
            TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: "Firma Adı"),
                validator: (v) => v!.isEmpty ? "Gerekli" : null),
            TextFormField(
                controller: _authCtrl,
                decoration: const InputDecoration(labelText: "Yetkili Kişi")),
            TextFormField(
                controller: _contactCtrl,
                decoration: const InputDecoration(labelText: "İletişim")),
            TextFormField(
                controller: _addressCtrl,
                decoration: const InputDecoration(labelText: "Adres")),
            TextFormField(
                controller: _emailCtrl,
                decoration: const InputDecoration(labelText: "Email")),
            TextFormField(
                controller: _phoneCtrl,
                decoration: const InputDecoration(labelText: "Telefon")),
            SwitchListTile(
                value: _isActive,
                onChanged: (v) => setState(() => _isActive = v),
                title: const Text("Aktif mi?")),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _update, child: const Text("Güncelle")),
          ]),
        ),
      ),
    );
  }
}
