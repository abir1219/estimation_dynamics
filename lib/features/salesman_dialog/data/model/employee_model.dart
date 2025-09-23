class SalesmanModel {
  int? status;
  String? message;
  String? remarks;
  String? errorDetails;
  Payload? payload;

  SalesmanModel(
      {this.status,
        this.message,
        this.remarks,
        this.errorDetails,
        this.payload});

  SalesmanModel.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Message'];
    remarks = json['Remarks'];
    errorDetails = json['ErrorDetails'];
    payload =
    json['Payload'] != null ? Payload.fromJson(json['Payload']) : null;
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
  int? status;
  String? message;
  String? remarks;
  String? errorDetails;
  List<SalesmanPayload>? payload;

  Payload(
      {this.status,
        this.message,
        this.remarks,
        this.errorDetails,
        this.payload});

  Payload.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Message'];
    remarks = json['Remarks'];
    errorDetails = json['ErrorDetails'];
    if (json['Payload'] != null) {
      payload = <SalesmanPayload>[];
      json['Payload'].forEach((v) {
        payload!.add(SalesmanPayload.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Status'] = status;
    data['Message'] = message;
    data['Remarks'] = remarks;
    data['ErrorDetails'] = errorDetails;
    if (payload != null) {
      data['Payload'] = payload!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SalesmanPayload {
  String? text;
  String? value;

  SalesmanPayload({this.text, this.value});

  SalesmanPayload.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['text'] = text;
    data['value'] = value;
    return data;
  }
}
