import 'dart:convert';

class CustomerModel {
  String? odataContext;
  DataResult? dataResult;

  CustomerModel({this.odataContext, this.dataResult,});

  CustomerModel.fromJson(Map<String, dynamic> json) {
    odataContext = json['@odata.context'];
    /*dataResult = json['DataResult'] != null
        ? DataResult.fromJson(json['DataResult'])
        : null;*/
    if (json['DataResult'] != null) {
      final decodedData = json['DataResult'] is String
          ? jsonDecode(json['DataResult']) // decode string → Map
          : json['DataResult'];

      dataResult = DataResult.fromJson(decodedData);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['@odata.context'] = odataContext;
    if (dataResult != null) {
      data['DataResult'] = dataResult!.toJson();
    }
    /*if (extensionProperties != null) {
      data['ExtensionProperties'] =
          extensionProperties!.map((v) => v.toJson()).toList();
    }*/
    return data;
  }
}

class DataResult {
  int? status;
  String? message;
  String? remarks;
  String? errorDetails;
  OuterPayload? payload;

  DataResult(
      {this.status,
        this.message,
        this.remarks,
        this.errorDetails,
        this.payload});

  DataResult.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Message'];
    remarks = json['Remarks'];
    errorDetails = json['ErrorDetails'];
    payload = json['Payload'] != null
        ? OuterPayload.fromJson(json['Payload'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Status'] = status;
    data['Message'] = message;
    data['Remarks'] = remarks;
    data['ErrorDetails'] = errorDetails;
    if (payload != null) {
      data['Payload'] = payload!.toJson();
    }
    return data;
  }
}

class OuterPayload{
  int? status;
  String? message;
  String? remarks;
  String? errorDetails;
  Payload? payload;

  OuterPayload.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Message'];
    remarks = json['Remarks'];
    errorDetails = json['ErrorDetails'];
    payload = json['Payload'] != null
        ? Payload.fromJson(json['Payload'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Status'] = status;
    data['Message'] = message;
    data['Remarks'] = remarks;
    data['ErrorDetails'] = errorDetails;
    if (payload != null) {
      data['Payload'] = payload!.toJson();
    }
    return data;
  }

}

class Payload {
  List<Customer>? customer;
  String? refNumber;
  int? refType;

  Payload({this.customer, this.refNumber, this.refType});

  Payload.fromJson(Map<String, dynamic> json) {
    if (json['Customer'] != null) {
      customer = <Customer>[];
      json['Customer'].forEach((v) {
        customer!.add(Customer.fromJson(v));
      });
    }
    refNumber = json['RefNumber'];
    refType = json['RefType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (customer != null) {
      data['Customer'] = customer!.map((v) => v.toJson()).toList();
    }
    data['RefNumber'] = refNumber;
    data['RefType'] = refType;
    return data;
  }
}

class Customer {
  String? accountNumber;
  String? fullName;
  String? mobile;
  String? email;
  String? address;

  Customer(
      {this.accountNumber,
        this.fullName,
        this.mobile,
        this.email,
        this.address});

  Customer.fromJson(Map<String, dynamic> json) {
    accountNumber = json['AccountNumber'];
    fullName = json['FullName'];
    mobile = json['Mobile'];
    email = json['Email'];
    address = json['Address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['AccountNumber'] = accountNumber;
    data['FullName'] = fullName;
    data['Mobile'] = mobile;
    data['Email'] = email;
    data['Address'] = address;
    return data;
  }
}
