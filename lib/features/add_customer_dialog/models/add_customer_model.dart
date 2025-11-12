import 'dart:convert';

class AddCustomerModel {
  final String? odataContext;
  final DataResult? dataResult;
  // final List<dynamic>? extensionProperties;

  AddCustomerModel({
    this.odataContext,
    this.dataResult,
    // this.extensionProperties,
  });

  factory AddCustomerModel.fromJson(Map<String, dynamic> json) {
    dynamic dataResultJson = json['DataResult'];
    if (dataResultJson is String) {
      dataResultJson = jsonDecode(dataResultJson);
    }

    return AddCustomerModel(
      odataContext: json['@odata.context'] as String?,
      dataResult:
      dataResultJson != null ? DataResult.fromJson(dataResultJson) : null,
      // extensionProperties: json['ExtensionProperties'] != null
      //     ? List<dynamic>.from(json['ExtensionProperties'])
      //     : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '@odata.context': odataContext,
      'DataResult': dataResult?.toJson(),
      // 'ExtensionProperties': extensionProperties,
    };
  }
}

class DataResult {
  final int? status;
  final String? message;
  final String? remarks;
  final String? errorDetails;
  final Payload? payload;

  DataResult({
    this.status,
    this.message,
    this.remarks,
    this.errorDetails,
    this.payload,
  });

  factory DataResult.fromJson(Map<String, dynamic> json) {
    return DataResult(
      status: json['Status'] as int?,
      message: json['Message'] as String?,
      remarks: json['Remarks'] as String?,
      errorDetails: json['ErrorDetails'] as String?,
      payload:
      json['Payload'] != null ? Payload.fromJson(json['Payload']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Status': status,
      'Message': message,
      'Remarks': remarks,
      'ErrorDetails': errorDetails,
      'Payload': payload?.toJson(),
    };
  }
}

class Payload {
  final int? status;
  final String? message;
  final String? remarks;
  final String? errorDetails;
  final PayloadCustomer? payload;

  Payload({
    this.status,
    this.message,
    this.remarks,
    this.errorDetails,
    this.payload,
  });

  factory Payload.fromJson(Map<String, dynamic> json) {
    return Payload(
      status: json['Status'] as int?,
      message: json['Message'] as String?,
      remarks: json['Remarks'] as String?,
      errorDetails: json['ErrorDetails'] as String?,
      payload: json['Payload'] != null
          ? PayloadCustomer.fromJson(json['Payload'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Status': status,
      'Message': message,
      'Remarks': remarks,
      'ErrorDetails': errorDetails,
      'Payload': payload?.toJson(),
    };
  }
}

class PayloadCustomer {
  final CustomerData? customer;
  final String? refNumber;
  final int? refType;

  PayloadCustomer({
    this.customer,
    this.refNumber,
    this.refType,
  });

  factory PayloadCustomer.fromJson(Map<String, dynamic> json) {
    return PayloadCustomer(
      // 🔥 FIXED: Use correct key 'Customer' instead of 'CustomerData'
      customer:
      json['Customer'] != null ? CustomerData.fromJson(json['Customer']) : null,
      refNumber: json['RefNumber'] as String?,
      refType: json['RefType'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Customer': customer?.toJson(),
      'RefNumber': refNumber,
      'RefType': refType,
    };
  }
}

class CustomerData {
  final String? accountNumber;
  final String? fullName;
  final String? mobile;
  final String? email;
  final String? address;

  CustomerData({
    this.accountNumber,
    this.fullName,
    this.mobile,
    this.email,
    this.address,
  });

  factory CustomerData.fromJson(Map<String, dynamic> json) {
    return CustomerData(
      accountNumber: json['AccountNumber'] as String?,
      fullName: json['FullName'] as String?,
      mobile: json['Mobile'] as String?,
      email: json['Email'] as String?,
      address: json['Address'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'AccountNumber': accountNumber,
      'FullName': fullName,
      'Mobile': mobile,
      'Email': email,
      'Address': address,
    };
  }
}
