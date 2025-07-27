import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pts_app_v1/constants/order_statuses.dart';
import 'package:pts_app_v1/models/order_list_dto.dart';
import 'package:pts_app_v1/screens/orders/order_detail_screen.dart';
import 'package:pts_app_v1/screens/orders/order_create_screen.dart';
import 'package:pts_app_v1/services/order_service.dart';
import 'package:pts_app_v1/utils/date_formatter.dart';
import 'package:pts_app_v1/widgets/common/app_scaffold.dart';

class OrderListScreen extends StatefulWidget {
  const OrderListScreen({super.key});

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  List<OrderListDto> _orders = [];
  List<OrderListDto> _filteredOrders = [];
  bool _loading = true;

  String _searchText = '';
  DateTimeRange? _dateRange;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case OrderStatuses.receivedFromCustomer:
        return Colors.orange;
      case OrderStatuses.deliveredToGA:
        return Colors.deepOrange;
      case OrderStatuses.readyForProcess:
        return Colors.amber;
      case OrderStatuses.onProcess:
        return Colors.blue;
      case OrderStatuses.processDone:
        return Colors.lightBlue;
      case OrderStatuses.qualityCheck:
        return Colors.indigo;
      case OrderStatuses.qualityCheckReject:
        return Colors.redAccent;
      case OrderStatuses.qualityCheckDone:
        return Colors.green;
      case OrderStatuses.readyToShipping:
        return Colors.teal;
      case OrderStatuses.delivering:
        return Colors.purple;
      case OrderStatuses.delivered:
        return Colors.greenAccent;
      default:
        return Colors.grey;
    }
  }

  Future<void> _loadOrders() async {
    setState(() => _loading = true);
    try {
      final result = await OrderService.getAll();
      setState(() {
        _orders = result;
        _applyFilters();
      });
    } catch (e) {
      debugPrint("Siparişler alınamadı: $e");
    } finally {
      setState(() => _loading = false);
    }
  }

  void _applyFilters() {
    setState(() {
      _filteredOrders = _orders.where((order) {
        final matchesSearch = _searchText.isEmpty ||
            order.orderNumber.toString().contains(_searchText) ||
            (order.customerCompanyName
                    ?.toLowerCase()
                    .contains(_searchText.toLowerCase()) ??
                false) ||
            (order.productName
                    ?.toLowerCase()
                    .contains(_searchText.toLowerCase()) ??
                false);

        final matchesDate = _dateRange == null ||
            (order.createdAt.isAfter(
                    _dateRange!.start.subtract(const Duration(days: 1))) &&
                order.createdAt
                    .isBefore(_dateRange!.end.add(const Duration(days: 1))));

        return matchesSearch && matchesDate;
      }).toList();
    });
  }

  void _selectDateRange() async {
    final now = DateTime.now();
    final initialDateRange = _dateRange ??
        DateTimeRange(start: now.subtract(const Duration(days: 7)), end: now);

    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
      initialDateRange: initialDateRange,
      builder: (context, child) => Theme(data: ThemeData.dark(), child: child!),
    );

    if (picked != null) {
      setState(() {
        _dateRange = picked;
        _applyFilters();
      });
    }
  }

  void _clearDateFilter() {
    setState(() {
      _dateRange = null;
      _applyFilters();
    });
  }

  void _openOrderDetail(String orderId) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => OrderDetailScreen(orderId: orderId)),
    );

    if (result == true) {
      await _loadOrders();
    }
  }

  void _createNewOrder() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const OrderCreateScreen()),
    );
    if (result == true) {
      await _loadOrders();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewOrder,
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Sipariş no, müşteri, ürün...",
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white12,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchText = value;
                        _applyFilters();
                      });
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _dateRange == null
                              ? "Tarih filtresi yok"
                              : "${DateFormat('dd.MM.yyyy').format(_dateRange!.start)} - ${DateFormat('dd.MM.yyyy').format(_dateRange!.end)}",
                          style: GoogleFonts.poppins(color: Colors.white70),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: _selectDateRange,
                        icon:
                            const Icon(Icons.date_range, color: Colors.white70),
                        label: Text("Tarih Seç",
                            style: GoogleFonts.poppins(color: Colors.white70)),
                      ),
                      if (_dateRange != null)
                        IconButton(
                          icon:
                              const Icon(Icons.clear, color: Colors.redAccent),
                          onPressed: _clearDateFilter,
                        )
                    ],
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _loadOrders,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: _filteredOrders.length,
                      itemBuilder: (context, index) {
                        final order = _filteredOrders[index];
                        return GestureDetector(
                          onTap: () => _openOrderDetail(order.id),
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white10,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: Colors.white24),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "#${order.orderNumber}",
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: _getStatusColor(order.status),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        OrderStatuses.label(order.status),
                                        style: GoogleFonts.poppins(
                                            fontSize: 12, color: Colors.white),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 10,
                                  runSpacing: 4,
                                  children: [
                                    if (order.productName != null)
                                      _infoChip(Icons.inventory_2,
                                          order.productName!),
                                    if (order.productType != null)
                                      _infoChip(Icons.format_list_bulleted,
                                          order.productType!),
                                    if (order.processType != null)
                                      _infoChip(
                                          Icons.build, order.processType!),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 10,
                                  runSpacing: 4,
                                  children: [
                                    if (order.customerCompanyName != null)
                                      _infoChip(Icons.person_outline,
                                          order.customerCompanyName!),
                                    if (order.createdByUserName != null)
                                      _infoChip(Icons.account_circle,
                                          order.createdByUserName!),
                                    _infoChip(Icons.calendar_today,
                                        formatDate(order.createdAt)),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Icon(
                                      order.isActive
                                          ? Icons.check_circle
                                          : Icons.cancel,
                                      color: order.isActive
                                          ? Colors.green
                                          : Colors.red,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      order.isActive ? "Aktif" : "Pasif",
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        color: order.isActive
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _infoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white70),
          const SizedBox(width: 4),
          Text(
            text,
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
