import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../main.dart';
import '../../../router/app_pages.dart';
import '../../product_list_dialog/data/model/estimation_response_model.dart';
import '../../product_list_dialog/data/model/reprint_estimation_response_model.dart';

class PdfviewScreen extends StatefulWidget {
  final EstimationResponseModel? estimationResponseModel;
  final ReprintEstimationModel? reprintEstimationModel;
  final String refNumber;

  const PdfviewScreen(
      {super.key,
      this.estimationResponseModel,
      this.reprintEstimationModel,
      required this.refNumber});

  @override
  State<PdfviewScreen> createState() => _PdfviewScreenState();
}

class _PdfviewScreenState extends State<PdfviewScreen> {
  String details = "";
  List<int> productNo = [];
  List<String> productName = [];
  Map<String, dynamic> productDetails = {"products": []};
  List<dynamic> products = [];
  double diamondRate = 0.0;
  double stoneRate = 0.0;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    products = [];
    if (widget.estimationResponseModel != null) {
      details = widget.estimationResponseModel!
          .dataResult!
          .payload!
          .payload!
          .salesPerson ?? "";

      productDetails["products"] = widget
          .estimationResponseModel!
          .dataResult!
          .payload!
          .payload!
          .listItem!
          .map((e) => e.toJson())
          .toList();

    } else if (widget.reprintEstimationModel != null) {

      var payload = widget
          .reprintEstimationModel!
          .dataResult!
          .payload
          .payload;

      details = payload[0][0]
          .salesPerson;


      for (var prodList in payload) {
        productDetails["products"].addAll(
          prodList.map((e) => e.toJson()).toList(),
        );

        /*for(var prod in prodList){
          for(var ing in prod.ingredients){
            debugPrint("ItemID===>${ing.itemId}");
            if (ing.itemId.toLowerCase() == 'diamond') {
              debugPrint("DiaMond===>${ing.itemId}");
              debugPrint("-->${ing.rate}");
              diamondRate += ing.rate;
              // diamondRate += ing.rate;
              debugPrint("DiaMondRATE===>$diamondRate");
              // diamondWtList.add(diamondRate);
            }else{
              debugPrint("DiaMondRATE_ELSE===>");
              diamondRate = 0.0;
              // diamondWtList.add(diamondRate);
            }
          }
        }*/
      }
      // diamondWtList.add(diamondRate);
      // debugPrint("DiaMondRATEList===>${diamondWtList.length}");
      /*double diamondRate = 0.0;
      for (var ingredient in widget
          .reprintEstimationModel!
          .dataResult!
          .payload
          .payload) {
        //[0].ingredients!

        for(var ing in ingredient){
          if (ing.itemId.toLowerCase() == 'diamond') {
            debugPrint("-->${ing.rate}");
            diamondRate += ing.rate;
          }
        }
      }*/



      /*for(var prod in payload){
        productDetails["products"] = prod
            .map((e) => e.toJson())
            .toList();
      }*/
      /*productDetails["products"] = widget
          .reprintEstimationModel!
          .dataResult!
          .payload
          .payload[0]
          .map((e) => e.toJson())
          .toList();*/
    }

    products = productDetails["products"] as List;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        // context.go(AppPages.ESTIMATION);
        //context.go(AppPages.SELECT_PRODUCT);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.DEEP_YELLOW_COLOR,
          /*leading: BackButton(
            color: Colors.white,
            onPressed: () => context.go(AppPages.SELECT_PRODUCT),
          ),*/
          actions: [
            GestureDetector(
              onTap: () {
                //context.read<EstimationBloc>().add(LogoutEvent());
                //context.read<LegalEntityBloc>().add(ClearStateEvent());
                Future.delayed(Duration(milliseconds: 500), () {
                  if (mounted) {
                    navigatorKey.currentContext!.go(
                      // AppPages.LOGIN,
                      AppPages.LOGIN,
                    );
                  }
                });
                /*context.go(
                    // AppPages.ESTIMATION,
                    AppPages.SEARCH_PRODUCT,
                  );*/
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: size.width * 0.025),
                decoration: BoxDecoration(
                  color: AppColors.DEEP_YELLOW_COLOR,
                  borderRadius: BorderRadius.circular(4),
                ),
                height: 24,
                width: 24,
                child: Icon(Icons.home, color: Colors.white),
              ),
            ),
          ],
          centerTitle: true,
          title: const Text(
            "Print Layout",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
        body: OrientationBuilder(
          builder: (context, orientation) {
            // Adjust size based on orientation
            final adjustedSize = orientation == Orientation.portrait
                ? size
                : Size(
                    size.height,
                    size.width,
                  ); // Swap dimensions for landscape

            return SafeArea(
              child: PdfPreview(
                allowSharing: false,
                allowPrinting: true,
                canChangeOrientation: false,
                canChangePageFormat: false,
                canDebug: false,
                useActions: false,
                build: (format) => _createPdf(format, adjustedSize),
              ),
            );
          },
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: FloatingActionButton.extended(
            //onPressed: () => _printWithSunmi(),
            onPressed: () async {
              await _printWithSunmi(); // directly prints
            },
            label: const Text(
              'Print',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            icon: const Icon(
              Icons.print,
              color: Colors.white,
            ),
            backgroundColor: AppColors.DEEP_YELLOW_COLOR, //Colors.blue,
          ),
        ),
      ),
    );
  }

  Future<void> _printWithSunmi() async {
    final pdfData = await _createPdf(
      PdfPageFormat.roll80,
      MediaQuery.of(context).size,
    );
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdfData,
      name: 'Estimation_Print_Copy',
      format: PdfPageFormat.roll80,
    );
  }

  Future<Uint8List> _createPdf(PdfPageFormat format, Size size) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_4, compress: true);

    // Load logo once
    final logoBytes = await rootBundle.load('assets/images/logo.png');
    final logoImage = pw.MemoryImage(logoBytes.buffer.asUint8List());

    // Page 1..N: All products with header (only on first page)
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat(size.width, size.height, marginAll: 5),
        header: (context) {
          if (context.pageNumber == 1) {
            return _buildHeader(size, logoImage);
          }
          return pw.SizedBox(); // ✅ no header on other pages
        },
        build: (context) => [
          ...List.generate(
            // widget.estimationResponseModel!.dataResult!.payload!.payload!.listItem!.length,
            // products.length,
            (productDetails["products"] as List).length,
            (index) => pw.Container(
              width: size.width,
              margin: const pw.EdgeInsets.symmetric(vertical: 5),
              child: _buildProductContainer(size, index),
            ),
          ),
        ],
        // ❌ no footer here → avoids blank space under products
      ),
    );

    // Final Page: Footer only (payments + totals + employee)
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat(size.width, size.height, marginAll: 5),
        build: (context) {
          return _buildFooter(size);
        },
      ),
    );

    return pdf.save();
  }
  pw.Widget _buildProductContainer(Size size, int index) {
    final products = productDetails["products"] as List;
    final product = products[index]; // ✅ Single product map


    /*debugPrint("Product=>$product");
    for(var ing in product["INGREDIENTS"]){
      // debugPrint("ING_ITEMID-->${ing["ITEMID"]}");
      // debugPrint("ING_RATE-->${ing["RATE"]}");
      // debugPrint("CHECKING-->${(ing["ITEMID"].toLowerCase() == 'diamond')}");
      // if (ing.itemId.toLowerCase() == 'diamond') {
      if (ing["ITEMID"].toLowerCase() == 'diamond') {
        // debugPrint("ing[\"RATE\"]-->${ing["RATE"]}");
        // diamondRate += ing["RATE"];
        diamondRate += ing["CVALUE"];
      }

      if (ing["ITEMID"].toLowerCase() == 'stone') {
        // debugPrint("ing[\"RATE\"]-->${ing["RATE"]}");
        // diamondRate += ing["RATE"];
        stoneRate += ing["CVALUE"];
      }
    }*/

    double diamondRate = 0.0;
    double stoneRate = 0.0;

    for (var ing in product["INGREDIENTS"] ?? []) {
      final itemId = ing["ITEMID"]?.toString().toLowerCase();

      if (itemId == 'diamond') {
        diamondRate += (ing["CVALUE"] ?? 0).toDouble();
      }

      if (itemId == 'stone') {
        stoneRate += (ing["CVALUE"] ?? 0).toDouble();
      }
    }

    // debugPrint("diamondRate=!!!>$diamondRate");

    return pw.Column(
      children: [
        pw.Text(
          // "${widget.estimationResponseModel!.dataResult!.payload!.payload!.listItem?[index].productId!}",
          "${product["PRODUCTID"] ?? ""}",
          style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
        ),
        pw.Container(
          width: size.width,
          height: 0.5,
          margin: pw.EdgeInsets.symmetric(
            vertical: AppDimensions.getResponsiveHeight(context) * 0.01,
          ),
          color: PdfColors.grey,
        ),
        pw.Text(
          // "${widget.estimationResponseModel!.dataResult!.payload!.payload!.listItem?[index].itemId!}",
          "${product["ITEMID"] ?? ""}",
          style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
        ),
        pw.Container(
          width: size.width,
          height: 0.5,
          margin: pw.EdgeInsets.symmetric(
            vertical: AppDimensions.getResponsiveHeight(context) * 0.02,
          ),
        ),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
          children: [
            //pw.Flexible(
              //child:
              pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text(
                    "Pcs",
                    style: pw.TextStyle(
                      fontSize: 11.0,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Container(
                    // width: 22,
                    height: 0.5,
                    margin: pw.EdgeInsets.symmetric(
                      horizontal:
                          AppDimensions.getResponsiveHeight(context) * 0.002,
                    ),
                    color: PdfColors.grey,
                  ),
                  pw.Text(
                    // "${widget.estimationResponseModel!.dataResult!.payload!.payload!.listItem?[index].piece}",
                    "${product["PIECE"]}",
                    style: const pw.TextStyle(
                      fontSize: 11.5,
                      color: PdfColors.black,
                    ),
                  ),
                ],
              ),
            //),
            pw.Flexible(
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text(
                    "Gross",
                    style: pw.TextStyle(
                      fontSize: 11.0,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Container(
                    // width: 22,
                    height: 0.5,
                    margin: pw.EdgeInsets.symmetric(
                      horizontal:
                          AppDimensions.getResponsiveHeight(context) * 0.002,
                    ),
                    color: PdfColors.grey,
                  ),
                  pw.Text(
                    // "${widget.estimationResponseModel!.dataResult!.payload!.payload!.listItem?[index].grossWeight}",
                    "${product["GROSSWEIGHT"].toStringAsFixed(3)}",
                    style: const pw.TextStyle(
                      fontSize: 11.5,
                      color: PdfColors.black,
                    ),
                  ),
                ],
              ),
            ),
            pw.Flexible(
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text(
                    "Nett",
                    style: pw.TextStyle(
                      fontSize: 11.0,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Container(
                    // width: 22,
                    height: 0.5,
                    margin: pw.EdgeInsets.symmetric(
                      horizontal:
                          AppDimensions.getResponsiveHeight(context) * 0.002,
                    ),
                    color: PdfColors.grey,
                  ),
                  pw.Text(
                    // "${widget.estimationResponseModel!.dataResult!.payload!.payload!.listItem?[index].netWeight}",
                    "${product["NETWEIGHT"].toStringAsFixed(3)}",
                    style: const pw.TextStyle(
                      fontSize: 11.5,
                      color: PdfColors.black,
                    ),
                  ),
                ],
              ),
            ),
            pw.Flexible(
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text(
                    "DiaChrg",
                    style: pw.TextStyle(
                      fontSize: 11.0,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Container(
                    // width: 22,
                    height: 0.5,
                    margin: pw.EdgeInsets.symmetric(
                      horizontal:
                      AppDimensions.getResponsiveHeight(context) * 0.002,
                    ),
                    color: PdfColors.grey,
                  ),
                  pw.Text(
                    // "${widget.estimationResponseModel!.dataResult!.payload!.payload!.listItem?[index].piece}",
                    diamondRate.toStringAsFixed(2),
                    style: const pw.TextStyle(
                      fontSize: 11.5,
                      color: PdfColors.black,
                    ),
                  ),
                ],
              ),
            ),
            pw.Flexible(
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text(
                    "StnChrg",
                    style: pw.TextStyle(
                      fontSize: 11.0,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Container(
                    // width: 22,
                    height: 0.5,
                    margin: pw.EdgeInsets.symmetric(
                      horizontal:
                      AppDimensions.getResponsiveHeight(context) * 0.002,
                    ),
                    color: PdfColors.grey,
                  ),
                  pw.Text(
                    // "${widget.estimationResponseModel!.dataResult!.payload!.payload!.listItem?[index].piece}",
                    stoneRate.toStringAsFixed(2),
                    style: const pw.TextStyle(
                      fontSize: 11.5,
                      color: PdfColors.black,
                    ),
                  ),
                ],
              ),
            ),
            pw.Flexible(
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text(
                    "MkChrg",
                    style: pw.TextStyle(
                      fontSize: 11.0,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Container(
                    // width: 22,
                    height: 0.5,
                    margin: pw.EdgeInsets.symmetric(
                      horizontal:
                      AppDimensions.getResponsiveHeight(context) * 0.002,
                    ),
                    color: PdfColors.grey,
                  ),
                  pw.Text(
                    // "${widget.estimationResponseModel!.dataResult!.payload!.payload!.listItem?[index].piece}",
                    //diamondRate.toString(),
                    (product["MAKINGRATE"] + product["WASTAGEAMOUNT"]).toStringAsFixed(2),
                    style: const pw.TextStyle(
                      fontSize: 11.5,
                      color: PdfColors.black,
                    ),
                  ),
                ],
              ),
            ),
            pw.Flexible(
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text(
                    "Value",
                    style: pw.TextStyle(
                      fontSize: 11.0,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Container(
                    //width: 22,
                    height: 0.5,
                    margin: pw.EdgeInsets.symmetric(
                      horizontal:
                          AppDimensions.getResponsiveHeight(context) * 0.002,
                    ),
                    color: PdfColors.grey,
                  ),
                  pw.Text(
                    // "${widget.estimationResponseModel.data!.estimateDetails![index].estimateProductDetails!.lineAmount}",
                    // "${widget.estimationResponseModel!.dataResult!.payload!.payload!.listItem?[index].total!}",
                    "${product["TOTAL"].toStringAsFixed(2)}",
                    style: const pw.TextStyle(
                      fontSize: 11.5,
                      color: PdfColors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        pw.Container(
          width: size.width,
          height: 0.5,
          margin: pw.EdgeInsets.symmetric(
            vertical: AppDimensions.getResponsiveHeight(context) * 0.008,
          ),
          color: PdfColors.grey,
        ),
      ],
    );
  }

  pw.Widget _buildHeader(Size size, pw.MemoryImage logoImage) {
    return pw.Column(
      mainAxisAlignment: pw.MainAxisAlignment.start,
      children: [
        pw.Container(
          alignment: pw.Alignment.center,
          margin: const pw.EdgeInsets.symmetric(vertical: 10),
          child: pw.Image(logoImage,
              width: size.width * 0.4, height: size.width * 0.25),
        ),
        pw.Text(
          "* SALES ADVICE *",
          style: pw.TextStyle(
            fontSize: 24,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 10),
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 8),
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Spacer(),
              /*pw.Expanded(
                child: pw.Text(
                  "Mob No.: ${widget.mobileNo}",
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.black,
                  ),
                ),
              ),*/
              pw.Expanded(
                child: pw.Text(
                  DateFormat('dd-MM-yyyy').format(DateTime.now()),
                  textAlign: pw.TextAlign.right,
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
        pw.SizedBox(height: 10),
        pw.Divider(color: PdfColors.grey, thickness: 0.5),
        pw.Container(
          margin: const pw.EdgeInsets.symmetric(vertical: 15),
          child: pw.BarcodeWidget(
            barcode: pw.Barcode.code39(),
            data: widget.refNumber.toUpperCase(),
            width: size.width * 0.9,
            height: 75,
            drawText: false,
          ),
        ),
        pw.Text(
          widget.refNumber.toUpperCase(),
          style: pw.TextStyle(
            fontSize: 22,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 10),
      ],
    );
  }

  pw.Widget _buildFooter(Size size) {
    // final payments = widget.estimationResponseModel.data!.estimatePayments ?? [];
    /*final details = widget.estimationResponseModel!.dataResult!.payload!.payload!
            .salesPerson ??
        "";*/

    // double totalAmount = 0.00;
    /* for(var i in details){
      totalAmount += double.tryParse(i.estimateProductDetails!.lineamount!) ?? 0.00;
    }*/

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        /*if (payments.isNotEmpty) ...[
          pw.SizedBox(height: 8),
          pw.Column(
            children: List.generate(
              payments.length,
                  (index) => pw.Container(
                width: size.width,
                margin: const pw.EdgeInsets.symmetric(vertical: 5,horizontal: 6),
                child: _buildPaymentContainer(size, index),
              ),
            ),
          ),
        ],
        pw.SizedBox(height: 8),*/
        /*pw.Row(
          children: [
            pw.Expanded(
              child: pw.Text(
                "Total Amount",
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.Expanded(
              child: pw.Text(
                details.isNotEmpty
                    ? totalAmount.toString() //details[0].estimateProductDetails?.lineamount ?? ''
                    : "0.00",
                textAlign: pw.TextAlign.right,
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
          ],
        ),*/
        pw.SizedBox(height: 12),
        pw.Align(
          alignment: pw.Alignment.center,
          child: pw.Text(
            details,
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
