import 'package:estimation_dynamics/features/product_list_dialog/data/model/product_model.dart';
import 'package:estimation_dynamics/features/product_list_dialog/presentation/product_list_dialog.dart';
import 'package:estimation_dynamics/widgets/custom_bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../main.dart';
import '../../../router/app_pages.dart';
import '../../../widgets/app_widgets.dart';
import '../../add_estimation_screen/presentation/bloc/estimation_bloc.dart';
import '../../product_list_dialog/presentation/bloc/product_bloc.dart';
import '../../salesman_dialog/data/model/employee_model.dart';
import '../../search_customer_dialog/data/customer_model.dart';

class SelectProductScreen extends StatefulWidget {
  const SelectProductScreen({super.key});

  @override
  State<SelectProductScreen> createState() => _SelectProductScreenState();
}

class _SelectProductScreenState extends State<SelectProductScreen> {
  bool _isDialogOpen = false;

  String? refNumber = "";
  late final Customer customer;
  late final SalesmanPayload salesman;

  @override
  void initState() {
    super.initState();
    // context.read<EstimationBloc>().add(const FetchProductListEvent());
    final estimationState = context.read<EstimationBloc>().state;
    debugPrint("STATE-->$estimationState");
    if (estimationState is EstimationDataState) {
      debugPrint("Ref Number: ${estimationState.refNumber}");
      refNumber = estimationState.refNumber;
      debugPrint("Customer: ${estimationState.customer}");
      customer = estimationState.customer!;
      debugPrint("Salesman: ${estimationState.salesman}");
      salesman = estimationState.salesman!;
    }
  }

  void _toggleDialog() {
    setState(() {
      _isDialogOpen = !_isDialogOpen;
    });
    if (_isDialogOpen) {
      showModalBottomSheet(
        context: context,
        isDismissible: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
        ),
        builder: (context) => Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              //margin: EdgeInsets.symmetric(horizontal: size.width * .02,),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: AppColors.HEADER_GRADIENT_START_COLOR,
              ),
              height: AppDimensions.getResponsiveHeight(context) * .08,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Estimate Amount",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.TITLE_TEXT_COLOR,
                                  fontWeight: FontWeight.w300),
                            ),
                            /*Gap(MediaQuery.sizeOf(context).width * 0.004),
                            InkWell(
                              onTap: () {
                                showGeneralDialog(
                                  context: context,
                                  // builder: (context) => const IngredientsFormDialog(),
                                  barrierDismissible: true,
                                  barrierLabel:
                                      MaterialLocalizations.of(context)
                                          .modalBarrierDismissLabel,
                                  barrierColor: Colors.black45,
                                  transitionDuration:
                                      const Duration(milliseconds: 300),
                                  transitionBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    return SlideTransition(
                                      position: Tween<Offset>(
                                        begin: const Offset(0, 1),
                                        // Start from the bottom
                                        end: const Offset(
                                            0, 0), // End at the center
                                      ).animate(CurvedAnimation(
                                        parent: animation,
                                        curve: Curves
                                            .easeInOut, // Ease-in transformation
                                      )),
                                      child: child,
                                    );
                                  },
                                  pageBuilder: (BuildContext context,
                                          Animation<double> animation,
                                          Animation<double>
                                              secondaryAnimation) =>
                                      Container(),
                                );
                              },
                              child: const Icon(
                                Icons.info,
                                size: 18,
                                color: Colors.white,
                              ),
                            )*/
                          ],
                        ),
                        BlocConsumer<ProductBloc, ProductState>(
                          listener: (context, state) {
                            // TODO: implement listener
                          },
                          builder: (context, state) {
                            final totalAmount =
                                ( //state.status == ProductStatus.submittedItems &&
                                        //state.productList != null &&
                                        state.selectedProductList!.isNotEmpty)
                                    ? state.totalAmount
                                    : 0.0;

                            return Text(
                              "₹ ${totalAmount.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.TITLE_TEXT_COLOR,
                                fontWeight: FontWeight.w400,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal:
                              AppDimensions.getResponsiveWidth(context) * 0.01),
                      child: BlocConsumer<ProductBloc, ProductState>(
                        listener: (context, state) {
                          if (state.status == ProductStatus.submitDone) {
                            context
                                .read<EstimationBloc>()
                                .add(ResetEstimationEvent());
                            _showSuccessDialog();
                            // Future.delayed(Duration(milliseconds: 2300),() => navigatorKey.currentContext!.go(AppPages.DASHBOARD),);
                            Future.delayed(const Duration(milliseconds: 2500),
                                () {
                              if (!mounted) return;
                              navigatorKey.currentContext!.go(
                                AppPages.PDFVIEW,
                                //extra: state.estimationResponseModel,
                                extra: {
                                  'estimationResponseModel':
                                      state.estimationResponseModel,
                                  'refNumber': refNumber,
                                },
                              );
                            });
                          }
                        },
                        builder: (context, state) {
                          return AppWidgets.customButton(
                            btnName: "Submit",
                            context: context,
                            isLoading:
                                state.status == ProductStatus.scanLoading,
                            onClick: () {
                              // if(state.totalAmount > 0.0){
                              if (state.selectedProductList!.isNotEmpty) {
                                context.read<ProductBloc>().add(
                                    SubmitProductEvent(
                                        selectedProductList:
                                            state.selectedProductList,
                                        refNo: refNumber,
                                        customer: customer,
                                        salesman: salesman));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text("Please select product")));
                              }
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  Gap(AppDimensions.getResponsiveWidth(context) * 0.01),
                ],
              ),
            ),
            /*Container(
              padding: const EdgeInsets.all(16.0),
              height: 200,
              child: Column(
                children: [
                  const Spacer(),
                  const Text('This is a bottom popup dialog!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      setState(() => _isDialogOpen = false);
                    },
                    child: const Text('Close'),
                  ),
                  const Spacer(),
                ],
              ),
            ),*/
            /* Positioned(
              top: -20,
              right: 16,
              child: Material(
                elevation: 6,
                shape: const CircleBorder(),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey),
                    onPressed: () {
                      Navigator.of(context).pop();
                      setState(() => _isDialogOpen = false);
                    },
                  ),
                ),
              ),
            ),*/
          ],
        ),
      ).then((_) => setState(() => _isDialogOpen = false));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: Scaffold(
        bottomNavigationBar: CustomBottomNav(
          selectedIndex: 0,
        ),
        body: SafeArea(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                children: [
                  AppWidgets.headerContainer(
                      context: context,
                      isLogin: true,
                      backPageName: AppPages.ADD_ESTIMATION),
                  Expanded(child: AppWidgets.footerContainer(context)),
                ],
              ),
              Positioned(
                top: AppDimensions.getResponsiveHeight(context) * 0.12,
                left: 0,
                right: 0,
                child: _buildMainContainer(context),
              ),
            ],
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 52.0),
          child: FloatingActionButton.small(
            elevation: 0,
            highlightElevation: 0,
            splashColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            onPressed: _toggleDialog,
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.DEEP_YELLOW_COLOR,
              ),
              constraints: const BoxConstraints.expand(),
              child: Icon(
                _isDialogOpen
                    ? Icons.keyboard_arrow_down
                    : Icons.keyboard_arrow_up,
                color: Colors.white,
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        // floatingActionButtonAnimator: FloatingActionButtonAnimator(),
      ),
    );
  }

  Widget _buildMainContainer(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: AppDimensions.getResponsiveHeight(context) * 0.7,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.APP_SCREEN_BACKGROUND_COLOR,
            AppColors.APP_SCREEN_BACKGROUND_COLOR,
            AppColors.APP_SCREEN_BACKGROUND_COLOR.withValues(alpha: 0.19),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppWidgets.showIconContainer(context),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.getResponsiveWidth(context) * 0.02,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppWidgets().buildStepperContainer(MediaQuery.sizeOf(context),
                    pageNo: 2),
                _buildTitleBar(context),
                // _buildSearchOptions(),
                // _buildTitleBar(context),
              ],
            ),
          ),
          Expanded(
            child: _buildEstimationList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.sizeOf(context).height * 0.02),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppWidgets.showTitle(
            title: 'Selected Product List',
            size: MediaQuery.sizeOf(context),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              /*IconButton(
                onPressed: () => context.go(AppPages.ADD_ESTIMATION),
                icon: const Icon(
                  Icons.lock_reset,
                  color: AppColors.TITLE_TEXT_COLOR,
                ),
              ),
              IconButton(
                onPressed: () => context.go(AppPages.ADD_ESTIMATION),
                icon: const Icon(
                  Icons.add_circle_outline_rounded,
                  color: AppColors.TITLE_TEXT_COLOR,
                ),
              ),*/
              GestureDetector(
                onTap: () => debugPrint("REFRESH---->"),
                child: Container(
                  margin: EdgeInsets.only(right: 5),
                  child: Icon(
                    Icons.lock_reset,
                    size: 30,
                    color: AppColors.TITLE_TEXT_COLOR,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (context) {
                      // context
                      //     .read<ProductBloc>()
                      //     .add(ResetProductStateEvent());
                      return ProductListDialog(
                          // productList: state.productList!,
                          // index: index,
                          );
                    },
                  );
                }, //context.go(AppPages.ADD_ESTIMATION),
                child: Container(
                  margin: EdgeInsets.only(left: 5),
                  child: Icon(
                    Icons.add_circle_outline_rounded,
                    size: 30,
                    color: AppColors.TITLE_TEXT_COLOR,
                  ),
                ),
              ),
            ],
          ),
          /*IconButton(
            onPressed: () => context.go(AppPages.ADD_ESTIMATION),
            icon: const Icon(
              Icons.add_circle_outline_rounded,
              color: AppColors.TITLE_TEXT_COLOR,
            ),
          ),*/
        ],
      ),
    );
  }

  Widget _buildSearchOptions() {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: AppDimensions.getResponsiveHeight(context) * 0.02),
      child: AppWidgets.buildSearchableField(
          MediaQuery.sizeOf(context), "Product code", null,
          isEnabled: true),
      /*AppWidgets.searchBoxContainer(
        isSearchByDate: false,
        hintText: "Search by product id",
        context: context,
        func: () => debugPrint("Searching..."),
      ),*/
    );
  }

  /*Widget _buildEstimationList() {
    return BlocConsumer<ProductBloc, ProductState>(
      listener: (context, state) {},
      builder: (context, state) {
        debugPrint("STATE--->$state");
        final size = MediaQuery.sizeOf(context);

        switch (state.status) {
          case ProductStatus.initial:
            return const Center(
              child: Text(
                "Add Product",
                style: TextStyle(
                  color: AppColors.DEEP_YELLOW_COLOR,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );

          case ProductStatus.submittedItems:
            if (state.productList != null && state.productList!.isNotEmpty) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: state.productList!.length,
                itemBuilder: (context, index) {
                  final product = state.productList![index];
                  return _buildProductContainer(product, size, () {});
                },
              );
            } else {
              return const Center(
                child: Text(
                  "Add Product",
                  style: TextStyle(
                    color: AppColors.DEEP_YELLOW_COLOR,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }

          case ProductStatus.scanLoading:
          case ProductStatus.scanLoaded:
          // You can optionally handle scanned item UI here if needed
            return const Center(
              child: Text(
                "Add Product",
                style: TextStyle(
                  color: AppColors.DEEP_YELLOW_COLOR,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
        }
      },
    );
  }*/

  Widget _buildEstimationList() {
    return BlocConsumer<ProductBloc, ProductState>(
      listener: (context, state) {},
      builder: (context, state) {
        final size = MediaQuery.sizeOf(context);

        // ✅ Always check productList first
        if (state.selectedProductList != null &&
            state.selectedProductList!.isNotEmpty) {
          debugPrint("ProductLength---> ${state.selectedProductList!.length}");
          return ListView.builder(
            shrinkWrap: true,
            itemCount: state.selectedProductList!.length,
            itemBuilder: (context, index) {
              final product = state.selectedProductList![index];
              return _buildProductContainer(product, index, size, () {});
            },
          );
        }

        // If no product, then fallback UI
        return const Center(
          child: Text(
            "Add Product",
            style: TextStyle(
              color: AppColors.DEEP_YELLOW_COLOR,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      },
    );
  }

  Widget _buildProductContainer(
    ProductPayload product,
    int index,
    Size size,
    void Function() func,
  ) {
    return GestureDetector(
      onTap: () => func(),
      child: Container(
        /*margin: EdgeInsets.symmetric(
            horizontal: size.width * 0.01, vertical: AppDimensions.getResponsiveHeight(context) * 0.02),*/
        margin: EdgeInsets.symmetric(
            vertical: AppDimensions.getResponsiveHeight(context) * .005,
            horizontal: AppDimensions.getResponsiveWidth(context) * 0.02),
        // padding: const EdgeInsets.symmetric(horizontal: 6), //,vertical: 2
        padding: const EdgeInsets.only(bottom: 1),
        //,vertical: 2
        height: AppDimensions.getResponsiveHeight(context) * 0.09,
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.TITLE_TEXT_COLOR,
          ),
          color: AppColors.APP_SCREEN_BACKGROUND_COLOR,
        ),
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
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Center(
                    child: Text(
                      "${product.productId}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                    vertical: AppDimensions.getResponsiveHeight(context) * .005,
                    horizontal: size.width * .01,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * .002,
                    vertical: AppDimensions.getResponsiveHeight(context) * .002,
                  ),
                  child: Text(
                    "${product.description}, ₹ ${product.lineTotal}",
                    style: const TextStyle(
                      color: AppColors.TITLE_TEXT_COLOR,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                /*GestureDetector(
                  onTap: () {
                    debugPrint("---VIEW---");
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    height: 25,
                    width: 25,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.transparent),
                    child: const Icon(
                      Icons.visibility_outlined,
                      color: AppColors.TITLE_TEXT_COLOR,
                      size: 25,
                    ),
                  ),
                ),*/
                GestureDetector(
                  onTap: () {
                    debugPrint("---DELETE---");
                    context
                        .read<ProductBloc>()
                        .add(DeleteProductStateEvent(index: index));
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    height: 25,
                    width: 25,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.transparent),
                    child: const Icon(
                      Icons.delete_outline,
                      color: AppColors.TITLE_TEXT_COLOR,
                      size: 25,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future _showSuccessDialog() {
    final size = MediaQuery.sizeOf(context);
    return showDialog(
      barrierColor: Colors.white,
      context: context,
      builder: (context) {
        return Lottie.asset(
          'assets/lottie/success_lottie.json',
          width: size.width * 0.4,
          height: size.height * 0.4,
          repeat: false,
        );
      },
    );
  }
}
