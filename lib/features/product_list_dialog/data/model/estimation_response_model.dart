import 'dart:convert';

import 'package:flutter/foundation.dart';

class EstimationResponseModel {
  final String? odataContext;
  final DataResult? dataResult;
  final List<dynamic>? extensionProperties;

  EstimationResponseModel({
    this.odataContext,
    this.dataResult,
    this.extensionProperties,
  });

  factory EstimationResponseModel.fromJson(Map<String, dynamic> json) {
    debugPrint("EstimationResponseModel_JSON--->$json");
    return EstimationResponseModel(
      odataContext: json['@odata.context'],
      /*dataResult: json['DataResult'] != null
          ? DataResult.fromJson(json['DataResult'])
          : null,*/
      dataResult: json['DataResult'] != null
          ? DataResult.fromJson(
          json['DataResult'] is String
              ? jsonDecode(json['DataResult'])
              : json['DataResult']
      )
          : null,
      extensionProperties: json['ExtensionProperties'] ?? [],
        );
  }

  Map<String, dynamic> toJson() {
    return {
      // '@odata.context': odataContext,
      // 'DataResult': dataResult?.toJson(),
      // 'ExtensionProperties': extensionProperties,
    };
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
    debugPrint("DATA_RESULT_JSON--->$json");
    return DataResult(
      status: json['Status'],
      message: json['Message'],
      remarks: json['Remarks'],
      errorDetails: json['ErrorDetails'],
      /*payload: json['Payload'] != null
          ? PayloadWrapper.fromJson(json['Payload'])
          : null,*/
      payload: json['Payload'] != null
          ? PayloadWrapper.fromJson(
        json['Payload'] is String
            ? jsonDecode(json['Payload'])
            : json['Payload'],
      )
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

class PayloadWrapper {
  final int? status;
  final String? message;
  final String? remarks;
  final String? errorDetails;
  final PayloadData? payload;

  PayloadWrapper({
    this.status,
    this.message,
    this.remarks,
    this.errorDetails,
    this.payload,
  });

  factory PayloadWrapper.fromJson(Map<String, dynamic> json) {
    return PayloadWrapper(
      status: json['Status'],
      message: json['Message'],
      remarks: json['Remarks'],
      errorDetails: json['ErrorDetails'],
      /*payload: json['Payload'] != null
          ? PayloadData.fromJson(json['Payload'])
          : null,*/
      payload: json['Payload'] != null
          ? PayloadData.fromJson(
        json['Payload'] is String
            ? jsonDecode(json['Payload'])
            : json['Payload'],
      )
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

class PayloadData {
  final String? customerId;
  final String? refNumber;
  final int? refType;
  final String? custName;
  final String? salesPerson;
  final List<ListItem>? listItem;

  PayloadData({
    this.customerId,
    this.refNumber,
    this.refType,
    this.custName,
    this.salesPerson,
    this.listItem,
  });

  factory PayloadData.fromJson(Map<String, dynamic> json) {
    return PayloadData(
      customerId: json['CustomerId'],
      refNumber: json['RefNumber'],
      refType: json['RefType'],
      custName: json['CustName'],
      salesPerson: json['SalesPerson'],
      listItem: (json['ListItem'] as List<dynamic>?)
          ?.map((e) => ListItem.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CustomerId': customerId,
      'RefNumber': refNumber,
      'RefType': refType,
      'CustName': custName,
      'SalesPerson': salesPerson,
      'ListItem': listItem?.map((e) => e.toJson()).toList(),
    };
  }
}

class ListItem {
  final double? netWeight;
  final double? lineNum;
  final String? wastageType;
  final double? wastageQty;
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
  final List<Ingredient>? ingredients;
  final TransactionStr? transactionStr;
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
    this.wastageType,
    this.wastageQty,
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
    this.ingredients,
    this.transactionStr,
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
      wastageType: json['WASTAGETYPE'],
      wastageQty: (json['WASTAGEQTY'] as num?)?.toDouble(),
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
      ingredients: (json['INGREDIENTS'] as List<dynamic>?)
          ?.map((e) => Ingredient.fromJson(e))
          .toList(),
      /*transactionStr: json['TRANSACTIONSTR'] != null
          ? TransactionStr.fromJson(json['TRANSACTIONSTR'])
          : null,*/
      transactionStr: json['TRANSACTIONSTR'] != null
          ? TransactionStr.fromJson(
        json['TRANSACTIONSTR'] is String
            ? jsonDecode(json['TRANSACTIONSTR'])
            : json['TRANSACTIONSTR'],
      )
          : null,
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
      'NETWEIGHT': netWeight,
      'LINENUM': lineNum,
      'WASTAGETYPE': wastageType,
      'WASTAGEQTY': wastageQty,
      'WASTAGEAMOUNT': wastageAmount,
      'MAKINGTYPE': makingType,
      'MAKINGRATE': makingRate,
      'MAKINGAMOUNT': makingAmount,
      'PIECE': piece,
      'GROSSWEIGHT': grossWeight,
      'CALCTYPE': calcType,
      'RATE': rate,
      'RATEDIFFDISC': rateDiffDisc,
      'CVALUE': cValue,
      'NETVALUE': netValue,
      'TOTAL': total,
      'DISCOUNTPERCENT': discountPercent,
      'DISCOUNTAMOUNT': discountAmount,
      'TAXCODE': taxCode,
      'TAXPERCENT': taxPercent,
      'TAXAMOUNT': taxAmount,
      'LINETOTAL': lineTotal,
      'INGREDIENTS': ingredients?.map((e) => e.toJson()).toList(),
      'TRANSACTIONSTR': transactionStr?.toJson(),
      'SALESPERSON': salesPerson,
      'PRODUCTID': productId,
      'DESCRIPTION': description,
      'INVENTDIMID': inventDimId,
      'ITEMBARCODE': itemBarcode,
      'ITEMID': itemId,
      'CONFIGID': configId,
      'INVENTCOLORID': inventColorId,
      'INVENTSIZEID': inventSizeId,
      'INVENTSTYLEID': inventStyleId,
      'INVENTUNIT': inventUnit,
      'RETAILVARIANTID': retailVariantId,
    };
  }
}

class Ingredient {
  final String? itemId;
  final int? piece;
  final double? netWeight;
  final double? rate;
  final double? cValue;
  final double? rateDiffDisc;
  final double? netValue;
  final double? pureQty;
  final String? unit;

  Ingredient({
    this.itemId,
    this.piece,
    this.netWeight,
    this.rate,
    this.cValue,
    this.rateDiffDisc,
    this.netValue,
    this.pureQty,
    this.unit,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      itemId: json['ITEMID'],
      piece: json['PIECE'],
      netWeight: (json['NETWEIGHT'] as num?)?.toDouble(),
      rate: (json['RATE'] as num?)?.toDouble(),
      cValue: (json['CVALUE'] as num?)?.toDouble(),
      rateDiffDisc: (json['RATEDIFFDISC'] as num?)?.toDouble(),
      netValue: (json['NETVALUE'] as num?)?.toDouble(),
      pureQty: (json['PUREQTY'] as num?)?.toDouble(),
      unit: json['UNIT'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ITEMID': itemId,
      'PIECE': piece,
      'NETWEIGHT': netWeight,
      'RATE': rate,
      'CVALUE': cValue,
      'RATEDIFFDISC': rateDiffDisc,
      'NETVALUE': netValue,
      'PUREQTY': pureQty,
      'UNIT': unit,
    };
  }
}

class TransactionStr {
  final String? sectionHeaderR;
  final String? itemIDD;
  final String? itemName;
  final String? pieces;
  final String? grossWt;
  final String? rate;
  final String? calcType;
  final String? valueC;
  final String? makingRate;
  final String? makingType;
  final String? total;
  final double? wsDiscQty;
  final double? wsDiscAmt;
  final List<ItemDetail>? itemDetails;
  final ItemInformation? itemInformation;

  TransactionStr({
    this.sectionHeaderR,
    this.itemIDD,
    this.itemName,
    this.pieces,
    this.grossWt,
    this.rate,
    this.calcType,
    this.valueC,
    this.makingRate,
    this.makingType,
    this.total,
    this.wsDiscQty,
    this.wsDiscAmt,
    this.itemDetails,
    this.itemInformation,
  });

  factory TransactionStr.fromJson(Map<String, dynamic> json) {
    return TransactionStr(
      sectionHeaderR: json['SectionHeaderR'],
      itemIDD: json['ItemIDD'],
      itemName: json['ItemName'],
      pieces: json['Pieces'],
      grossWt: json['GrossWt'],
      rate: json['Rate'],
      calcType: json['CalcType'],
      valueC: json['ValueC'],
      makingRate: json['MakingRate'],
      makingType: json['MakingType'],
      total: json['Total'],
      wsDiscQty: (json['WsDiscQty'] as num?)?.toDouble(),
      wsDiscAmt: (json['WsDiscAmt'] as num?)?.toDouble(),
      itemDetails: (json['ItemDetails'] as List<dynamic>?)
          ?.map((e) => ItemDetail.fromJson(e))
          .toList(),
      itemInformation: json['ItemInformation'] != null
          ? ItemInformation.fromJson(json['ItemInformation'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'SectionHeaderR': sectionHeaderR,
      'ItemIDD': itemIDD,
      'ItemName': itemName,
      'Pieces': pieces,
      'GrossWt': grossWt,
      'Rate': rate,
      'CalcType': calcType,
      'ValueC': valueC,
      'MakingRate': makingRate,
      'MakingType': makingType,
      'Total': total,
      'WsDiscQty': wsDiscQty,
      'WsDiscAmt': wsDiscAmt,
      'ItemDetails': itemDetails?.map((e) => e.toJson()).toList(),
      'ItemInformation': itemInformation?.toJson(),
    };
  }
}

class ItemDetail {
  final String? itemId;
  final String? netWt;
  final String? rate;
  final String? cValue;
  final String? unitId;
  final double? wastageQty;
  final double? wastageAmount;
  final String? pureQty;

  ItemDetail({
    this.itemId,
    this.netWt,
    this.rate,
    this.cValue,
    this.unitId,
    this.wastageQty,
    this.wastageAmount,
    this.pureQty,
  });

  factory ItemDetail.fromJson(Map<String, dynamic> json) {
    return ItemDetail(
      itemId: json['ITEMID'],
      netWt: json['NETWT'],
      rate: json['RATE'],
      cValue: json['CVALUE'],
      unitId: json['UNITID'],
      wastageQty: (json['WASTAGEQTY'] as num?)?.toDouble(),
      wastageAmount: (json['WASTAGEAMOUNT'] as num?)?.toDouble(),
      pureQty: json['PureQty'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ITEMID': itemId,
      'NETWT': netWt,
      'RATE': rate,
      'CVALUE': cValue,
      'UNITID': unitId,
      'WASTAGEQTY': wastageQty,
      'WASTAGEAMOUNT': wastageAmount,
      'PureQty': pureQty,
    };
  }
}

class ItemInformation {
  final String? itemId;
  final String? nimItemTypeCodeDesc;
  final String? nimProductTypeCodeDesc;
  final String? nimItemDesc;

  ItemInformation({
    this.itemId,
    this.nimItemTypeCodeDesc,
    this.nimProductTypeCodeDesc,
    this.nimItemDesc,
  });

  factory ItemInformation.fromJson(Map<String, dynamic> json) {
    return ItemInformation(
      itemId: json['ITEMID'],
      nimItemTypeCodeDesc: json['NIMITEMTYPECODEDESC'],
      nimProductTypeCodeDesc: json['NIMPRODUCTTYPECODEDESC'],
      nimItemDesc: json['NIMITEMDESC'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ITEMID': itemId,
      'NIMITEMTYPECODEDESC': nimItemTypeCodeDesc,
      'NIMPRODUCTTYPECODEDESC': nimProductTypeCodeDesc,
      'NIMITEMDESC': nimItemDesc,
    };
  }
}
