import 'dart:convert';

class StoreModel{
  final String? odataContext;
  final DataResult? dataResult;
  final List<dynamic>? extensionProperties;

  StoreModel({
    this.odataContext,
    this.dataResult,
    this.extensionProperties,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      odataContext: json["@odata.context"],
      dataResult: json["DataResult"] != null
          ? DataResult.fromJson(jsonDecode(json["DataResult"]))
          : null,
      extensionProperties: json["ExtensionProperties"] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "@odata.context": odataContext,
      "DataResult": dataResult != null ? jsonEncode(dataResult!.toJson()) : null,
      "ExtensionProperties": extensionProperties,
    };
  }
}

class DataResult {
  final int? status;
  final String? message;
  final String? remarks;
  final String? errorDetails;
  final List<StoreListPayload>? payload;

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
      payload: json["Payload"] != null
          ? (json["Payload"] as List)
          .map((item) => StoreListPayload.fromJson(item))
          .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "Status": status,
      "Message": message,
      "Remarks": remarks,
      "ErrorDetails": errorDetails,
      "Payload": payload?.map((item) => item.toJson()).toList(),
    };
  }
}

class StoreListPayload {
  String? storeId;
  String? terminalId;
  String? storeName;

  StoreListPayload({this.storeId, this.terminalId, this.storeName});

  StoreListPayload.fromJson(Map<String, dynamic> json) {
    storeId = json['StoreId'];
    terminalId = json['TerminalId'];
    storeName = json['StoreName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['StoreId'] = storeId;
    data['TerminalId'] = terminalId;
    data['StoreName'] = storeName;
    return data;
  }
}