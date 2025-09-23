import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../router/app_pages.dart';
import '../../../widgets/app_widgets.dart';
import '../../../widgets/custom_bottom_nav.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNav(selectedIndex: 1),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                children: [
                  AppWidgets.headerContainer(
                    context: context,
                    isLogin: true,
                    from: "dashboard",
                  ),
                  AppWidgets.footerContainer(context),
                ],
              ),
              Positioned(
                top: AppDimensions.getResponsiveHeight(context) * 0.12,
                left: 0,
                right: 0,
                child: _buildDashboardContent(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardContent(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: AppDimensions.getResponsiveHeight(context) * 0.6,
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
            AppColors.APP_SCREEN_BACKGROUND_COLOR.withValues(alpha:0.19),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppWidgets.showIconContainer(context),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.getResponsiveWidth(context) * 0.02,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: MediaQuery.sizeOf(context).height * 0.08),
                  AppWidgets.showTitle(
                    title: 'Dashboard',
                    size: MediaQuery.sizeOf(context),
                  ),
                  const SizedBox(height: 10),
                  _buildDashboardRow(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: _buildDashboardContainer(
            name: "Estimation",
            iconName: "assets/images/estimation.png",
            onClick: () => context.go(AppPages.ESTIMATION),
          ),
        ),
        SizedBox(width: AppDimensions.getResponsiveWidth(context) * 0.02),
        Expanded(
          child: _buildDashboardContainer(
            name: "Sales Advice",
            iconName: "assets/images/sales_advice.png",
            onClick: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildDashboardContainer({
    required String name,
    required String iconName,
    required VoidCallback onClick,
  }) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        height: AppDimensions.getResponsiveHeight(context) * 0.2,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.TITLE_TEXT_COLOR),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: AppDimensions.getResponsiveHeight(context) * 0.1,
              width: AppDimensions.getResponsiveHeight(context) * 0.1,
              color: AppColors.TITLE_TEXT_COLOR,
              child: Center(
                child: Image.asset(iconName, width: 50, height: 50),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              name,
              style: const TextStyle(
                color: AppColors.TITLE_TEXT_COLOR,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
