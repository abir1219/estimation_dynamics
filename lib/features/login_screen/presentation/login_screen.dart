import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:estimation_dynamics/core/constants/app_colors.dart';
import 'package:estimation_dynamics/core/constants/app_constants.dart';
import 'package:estimation_dynamics/core/constants/app_dimensions.dart';
import 'package:estimation_dynamics/core/local/shared_preferences_helper.dart';
import 'package:estimation_dynamics/features/login_screen/data/model/store_model.dart';
import 'package:estimation_dynamics/features/login_screen/presentation/blocStore/store_bloc.dart';
import 'package:estimation_dynamics/router/app_pages.dart';
import 'package:estimation_dynamics/widgets/app_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import 'blocLogin/login_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
    context.read<StoreBloc>().add(FetchStoreEvent());
  }

  final dropDownKey = GlobalKey<DropdownSearchState>();

  // List<String> list = ["Menu", "Dialog", "Modal", "BottomSheet"];
  TextEditingController dropdownController = TextEditingController();
  final TextEditingController _employeeIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String storeID = "";
  late final StoreListPayload storeListPayload;
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Stack(
          // alignment: Alignment.center,
          children: [
            Flex(
              direction: Axis.vertical,
              children: [
                AppWidgets.headerContainer(
                  context: context,
                ),
                AppWidgets.footerContainer(context),
              ],
            ),
            Positioned(
              top: AppDimensions.getResponsiveHeight(context) * .12,
              right: 0,
              left: 0,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                height: AppDimensions.getResponsiveHeight(context) * 0.8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                  //color: Colors.red,//AppColors.APP_SCREEN_BACKGROUND_COLOR,
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
                child: Column(
                  // spacing: AppDimensions.getResponsiveHeight(context) * 0.02,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppWidgets.showIconContainer(context),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal:
                              AppDimensions.getResponsiveWidth(context) * 0.02,
                        ),
                        child: Column(
                          spacing:
                              AppDimensions.getResponsiveHeight(context) * 0.02,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //Gap(AppDimensions.getResponsiveHeight(context) * 0.02),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                      left: MediaQuery.sizeOf(context).width *
                                          0.03,
                                      // right: MediaQuary.sizeOf(context).width * 0.03,
                                      top: MediaQuery.sizeOf(context).height *
                                          0.02),
                                  child: AppWidgets.showTitle(
                                    title: 'Login',
                                    size: MediaQuery.sizeOf(context),
                                  ),
                                ),
                                // Gap(AppDimensions.getResponsiveHeight(context) * 0.005),
                                Container(
                                  margin: EdgeInsets.only(
                                    left:
                                        MediaQuery.sizeOf(context).width * 0.03,
                                    // right: MediaQuary.sizeOf(context).width * 0.03,
                                    //top: MediaQuery.sizeOf(context).height * 0.02,
                                  ),
                                  child: AppWidgets.showSubTitle(
                                      subtitle: 'Please Login to continue',
                                      size: MediaQuery.sizeOf(context)),
                                ),
                              ],
                            ),
                            Gap(AppDimensions.getResponsiveHeight(context) *
                                0.008),
                            Column(
                              spacing:
                                  AppDimensions.getResponsiveHeight(context) *
                                      0.02,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                BlocConsumer<StoreBloc, StoreState>(
                                  listener: (context, state) {
                                    if (state is StoreLoaded) {
                                      //debugPrint("isVisible==>$isVisible");
                                      //isVisible = state.isVisible!;
                                    }
                                  },
                                  // buildWhen: (previous, current) => current is! StoreLoading,
                                  builder: (context, state) {
                                    switch (state) {
                                      case StoreLoading():
                                        return Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                height:
                                                    MediaQuery.sizeOf(context)
                                                            .height *
                                                        0.05,
                                                width:
                                                    MediaQuery.sizeOf(context)
                                                            .width *
                                                        0.08,
                                                child: Platform.isAndroid
                                                    ? const CircularProgressIndicator(
                                                        color: AppColors
                                                            .BUTTON_COLOR,
                                                      )
                                                    : const CupertinoActivityIndicator(),
                                              ),
                                              Text(
                                                "Store loading. Please wait...",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16),
                                              )
                                            ],
                                          ),
                                        );
                                      case StoreLoaded():
                                        return Column(
                                          spacing:
                                              AppDimensions.getResponsiveHeight(
                                                      context) *
                                                  0.02,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: DropdownSearch<String>(
                                                    key: dropDownKey,
                                                    selectedItem: "Select store",
                                                    items: (filter, _) async {
                                                      if (state.storeList != null) {
                                                        // Make each item unique by combining StoreName and TerminalId
                                                        return state.storeList!
                                                            .map((store) => "${store.storeName} - ${store.terminalId}")
                                                            .toList();
                                                      }
                                                      return [];
                                                    },
                                                    dropdownBuilder: (context, selectedItem) {
                                                      return Text(
                                                        selectedItem ?? "Select store",
                                                        style: TextStyle(
                                                          color: AppColors.BUTTON_COLOR,
                                                        ),
                                                      );
                                                    },
                                                    decoratorProps: DropDownDecoratorProps(
                                                      decoration: InputDecoration(
                                                        prefixIcon: Icon(
                                                          Icons.storefront_outlined,
                                                          color: AppColors.BUTTON_COLOR,
                                                        ),
                                                        border: OutlineInputBorder(),
                                                        enabledBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                            color: AppColors.TITLE_TEXT_COLOR,
                                                            width: 1.0,
                                                          ),
                                                        ),
                                                        focusedBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                            color: AppColors.TITLE_TEXT_COLOR,
                                                            width: 1.0,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    onChanged: (String? selectedValue) {
                                                      dropdownController.text = selectedValue ?? "";

                                                      if (selectedValue != null && state.storeList != null) {
                                                        // Find the selected store by matching both storeName and terminalId
                                                        selectedIndex = state.storeList!.indexWhere(
                                                              (store) => "${store.storeName} - ${store.terminalId}".trim().toLowerCase() ==
                                                              selectedValue.trim().toLowerCase(),
                                                        );

                                                        if (selectedIndex != -1) {
                                                          var selectedStore = state.storeList![selectedIndex];
                                                          storeListPayload = selectedStore;
                                                          storeID = selectedStore.storeId!;

                                                          debugPrint("SELECTED_INDEX ===> $selectedIndex");
                                                          debugPrint("Selected StoreId: $storeID, TerminalId: ${selectedStore.terminalId}");
                                                        }
                                                      }
                                                    },
                                                    popupProps: PopupProps.menu(
                                                      fit: FlexFit.loose,
                                                      constraints: BoxConstraints(
                                                        maxHeight: MediaQuery.sizeOf(context).height * 0.4,
                                                      ),
                                                      scrollbarProps: ScrollbarProps(
                                                        trackVisibility: true,
                                                        thumbVisibility: true,
                                                        thickness: 5,
                                                        radius: Radius.circular(10),
                                                      ),
                                                      containerBuilder: (ctx, child) {
                                                        return Container(
                                                          decoration: BoxDecoration(
                                                            color: AppColors.APP_SCREEN_BACKGROUND_COLOR,
                                                            borderRadius: BorderRadius.circular(0),
                                                          ),
                                                          child: child,
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                  /*DropdownSearch<String>(
                                                    key: dropDownKey,
                                                    selectedItem:
                                                        "Select store",
                                                    *//*items: (filter,
                                                        infiniteScrollProps) async {
                                                      if (state.storeList !=
                                                          null) {
                                                        return state.storeList!
                                                            .map((store) =>
                                                                store.storeName!)
                                                            .toList();
                                                      }
                                                      return []; // Return an empty list if null
                                                    },*//*
                                                    items: (filter, _) async {
                                                      if (state.storeList != null) {
                                                        return state.storeList!
                                                            .map((store) => "${store.storeName} - ${store.terminalId}")
                                                            .toList();
                                                      }
                                                      return [];
                                                    },
                                                    dropdownBuilder: (context,
                                                        selectedItem) {
                                                      return Text(
                                                        selectedItem ??
                                                            "Select store",
                                                        style: TextStyle(
                                                          color: AppColors
                                                              .BUTTON_COLOR,
                                                        ), // Selected item text color
                                                      );
                                                    },
                                                    decoratorProps:
                                                        DropDownDecoratorProps(
                                                      decoration:
                                                          InputDecoration(
                                                        //labelText: 'Examples for: ',
                                                        prefixIcon: Icon(
                                                          Icons
                                                              .storefront_outlined,
                                                          color: AppColors
                                                              .BUTTON_COLOR,
                                                        ),
                                                        *//*suffixIcon: Icon(
                                                    Icons.keyboard_arrow_down_outlined,
                                                    color: AppColors.BUTTON_COLOR),*//*
                                                        border: OutlineInputBorder(
                                                            *//* borderSide: BorderSide(
                                                    color: AppColors.TITLE_TEXT_COLOR,
                                                  ),*//*
                                                            ),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            color: AppColors
                                                                .TITLE_TEXT_COLOR,
                                                            width: 1.0,
                                                          ), // Normal border color
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            color: AppColors
                                                                .TITLE_TEXT_COLOR,
                                                            width: 1.0,
                                                          ), // Border color when focused
                                                        ),
                                                      ),
                                                    ),
                                                    *//*onChanged: (String?
                                                        selectedValue) {
                                                      dropdownController.text =
                                                          selectedValue ?? "";
                                                      if (selectedValue !=
                                                          null) {
                                                        selectedIndex = state
                                                                .storeList
                                                                ?.indexWhere((store) =>
                                                                    store.storeName ==
                                                                    selectedValue) ??
                                                            -1;

                                                        debugPrint("SELECTED_INDEX===>$selectedIndex");
                                                        storeListPayload = state
                                                            .storeList![
                                                        selectedIndex];
                                                        storeID = state
                                                            .storeList![
                                                                selectedIndex].storeId!;


                                                        if (kDebugMode) {
                                                          print(
                                                              "Selected: ${dropdownController.text}, Index: $selectedIndex");
                                                        }
                                                      }
                                                      if (kDebugMode) {
                                                        print(
                                                            "Selected: ${dropdownController.text}");
                                                      }
                                                    },*//*
                                                    onChanged: (String? selectedValue) {
                                                      dropdownController.text = selectedValue ?? "";
                                                      if (selectedValue != null && state.storeList != null) {
                                                        for (var i = 0; i < state.storeList!.length; i++) {
                                                          debugPrint("[$i] storeName: '${state.storeList![i].storeName}'");
                                                        }
                                                        debugPrint("selectedValue: '$selectedValue'");

                                                        selectedIndex = state.storeList!.indexWhere(
                                                              (store) => store.storeName?.trim().toLowerCase() ==
                                                              selectedValue.trim().toLowerCase(),
                                                        );

                                                        debugPrint("SELECTED_INDEX===>$selectedIndex");
                                                      }
                                                    },
                                                    popupProps: PopupProps.menu(
                                                      fit: FlexFit.loose,
                                                      constraints: BoxConstraints(
                                                          maxHeight:
                                                              MediaQuery.sizeOf(
                                                                          context)
                                                                      .height *
                                                                  .4 //300,
                                                          ),
                                                      scrollbarProps:
                                                          ScrollbarProps(
                                                        trackVisibility: true,
                                                        thumbVisibility: true,
                                                        thickness: 5,
                                                        radius:
                                                            Radius.circular(10),
                                                      ),
                                                      containerBuilder:
                                                          (ctx, child) {
                                                        return Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: AppColors
                                                                .APP_SCREEN_BACKGROUND_COLOR,
                                                            // Background color of the dropdown
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        0), // Rounded corners
                                                          ),
                                                          child: child,
                                                        );
                                                      },
                                                    ),
                                                  )*/
                                                ),
                                              ],
                                            ),
                                            /*AppWidgets.textFieldContainer(
                                              controller: _employeeIdController,
                                              hintString: "Employee Id",
                                              icon: Icons.person_3_outlined,
                                            ),
                                            AppWidgets
                                                .textPasswordFieldContainer(
                                              onVisibility: () => context.read<LoginBloc>().add(PasswordVisibilityChangeEvent()),
                                              controller: _passwordController,
                                              hintString: "Enter Password",
                                              isObscure: context.watch<LoginBloc>().state is PasswordVisibilityLogin
                                                  ? !(context.watch<LoginBloc>().state as PasswordVisibilityLogin).isVisible!
                                                  : true,
                                            ),*/
                                            state.isVisible!
                                                ? BlocConsumer<LoginBloc,
                                                    LoginState>(
                                                    listener: (context, state) {
                                                      if (state
                                                          is UserLoginLoaded) {
                                                        SharedPreferencesHelper
                                                            .saveString(
                                                                AppConstants
                                                                    .APP_KEY,
                                                                state.appKey!);
                                                        context.go(
                                                            AppPages.DASHBOARD);
                                                      } else if (state
                                                          is LoginError) {
                                                        AppWidgets
                                                            .showCustomSnackBar(
                                                                context,
                                                                state.message!);
                                                      }
                                                    },
                                                    builder: (context, state) {
                                                      return AppWidgets
                                                          .customButton(
                                                        btnName: 'Login',
                                                        isLoading: state
                                                                is UserLoginLoading
                                                            ? true
                                                            : false,
                                                        onClick: () {
                                                          if (storeListPayload == null) {
                                                            AppWidgets
                                                                .showCustomSnackBar(
                                                                    context,
                                                                    "Select store");
                                                          } else {
                                                            context.read<LoginBloc>().add(
                                                                LoginUserEvent(
                                                                  storeId: storeListPayload.storeId,
                                                                    storeName: storeListPayload.storeName,
                                                                    terminalId: storeListPayload.terminalId
                                                                    /*_employeeIdController
                                                                        .text,
                                                                    //dropdownController.text,
                                                                    // state.storeList![selectedIndex].value,
                                                                    storeID,
                                                                    _passwordController
                                                                        .text*/)
                                                            );
                                                          }
                                                          /*context.go(
                                                  AppPages.DASHBOARD,
                                                );*/
                                                        },
                                                        context: context,
                                                      );
                                                    },
                                                  )
                                                : Container(),
                                          ],
                                        );
                                      default:
                                        return Container();
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
