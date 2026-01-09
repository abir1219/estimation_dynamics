import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:estimation_dynamics/features/product_list_dialog/data/model/product_model.dart';
import 'package:estimation_dynamics/features/product_list_dialog/presentation/bloc/product_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../widgets/app_widgets.dart';
import '../../add_estimation_screen/presentation/bloc/estimation_bloc.dart';
import '../../salesman_dialog/data/model/employee_model.dart';

class ProductEstimateFormDialog extends StatefulWidget {
  // final List<ProductListModel> productList;
  final ProductPayload product;
  final String skuNo;

  // final int index;

  const ProductEstimateFormDialog(
      {super.key, required this.product, required this.skuNo});

  @override
  State<ProductEstimateFormDialog> createState() =>
      _ProductEstimateFormDialogState();
}

class _ProductEstimateFormDialogState extends State<ProductEstimateFormDialog> {
  TextEditingController productIdController = TextEditingController();
  TextEditingController itemBarCodeController = TextEditingController();
  TextEditingController netWtController = TextEditingController();
  TextEditingController pieceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController netController = TextEditingController();
  TextEditingController diamondRateController = TextEditingController();
  TextEditingController stoneRateController = TextEditingController();
  TextEditingController wasteageAmntController = TextEditingController();
  TextEditingController makingRateController = TextEditingController();
  TextEditingController makingTypeController = TextEditingController();
  TextEditingController makingValueController = TextEditingController();
  TextEditingController rateController = TextEditingController();
  TextEditingController stoneValueController = TextEditingController();
  TextEditingController diamondValueController = TextEditingController();
  TextEditingController discPercentageController = TextEditingController();
  TextEditingController discAmountController = TextEditingController();
  TextEditingController totalAmountController = TextEditingController();
  TextEditingController taxCodeController = TextEditingController();
  TextEditingController taxAmountController = TextEditingController();
  TextEditingController otherValueController = TextEditingController();
  TextEditingController calculationValue = TextEditingController();
  TextEditingController miscAmountController = TextEditingController();
  TextEditingController lineAmountController = TextEditingController();

  List<String> items = ['Qty', 'Pcs', 'Tot', 'Percentage', "Nett"];
  String? _selectedMacType;

  String? refNumber = "";

  // late final Customer customer;
  late final dynamic customer;

  // late final CustomerData customerData;
  late final SalesmanPayload salesman;

  @override
  void initState() {
    super.initState();

    final estimationState = context.read<EstimationBloc>().state;
    debugPrint("STATE-->$estimationState");
    if (estimationState is EstimationDataState) {
      debugPrint("Ref Number: ${estimationState.refNumber}");
      refNumber = estimationState.refNumber;
      // debugPrint("Customer: ${estimationState.customer}");
      // customer = estimationState.customer!;
      if (estimationState.customer != null) {
        debugPrint("Customer: ${estimationState.customer}");
        customer = estimationState.customer!;
      } else {
        debugPrint("Customer: ${estimationState.customerData}");
        // customerData = estimationState.customerData!;
        customer = estimationState.customerData!;
      }
      debugPrint("Salesman: ${estimationState.salesman}");
      salesman = estimationState.salesman!;
    }

    _selectedMacType = items[0];

    // debugPrint("miscChargeArray-->${widget.productList[widget.index].skuDetailCode}");
    // debugPrint("miscChargeArray-->${widget.productList[widget.index].miscCharge![0].amount}");

    productIdController.text = widget.product.productId.toString();
    itemBarCodeController.text = widget.product.itemBarcode.toString();
    pieceController.text = widget.product.piece.toString();
    wasteageAmntController.text = AppWidgets.formatIndianNumber(widget
        .product.wastageAmount); //widget.product.wastageAmount.toString();
    quantityController.text = widget.product.grossWeight.toString();
    totalAmountController.text = AppWidgets.formatIndianNumber(
        widget.product.total); //widget.product.total.toString();
    // netWtController.text = widget.product.netweight.toString();
    double netWt = 0.0;
    for (var ingredient in widget.product.ingredients) {
      if (ingredient.pUREQTY != 0) {
        netWt += ingredient.nETWEIGHT!;
      }
    }
    netWtController.text = netWt.toString();
    netController.text =
        AppWidgets.formatIndianNumber(
        widget.product.netValue); //widget.product.netValue.toString();
    double diamondRate = 0.0;
    double stoneRate = 0.0;
    for (var ingredient in widget.product.ingredients) {
      if (ingredient.iTEMID!.toLowerCase() == 'diamond') {
        // diamondRate += ingredient.rATE!;
        diamondRate += ingredient.cVALUE!;
      }
      if (ingredient.iTEMID!.toLowerCase() == 'stone') {
        // stoneRate += ingredient.rATE!;
        stoneRate += ingredient.cVALUE!;
      }
    }
    diamondRateController.text = AppWidgets.formatIndianNumber(
        diamondRate); //diamondRate.toStringAsFixed(2);
    stoneRateController.text = AppWidgets.formatIndianNumber(
        stoneRate); //stoneRate.toStringAsFixed(2);
    // netController.text = widget.productList[widget.index].nett!;
    rateController.text = AppWidgets.formatIndianNumber(widget.product.rate - (diamondRate + stoneRate)); //widget.product.rate.toString();
    makingRateController.text = AppWidgets.formatIndianNumber(widget.product.makingAmount);

        /*AppWidgets.formatIndianNumber(
        widget.product.makingRate == 0
            ? *//*widget.product.makingRate +*//* widget.product.wastageAmount
            : widget.product.makingRate);*/
    //(widget.product.makingRate + widget.product.wastageAmount).toString();
    // stoneValueController.text = widget.product.productId.toString();
    // diamondValueController.text = widget.productList[widget.index].diaVal!;
    calculationValue.text = AppWidgets.formatIndianNumber(
        widget.product.cvalue); //widget.product.cvalue.toString();
    lineAmountController.text = AppWidgets.formatIndianNumber(
        widget.product.lineTotal); //widget.product.lineTotal.toString();
    taxCodeController.text = widget.product.taxCode.toString();
    taxAmountController.text = AppWidgets.formatIndianNumber(
        widget.product.taxAmount); //widget.product.taxAmount.toString();
    // miscAmountController.text =
    //     widget.productList[widget.index].miscChargeCode != null
    //         ? widget.productList[widget.index].miscChargeCode!.rate!
    //             .toStringAsFixed(2)
    //         : "0.00";
    // taxCodeController.text =
    //     widget.productList[widget.index].taxInfo![0].taxCode!;
    // discPercentageController.text = "0.00";
    // discAmountController.text = "0.00";

    /*if (_selectedMacType == 'Qty') {
      makingValueController.text =
          (double.parse(quantityController.text.toString()) *
                  double.parse(makingRateController.text.toString()))
              .toString();
    }*/
  }

  @override
  void dispose() {
    productIdController.dispose();
    itemBarCodeController.dispose();
    netWtController.dispose();
    pieceController.dispose();
    quantityController.dispose();
    netController.dispose();
    diamondRateController.dispose();
    wasteageAmntController.dispose();
    stoneRateController.dispose();
    makingRateController.dispose();
    makingTypeController.dispose();
    makingValueController.dispose();
    rateController.dispose();
    stoneValueController.dispose();
    diamondValueController.dispose();
    discPercentageController.dispose();
    discAmountController.dispose();
    taxCodeController.dispose();
    taxAmountController.dispose();
    otherValueController.dispose();
    totalAmountController.dispose();
    calculationValue.dispose();
    miscAmountController.dispose();
    lineAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);

    /*taxAmountController.text = calculateTaxAmount(
      makingValue: makingValueController.text,
      stoneAmount: stoneValueController.text,
      diamondAmount: diamondValueController.text,
      miscAmount: miscAmountController.text,
      calculationValue: calculationValue.text,
      otherValue: '0.00',
      discountAmount: discAmountController.text,
      taxPercentage: widget.productList[widget.index].taxInfo![0].percentage!,
    ).toStringAsFixed(2);

    lineAmountController.text = calculateLineAmount(
      makingValue: makingValueController.text,
      stoneAmount: stoneValueController.text,
      calculationValue: calculationValue.text,
      miscAmount: miscAmountController.text,
      diamondAmount: diamondValueController.text,
      otherValue: '0.00',
      discountAmount: discAmountController.text,
      taxAmount: double.parse(taxAmountController.text),
    ).toStringAsFixed(2);*/

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        var state = context.read<ProductBloc>().state;
        _showVoidAlertDialog(state);
      },
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        insetPadding: EdgeInsets.symmetric(
          // horizontal: size.width * 0.02, vertical: AppDimensions.getResponsiveHeight(context) * 0.1),
          horizontal: AppDimensions.getResponsiveWidth(context) * 0.02,
          vertical: MediaQuery.orientationOf(context) == Orientation.portrait
              ? AppDimensions.getResponsiveHeight(context) * 0.05
              : AppDimensions.getResponsiveHeight(context) * 0.01,
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        backgroundColor: Colors.white,
        child: ScaffoldMessenger(
          child: Scaffold(
            backgroundColor: AppColors.APP_SCREEN_BACKGROUND_COLOR,
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Gap(AppDimensions.getResponsiveHeight(context) * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              // "${widget.productList[widget.index].productCode!.prodName} ${widget.productList[widget.index].purity != null ? widget.productList[widget.index].purity!.purity : "18k"}",
                              widget.product.description,
                              style: const TextStyle(
                                color: AppColors.TITLE_TEXT_COLOR,
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            var state = context.read<ProductBloc>().state;
                            _showVoidAlertDialog(state);
                          },
                          child: Container(
                            height: 25,
                            width: 25,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: Colors.white),
                            child: SvgPicture.asset(
                              "assets/images/circle_close.svg",
                              colorFilter: const ColorFilter.mode(
                                  AppColors.TITLE_TEXT_COLOR, BlendMode.srcIn),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Gap(AppDimensions.getResponsiveHeight(context) * 0.02),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            /*widget.productList[widget.index].productCode!.image!=null?SizedBox(
                              height: size.height * 0.2,
                              width: size.width * 0.5,
                              child: Image.network(widget.productList[widget.index].productCode!.image!,fit: BoxFit.fill,),
                              //Image.network(widget.productList[widget.index].productCode!.image!,fit: BoxFit.fill,),
                            ):Container(),*/
                            Gap(AppDimensions.getResponsiveHeight(context) *
                                0.01),
                            Row(
                              children: [
                                Expanded(
                                  child: AppWidgets().buildTextFormField(
                                    enabled: false,
                                    size,
                                    controller: productIdController,
                                    hintText: "Product Id",
                                    labelText: 'Product Id',
                                  ),
                                ),
                                Expanded(
                                  child: AppWidgets().buildTextFormField(
                                    enabled: false,
                                    size,
                                    controller: itemBarCodeController,
                                    hintText: "Item Barcode",
                                    labelText: 'Item Barcode',
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: AppWidgets().buildTextFormField(
                                    enabled: false,
                                    size,
                                    controller: pieceController,
                                    hintText: "Piece",
                                    labelText: 'Piece',
                                    onChange: (value) {
                                      setState(() {
                                        if (_selectedMacType == 'Pcs') {
                                          makingValueController.text =
                                              (double.parse(pieceController.text
                                                          .toString()) *
                                                      double.parse(
                                                          makingRateController
                                                              .text
                                                              .toString()))
                                                  .toStringAsFixed(2);
                                        }
                                      });
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: AppWidgets().buildTextFormField(
                                    enabled: false,
                                    size,
                                    controller: quantityController,
                                    hintText: "Gross Wt.",
                                    labelText: 'Gross Wt.',
                                    onChange: (value) {
                                      setState(() {
                                        if (_selectedMacType == 'Qty') {
                                          makingValueController.text =
                                              (double.parse(quantityController
                                                          .text
                                                          .toString()) *
                                                      double.parse(
                                                          makingRateController
                                                              .text
                                                              .toString()))
                                                  .toStringAsFixed(2);
                                        }
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: AppWidgets().buildTextFormField(
                                    enabled: false,
                                    size,
                                    controller: netWtController,
                                    hintText: "Net Wt.",
                                    labelText: 'Net Wt.',
                                    onChange: (value) {
                                      setState(() {
                                        if (_selectedMacType == 'Pcs') {
                                          makingValueController.text =
                                              (double.parse(pieceController.text
                                                          .toString()) *
                                                      double.parse(
                                                          makingRateController
                                                              .text
                                                              .toString()))
                                                  .toStringAsFixed(2);
                                        }
                                      });
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: AppWidgets().buildTextFormField(
                                    enabled: false,
                                    size,
                                    controller: netController,
                                    hintText: "Net Value",
                                    labelText: 'Net Value',
                                    onChange: (value) {
                                      setState(() {
                                        if (_selectedMacType == 'Nett') {
                                          makingValueController.text =
                                              (double.parse(netController.text
                                                          .toString()) *
                                                      double.parse(
                                                          makingRateController
                                                              .text
                                                              .toString()))
                                                  .toStringAsFixed(2);
                                        }
                                      });
                                    },
                                  ),
                                ),
                                /*Expanded(
                                  child: AppWidgets().buildTextFormField(
                                    enabled: false,
                                    size,
                                    controller: quantityController,
                                    hintText: "Gross Wt.",
                                    labelText: 'Gross Wt.',
                                    onChange: (value) {
                                      setState(() {
                                        if (_selectedMacType == 'Qty') {
                                          makingValueController.text =
                                              (double.parse(quantityController.text
                                                          .toString()) *
                                                      double.parse(
                                                          makingRateController.text
                                                              .toString()))
                                                  .toStringAsFixed(2);
                                        }
                                      });
                                    },
                                  ),
                                ),*/
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: AppWidgets().buildTextFormField(
                                    size,
                                    controller: rateController,
                                    hintText: "Metal Value",
                                    enabled: false,
                                    labelText: 'Metal Value',
                                  ),
                                ),
                                Expanded(
                                  child: AppWidgets().buildTextFormField(
                                    size,
                                    controller: calculationValue,
                                    hintText: "C Value",
                                    enabled: false,
                                    labelText: 'C Value',
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: AppWidgets().buildTextFormField(
                                    enabled: false,
                                    size,
                                    controller: diamondRateController,
                                    hintText: "Diamond Rate",
                                    labelText: 'Diamond Rate',
                                  ),
                                ),
                                Expanded(
                                  child: AppWidgets().buildTextFormField(
                                    size,
                                    controller: stoneRateController,
                                    hintText: "Stone Rate",
                                    enabled: false,
                                    labelText: 'Stone Rate',
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: AppWidgets().buildTextFormField(
                                    size,
                                    controller: wasteageAmntController,
                                    enabled: false,
                                    hintText: "Wastage Amount",
                                    labelText: 'Wastage Amount',
                                  ),
                                ),
                                Expanded(
                                  child: AppWidgets().buildTextFormField(
                                    size,
                                    controller: makingRateController,
                                    enabled: false,
                                    hintText: "Mak Value",
                                    labelText: 'Mak Value',
                                  ),
                                ),
                              ],
                            ),
                            /* Row(
                              children: [
                                Expanded(
                                  child: AppWidgets().buildDropdownField(
                                    size,
                                    //controller: pieceController,
                                    selectedValue: _selectedMacType,
                                    hintText: "Mak Type",
                                    labelText: 'Mak Type',
                                    dropdownItems: items,
                                    onChange: (value) {
                                      debugPrint("DD-Value==>$value");
                                      setState(() {
                                        _selectedMacType = value.toString();
                                        if (_selectedMacType == 'Qty') {
                                          makingValueController.text =
                                              (double.parse(quantityController.text
                                                          .toString()) *
                                                      double.parse(
                                                          makingRateController.text
                                                              .toString()))
                                                  .toStringAsFixed(2);
                                        } else if (_selectedMacType == 'Pcs') {
                                          makingValueController.text =
                                              (double.parse(pieceController.text
                                                          .toString()) *
                                                      double.parse(
                                                          makingRateController.text
                                                              .toString()))
                                                  .toStringAsFixed(2);
                                        } else if (_selectedMacType == 'Tot') {
                                          makingValueController.text =
                                              (double.parse(makingRateController
                                                      .text
                                                      .toString()))
                                                  .toStringAsFixed(2);
                                        } else if (_selectedMacType == 'Nett') {
                                          makingValueController.text =
                                              (double.parse(netController.text
                                                          .toString()) *
                                                      double.parse(
                                                          makingRateController.text
                                                              .toString()))
                                                  .toStringAsFixed(2);
                                        }
                                      });
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: AppWidgets().buildTextFormField(
                                    size,
                                    controller: makingValueController,
                                    enabled: false,
                                    hintText: "Mak Val",
                                    labelText: 'Mak Val',
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: AppWidgets().buildTextFormField(
                                    size,
                                    controller: diamondValueController,
                                    hintText: "Dia. Val.",
                                    enabled: false,
                                    labelText: 'Dia. Val.',
                                  ),
                                ),
                                Expanded(
                                  child: AppWidgets().buildTextFormField(
                                    size,
                                    controller: stoneValueController,
                                    enabled: false,
                                    hintText: "St. Val",
                                    labelText: 'St. Val',
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: AppWidgets().buildTextFormField(
                                    size,
                                    controller: otherValueController,
                                    hintText: "Other Val.",
                                    labelText: 'Other Val.',
                                  ),
                                ),
                                Expanded(
                                  child: AppWidgets().buildTextFormField(
                                    size,
                                    controller: miscAmountController,
                                    hintText: "Misc Amt",
                                    enabled: false,
                                    labelText: 'Misc Amt',
                                  ),
                                ),
                              ],
                            ),

                            Row(
                              children: [
                                Expanded(
                                  child: AppWidgets().buildTextFormField(
                                    size,
                                    controller: discPercentageController,
                                    hintText: "Disc Per",
                                    labelText: 'Disc Per',
                                    textInputType:
                                        const TextInputType.numberWithOptions(
                                            decimal: true),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'^\d*\.?\d*')),
                                    ],
                                    onChange: (value) {
                                      setState(() {
                                        // if (double.parse(
                                        //         discPercentageController.text) <=
                                        //     100) {
                                        if (discPercentageController
                                            .text.isNotEmpty) {
                                          discAmountController.text = (double.parse(
                                                      makingValueController.text) *
                                                  double.parse(
                                                      discPercentageController
                                                          .text) /
                                                  100)
                                              .toStringAsFixed(2);
                                        } else {
                                          discAmountController.text = '0.00';
                                          //discPercentageController.text = '0.00';
                                        }
                                        //}
                                      });
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: AppWidgets().buildTextFormField(
                                    size,
                                    controller: discAmountController,
                                    hintText: "Disc Amt",
                                    labelText: 'Disc Amt',
                                    textInputType:
                                        const TextInputType.numberWithOptions(
                                            decimal: true),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'^\d*\.?\d*')),
                                    ],
                                    onChange: (value) {
                                      setState(() {
                                        if (discAmountController.text.isNotEmpty) {
                                          discPercentageController
                                              .text = ((double.parse(
                                                          discAmountController
                                                              .text) *
                                                      100) /
                                                  (double.parse(
                                                      makingValueController.text)))
                                              .toString();
                                        } else {
                                          discPercentageController.text = '0.00';
                                        }
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),*/
                            Row(
                              children: [
                                Expanded(
                                  child: AppWidgets().buildTextFormField(
                                    size,
                                    controller: totalAmountController,
                                    enabled: false,
                                    hintText: "Total",
                                    labelText: 'Total',
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: AppWidgets().buildTextFormField(
                                    size,
                                    controller: taxCodeController,
                                    enabled: false,
                                    hintText: "Tax Code",
                                    labelText: 'Tax Code',
                                  ),
                                ),
                                Expanded(
                                  child: AppWidgets().buildTextFormField(
                                    size,
                                    controller: taxAmountController,
                                    enabled: false,
                                    hintText: "Tax Amt",
                                    labelText: 'Tax Amt',
                                  ),
                                ),
                              ],
                            ),
                            /* Row(
                              children: [
                                Expanded(
                                  child: AppWidgets().buildTextFormField(
                                    size,
                                    controller: pieceController,
                                    hintText: "Tax Amt",
                                    labelText: 'Tax Amt',
                                  ),
                                ),
                                */
                            /*Expanded(
                                  child: AppWidgets().buildTextFormField(
                                    size,
                                    controller: quantityController,
                                    hintText: "Line Amt",
                                    labelText: 'Line Amt',
                                  ),
                                ),*/
                            /*
                              ],
                            ),*/
                            AppWidgets().buildTextFormField(
                              size,
                              controller: lineAmountController,
                              enabled: false,
                              hintText: "Line Amt",
                              labelText: 'Line Amt',
                            ),
                          ],
                        ),
                      ),
                    ),
                    Gap(AppDimensions.getResponsiveHeight(context) * 0.01),
                    AppWidgets.customMobileButton(
                      size: size,
                      isLoading: false,
                      //state.apiStatus == ApiStatus.loading ? true : false,
                      btnName: "Submit",
                      color: AppColors.DEEP_YELLOW_COLOR,
                      func: () {
                        context
                            .read<ProductBloc>()
                            .add(SelectProductEvent(product: widget.product));
                        Navigator.pop(context);
                      },
                    ),
                    /*BlocConsumer<EstimationBloc, EstimationState>(
                      listener: (context, state) {
                        switch (state.apiStatus) {
                          case ApiStatus.success:
                            Navigator.pop(context);
                            context.go(AppPages.SEARCH_PRODUCT);
                          default:
                            return;
                        }
                      },
                      builder: (context, state) {
                        return AppWidgets.customMobileButton(
                          size: size,
                          isLoading:
                              state.apiStatus == ApiStatus.loading ? true : false,
                          btnName: "Submit",
                          color: AppColors.LOGO_BACKGROUND_COLOR,
                          func: () {
                            state.productList![widget.index].pcs =
                                int.parse(pieceController.text);
                            state.productList![widget.index].quantity =
                                quantityController.text;
                            context.read<EstimationBloc>().add(
                                  SkuSaveForListEvent(
                                    widget.index,
                                    double.parse(lineAmountController.text),
                                    double.parse(taxAmountController.text),
                                    double.parse(discAmountController.text),
                                    double.parse(quantityController.text),
                                  ),
                                );
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),*/
                    Gap(AppDimensions.getResponsiveHeight(context) * 0.01),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  double calculateTaxAmount(
      {required String makingValue,
      required String stoneAmount,
      required String diamondAmount,
      required String calculationValue,
      required String miscAmount,
      required String otherValue,
      required String discountAmount,
      required double taxPercentage}) {
    double discountedAmount = discountAmount.isEmpty
        ? double.parse("0.00")
        : double.parse(discountAmount);
    double taxableAmount = (((double.parse(makingValue) +
                    double.parse(stoneAmount) +
                    double.parse(calculationValue) +
                    double.parse(miscAmount) +
                    double.parse(diamondAmount) +
                    double.parse(otherValue)) -
                discountedAmount) *
            taxPercentage) /
        100;
    return taxableAmount;
  }

  double calculateLineAmount(
      {required String makingValue,
      required String stoneAmount,
      required String diamondAmount,
      required String calculationValue,
      required String miscAmount,
      required String otherValue,
      required String discountAmount,
      required double taxAmount}) {
    double discountedAmount = discountAmount.isEmpty
        ? double.parse("0.00")
        : double.parse(discountAmount);
    double total = ((double.parse(makingValue) +
            double.parse(stoneAmount) +
            double.parse(diamondAmount) +
            double.parse(otherValue) +
            double.parse(miscAmount) +
            double.parse(calculationValue) +
            taxAmount) -
        discountedAmount);
    return total;
  }

  _showVoidAlertDialog(ProductState state) {
    return AwesomeDialog(
      context: context,
      dismissOnBackKeyPress: false,
      dismissOnTouchOutside: false,
      animType: AnimType.scale,
      dialogType: DialogType.warning,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6),
        child: Text(
          'Do you need to void this estimation?',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontStyle: FontStyle.normal,
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w600),
        ),
      ),
      title: 'This is Ignored',
      desc: 'This is also Ignored',
      //btnOk: Text('Yes'),
      btnOkText: 'Yes',
      btnOkOnPress: () {
        context.read<ProductBloc>().add(UnlockItemEvent(
            itemNo: widget.skuNo,
            refNo: refNumber,
            customer: customer,
            salesman: salesman,
            lineNo: widget.product.linenum,
            isScanned: true));
        Navigator.pop(context);
      },
      // btnCancel: Text('No'),
      btnCancelText: 'No',
      btnCancelOnPress: () {}, //Navigator.pop(context),
    )..show();
  }
}
