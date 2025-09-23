import 'dart:convert';

class LoginModel{
  final DataResult? dataResult;

  LoginModel({
    this.dataResult,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      dataResult: json["DataResult"] != null
          ? DataResult.fromJson(jsonDecode(json["DataResult"]))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "DataResult": dataResult != null ? jsonEncode(dataResult!.toJson()) : null,
    };
  }
}

class DataResult {
  final int? status;
  final String? message;
  final String? remarks;
  final String? errorDetails;
  final String? payload;

  DataResult({
    this.status,
    this.message,
    this.remarks,
    this.errorDetails,
    this.payload,
  });

  factory DataResult.fromJson(Map<String, dynamic> json) {
    return DataResult(
      status: json["Status"],
      message: json["Message"],
      remarks: json["Remarks"],
      errorDetails: json["ErrorDetails"],
      payload: json["Payload"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "Status": status,
      "Message": message,
      "Remarks": remarks,
      "ErrorDetails": errorDetails,
      "Payload": payload,
    };
  }
}