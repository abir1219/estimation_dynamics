import 'dart:convert';

class EstimationResponseModel_01 {
  final String? odataContext;
  final DataResult? dataResult;

  EstimationResponseModel_01({this.odataContext, this.dataResult});

  factory EstimationResponseModel_01.fromJson(Map<String, dynamic> json) {
    return EstimationResponseModel_01(
      odataContext: json['@odata.context'],
      dataResult: json['DataResult'] != null
          ? DataResult.fromJson(
        json['DataResult'] is String
            ? jsonDecode(json['DataResult'])
            : json['DataResult'],
      )
          : null,
    );
  }
}
class DataResult {
  final int? status;
  final String? message;
  final String? remarks;
  final String? errorDetails;
  final PayloadWrapper? payload;

  DataResult({
    this.status,
    this.message,
    this.remarks,
    this.errorDetails,
    this.payload,
  });

  factory DataResult.fromJson(Map<String, dynamic> json) {
    return DataResult(
      status: json['Status'],
      message: json['Message'],
      remarks: json['Remarks'],
      errorDetails: json['ErrorDetails'],
      payload: json['Payload'] != null
          ? PayloadWrapper.fromJson(json['Payload'])
          : null,
    );
  }
}
class PayloadWrapper {
  final int? status;
  final String? message;
  final String? remarks;
  final String? errorDetails;
  final List<List<ListItem>>? listItem;   // ✅ FIXED

  PayloadWrapper({
    this.status,
    this.message,
    this.remarks,
    this.errorDetails,
    this.listItem,
  });

  factory PayloadWrapper.fromJson(Map<String, dynamic> json) {
    return PayloadWrapper(
      status: json['Status'],
      message: json['Message'],
      remarks: json['Remarks'],
      errorDetails: json['ErrorDetails'],
      listItem: (json['Payload'] as List<dynamic>?)
          ?.map((outer) => (outer as List<dynamic>)
          .map((inner) => ListItem.fromJson(inner))
          .toList())
          .toList(),
    );
  }
}
class ListItem {
  final double? netWeight;
  final double? lineNum;
  final double? wastageAmount;
  final String? makingType;
  final double? makingRate;
  final double? makingAmount;
  final int? piece;
  final double? grossWeight;
  final String? calcType;
  final double? rate;
  final double? rateDiffDisc;
  final double? cValue;
  final double? netValue;
  final double? total;
  final double? discountPercent;
  final double? discountAmount;
  final String? taxCode;
  final double? taxPercent;
  final double? taxAmount;
  final double? lineTotal;
  final String? salesPerson;
  final num? productId;
  final String? description;
  final String? inventDimId;
  final String? itemBarcode;
  final String? itemId;
  final String? configId;
  final String? inventColorId;
  final String? inventSizeId;
  final String? inventStyleId;
  final String? inventUnit;
  final String? retailVariantId;

  ListItem({
    this.netWeight,
    this.lineNum,
    this.wastageAmount,
    this.makingType,
    this.makingRate,
    this.makingAmount,
    this.piece,
    this.grossWeight,
    this.calcType,
    this.rate,
    this.rateDiffDisc,
    this.cValue,
    this.netValue,
    this.total,
    this.discountPercent,
    this.discountAmount,
    this.taxCode,
    this.taxPercent,
    this.taxAmount,
    this.lineTotal,
    this.salesPerson,
    this.productId,
    this.description,
    this.inventDimId,
    this.itemBarcode,
    this.itemId,
    this.configId,
    this.inventColorId,
    this.inventSizeId,
    this.inventStyleId,
    this.inventUnit,
    this.retailVariantId,
  });

  factory ListItem.fromJson(Map<String, dynamic> json) {
    return ListItem(
        netWeight: (json['NETWEIGHT'] as num?)?.toDouble(),
        lineNum: (json['LINENUM'] as num?)?.toDouble(),

    wastageAmount: (json['WASTAGEAMOUNT'] as num?)?.toDouble(),
    makingType: json['MAKINGTYPE'],
    makingRate: (json['MAKINGRATE'] as num?)?.toDouble(),
    makingAmount: (json['MAKINGAMOUNT'] as num?)?.toDouble(),
    piece: json['PIECE'],
    grossWeight: (json['GROSSWEIGHT'] as num?)?.toDouble(),
    calcType: json['CALCTYPE'],
    rate: (json['RATE'] as num?)?.toDouble(),
    rateDiffDisc: (json['RATEDIFFDISC'] as num?)?.toDouble(),
    cValue: (json['CVALUE'] as num?)?.toDouble(),
    netValue: (json['NETVALUE'] as num?)?.toDouble(),
    total: (json['TOTAL'] as num?)?.toDouble(),
    discountPercent: (json['DISCOUNTPERCENT'] as num?)?.toDouble(),
    discountAmount: (json['DISCOUNTAMOUNT'] as num?)?.toDouble(),
    taxCode: json['TAXCODE'],
    taxPercent: (json['TAXPERCENT'] as num?)?.toDouble(),
    taxAmount: (json['TAXAMOUNT'] as num?)?.toDouble(),
    lineTotal: (json['LINETOTAL'] as num?)?.toDouble(),
    salesPerson: json['SALESPERSON'],
    productId: json['PRODUCTID'],
    description: json['DESCRIPTION'],
    inventDimId: json['INVENTDIMID'],
    itemBarcode: json['ITEMBARCODE'],
    itemId: json['ITEMID'],
    configId: json['CONFIGID'],
    inventColorId: json['INVENTCOLORID'],
    inventSizeId: json['INVENTSIZEID'],
    inventStyleId: json['INVENTSTYLEID'],
    inventUnit: json['INVENTUNIT'],
    retailVariantId: json['RETAILVARIANTID'],
    );
  }
}

