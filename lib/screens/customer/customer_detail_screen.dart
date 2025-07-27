import 'package:flutter/material.dart';
import '../../models/customer.dart';
import '../../services/customer_service.dart';
import 'customer_edit_screen.dart';

class CustomerDetailScreen extends StatefulWidget {
  final String customerId;
  const CustomerDetailScreen({super.key, required this.customerId});

  @override
  State<CustomerDetailScreen> createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen> {
  late Future<Customer> _future;

  @override
  void initState() {
    super.initState();
    _future = CustomerService.getById(widget.customerId);
  }

  Future<void> _deleteCustomer() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Müşteri Sil"),
        content: const Text("Bu müşteriyi silmek istediğinizden emin misiniz?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Vazgeç")),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Sil")),
        ],
      ),
    );

    if (confirmed == true) {
      await CustomerService.delete(widget.customerId);
      if (mounted) Navigator.pop(context); // Liste ekranına geri dön
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Müşteri Detayı")),
      body: FutureBuilder<Customer>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final c = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                Text("Firma: ${c.customerCompanyName}",
                    style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 8),
                Text("Yetkili: ${c.customerAuthorizedPerson}"),
                Text("İletişim: ${c.customerContactInfo}"),
                Text("Adres: ${c.customerAddress}"),
                Text("Email: ${c.customerEmail}"),
                Text("Telefon: ${c.customerPhoneNumber}"),
                Text("Durum: ${c.customerIsActive ? "Aktif" : "Pasif"}"),
                Text("Oluşturma: ${c.customerCreatedAt.toLocal()}"),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.edit),
                        label: const Text("Güncelle"),
                        onPressed: () async {
                          final updated = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CustomerEditScreen(customer: c),
                            ),
                          );
                          if (updated == true) {
                            setState(() => _future =
                                CustomerService.getById(c.customerId!));
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.delete),
                        label: const Text("Sil"),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                        onPressed: _deleteCustomer,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
