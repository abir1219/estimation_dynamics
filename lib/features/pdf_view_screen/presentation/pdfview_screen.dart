import 'package:estimation_dynamics/features/product_list_dialog/data/model/product_model.dart';
import 'package:estimation_dynamics/features/product_list_dialog/presentation/bloc/product_bloc.dart';
import 'package:estimation_dynamics/widgets/app_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../main.dart';
import '../../../router/app_pages.dart';
import '../../add_estimation_screen/presentation/bloc/estimation_bloc.dart';
import '../../product_list_dialog/data/model/estimation_response_model.dart';
import '../../product_list_dialog/data/model/reprint_estimation_response_model.dart';
import '../../salesman_dialog/data/model/employee_model.dart';
import '../../search_customer_dialog/data/customer_model.dart';

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
  Map<String, dynamic> productDetails = {"products": []};

  double totalTaxableAmount = 0.0;
  double totalTaxAmount = 0.0;
  double totalAmount = 0.0;

  String? refNumber;
  bool _isEditFlowInProgress = false;
  bool _scanTriggered = false; // 🔐 IMPORTANT

  dynamic customer;
  SalesmanPayload? salesman;

  @override
  void initState() {
    super.initState();
  }

  /// -------------------- FETCH DATA --------------------
  void fetchData() {
    final estimationState = context.read<EstimationBloc>().state;
    final productState = context.read<ProductBloc>().state;

    if (estimationState is! EstimationDataState) return;

    refNumber = estimationState.refNumber;

    final payload =
        productState.estimationResponseModel?.dataResult?.payload?.payload;

    customer = estimationState.customer ??
        estimationState.customerData ??
        (payload != null
            ? Customer(
                accountNumber: payload.customerId ?? '',
                fullName: payload.custName ?? '',
              )
            : null);

    salesman = estimationState.salesman ??
        (payload != null
            ? SalesmanPayload(text: payload.salesPerson ?? '', value: '')
            : null);
  }

  /// -------------------- UI --------------------
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    /// Always reset product list
    productDetails["products"] = [];

    if (widget.estimationResponseModel != null) {
      final payload =
          widget.estimationResponseModel!.dataResult!.payload!.payload!;
      details = payload.salesPerson ?? "";
      productDetails["products"] =
          payload.listItem!.map((e) => e.toJson()).toList();
    } else if (widget.reprintEstimationModel != null) {
      final payload =
          widget.reprintEstimationModel!.dataResult!.payload.payload;
      details = payload[0][0].salesPerson;
      for (final list in payload) {
        productDetails["products"].addAll(list.map((e) => e.toJson()));
      }
    }

    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.DEEP_YELLOW_COLOR,
          centerTitle: true,
          title: const Text(
            "Print Layout",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                context.read<ProductBloc>().add(GoToHomeEvent());
                context.read<EstimationBloc>().add(GotoHomeEvent());
                Future.delayed(const Duration(milliseconds: 300), () {
                  navigatorKey.currentContext!.go(AppPages.LOGIN);
                });
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: size.width * 0.025),
                height: 24,
                width: 24,
                child: const Icon(Icons.home, color: Colors.white),
              ),
            ),
          ],
        ),
        body: OrientationBuilder(
          builder: (_, orientation) {
            final adjustedSize = orientation == Orientation.portrait
                ? size
                : Size(size.height, size.width);

            return Stack(
              children: [
                MultiBlocListener(
                  listeners: [
                    /// 1️⃣ DELETE DONE → GENERATE REF
                    BlocListener<ProductBloc, ProductState>(
                      listenWhen: (p, c) =>
                          c.status == ProductStatus.deleteSuccess,
                      listener: (_, __) {
                        context
                            .read<EstimationBloc>()
                            .add(GenerateEstimationNoEvent());
                      },
                    ),

                    /// 2️⃣ REF GENERATED → SCAN (ONCE)
                    BlocListener<EstimationBloc, EstimationState>(
                      listenWhen: (prev, curr) {
                        if (prev is EstimationDataState &&
                            curr is EstimationDataState) {
                          return prev.refNumber != curr.refNumber &&
                              curr.refNumber != null;
                        }
                        return curr is EstimationDataState &&
                            curr.refNumber != null;
                      },
                      listener: (_, state) {
                        if (_scanTriggered) return;

                        final s = state as EstimationDataState;
                        _scanTriggered = true;

                        refNumber = s.refNumber;
                        debugPrint("✅ SCAN FLOW STARTED → $refNumber");

                        final productBloc = context.read<ProductBloc>();
                        final productState = productBloc.state;

                        final payload = widget.estimationResponseModel
                            ?.dataResult?.payload?.payload;

                        if (payload == null) return;

                        final productIds = payload.listItem!
                            .map((e) => e.productId?.toString())
                            .whereType<String>()
                            .toSet();
                        debugPrint("==>$productIds");

                        final products = productState.selectedProductList
                            ?.where((p) =>
                                productIds.contains(p.productId.toString()))
                            .toList();

                        debugPrint("==>${products!.length}");
                        debugPrint("==>${products}");

                        _continueEditFlow(productBloc, products);
                      },
                    ),
                  ],
                  child: PdfPreview(
                    allowSharing: false,
                    allowPrinting: true,
                    useActions: false,
                    build: (format) => _createPdf(format, adjustedSize),
                  ),
                ),

                /// 🔄 LOADER
                if (_isEditFlowInProgress)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withOpacity(0.3),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton.small(
              heroTag: 'print',
              backgroundColor: AppColors.DEEP_YELLOW_COLOR,
              onPressed: _printWithSunmi,
              child: const Icon(Icons.print, color: Colors.white),
            ),
            FloatingActionButton.small(
              heroTag: 'edit',
              backgroundColor: AppColors.DEEP_YELLOW_COLOR,
              child: const Icon(Icons.edit,color: Colors.white,),
              onPressed: () {
                setState(() {
                  _isEditFlowInProgress = true;
                  _scanTriggered = false; // 🔁 RESET
                });

                fetchData();

                context.read<ProductBloc>().add(
                      DeleteEstimationEvent(
                        referenceNo: widget.refNumber,
                      ),
                    );
              },
            ),
            SizedBox(width: 10                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      ,),
          ],
        ),
      ),
    );
  }

  /// -------------------- SCAN FLOW --------------------
  void _continueEditFlow(
    ProductBloc bloc,
    List<ProductPayload>? products,
  ) {
    if (products == null ||
        products.isEmpty ||
        customer == null ||
        salesman == null ||
        refNumber == null) {
      return;
    }

    int count = 0;

    for (final item in products) {
      bloc.add(
        ScanItemEvent(
          itemNo: item.itemBarcode.toString().trim(),
          refNo: refNumber!,
          customer: customer,
          salesman: salesman,
          fromPdf: count == 0,
        ),
      );

      bloc.add(SelectProductEvent(product: item));
      count++;
    }

    setState(() => _isEditFlowInProgress = false);

    Future.delayed(
      const Duration(milliseconds: 400),
      () => navigatorKey.currentContext!.go(AppPages.SELECT_PRODUCT),
    );
  }

  /// -------------------- PDF --------------------
  Future<Uint8List> _createPdf(PdfPageFormat format, Size size) async {
    final products = productDetails["products"] as List;

    totalTaxableAmount = 0;
    totalTaxAmount = 0;
    totalAmount = 0;

    for (final p in products) {
      totalTaxableAmount += (p['TOTAL'] ?? 0).toDouble();
      totalTaxAmount += (p['TAXAMOUNT'] ?? 0).toDouble();
      totalAmount += (p['LINETOTAL'] ?? 0).toDouble();
    }

    final pdf = pw.Document(
      version: PdfVersion.pdf_1_4,
      compress: true,
    );

    final logoBytes = await rootBundle.load('assets/images/logo.png');
    final logo = pw.MemoryImage(logoBytes.buffer.asUint8List());

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat(size.width, size.height, marginAll: 5),
        header: (c) =>
            c.pageNumber == 1 ? _buildHeader(size, logo) : pw.SizedBox(),
        build: (_) => [
          pw.Column(
            children: List.generate(
              products.length,
              (i) => pw.Column(
                children: [
                  _buildProductContainer(size, i),
                  if (i == products.length - 1) _buildFooter(size),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    return pdf.save();
  }

  pw.Widget _buildHeader(Size size, pw.MemoryImage logoImage) {
    return pw.Column(
      mainAxisAlignment: pw.MainAxisAlignment.start,
      children: [
        pw.Container(
          alignment: pw.Alignment.center,
          margin: const pw.EdgeInsets.symmetric(vertical: 10),
          child: pw.Image(
            logoImage,
            width: size.width * 0.4,
            height: size.width * 0.25,
          ),
        ),
        pw.Text(
          "* SALES ADVICE *",
          style: pw.TextStyle(
            fontSize: 24,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 10),
        pw.Row(
          children: [
            pw.Spacer(),
            pw.Text(
              DateFormat('dd-MM-yyyy').format(DateTime.now()),
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 10),
        pw.Divider(thickness: 0.5),
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

  pw.Widget _buildProductContainer(Size size, int index) {
    final products = productDetails["products"] as List;
    final product = products[index];

    double diamondRate = 0.0;
    double stoneRate = 0.0;

    for (final ing in product["INGREDIENTS"] ?? []) {
      final id = ing["ITEMID"]?.toString().toLowerCase();
      final value = (ing["CVALUE"] ?? 0).toDouble();

      if (id == 'diamond') diamondRate += value;
      if (id == 'stone') stoneRate += value;
    }

    return pw.Column(
      children: [
        pw.Text(
          "${product["PRODUCTID"] ?? ""}",
          style: pw.TextStyle(
            fontSize: 20,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.Divider(thickness: 0.5),
        pw.Text(
          "${product["ITEMID"] ?? ""}",
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 6),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
          children: [
            _valueColumn("Pcs", product["PIECE"]),
            _valueColumn("Gross", product["GROSSWEIGHT"].toStringAsFixed(3)),
            _valueColumn("Nett", product["NETWEIGHT"].toStringAsFixed(3)),
            _valueColumn("DiaChrg", diamondRate.toStringAsFixed(2)),
            _valueColumn("StnChrg", stoneRate.toStringAsFixed(2)),
            _valueColumn(
              "MkChrg",
              (product["MAKINGRATE"] + product["WASTAGEAMOUNT"])
                  .toStringAsFixed(2),
            ),
            _valueColumn("Value", product["TOTAL"].toStringAsFixed(2)),
          ],
        ),
        pw.Divider(thickness: 0.5),
      ],
    );
  }

  /// Small helper for columns
  pw.Widget _valueColumn(String title, dynamic value) {
    return pw.Column(
      children: [
        pw.Text(
          title,
          style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 2),
        pw.Text(
          "$value",
          style: const pw.TextStyle(fontSize: 11.5),
        ),
      ],
    );
  }

  pw.Widget _buildFooter(Size size) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 10),
        _footerRow(
          "Total Taxable Amount",
          AppWidgets.formatIndianNumber(totalTaxableAmount),
        ),
        pw.SizedBox(height: 6),
        _footerRow(
          "Total Tax Amount",
          AppWidgets.formatIndianNumber(totalTaxAmount),
        ),
        pw.SizedBox(height: 6),
        _footerRow(
          "Total Amount",
          AppWidgets.formatIndianNumber(totalAmount),
        ),
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

  /// 🔹 Print
  Future<void> _printWithSunmi() async {
    final pdfData = await _createPdf(
      PdfPageFormat.roll80,
      MediaQuery.of(context).size,
    );
    await Printing.layoutPdf(
      onLayout: (_) async => pdfData,
      format: PdfPageFormat.roll80,
      name: 'Estimation_Print_Copy',
    );
  }

  /// Footer row helper
  pw.Widget _footerRow(String label, String value) {
    return pw.Row(
      children: [
        pw.Expanded(
          child: pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
        pw.Expanded(
          child: pw.Text(
            value,
            textAlign: pw.TextAlign.right,
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

/*class _PdfviewScreenState extends State<PdfviewScreen> {
  String details = "";
  Map<String, dynamic> productDetails = {"products": []};

  double totalTaxableAmount = 0.0;
  double totalTaxAmount = 0.0;
  double totalAmount = 0.0;
  bool _scanTriggered = false;

  String? refNumber;
  bool _isEditFlowInProgress = false;

  dynamic customer;
  SalesmanPayload? salesman;

  @override
  void initState() {
    super.initState();
  }

  /// 🔹 Fetch customer & salesman
  void fetchData() {
    final estimationState = context.read<EstimationBloc>().state;
    final productState = context.read<ProductBloc>().state;

    if (estimationState is! EstimationDataState) return;

    refNumber = estimationState.refNumber;

    final payload =
        productState.estimationResponseModel?.dataResult?.payload?.payload;

    customer = estimationState.customer ??
        estimationState.customerData ??
        (payload != null
            ? Customer(
                accountNumber: payload.customerId ?? '',
                fullName: payload.custName ?? '',
              )
            : null);

    salesman = estimationState.salesman ??
        (payload != null
            ? SalesmanPayload(text: payload.salesPerson ?? '', value: '')
            : null);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    /// Always rebuild product list cleanly
    productDetails["products"] = [];

    if (widget.estimationResponseModel != null) {
      final payload =
          widget.estimationResponseModel!.dataResult!.payload!.payload!;
      details = payload.salesPerson ?? "";
      productDetails["products"] =
          payload.listItem!.map((e) => e.toJson()).toList();
    } else if (widget.reprintEstimationModel != null) {
      final payload =
          widget.reprintEstimationModel!.dataResult!.payload.payload;
      details = payload[0][0].salesPerson;
      for (final prodList in payload) {
        productDetails["products"].addAll(prodList.map((e) => e.toJson()));
      }
    }

    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.DEEP_YELLOW_COLOR,
          centerTitle: true,
          title: const Text(
            "Print Layout",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Future.delayed(const Duration(milliseconds: 300), () {
                  navigatorKey.currentContext!.go(AppPages.LOGIN);
                });
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: size.width * 0.025),
                height: 24,
                width: 24,
                child: const Icon(Icons.home, color: Colors.white),
              ),
            ),
          ],
        ),
        body: OrientationBuilder(
          builder: (context, orientation) {
            final adjustedSize = orientation == Orientation.portrait
                ? size
                : Size(size.height, size.width);

            return Stack(
              children: [
                MultiBlocListener(
                  listeners: [
                    /// 🔹 STEP 1: After delete → generate ref no
                    BlocListener<ProductBloc, ProductState>(
                      listenWhen: (p, c) =>
                          c.status == ProductStatus.deleteSuccess,
                      listener: (context, state) {
                        context
                            .read<EstimationBloc>()
                            .add(GenerateEstimationNoEvent());
                      },
                    ),

                    /// 🔹 STEP 2: After ref no → scan items
                    BlocListener<EstimationBloc, EstimationState>(
                      listenWhen: (p, c) =>
                          c is EstimationDataState && c.refNumber != null,
                      listener: (context, state) {
                        final estimationState = state as EstimationDataState;

                        refNumber = estimationState.refNumber;
                        final productBloc = context.read<ProductBloc>();
                        final productState = productBloc.state;

                        final payload = widget.estimationResponseModel
                            ?.dataResult?.payload?.payload;

                        if (payload == null) return;

                        final productIds = payload.listItem!
                            .map((e) => e.productId?.toString())
                            .whereType<String>()
                            .toSet();

                        final products = productState.selectedProductList
                            ?.where((p) =>
                                productIds.contains(p.productId.toString()))
                            .toList();

                        _continueEditFlow(productBloc, products);
                      },
                    ),
                  ],
                  child: PdfPreview(
                    allowSharing: false,
                    allowPrinting: true,
                    canChangeOrientation: false,
                    canChangePageFormat: false,
                    useActions: false,
                    build: (format) => _createPdf(format, adjustedSize),
                  ),
                ),

                /// 🔄 Loader
                if (_isEditFlowInProgress)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withOpacity(0.3),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.BUTTON_COLOR,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton.small(
              heroTag: 'print',
              backgroundColor: AppColors.DEEP_YELLOW_COLOR,
              onPressed: _printWithSunmi,
              child: const Icon(Icons.print, color: Colors.white),
            ),
            if (widget.estimationResponseModel != null)
              const SizedBox(width: 10),
            if (widget.estimationResponseModel != null)
              FloatingActionButton.small(
                heroTag: 'edit',
                backgroundColor: AppColors.DEEP_YELLOW_COLOR,
                child: const Icon(Icons.edit, color: Colors.white),
                onPressed: () {
                  setState(() => _isEditFlowInProgress = true);
                  fetchData();
                  context.read<ProductBloc>().add(
                        DeleteEstimationEvent(
                          referenceNo: widget.refNumber,
                        ),
                      );
                },
              ),
          ],
        ),
      ),
    );
  }

  /// 🔹 Scan flow (safe & ordered)
  void _continueEditFlow(
    ProductBloc bloc,
    List<ProductPayload>? products,
  ) {
    if (products == null ||
        products.isEmpty ||
        customer == null ||
        salesman == null ||
        refNumber == null) return;

    int count = 0;

    for (final item in products) {
      bloc.add(
        ScanItemEvent(
          itemNo: item.itemBarcode.toString().trim(),
          refNo: refNumber!,
          customer: customer,
          salesman: salesman,
          fromPdf: count == 0,
        ),
      );
      bloc.add(SelectProductEvent(product: item));
      count++;
    }

    setState(() => _isEditFlowInProgress = false);

    Future.delayed(
      const Duration(milliseconds: 400),
      () => navigatorKey.currentContext!.go(AppPages.SELECT_PRODUCT),
    );
  }

  /// 🔹 Print
  Future<void> _printWithSunmi() async {
    final pdfData = await _createPdf(
      PdfPageFormat.roll80,
      MediaQuery.of(context).size,
    );
    await Printing.layoutPdf(
      onLayout: (_) async => pdfData,
      format: PdfPageFormat.roll80,
      name: 'Estimation_Print_Copy',
    );
  }

  /// 🔹 PDF creation (PURE & SAFE)
  Future<Uint8List> _createPdf(PdfPageFormat format, Size size) async {
    final products = productDetails["products"] as List;

    /// ✅ RESET TOTALS
    totalTaxableAmount = 0.0;
    totalTaxAmount = 0.0;
    totalAmount = 0.0;

    /// ✅ CALCULATE TOTALS ONCE
    for (final product in products) {
      totalTaxableAmount += (product['TOTAL'] ?? 0).toDouble();
      totalTaxAmount += (product['TAXAMOUNT'] ?? 0).toDouble();
      totalAmount += (product['LINETOTAL'] ?? 0).toDouble();
    }

    final pdf = pw.Document(
      version: PdfVersion.pdf_1_4,
      compress: true,
    );

    final logoBytes = await rootBundle.load('assets/images/logo.png');
    final logo = pw.MemoryImage(logoBytes.buffer.asUint8List());

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat(size.width, size.height, marginAll: 5),
        header: (ctx) =>
            ctx.pageNumber == 1 ? _buildHeader(size, logo) : pw.SizedBox(),
        build: (_) => [
          pw.Column(
            children: List.generate(
              products.length,
              (i) => pw.Column(
                children: [
                  _buildProductContainer(size, i),
                  if (i == products.length - 1) _buildFooter(size),
                ],
              ),
            ),
          )
        ],
      ),
    );

    return pdf.save();
  }

  pw.Widget _buildHeader(Size size, pw.MemoryImage logoImage) {
    return pw.Column(
      mainAxisAlignment: pw.MainAxisAlignment.start,
      children: [
        pw.Container(
          alignment: pw.Alignment.center,
          margin: const pw.EdgeInsets.symmetric(vertical: 10),
          child: pw.Image(
            logoImage,
            width: size.width * 0.4,
            height: size.width * 0.25,
          ),
        ),
        pw.Text(
          "* SALES ADVICE *",
          style: pw.TextStyle(
            fontSize: 24,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 10),
        pw.Row(
          children: [
            pw.Spacer(),
            pw.Text(
              DateFormat('dd-MM-yyyy').format(DateTime.now()),
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 10),
        pw.Divider(thickness: 0.5),
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

  pw.Widget _buildProductContainer(Size size, int index) {
    final products = productDetails["products"] as List;
    final product = products[index];

    double diamondRate = 0.0;
    double stoneRate = 0.0;

    for (final ing in product["INGREDIENTS"] ?? []) {
      final id = ing["ITEMID"]?.toString().toLowerCase();
      final value = (ing["CVALUE"] ?? 0).toDouble();

      if (id == 'diamond') diamondRate += value;
      if (id == 'stone') stoneRate += value;
    }

    return pw.Column(
      children: [
        pw.Text(
          "${product["PRODUCTID"] ?? ""}",
          style: pw.TextStyle(
            fontSize: 20,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.Divider(thickness: 0.5),
        pw.Text(
          "${product["ITEMID"] ?? ""}",
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 6),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
          children: [
            _valueColumn("Pcs", product["PIECE"]),
            _valueColumn("Gross", product["GROSSWEIGHT"].toStringAsFixed(3)),
            _valueColumn("Nett", product["NETWEIGHT"].toStringAsFixed(3)),
            _valueColumn("DiaChrg", diamondRate.toStringAsFixed(2)),
            _valueColumn("StnChrg", stoneRate.toStringAsFixed(2)),
            _valueColumn(
              "MkChrg",
              (product["MAKINGRATE"] + product["WASTAGEAMOUNT"])
                  .toStringAsFixed(2),
            ),
            _valueColumn("Value", product["TOTAL"].toStringAsFixed(2)),
          ],
        ),
        pw.Divider(thickness: 0.5),
      ],
    );
  }

  /// Small helper for columns
  pw.Widget _valueColumn(String title, dynamic value) {
    return pw.Column(
      children: [
        pw.Text(
          title,
          style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 2),
        pw.Text(
          "$value",
          style: const pw.TextStyle(fontSize: 11.5),
        ),
      ],
    );
  }

  pw.Widget _buildFooter(Size size) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 10),
        _footerRow(
          "Total Taxable Amount",
          AppWidgets.formatIndianNumber(totalTaxableAmount),
        ),
        pw.SizedBox(height: 6),
        _footerRow(
          "Total Tax Amount",
          AppWidgets.formatIndianNumber(totalTaxAmount),
        ),
        pw.SizedBox(height: 6),
        _footerRow(
          "Total Amount",
          AppWidgets.formatIndianNumber(totalAmount),
        ),
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

  /// Footer row helper
  pw.Widget _footerRow(String label, String value) {
    return pw.Row(
      children: [
        pw.Expanded(
          child: pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
        pw.Expanded(
          child: pw.Text(
            value,
            textAlign: pw.TextAlign.right,
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}*/

/*class _PdfviewScreenState extends State<PdfviewScreen> {
  String details = "";
  List<int> productNo = [];
  List<String> productName = [];
  Map<String, dynamic> productDetails = {"products": []};
  List<dynamic> products = [];
  double diamondRate = 0.0;
  double stoneRate = 0.0;
  double totalTaxableAmount = 0.0;
  double totalTaxAmount = 0.0;
  double totalAmount = 0.0;

  String? refNumber;

  bool _isEditFlowInProgress = false;

  dynamic customer;
  SalesmanPayload? salesman;

  @override
  void initState() {
    super.initState();
  }

  void fetchData() {
    final estimationState = context
        .read<EstimationBloc>()
        .state;
    final productState = context
        .read<ProductBloc>()
        .state;

    if (estimationState is! EstimationDataState) return;

    refNumber = estimationState.refNumber;

    final payload =
        productState.estimationResponseModel?.dataResult?.payload?.payload;

    if (estimationState.customer != null) {
      customer = estimationState.customer!;
    } else if (estimationState.customerData != null) {
      customer = estimationState.customerData!;
    } else if (payload != null) {
      customer = Customer(
        accountNumber: payload.customerId ?? '',
        fullName: payload.custName ?? '',
      );
    }

    if (estimationState.salesman != null) {
      salesman = estimationState.salesman!;
    } else if (payload != null) {
      salesman = SalesmanPayload(
        text: payload.salesPerson ?? '',
        value: '',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    products = [];
    if (widget.estimationResponseModel != null) {
      details = widget.estimationResponseModel!.dataResult!.payload!.payload!
          .salesPerson ??
          "";

      productDetails["products"] = widget
          .estimationResponseModel!.dataResult!.payload!.payload!.listItem!
          .map((e) => e.toJson())
          .toList();
    } else if (widget.reprintEstimationModel != null) {
      var payload = widget.reprintEstimationModel!.dataResult!.payload.payload;

      details = payload[0][0].salesPerson;

      for (var prodList in payload) {
        productDetails["products"].addAll(
          prodList.map((e) => e.toJson()).toList(),
        );
      }
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
          */ /*leading: BackButton(
            color: Colors.white,
            onPressed: () => context.go(AppPages.SELECT_PRODUCT),
          ),*/ /*
          actions: [
            GestureDetector(
              onTap: () {
                //context.read<EstimationBloc>().add(LogoutEvent());
                //context.read<LegalEntityBloc>().add(ClearStateEvent());
                Future.delayed(const Duration(milliseconds: 500), () {
                  if (mounted) {
                    navigatorKey.currentContext!.go(
                      // AppPages.LOGIN,
                      AppPages.LOGIN,
                    );
                  }
                });
                */ /*context.go(
                    // AppPages.ESTIMATION,
                    AppPages.SEARCH_PRODUCT,
                  );*/ /*
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: size.width * 0.025),
                decoration: BoxDecoration(
                  color: AppColors.DEEP_YELLOW_COLOR,
                  borderRadius: BorderRadius.circular(4),
                ),
                height: 24,
                width: 24,
                child: const Icon(Icons.home, color: Colors.white),
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
                child: Stack(
                  children: [
                    MultiBlocListener(
                      listeners: [
                        // 🔹 STEP 1: After Delete → Generate Estimation No
                        BlocListener<ProductBloc, ProductState>(
                          listenWhen: (prev, curr) =>
                          curr.status == ProductStatus.deleteSuccess,
                          listener: (context, state) {
                            context
                                .read<EstimationBloc>()
                                .add(GenerateEstimationNoEvent());
                          },
                        ),
                        // 🔹 STEP 2: After Ref Number → Continue Edit Flow
                        BlocListener<EstimationBloc, EstimationState>(
                          listenWhen: (prev, curr) =>
                          curr is EstimationDataState && curr.refNumber != null,
                          listener: (context, state) {
                            final estimationState = state as EstimationDataState;

                            refNumber = estimationState.refNumber!;
                            debugPrint("NEW REF NUMBER --> $refNumber");

                            final productBloc = context.read<ProductBloc>();
                            final productState = productBloc.state;

                            final estimationPayload = widget
                                .estimationResponseModel
                                ?.dataResult?.payload?.payload;

                            if (estimationPayload == null) return;

                            final productIdStrings = estimationPayload.listItem!
                                .map((e) => e.productId?.toString())
                                .whereType<String>()
                                .toSet();

                            final productList = productState
                                .selectedProductList!
                                .where((product) =>
                                productIdStrings
                                    .contains(product.productId.toString()))
                                .toList();

                            debugPrint(
                                "PRODUCT_LIST --> ${productList.length}");

                            _continueEditFlow(productBloc, productList);
                          },
                        ),
                      ],
                      child: PdfPreview(
                        allowSharing: false,
                        allowPrinting: true,
                        canChangeOrientation: false,
                        canChangePageFormat: false,
                        canDebug: false,
                        useActions: false,
                        build: (format) => _createPdf(format, adjustedSize),
                      ),
                    ),
                    // 🔄 FULL-SCREEN LOADER
                    if (_isEditFlowInProgress)
                      Positioned.fill(
                        child: Container(
                          color: Colors.black.withValues(alpha: 0.3),
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.BUTTON_COLOR,
                            ),
                          ),
                        ),
                      ),
                  ],
                ));
          },
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton.small(
                heroTag: 'f2',
                //onPressed: () => _printWithSunmi(),
                onPressed: () async {
                  await _printWithSunmi(); // directly prints
                },
                backgroundColor: AppColors.DEEP_YELLOW_COLOR,
                */ /*label: const Text(
                  'Print',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),*/ /*
                child: const Icon(
                  Icons.print,
                  color: Colors.white,
                ), //Colors.blue,
              ),
              SizedBox(
                width: size.width * 0.01,
              ),
              if (widget.estimationResponseModel != null)
                FloatingActionButton.small(
                  heroTag: 'f1',
                  backgroundColor: AppColors.DEEP_YELLOW_COLOR,
                  onPressed: () {
                    setState(() {
                      _isEditFlowInProgress = true; // 🔄 START LOADER
                    });

                    fetchData();

                    final estimationPayload = widget
                        .estimationResponseModel?.dataResult?.payload?.payload;

                    if (estimationPayload == null) return;

                    context.read<ProductBloc>().add(
                      DeleteEstimationEvent(referenceNo: widget.refNumber),
                    );
                  },
                  child: const Icon(Icons.edit, color: Colors.white),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _continueEditFlow(ProductBloc productBloc,
      List<ProductPayload>? selectedProducts) {
    if (selectedProducts == null || selectedProducts.isEmpty) {
      debugPrint("No products selected");
      return;
    }

    if (customer == null || salesman == null || refNumber == null) {
      debugPrint("Missing customer / salesman / refNumber");
      return;
    }

    // 3️⃣ Scan each product with NEW ref number
    int count = 0;
    for (final item in selectedProducts) {
      productBloc.add(
        ScanItemEvent(
            itemNo: item.itemBarcode.toString().trim(),
            refNo: refNumber!,
            // ✅ NEW ref number
            customer: customer,
            salesman: salesman,
            fromPdf: count == 0 ? true:false),
      );
      context.read<ProductBloc>().add(SelectProductEvent(product: item));
      count++;
    }
// ✅ END FLOW
    setState(() {
      _isEditFlowInProgress = false;
    });
    // 4️⃣ Navigate
    Future.delayed(const Duration(milliseconds: 500),() => navigatorKey.currentContext!.go(AppPages.SELECT_PRODUCT),);
    // context.go(AppPages.SELECT_PRODUCT);
  }

  Future<void> _printWithSunmi() async {
    final pdfData = await _createPdf(
      PdfPageFormat.roll80,
      MediaQuery
          .of(context)
          .size,
    );
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdfData,
      name: 'Estimation_Print_Copy',
      format: PdfPageFormat.roll80,
    );
  }

  Future<Uint8List> _createPdf(PdfPageFormat format, Size size) async {
    final pdf = pw.Document(
      version: PdfVersion.pdf_1_4,
      compress: true,
    );

    // Load logo once
    final logoBytes = await rootBundle.load('assets/images/logo.png');
    final logoImage = pw.MemoryImage(logoBytes.buffer.asUint8List());

    final products = productDetails["products"] as List;
    final lastIndex = products.length - 1;

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat(
          size.width,
          size.height,
          marginAll: 5,
        ),

        // Header only on first page
        header: (context) {
          if (context.pageNumber == 1) {
            return _buildHeader(size, logoImage);
          }
          return pw.SizedBox();
        },
        build: (context) =>
        [
          pw.Column(
            children: List.generate(
              products.length,
                  (index) {
                return pw.Container(
                  width: size.width,
                  margin: const pw.EdgeInsets.symmetric(vertical: 3),
                  child: pw.Column(
                    children: [
                      _buildProductContainer(size, index),

                      // ✅ Footer ONLY after last product
                      if (index == lastIndex) ...[
                        // pw.SizedBox(height: size.height * 0.05),
                        _buildFooter(size),
                      ],
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
    return pdf.save();
  }

  pw.Widget _buildProductContainer(Size size, int index) {
    final products = productDetails["products"] as List;
    final product = products[index]; // ✅ Single product map
    double diamondRate = 0.0;
    double stoneRate = 0.0;

    totalTaxableAmount += product['TOTAL'];
    totalTaxAmount += product['TAXAMOUNT'];
    totalAmount += product['LINETOTAL'];

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
          // "${product["PRODUCTID"] ?? ""} (${product["ITEMBARCODE"]})",
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
                    (product["MAKINGRATE"] + product["WASTAGEAMOUNT"])
                        .toStringAsFixed(2),
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
              */ /*pw.Expanded(
                child: pw.Text(
                  "Mob No.: ${widget.mobileNo}",
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.black,
                  ),
                ),
              ),*/ /*
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
    //final payments = widget.estimationResponseModel.data!.estimatePayments ?? [];
    */ /*final details = widget.estimationResponseModel!.dataResult!.payload!.payload!
            .salesPerson ??
        "";*/ /*

    // double totalAmount = 0.00;
    debugPrint("TotalTaxableAmount---->$totalTaxableAmount");
    */ /*for(var i in details){
      totalAmount += double.tryParse(i.estimateProductDetails!.lineamount!) ?? 0.00;
    }*/ /*

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // pw.SizedBox(height: 8),
        pw.Row(
          children: [
            pw.Expanded(
              child: pw.Text(
                "Total Taxable Amount",
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.Expanded(
              child: pw.Text(
                details.isNotEmpty
                    ? AppWidgets.formatIndianNumber(totalTaxableAmount)
                // ? totalTaxableAmount.toStringAsFixed(2) //details[0].estimateProductDetails?.lineamount ?? ''
                    : "0.00",
                textAlign: pw.TextAlign.right,
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 6),
        pw.Row(
          children: [
            pw.Expanded(
              child: pw.Text(
                "Total Tax Amount",
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.Expanded(
              child: pw.Text(
                details.isNotEmpty
                    ? AppWidgets.formatIndianNumber(totalTaxAmount)
                // ? totalTaxAmount.toStringAsFixed(2) //details[0].estimateProductDetails?.lineamount ?? ''
                    : "0.00",
                textAlign: pw.TextAlign.right,
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 6),
        pw.Row(
          children: [
            pw.Expanded(
              child: pw.Text(
                "Total Amount",
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.Expanded(
              child: pw.Text(
                details.isNotEmpty
                    ? AppWidgets.formatIndianNumber(totalAmount)
                // ?  totalAmount.toStringAsFixed(2) //details[0].estimateProductDetails?.lineamount ?? ''
                    : "0.00",
                textAlign: pw.TextAlign.right,
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
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
}*/
