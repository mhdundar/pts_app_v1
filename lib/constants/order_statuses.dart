enum UserRole {
  admin,
  manager,
  employee,
  customer,
  operator,
  driver,
  logistics,
}

extension UserRoleExtension on UserRole {
  String get label {
    switch (this) {
      case UserRole.admin:
        return 'Admin';
      case UserRole.manager:
        return 'Manager';
      case UserRole.customer:
        return 'Customer';
      case UserRole.employee:
        return 'Employee';
      case UserRole.operator:
        return 'Operator';
      case UserRole.driver:
        return 'Driver';
      case UserRole.logistics:
        return 'Logistics';
    }
  }

  String toShortString() {
    return toString().split('.').last;
  }
}

class OrderStatuses {
  static const receivedFromCustomer = 'ReceivedFromCustomer';
  static const deliveredToGA = 'DeliveredToGA';
  static const readyForProcess = 'ReadyForProcess';
  static const onProcess = 'OnProcess';
  static const processDone = 'ProcessDone';
  static const qualityCheck = 'QualityCheck';
  static const qualityCheckReject = 'QualityCheckReject';
  static const qualityCheckDone = 'QualityCheckDone';
  static const readyToShipping = 'ReadyToShipping';
  static const delivering = 'Delivering';
  static const delivered = 'Delivered';

  static const all = [
    receivedFromCustomer,
    deliveredToGA,
    readyForProcess,
    onProcess,
    processDone,
    qualityCheck,
    qualityCheckReject,
    qualityCheckDone,
    readyToShipping,
    delivering,
    delivered,
  ];

  static const _intToName = {
    0: receivedFromCustomer,
    1: deliveredToGA,
    2: readyForProcess,
    3: onProcess,
    4: processDone,
    5: qualityCheck,
    6: qualityCheckReject,
    7: qualityCheckDone,
    8: readyToShipping,
    9: delivering,
    10: delivered,
  };

  static String label(dynamic status) {
    String? name;
    if (status is int) {
      name = _intToName[status];
    } else {
      name = status.toString();
    }

    switch (name) {
      case receivedFromCustomer:
        return "Müşteriden Alındı";
      case deliveredToGA:
        return "Lojistik Teslim Aldı";
      case readyForProcess:
        return "İşlemeye Hazır";
      case onProcess:
        return "İşlemde";
      case processDone:
        return "İşlem Tamamlandı";
      case qualityCheck:
        return "Kalite Kontrol";
      case qualityCheckReject:
        return "Kalite Red";
      case qualityCheckDone:
        return "Kalite Onaylandı";
      case readyToShipping:
        return "Sevke Hazır";
      case delivering:
        return "Sevkiyat Başladı";
      case delivered:
        return "Teslim Edildi";
      default:
        return name ?? 'Bilinmiyor';
    }
  }

  static Map<String, dynamic>? nextStatus(String current) => {
        receivedFromCustomer: {
          "next": deliveredToGA,
          "label": "Lojistik Teslim Aldı"
        },
        deliveredToGA: {"next": readyForProcess, "label": "İşlemeye Hazır"},
        readyForProcess: {"next": onProcess, "label": "İşlem Başlat"},
        onProcess: {"next": processDone, "label": "İşlem Tamamla"},
        processDone: {"next": qualityCheck, "label": "Kaliteye Gönder"},
        qualityCheck: {"next": qualityCheckDone, "label": "Onayla"},
        qualityCheckDone: {"next": readyToShipping, "label": "Kargoya Hazırla"},
        readyToShipping: {"next": delivering, "label": "Sevkiyata Başla"},
        delivering: {"next": delivered, "label": "Teslim Et"},
      }[current];
}

class OrderStatusRoles {
  static List<UserRole> getAllowedRoles(String status) {
    switch (status) {
      case OrderStatuses.deliveredToGA:
        return [
          UserRole.admin,
          UserRole.logistics,
          UserRole.employee,
          UserRole.manager
        ];
      case OrderStatuses.readyForProcess:
      case OrderStatuses.onProcess:
      case OrderStatuses.processDone:
        return [
          UserRole.admin,
          UserRole.logistics,
          UserRole.employee,
          UserRole.manager
        ];
      case OrderStatuses.qualityCheck:
      case OrderStatuses.qualityCheckReject:
      case OrderStatuses.qualityCheckDone:
        return [
          UserRole.admin,
          UserRole.logistics,
          UserRole.employee,
          UserRole.manager
        ];
      case OrderStatuses.readyToShipping:
        return [
          UserRole.admin,
          UserRole.logistics,
          UserRole.employee,
          UserRole.manager
        ];
      case OrderStatuses.delivering:
      case OrderStatuses.delivered:
        return [
          UserRole.admin,
          UserRole.logistics,
          UserRole.employee,
          UserRole.manager
        ];
      default:
        return [UserRole.admin, UserRole.manager, UserRole.employee];
    }
  }
}
