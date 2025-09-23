import 'package:estimation_dynamics/core/constants/app_colors.dart';
import 'package:estimation_dynamics/router/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNav extends StatefulWidget {
  final selectedIndex;

  const CustomBottomNav({super.key, this.selectedIndex = 0});

  @override
  State<CustomBottomNav> createState() => _CustomBottomNavState();
}

class _CustomBottomNavState extends State<CustomBottomNav> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: AppColors.BOTTOM_NAVIGATION_BAR_COLOR,
      showSelectedLabels: true,
      currentIndex: widget.selectedIndex,
      iconSize: 34,
      elevation: 0.00,
      selectedFontSize: 9,
      unselectedFontSize: 9,
      onTap: (value) {
        debugPrint("---value-->$value");
        if (value == 0) {
          context.go(AppPages.ESTIMATION);
        } else if (value == 1) {
          context.go(AppPages.DASHBOARD);
        } else if (value == 2) {
          print("-----WORKING-----");
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: Stack(
            clipBehavior: Clip.none,
            // Ensures the dot is visible outside the Stack bounds
            alignment: AlignmentDirectional.topEnd,
            // Aligns the dot at the top-right corner
            children: [
              Image.asset(
                "assets/images/estimation.png",
                height: 24,
                width: 24,
                color: AppColors.TITLE_TEXT_COLOR,
              ),
              widget.selectedIndex == 0
                  ? Positioned(
                      top: -8, // Adjust this to position the dot correctly
                      right: -10, // Adjust this to position the dot correctly
                      child: Container(
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                          color: AppColors.TITLE_TEXT_COLOR,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : SizedBox(),
            ],
          ),
          label: "Estimation",
        ),
        BottomNavigationBarItem(
            icon: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,

                  color: widget.selectedIndex == 1
                      ? AppColors.HEADER_GRADIENT_START_COLOR//Colors.white
                      : AppColors.TITLE_TEXT_COLOR),
              child: Center(
                  child: Icon(
                Icons.home_outlined,
                color: widget.selectedIndex == 1
                    ? AppColors.TITLE_TEXT_COLOR
                    : Colors.white,
              )),
            ),
            label: ""),
        BottomNavigationBarItem(
          icon: Stack(
            clipBehavior: Clip.none,
            // Ensures the dot is visible outside the Stack bounds
            alignment: AlignmentDirectional.topEnd,
            // Aligns the dot at the top-right corner
            children: [
              Image.asset(
                "assets/images/sales_advice.png",
                height: 24,
                width: 24,
                color: AppColors.TITLE_TEXT_COLOR,
              ),
              widget.selectedIndex == 2
                  ? Positioned(
                      top: -8, // Adjust this to position the dot correctly
                      right: -2, // Adjust this to position the dot correctly
                      child: Container(
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                          color: AppColors.TITLE_TEXT_COLOR,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : SizedBox(),
            ],
          ),
          label: "Sales Advice",
        ),
      ],
    );
  }
}
