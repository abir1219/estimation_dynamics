import 'dart:convert';

class ReprintEstimationModel {
  final String odataContext;
  final DataResultModel? dataResult;
  final List<dynamic> extensionProperties;

  ReprintEstimationModel({
    required this.odataContext,
    required this.dataResult,
    required this.extensionProperties,
  });

  factory ReprintEstimationModel.fromJson(Map<String, dynamic> json) {
    return ReprintEstimationModel(
      odataContext: json['@odata.context'],
      // dataResult: DataResultModel.fromJson(json['DataResult']),
      dataResult: json['DataResult'] != null
          ? DataResultModel.fromJson(json['DataResult'] is String
              ? jsonDecode(json['DataResult'])
              : json['DataResult'])
          : null,
      extensionProperties: json['ExtensionProperties'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "@odata.context": odataContext,
      "DataResult": dataResult?.toJson(),
      "ExtensionProperties": extensionProperties,
    };
  }
}

class DataResultModel {
  final int status;
  final String message;
  final String remarks;
  final String errorDetails;
  final PayloadModel payload;

  DataResultModel({
    required this.status,
    required this.message,
    required this.remarks,
    required this.errorDetails,
    required this.payload,
  });

  factory DataResultModel.fromJson(Map<String, dynamic> json) {
    return DataResultModel(
      status: json['Status'],
      message: json['Message'],
      remarks: json['Remarks'],
      errorDetails: json['ErrorDetails'],
      payload: PayloadModel.fromJson(json['Payload']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "Status": status,
      "Message": message,
      "Remarks": remarks,
      "ErrorDetails": errorDetails,
      "Payload": payload.toJson(),
    };
  }
}

class PayloadModel {
  final int status;
  final String message;
  final String remarks;
  final String errorDetails;
  final List<List<ProductLineModel>> payload;

  PayloadModel({
    required this.status,
    required this.message,
    required this.remarks,
    required this.errorDetails,
    required this.payload,
  });

  factory PayloadModel.fromJson(Map<String, dynamic> json) {
    return PayloadModel(
      status: json['Status'],
      message: json['Message'],
      remarks: json['Remarks'],
      errorDetails: json['ErrorDetails'],
      payload: (json['Payload'] as List)
          .map((e) =>
              (e as List).map((i) => ProductLineModel.fromJson(i)).toList())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "Status": status,
      "Message": message,
      "Remarks": remarks,
      "ErrorDetails": errorDetails,
      "Payload": payload
          .map((group) => group.map((item) => item.toJson()).toList())
          .toList(),
    };
  }
}

class ProductLineModel {
  final double netWeight;
  final double lineNum;
  final String wastageType;
  final double wastageQty;
  final double wastageAmount;
  final String makingType;
  final double makingRate;
  final double makingAmount;
  final int piece;
  final double grossWeight;
  final String calcType;
  final double rate;
  final double rateDiffDisc;
  final double cValue;
  final double netValue;
  final double total;
  final double discountPercent;
  final double discountAmount;
  final String taxCode;
  final double taxPercent;
  final double taxAmount;
  final double lineTotal;

  final List<IngredientModel> ingredients;

  final String salesPerson;
  final int productId;
  final String description;
  final String inventDimId;
  final String itemBarcode;
  final String itemId;
  final String configId;
  final String inventColorId;
  final String inventSizeId;
  final String inventStyleId;
  final String inventUnit;
  final String retailVariantId;

  ProductLineModel({
    required this.netWeight,
    required this.lineNum,
    required this.wastageType,
    required this.wastageQty,
    required this.wastageAmount,
    required this.makingType,
    required this.makingRate,
    required this.makingAmount,
    required this.piece,
    required this.grossWeight,
    required this.calcType,
    required this.rate,
    required this.rateDiffDisc,
    required this.cValue,
    required this.netValue,
    required this.total,
    required this.discountPercent,
    required this.discountAmount,
    required this.taxCode,
    required this.taxPercent,
    required this.taxAmount,
    required this.lineTotal,
    required this.ingredients,
    required this.salesPerson,
    required this.productId,
    required this.description,
    required this.inventDimId,
    required this.itemBarcode,
    required this.itemId,
    required this.configId,
    required this.inventColorId,
    required this.inventSizeId,
    required this.inventStyleId,
    required this.inventUnit,
    required this.retailVariantId,
  });

  factory ProductLineModel.fromJson(Map<String, dynamic> json) {
    return ProductLineModel(
      netWeight: json['NETWEIGHT'],
      lineNum: json['LINENUM'],
      wastageType: json['WASTAGETYPE'],
      wastageQty: json['WASTAGEQTY'],
      wastageAmount: json['WASTAGEAMOUNT'],
      makingType: json['MAKINGTYPE'],
      makingRate: json['MAKINGRATE'],
      makingAmount: json['MAKINGAMOUNT'],
      piece: json['PIECE'],
      grossWeight: json['GROSSWEIGHT'],
      calcType: json['CALCTYPE'],
      rate: json['RATE'],
      rateDiffDisc: json['RATEDIFFDISC'],
      cValue: json['CVALUE'],
      netValue: json['NETVALUE'],
      total: json['TOTAL'],
      discountPercent: json['DISCOUNTPERCENT'],
      discountAmount: json['DISCOUNTAMOUNT'],
      taxCode: json['TAXCODE'],
      taxPercent: json['TAXPERCENT'],
      taxAmount: json['TAXAMOUNT'],
      lineTotal: json['LINETOTAL'],
      ingredients: (json['INGREDIENTS'] as List)
          .map((e) => IngredientModel.fromJson(e))
          .toList(),
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

  Map<String, dynamic> toJson() {
    return {
      "NETWEIGHT": netWeight,
      "LINENUM": lineNum,
      "WASTAGETYPE": wastageType,
      "WASTAGEQTY": wastageQty,
      "WASTAGEAMOUNT": wastageAmount,
      "MAKINGTYPE": makingType,
      "MAKINGRATE": makingRate,
      "MAKINGAMOUNT": makingAmount,
      "PIECE": piece,
      "GROSSWEIGHT": grossWeight,
      "CALCTYPE": calcType,
      "RATE": rate,
      "RATEDIFFDISC": rateDiffDisc,
      "CVALUE": cValue,
      "NETVALUE": netValue,
      "TOTAL": total,
      "DISCOUNTPERCENT": discountPercent,
      "DISCOUNTAMOUNT": discountAmount,
      "TAXCODE": taxCode,
      "TAXPERCENT": taxPercent,
      "TAXAMOUNT": taxAmount,
      "LINETOTAL": lineTotal,
      "INGREDIENTS": ingredients.map((e) => e.toJson()).toList(),
      "SALESPERSON": salesPerson,
      "PRODUCTID": productId,
      "DESCRIPTION": description,
      "INVENTDIMID": inventDimId,
      "ITEMBARCODE": itemBarcode,
      "ITEMID": itemId,
      "CONFIGID": configId,
      "INVENTCOLORID": inventColorId,
      "INVENTSIZEID": inventSizeId,
      "INVENTSTYLEID": inventStyleId,
      "INVENTUNIT": inventUnit,
      "RETAILVARIANTID": retailVariantId,
    };
  }
}

class IngredientModel {
  final String itemId;
  final int piece;
  final double netWeight;
  final double rate;
  final double cValue;
  final double rateDiffDisc;
  final double netValue;
  final double pureQty;
  final String unit;

  IngredientModel({
    required this.itemId,
    required this.piece,
    required this.netWeight,
    required this.rate,
    required this.cValue,
    required this.rateDiffDisc,
    required this.netValue,
    required this.pureQty,
    required this.unit,
  });

  factory IngredientModel.fromJson(Map<String, dynamic> json) {
    return IngredientModel(
      itemId: json['ITEMID'],
      piece: json['PIECE'],
      netWeight: json['NETWEIGHT'],
      rate: json['RATE'],
      cValue: json['CVALUE'],
      rateDiffDisc: json['RATEDIFFDISC'],
      netValue: json['NETVALUE'],
      pureQty: json['PUREQTY'],
      unit: json['UNIT'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "ITEMID": itemId,
      "PIECE": piece,
      "NETWEIGHT": netWeight,
      "RATE": rate,
      "CVALUE": cValue,
      "RATEDIFFDISC": rateDiffDisc,
      "NETVALUE": netValue,
      "PUREQTY": pureQty,
      "UNIT": unit,
    };
  }
}
