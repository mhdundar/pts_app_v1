import 'package:flutter/material.dart';
import '../../models/customer.dart';
import '../../services/customer_service.dart';
import 'customer_detail_screen.dart';
import 'customer_create_screen.dart';

class CustomerListScreen extends StatefulWidget {
  const CustomerListScreen({super.key});

  @override
  State<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  late Future<List<Customer>> _future;

  @override
  void initState() {
    super.initState();
    _future = CustomerService.getAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Müşteri Listesi")),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CustomerCreateScreen()),
        ).then((_) => setState(() {
              _future = CustomerService.getAll();
            })),
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Customer>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Hata: \${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Kayıtlı müşteri yok."));
          }

          final customers = snapshot.data!;
          return ListView.builder(
            itemCount: customers.length,
            itemBuilder: (context, index) {
              final customer = customers[index];
              return ListTile(
                title: Text(customer.customerCompanyName),
                subtitle: Text(customer.customerAuthorizedPerson),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        CustomerDetailScreen(customerId: customer.customerId!),
                  ),
                ).then((_) => setState(() {
                      _future = CustomerService.getAll();
                    })),
              );
            },
          );
        },
      ),
    );
  }
}
