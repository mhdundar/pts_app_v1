import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pts_app_v1/models/order_details_dto.dart';
import 'package:pts_app_v1/constants/order_statuses.dart';
import 'package:pts_app_v1/utils/date_formatter.dart';

class OrderInfoCard extends StatelessWidget {
  final OrderDetailsDto order;

  const OrderInfoCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final spacingSmall = screenHeight * 0.01; // ~8 px
    final spacingMedium = screenHeight * 0.015; // ~12 px

    return Container(
      width: screenWidth,
      margin: EdgeInsets.symmetric(vertical: spacingSmall),
      child: Card(
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        elevation: 0,
        color: Colors.white.withValues(alpha: 0.05),
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("#${order.orderNumber}",
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  )),
              SizedBox(height: spacingMedium),
              _info("Ürün", order.productName),
              _info("Miktar", order.productWeight?.toString()),
              _info("Birim", order.productType),
              _info("İşlem", order.processType),
              SizedBox(height: spacingSmall),
              _info("Durum", OrderStatuses.label(order.status)),
              _info("Müşteri", order.createdByUserName),
              _info("Firma", order.customerCompanyName),
              _info("Tarih", formatDateTime(order.createdAt)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _info(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        "$title: ${value ?? '-'}",
        style: GoogleFonts.poppins(
          fontSize: 14,
          color: Colors.white,
        ),
      ),
    );
  }
}
