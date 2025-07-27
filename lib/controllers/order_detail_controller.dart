import 'dart:io';
import 'package:pts_app_v1/models/order.dart';
import 'package:pts_app_v1/models/order_details_dto.dart';
import 'package:pts_app_v1/services/order_service.dart';
import 'package:pts_app_v1/services/photo_service.dart';

class OrderDetailController {
  static Future<OrderDetailsDto?> fetchOrder(String orderId) async {
    try {
      return await OrderService.getDetails(orderId);
    } catch (e) {
      return null;
    }
  }

  static Future<bool> updateStatus(String orderId, String newStatus) async {
    try {
      await OrderService.updateStatus(orderId, newStatus);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> uploadPhotos(String orderId, List<File> files) async {
    try {
      await PhotoService.uploadPhotos(orderId, files);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> deletePhoto(String orderId, String url) async {
    try {
      await PhotoService.deletePhoto(orderId, url);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> splitAndUpdate(
    Order originalOrderUpdated,
    Order newOrder,
  ) async {
    try {
      // 1. Orijinal siparişi güncelle
      await OrderService.update(originalOrderUpdated.id!, originalOrderUpdated);

      // 2. Yeni siparişi oluştur
      await OrderService.create(newOrder);

      return true;
    } catch (e) {
      return false;
    }
  }
}
