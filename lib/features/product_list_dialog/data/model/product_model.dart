import 'dart:convert';

class ProductModel {
  String? odataContext;
  DataResult? dataResult;

  ProductModel({this.odataContext, this.dataResult});

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      odataContext: json["@odata.context"],
      dataResult: json['DataResult'] != null
          ? DataResult.fromJson(
        json['DataResult'] is String
            ? jsonDecode(json['DataResult'])
            : json['DataResult'],
      )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "@odata.context": odataContext,
      "DataResult": dataResult?.toJson(),
    };
  }
}

class DataResult {
  final int status;
  final String message;
  final String remarks;
  final String errorDetails;
  final ProductPayload payload;

  DataResult({
    required this.status,
    required this.message,
    required this.remarks,
    required this.errorDetails,
    required this.payload,
  });

  factory DataResult.fromJson(Map<String, dynamic> json) => DataResult(
    status: json["Status"],
    message: json["Message"],
    remarks: json["Remarks"],
    errorDetails: json["ErrorDetails"],
    payload: ProductPayload.fromJson(json["Payload"]),
  );

  Map<String, dynamic> toJson() => {
    "Status": status,
    "Message": message,
    "Remarks": remarks,
    "ErrorDetails": errorDetails,
    "Payload": payload.toJson(),
  };
}

class ProductPayload {
  final double netweight;
  final double linenum;
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
  final double cvalue;
  final double netValue;
  final double total;
  final double discountPercent;
  final double discountAmount;
  final String taxCode;
  final double taxPercent;
  final double taxAmount;
  final double lineTotal;
  final List<INGREDIENTS> ingredients;
  final TransactionStr transactionStr;
  final String salesperson;
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

  ProductPayload({
    required this.netweight,
    required this.linenum,
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
    required this.cvalue,
    required this.netValue,
    required this.total,
    required this.discountPercent,
    required this.discountAmount,
    required this.taxCode,
    required this.taxPercent,
    required this.taxAmount,
    required this.lineTotal,
    required this.ingredients,
    required this.transactionStr,
    required this.salesperson,
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

  factory ProductPayload.fromJson(Map<String, dynamic> json) => ProductPayload(
    netweight: (json["NETWEIGHT"] ?? 0).toDouble(),
    linenum: (json["LINENUM"] ?? 0).toDouble(),
    wastageType: json["WASTAGETYPE"] ?? '',
    wastageQty: (json["WASTAGEQTY"] ?? 0).toDouble(),
    wastageAmount: (json["WASTAGEAMOUNT"] ?? 0).toDouble(),
    makingType: json["MAKINGTYPE"] ?? '',
    makingRate: (json["MAKINGRATE"] ?? 0).toDouble(),
    makingAmount: (json["MAKINGAMOUNT"] ?? 0).toDouble(),
    piece: json["PIECE"] ?? 0,
    grossWeight: (json["GROSSWEIGHT"] ?? 0).toDouble(),
    calcType: json["CALCTYPE"] ?? '',
    rate: (json["RATE"] ?? 0).toDouble(),
    cvalue: (json["CVALUE"] ?? 0).toDouble(),
    netValue: (json["NETVALUE"] ?? 0).toDouble(),
    total: (json["TOTAL"] ?? 0).toDouble(),
    discountPercent: (json["DISCOUNTPERCENT"] ?? 0).toDouble(),
    discountAmount: (json["DISCOUNTAMOUNT"] ?? 0).toDouble(),
    taxCode: json["TAXCODE"] ?? '',
    taxPercent: (json["TAXPERCENT"] ?? 0).toDouble(),
    taxAmount: (json["TAXAMOUNT"] ?? 0).toDouble(),
    lineTotal: (json["LINETOTAL"] ?? 0).toDouble(),
    // ingredients: List<INGREDIENTS>.from(json["INGREDIENTS"] ?? []),
    ingredients: (json["INGREDIENTS"] != null)
        ? List<INGREDIENTS>.from(
        (json["INGREDIENTS"] as List)
            .map((x) => INGREDIENTS.fromJson(x as Map<String, dynamic>)))
        : [],
    transactionStr: TransactionStr.fromJson(
      jsonDecode(json["TRANSACTIONSTR"] ?? '{}'),
    ),
    salesperson: json["SALESPERSON"] ?? '',
    productId: json["PRODUCTID"] ?? 0,
    description: json["DESCRIPTION"] ?? '',
    inventDimId: json["INVENTDIMID"] ?? '',
    itemBarcode: json["ITEMBARCODE"] ?? '',
    itemId: json["ITEMID"] ?? '',
    configId: json["CONFIGID"] ?? '',
    inventColorId: json["INVENTCOLORID"] ?? '',
    inventSizeId: json["INVENTSIZEID"] ?? '',
    inventStyleId: json["INVENTSTYLEID"] ?? '',
    inventUnit: json["INVENTUNIT"] ?? '',
    retailVariantId: json["RETAILVARIANTID"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "NETWEIGHT": netweight,
    "LINENUM": linenum,
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
    "CVALUE": cvalue,
    "NETVALUE": netValue,
    "TOTAL": total,
    "DISCOUNTPERCENT": discountPercent,
    "DISCOUNTAMOUNT": discountAmount,
    "TAXCODE": taxCode,
    "TAXPERCENT": taxPercent,
    "TAXAMOUNT": taxAmount,
    "LINETOTAL": lineTotal,
    "INGREDIENTS": ingredients,
    "TRANSACTIONSTR": jsonEncode(transactionStr.toJson()),
    "SALESPERSON": salesperson,
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

class TransactionStr {
  final String sectionHeaderR;
  final String itemIDD;
  final String itemName;
  final String rate;
  final String total;
  final ItemInformation itemInformation;
  final DiscInformation discInformation;

  TransactionStr({
    required this.sectionHeaderR,
    required this.itemIDD,
    required this.itemName,
    required this.rate,
    required this.total,
    required this.itemInformation,
    required this.discInformation,
  });

  factory TransactionStr.fromJson(Map<String, dynamic> json) => TransactionStr(
    sectionHeaderR: json["SectionHeaderR"] ?? '',
    itemIDD: json["ItemIDD"] ?? '',
    itemName: json["ItemName"] ?? '',
    rate: json["Rate"] ?? '0',
    total: json["Total"] ?? '0',
    itemInformation: ItemInformation.fromJson(json["ItemInformation"] ?? {}),
    discInformation: DiscInformation.fromJson(json["DiscInformation"] ?? {}),
  );

  Map<String, dynamic> toJson() => {
    "SectionHeaderR": sectionHeaderR,
    "ItemIDD": itemIDD,
    "ItemName": itemName,
    "Rate": rate,
    "Total": total,
    "ItemInformation": itemInformation.toJson(),
    "DiscInformation": discInformation.toJson(),
  };
}

class ItemInformation {
  final String itemId;
  final String itemDesc;
  final String itemTypeCodeDesc;
  final String productTypeCodeDesc;
  final String unitId;

  ItemInformation({
    required this.itemId,
    required this.itemDesc,
    required this.itemTypeCodeDesc,
    required this.productTypeCodeDesc,
    required this.unitId,
  });

  factory ItemInformation.fromJson(Map<String, dynamic> json) => ItemInformation(
    itemId: json["ITEMID"] ?? '',
    itemDesc: json["NIMITEMDESC"] ?? '',
    itemTypeCodeDesc: json["NIMITEMTYPECODEDESC"] ?? '',
    productTypeCodeDesc: json["NIMPRODUCTTYPECODEDESC"] ?? '',
    unitId: json["UNITID"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "ITEMID": itemId,
    "NIMITEMDESC": itemDesc,
    "NIMITEMTYPECODEDESC": itemTypeCodeDesc,
    "NIMPRODUCTTYPECODEDESC": productTypeCodeDesc,
    "UNITID": unitId,
  };
}

class DiscInformation {
  final double discAmount;
  final double discountType;

  DiscInformation({
    required this.discAmount,
    required this.discountType,
  });

  factory DiscInformation.fromJson(Map<String, dynamic> json) => DiscInformation(
    discAmount: (json["DiscAmount"] ?? 0).toDouble(),
    discountType: (json["DiscountType"] ?? 0).toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "DiscAmount": discAmount,
    "DiscountType": discountType,
  };
}
class INGREDIENTS {
  String? iTEMID;
  double? pIECE;
  double? nETWEIGHT;
  double? rATE;
  double? cVALUE;
  double? rATEDIFFDISC;
  double? nETVALUE;
  double? pUREQTY;
  String? uNIT;

  INGREDIENTS({
    this.iTEMID,
    this.pIECE,
    this.nETWEIGHT,
    this.rATE,
    this.cVALUE,
    this.rATEDIFFDISC,
    this.nETVALUE,
    this.pUREQTY,
    this.uNIT,
  });

  factory INGREDIENTS.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is int) return value.toDouble();
      if (value is double) return value;
      return double.tryParse(value.toString()) ?? 0.0;
    }

    return INGREDIENTS(
      iTEMID: json['ITEMID']?.toString(),
      pIECE: parseDouble(json['PIECE']),
      nETWEIGHT: parseDouble(json['NETWEIGHT']),
      rATE: parseDouble(json['RATE']),
      cVALUE: parseDouble(json['CVALUE']),
      rATEDIFFDISC: parseDouble(json['RATEDIFFDISC']),
      nETVALUE: parseDouble(json['NETVALUE']),
      pUREQTY: parseDouble(json['PUREQTY']),
      uNIT: json['UNIT']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ITEMID': iTEMID,
      'PIECE': pIECE,
      'NETWEIGHT': nETWEIGHT,
      'RATE': rATE,
      'CVALUE': cVALUE,
      'RATEDIFFDISC': rATEDIFFDISC,
      'NETVALUE': nETVALUE,
      'PUREQTY': pUREQTY,
      'UNIT': uNIT,
    };
  }
}

/*
class INGREDIENTS {
  String? iTEMID;
  double? pIECE;
  double? nETWEIGHT;
  double? rATE;
  double? cVALUE;
  double? rATEDIFFDISC;
  double? nETVALUE;
  double? pUREQTY;
  String? uNIT;

  INGREDIENTS(
      {this.iTEMID,
        this.pIECE,
        this.nETWEIGHT,
        this.rATE,
        this.cVALUE,
        this.rATEDIFFDISC,
        this.nETVALUE,
        this.pUREQTY,
        this.uNIT});

  INGREDIENTS.fromJson(Map<String, dynamic> json) {
    iTEMID = json['ITEMID'];
    pIECE = json['PIECE'];
    nETWEIGHT = json['NETWEIGHT'];
    rATE = json['RATE'];
    cVALUE = json['CVALUE'];
    rATEDIFFDISC = json['RATEDIFFDISC'];
    nETVALUE = json['NETVALUE'];
    pUREQTY = json['PUREQTY'];
    uNIT = json['UNIT'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ITEMID'] = iTEMID;
    data['PIECE'] = pIECE;
    data['NETWEIGHT'] = nETWEIGHT;
    data['RATE'] = rATE;
    data['CVALUE'] = cVALUE;
    data['RATEDIFFDISC'] = rATEDIFFDISC;
    data['NETVALUE'] = nETVALUE;
    data['PUREQTY'] = pUREQTY;
    data['UNIT'] = uNIT;
    return data;
  }
}*/
