import 'dart:io';

import 'package:estimation_dynamics/features/product_list_dialog/data/model/product_model.dart';
import 'package:estimation_dynamics/features/product_list_dialog/presentation/bloc/product_bloc.dart';
import 'package:estimation_dynamics/features/salesman_dialog/data/model/employee_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../widgets/app_widgets.dart';
import '../../add_estimation_screen/presentation/bloc/estimation_bloc.dart';
import '../../product_form_dialog/presentation/product_estimate_form_dialog.dart';

class ProductListDialog extends StatefulWidget {
  const ProductListDialog({super.key});

  @override
  State<ProductListDialog> createState() => _ProductListDialogState();
}

class _ProductListDialogState extends State<ProductListDialog> {
  String? refNumber = "";

  // late final Customer customer;
  late final dynamic customer;

  // late final CustomerData customerData;
  late final SalesmanPayload salesman;

  bool isScanned = false;

  @override
  void initState() {
    super.initState();
    context
        .read<ProductBloc>()
        .add(ApiStatusChangeEvent());
    // context.read<EstimationBloc>().add(const FetchProductListEvent());
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
  }

  final _itemTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      insetPadding: EdgeInsets.symmetric(
        // horizontal: size.width * 0.02, vertical: AppDimensions.getResponsiveHeight(context) * 0.1),
        horizontal: AppDimensions.getResponsiveWidth(context) * 0.02,
        vertical: MediaQuery.orientationOf(context) == Orientation.portrait
            ? AppDimensions.getResponsiveHeight(context) * 0.1
            : AppDimensions.getResponsiveHeight(context) * 0.01,
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      backgroundColor: Colors.white,
      child: ScaffoldMessenger(
        child: Scaffold(
          body: SafeArea(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.APP_SCREEN_BACKGROUND_COLOR,
                    AppColors.APP_SCREEN_BACKGROUND_COLOR,
                    AppColors.APP_SCREEN_BACKGROUND_COLOR
                        .withValues(alpha: 0.19),
                  ],
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
                child: Column(
                  children: [
                    Gap(AppDimensions.getResponsiveHeight(context) * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Product search",
                          style: TextStyle(
                              color: AppColors.TITLE_TEXT_COLOR,
                              fontWeight: FontWeight.w600,
                              fontSize: 18),
                        ),
                        BlocConsumer<ProductBloc, ProductState>(
                          listener: (context, state) {
                          },
                          builder: (context, state) {
                            return GestureDetector(
                                onTap: () {
                                  context
                                      .read<ProductBloc>()
                                      .add(ApiStatusChangeEvent());
                                  context.read<ProductBloc>().add(
                                      UnlockItemEvent(
                                          itemNo: state.scannedItem!.transactionStr.sectionHeaderR.split(":").first,
                                          refNo: refNumber,
                                          customer: customer,
                                          salesman: salesman,
                                          lineNo: state.scannedItem!.linenum,
                                          isScanned: state.isScanned));
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  height: 25,
                                  width: 25,
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white),
                                  child: SvgPicture.asset(
                                    "assets/images/circle_close.svg",
                                    colorFilter: const ColorFilter.mode(
                                        AppColors.TITLE_TEXT_COLOR,
                                        BlendMode.srcIn),
                                  ),
                                ));
                          },
                        ),
                      ],
                    ),
                    Gap(AppDimensions.getResponsiveHeight(context) * 0.02),
                    Expanded(
                      child: Column(
                        children: [
                          AppWidgets.buildSearchableField(
                              size, "Product code,Name,Id", _itemTextController,
                              func: () {
                            if (_itemTextController.text.isNotEmpty) {
                              context.read<ProductBloc>().add(ScanItemEvent(
                                    itemNo: _itemTextController.text.trim(),
                                    refNo: refNumber,
                                    customer: customer,
                                    salesman: salesman,
                                  ));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text("Scan an item to continue")));
                            }
                          }, isEnabled: true),
                          Gap(AppDimensions.getResponsiveHeight(context) *
                              0.01),
                          BlocConsumer<ProductBloc, ProductState>(
                            listener: (context, state) {},
                            builder: (context, state) {
                              final size = MediaQuery.of(context).size;

                              switch (state.status) {
                                case ProductStatus.submitError:
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    _showAlertDialog();
                                  });
                                  return SizedBox.shrink();

                                case ProductStatus.initial ||
                                      ProductStatus.submitDone:
                                  return const SizedBox.shrink();

                                case ProductStatus.scanLoading:
                                  return Expanded(
                                    child: Center(
                                      child: Platform.isAndroid
                                          ? const CircularProgressIndicator(
                                              color: AppColors.BUTTON_COLOR)
                                          : const CupertinoActivityIndicator(),
                                    ),
                                  );

                                case ProductStatus.scanLoaded:
                                  if (state.scannedItem != null) {
                                    return _buildProductContainer(
                                        state.scannedItem!, size, () {
                                      context
                                          .read<ProductBloc>()
                                          .add(ApiStatusChangeEvent());
                                      Navigator.pop(context);
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (context) {
                                          return ProductEstimateFormDialog(
                                              product: state.scannedItem!,
                                              skuNo: _itemTextController.text
                                                  .trim());
                                        },
                                      );
                                    });
                                  } else {
                                    return const SizedBox.shrink();
                                  }

                                case ProductStatus.submittedItems:
                                  if (state.productList != null &&
                                      state.productList!.isNotEmpty) {
                                    return ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: state.productList!.length,
                                      itemBuilder: (context, index) {
                                        final product =
                                            state.productList![index];
                                        return _buildProductContainer(
                                            product, size, () {
                                          context
                                              .read<ProductBloc>()
                                              .add(ApiStatusChangeEvent());
                                          Navigator.pop(context);
                                          showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (context) {
                                              return ProductEstimateFormDialog(
                                                product: product,
                                                skuNo: _itemTextController.text
                                                    .trim(),
                                              );
                                            },
                                          );
                                        });
                                      },
                                    );
                                  } else {
                                    return const Center(
                                      child: Text(
                                        "Search Product",
                                        style: TextStyle(
                                          color: AppColors.DEEP_YELLOW_COLOR,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    );
                                  }
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductContainer(
      ProductPayload product,
      Size size,
      /*EstimationState state,*/
      void Function() func) {
    return GestureDetector(
      onTap: () => func(),
      child: Container(
        /*margin: EdgeInsets.symmetric(
            horizontal: size.width * 0.01, vertical: AppDimensions.getResponsiveHeight(context) * 0.02),*/
        margin: EdgeInsets.symmetric(
            vertical: AppDimensions.getResponsiveHeight(context) * .005),
        // padding: const EdgeInsets.symmetric(horizontal: 6), //,vertical: 2
        // padding: const EdgeInsets.only(left: 6), //,vertical: 2
        // height: AppDimensions.getResponsiveHeight(context) * 0.008,
        decoration: BoxDecoration(
            color: AppColors.APP_SCREEN_BACKGROUND_COLOR,
            border: Border.all(color: AppColors.TITLE_TEXT_COLOR)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  // height: AppDimensions.getResponsiveHeight(context) * 0.02,
                  margin: EdgeInsets.symmetric(
                      vertical:
                          AppDimensions.getResponsiveHeight(context) * .005,
                      horizontal: size.width * .01),
                  padding: EdgeInsets.symmetric(
                      horizontal: size.width * .02,
                      vertical:
                          AppDimensions.getResponsiveHeight(context) * .002),
                  decoration: BoxDecoration(
                    color: AppColors.TITLE_TEXT_COLOR,
                    borderRadius: BorderRadius.circular(0),
                  ),
                  child: Center(
                    child: Text(
                      product.itemBarcode,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                      vertical:
                          AppDimensions.getResponsiveHeight(context) * .005,
                      horizontal: size.width * .01),
                  padding: EdgeInsets.symmetric(
                      horizontal: size.width * .002,
                      vertical:
                          AppDimensions.getResponsiveHeight(context) * .002),
                  child: Text(
                    // "${product.productId}, ${product.description}",
                    product.description,
                    style: const TextStyle(
                        color: AppColors.TITLE_TEXT_COLOR,
                        fontSize: 16,
                        fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: size.width * 0.02),
              child: SvgPicture.asset(
                "assets/images/arrow_right_circle.svg",
                // colorFilter: ColorFilter.mode(AppColors.TITLE_TEXT_COLOR, BlendMode.src,),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _showAlertDialog() {
    return AwesomeDialog(
      context: context,
      animType: AnimType.scale,
      dialogType: DialogType.error,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6),
        child: Text(
          'SKU is not found as already scanned!',
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
      btnOkOnPress: () {},
    )..show();
  }
}
