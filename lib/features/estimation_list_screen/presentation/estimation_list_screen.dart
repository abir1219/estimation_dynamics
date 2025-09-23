import 'package:estimation_dynamics/router/app_pages.dart';
import 'package:estimation_dynamics/widgets/custom_bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../widgets/app_widgets.dart';
import 'package:intl/intl.dart';

class EstimationListScreen extends StatefulWidget {
  const EstimationListScreen({super.key});

  @override
  State<EstimationListScreen> createState() => _EstimationListScreenState();
}

class _EstimationListScreenState extends State<EstimationListScreen> {
  int selectedValue = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNav(selectedIndex: 0),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                AppWidgets.headerContainer(
                  context: context,
                  isLogin: true,
                  backPageName: AppPages.DASHBOARD,
                ),
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
    );
  }

  Widget _buildMainContainer(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: AppDimensions.getResponsiveHeight(context) * 0.72,
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
                // horizontal: AppDimensions.getResponsiveWidth(context) * 0.02,
                ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSearchOptions(),
                _buildTitleBar(context),
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

  Widget _buildSearchOptions() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildRadioButton(1, "Search by Others"),
            _buildRadioButton(2, "Search by Date"),
          ],
        ),
        /*AppWidgets.buildSearchableField(MediaQuery.sizeOf(context),
            "Estimation Id, Product name", null,
            isEnabled: true),*/
        AppWidgets.searchBoxContainer(
          isSearchByDate: true,
          hintText: "Estimation Id or Product name",
          context: context,
          func: () => debugPrint("Searching..."),
        ),
      ],
    );
  }

  Widget _buildRadioButton(int value, String label) {
    return RadioMenuButton(
      value: value,
      groupValue: selectedValue,
      onChanged: (val) => setState(() => selectedValue = val as int),
      child: Text(label),
    );
  }

  Widget _buildTitleBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.sizeOf(context).height * 0.015),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppWidgets.showTitle(
            title: 'Estimation List',
            size: MediaQuery.sizeOf(context),
          ),
          GestureDetector(
            onTap: () => context.go(AppPages.ADD_ESTIMATION),
            child: Container(
              margin: EdgeInsets.only(right: 5),
              child: const Icon(
                Icons.add_circle_outline_rounded,
                color: AppColors.TITLE_TEXT_COLOR,
                size: 30,
              ),
            ),
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

  Widget _buildEstimationList() {
    return ListView.builder(
      // physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: 12,
      itemBuilder: (context, index) => _buildEstimationContainer(index),
    );
  }

  Widget _buildEstimationContainer(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      height: MediaQuery.sizeOf(context).height * 0.08,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.TITLE_TEXT_COLOR),
      ),
      child: Column(
        children: [
          Container(
            height: MediaQuery.sizeOf(context).height * 0.04,
            color: AppColors.TITLE_TEXT_COLOR,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    /*Checkbox(
                      checkColor: AppColors.TITLE_TEXT_COLOR,
                      fillColor: WidgetStateProperty.all(Colors.white),
                      value: true,
                      onChanged: (value) {},
                    ),*/
                    Container(
                      margin: EdgeInsets.only(
                        left: AppDimensions.getResponsiveWidth(context) * 0.02,
                      ),
                      child: Text(
                        "EST000001:${index + 1}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal:
                          AppDimensions.getResponsiveWidth(context) * 0.02),
                  child: Text(
                    DateFormat('dd MMM yyyy').format(DateTime.now()),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: AppColors.APP_SCREEN_BACKGROUND_COLOR,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal:
                            AppDimensions.getResponsiveWidth(context) * 0.02),
                    child: const Text(
                      "₹54,749.55",
                      style: TextStyle(
                        color: AppColors.TITLE_TEXT_COLOR,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal:
                            AppDimensions.getResponsiveWidth(context) * 0.02),
                    child: const Icon(
                      Icons.arrow_forward,
                      color: AppColors.TITLE_TEXT_COLOR,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
