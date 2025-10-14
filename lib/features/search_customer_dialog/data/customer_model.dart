import 'dart:convert';

class CustomerModel {
  final String? odataContext;
  final DataResult? dataResult;
  final List<dynamic>? extensionProperties;

  CustomerModel({
    this.odataContext,
    this.dataResult,
    this.extensionProperties,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    dynamic decodedData;

    if (json['DataResult'] != null) {
      decodedData = json['DataResult'] is String
          ? jsonDecode(json['DataResult'])
          : json['DataResult'];
    }

    return CustomerModel(
      odataContext: json['@odata.context'],
      dataResult: decodedData != null
          ? DataResult.fromJson(Map<String, dynamic>.from(decodedData))
          : null,
      extensionProperties: json['ExtensionProperties'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '@odata.context': odataContext,
      'DataResult': dataResult?.toJson(),
      'ExtensionProperties': extensionProperties,
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
    dynamic payloadData = json['Payload'];

    return DataResult(
      status: json['Status'],
      message: json['Message'],
      remarks: json['Remarks'],
      errorDetails: json['ErrorDetails'],
      payload: payloadData is Map
          ? Payload.fromJson(Map<String, dynamic>.from(payloadData))
          : null, // handles empty string
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Status': status,
      'Message': message,
      'Remarks': remarks,
      'ErrorDetails': errorDetails,
      'Payload': payload?.toJson() ?? '',
    };
  }
}

class Payload {
  final int? status;
  final String? message;
  final String? remarks;
  final String? errorDetails;
  final PayloadData? payload;

  Payload({
    this.status,
    this.message,
    this.remarks,
    this.errorDetails,
    this.payload,
  });

  factory Payload.fromJson(Map<String, dynamic> json) {
    dynamic payloadData = json['Payload'];

    return Payload(
      status: json['Status'],
      message: json['Message'],
      remarks: json['Remarks'],
      errorDetails: json['ErrorDetails'],
      payload: payloadData is Map
          ? PayloadData.fromJson(Map<String, dynamic>.from(payloadData))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Status': status,
      'Message': message,
      'Remarks': remarks,
      'ErrorDetails': errorDetails,
      'Payload': payload?.toJson() ?? '',
    };
  }
}

class PayloadData {
  final List<Customer>? customer;
  final String? refNumber;
  final int? refType;

  PayloadData({
    this.customer,
    this.refNumber,
    this.refType,
  });

  factory PayloadData.fromJson(Map<String, dynamic> json) {
    return PayloadData(
      customer: json['Customer'] != null
          ? List<Customer>.from(
          json['Customer'].map((c) => Customer.fromJson(c)))
          : null,
      refNumber: json['RefNumber'],
      refType: json['RefType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Customer': customer?.map((c) => c.toJson()).toList(),
      'RefNumber': refNumber,
      'RefType': refType,
    };
  }
}

class Customer {
  final String? accountNumber;
  final String? fullName;
  final String? mobile;
  final String? email;
  final String? address;

  Customer({
    this.accountNumber,
    this.fullName,
    this.mobile,
    this.email,
    this.address,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      accountNumber: json['AccountNumber'],
      fullName: json['FullName'],
      mobile: json['Mobile'],
      email: json['Email'],
      address: json['Address'],
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