import 'dart:io';

import 'package:estimation_dynamics/features/add_customer_dialog/presentation/mobile_add_customer.dart';
import 'package:estimation_dynamics/features/add_estimation_screen/presentation/bloc/estimation_bloc.dart';
import 'package:estimation_dynamics/router/app_pages.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../widgets/app_widgets.dart';
import '../../../widgets/custom_bottom_nav.dart';
import '../../salesman_dialog/presentation/salesman_dialog.dart';
import '../../search_customer_dialog/presentation/bloc/search_customer_bloc.dart';
import '../../search_customer_dialog/presentation/mobile_search_customer.dart';

class AddEstimationScreen extends StatefulWidget {
  const AddEstimationScreen({super.key});

  @override
  State<AddEstimationScreen> createState() => _AddEstimationScreenState();
}

class _AddEstimationScreenState extends State<AddEstimationScreen> {
  final _customerNameController = TextEditingController();
  final _salesmanController = TextEditingController();
  final _narrationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<EstimationBloc>().add(GenerateEstimationNoEvent());
  }

  @override
  void dispose() {
    _narrationController.dispose();
    _salesmanController.dispose();
    _customerNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNav(selectedIndex: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          // physics: NeverScrollableScrollPhysics(),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                children: [
                  AppWidgets.headerContainer(
                      context: context,
                      isLogin: true,
                      backPageName: AppPages.ESTIMATION),
                  AppWidgets.footerContainer(context),
                ],
              ),
              Positioned(
                top: AppDimensions.getResponsiveHeight(context) * 0.12,
                left: 0,
                right: 0,
                child: _buildContent(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: AppDimensions.getResponsiveHeight(context) * 0.8,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
        // color: Colors.red,
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery
                    .sizeOf(context)
                    .height * 0.02),
                AppWidgets().buildStepperContainer(MediaQuery.sizeOf(context)),
                const SizedBox(height: 10),
                Expanded(
                  child: BlocConsumer<EstimationBloc, EstimationState>(
                    listener: (context, state) {
                      if (state is EstimationDataState) {
                        // Update Customer Name if available
                        if (state.customer != null) {
                          debugPrint("CUSTOMER--->${state.customer}");
                          _customerNameController.text = state.customer!.fullName ?? "";
                        }
                        if (state.customerData != null) {
                          debugPrint("CUSTOMER--->${state.customerData}");
                          _customerNameController.text = state.customerData!.fullName ?? "";
                        }

                        // Update Salesman Name if available
                        if (state.salesman != null) {
                          debugPrint("SALESMAN--->${state.salesman}");
                          _salesmanController.text = state.salesman!.text ?? "";
                        }

                        // Handle error
                        if (state.error != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.error!)),
                          );
                        }
                      }
                    },
                    builder: (context, state) {
                      if (state is EstimationDataState) {
                        if (state.isLoading) {
                          return Center(
                            child: Platform.isAndroid
                                ? const CircularProgressIndicator(color: AppColors.BUTTON_COLOR)
                                : const CupertinoActivityIndicator(),
                          );
                        }
                        return Stack(
                          children: [
                            Positioned(
                              right: 0,
                              left: 0,
                              //top: AppDimensions.getResponsiveHeight(context) * 0.13,
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                  horizontal: AppDimensions.getResponsiveWidth(context) * 0.02,
                                ),
                                padding: EdgeInsets.only(
                                  left: AppDimensions.getResponsiveWidth(context) * 0.03,
                                  right: AppDimensions.getResponsiveWidth(context) * 0.03,
                                  bottom: AppDimensions.getResponsiveHeight(context) * 0.04,
                                ),
                                child: Column(
                                  spacing: AppDimensions.getResponsiveHeight(context) * 0.02,
                                  children: [
                                    Row(
                                      // mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: AppDimensions.getResponsiveWidth(context) * 0, //.04
                                            ),
                                            child: AppWidgets().buildCustomerTab(
                                              MediaQuery.sizeOf(context),
                                              "search.svg",
                                              "Search Customer",
                                                  () {
                                                showDialog(
                                                  context: context,
                                                  barrierDismissible: true,
                                                  builder: (context) {
                                                    context
                                                        .read<SearchCustomerBloc>()
                                                        .add(ResetSearchCustomerStateEvent());
                                                    return Dialog(
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(8)),
                                                      insetPadding: EdgeInsets.symmetric(
                                                        horizontal: MediaQuery.sizeOf(context).width * 0.02,
                                                        vertical: AppDimensions.getResponsiveHeight(context) * 0.01,
                                                      ),
                                                      child: const MobileSearchCustomer(),
                                                    );
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: AppDimensions.getResponsiveWidth(context) * 0,//.04
                                            ),
                                            child: AppWidgets().buildCustomerTab(
                                              MediaQuery.sizeOf(context),
                                              "plus_circle.svg",
                                              "Add Customer",
                                                  () {
                                                showDialog(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  builder: (context) {
                                                    context
                                                        .read<SearchCustomerBloc>()
                                                        .add(ResetSearchCustomerStateEvent());
                                                    return Dialog(
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(8)),
                                                      insetPadding: EdgeInsets.symmetric(
                                                        horizontal: MediaQuery.sizeOf(context).width * 0.02,
                                                        vertical: AppDimensions.getResponsiveHeight(context) * 0.01,
                                                      ),
                                                      child: const MobileAddCustomer(),
                                                    );
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    AppWidgets.textFieldContainer(
                                      icon: null,
                                      isEnabled: false,
                                      hintString: 'Customer Name',
                                      controller: _customerNameController,
                                    ),
                                    AppWidgets.buildSearchableField(
                                      MediaQuery.sizeOf(context),
                                      "Salesman",
                                      _salesmanController,
                                      func: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return Dialog(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8)),
                                              insetPadding: EdgeInsets.symmetric(
                                                horizontal: MediaQuery.sizeOf(context).width * 0.02,
                                                vertical: MediaQuery.sizeOf(context).height * 0.1,
                                              ),
                                              clipBehavior: Clip.antiAliasWithSaveLayer,
                                              child: const SalesmanDialog(),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                    AppWidgets.textFieldContainer(
                                      icon: null,
                                      hintString: 'Narration',
                                      controller: _narrationController,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Expanded(
                                          child: AppWidgets.customButton(
                                            btnName: 'Reset',
                                            context: context,
                                            onClick: () {
                                              context.read<EstimationBloc>().add(ResetEstimationEvent());
                                            },
                                          ),
                                        ),
                                        Gap(AppDimensions.getResponsiveWidth(context) * 0.01),
                                        Expanded(
                                          child: AppWidgets.customButton(
                                            btnName: 'Next',
                                            context: context,
                                            onClick: () {
                                              if(state.customer == null && state.customerData == null){
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(content: Text("Select Customer to continue.")));
                                              }else if(state.salesman == null){
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(content: Text("Select Salesman to continue.")));
                                              }else{
                                                context.go(AppPages.SELECT_PRODUCT);
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            /*Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: AppDimensions.getResponsiveWidth(context) * 0.04,
                                      ),
                                      child: AppWidgets().buildCustomerTab(
                                        MediaQuery.sizeOf(context),
                                        "search.svg",
                                        "Search Customer",
                                            () {
                                          showDialog(
                                            context: context,
                                            barrierDismissible: true,
                                            builder: (context) {
                                              context
                                                  .read<SearchCustomerBloc>()
                                                  .add(ResetSearchCustomerStateEvent());
                                              return Dialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(8)),
                                                insetPadding: EdgeInsets.symmetric(
                                                  horizontal: MediaQuery.sizeOf(context).width * 0.02,
                                                  vertical: AppDimensions.getResponsiveHeight(context) * 0.01,
                                                ),
                                                child: const MobileSearchCustomer(),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: AppDimensions.getResponsiveWidth(context) * 0.04,
                                      ),
                                      child: AppWidgets().buildCustomerTab(
                                        MediaQuery.sizeOf(context),
                                        "plus_circle.svg",
                                        "Add Customer",
                                            () {
                                          showDialog(
                                            context: context,
                                            barrierDismissible: true,
                                            builder: (context) {
                                              context
                                                  .read<SearchCustomerBloc>()
                                                  .add(ResetSearchCustomerStateEvent());
                                              return Dialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(8)),
                                                insetPadding: EdgeInsets.symmetric(
                                                  horizontal: MediaQuery.sizeOf(context).width * 0.02,
                                                  vertical: AppDimensions.getResponsiveHeight(context) * 0.01,
                                                ),
                                                child: const MobileAddCustomer(),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),*/
                          ],
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
