
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../widgets/app_widgets.dart';

class StateListDialog extends StatefulWidget {
  // final List<StateList>? stateList;

  const StateListDialog({super.key, /*this.stateList*/});

  @override
  State<StateListDialog> createState() => _StateListDialogState();
}

class _StateListDialogState extends State<StateListDialog> {
  final _searchTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //context.read<StateBloc>().add(FetchStateList());
    // context.read<EstimationBloc>().add(FetchStateList());
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      insetPadding: EdgeInsets.symmetric(
          horizontal: size.width * 0.02, vertical: AppDimensions.getResponsiveHeight(context) * 0.1),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      backgroundColor: Colors.white,
      child: PopScope(
        canPop: true,
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
                          /*GestureDetector(
                            onTap: () {},
                            child: const Icon(
                              Icons.arrow_back,
                              color: AppColors.STEPPER_DONE_COLOR,
                            ),
                          ),*/
                          const Text(
                            "State Search",
                            style: TextStyle(
                                color: AppColors.TITLE_TEXT_COLOR,
                                fontWeight: FontWeight.w600,
                                fontSize: 18),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 25,
                              width: 25,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.white),
                              child: SvgPicture.asset(
                                "assets/images/circle_close.svg",
                                colorFilter: const ColorFilter.mode(
                                    AppColors.TITLE_TEXT_COLOR,
                                    BlendMode.srcIn),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Gap(AppDimensions.getResponsiveHeight(context) * 0.02),
                      AppWidgets.buildSearchableField(
                          size,
                          "Search State Code,State Name,Country",
                          _searchTextController,
                          isEnabled: true),
                      Gap(AppDimensions.getResponsiveHeight(context) * 0.01),
                      Expanded(
                        child: ListView.builder(
                            itemBuilder: (context, index) {
                              return _buildStateContainer(
                                  index, size,);
                            },
                            itemCount: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStateContainer(int index, Size size,) {
    return GestureDetector(
      onTap: () {
        debugPrint("STATE_CLICK");
        // context.go(AppPages.ESTIMATION);
        // context.read<EstimationBloc>().add(SelectStateEvent(index));
        // context.read<EstimationBloc>().add(ApiStatusChangeEvent());
        Navigator.pop(context);
      },
      child: Container(
        height: AppDimensions.getResponsiveHeight(context) * 0.075,
        margin: EdgeInsets.symmetric(vertical: AppDimensions.getResponsiveHeight(context) * 0.01),
        decoration: BoxDecoration(
          color: AppColors.APP_SCREEN_BACKGROUND_COLOR,
          borderRadius: BorderRadius.circular(0),
          border: Border.all(
            color: AppColors.TITLE_TEXT_COLOR
          )
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.only(right: size.width * 0.02),
              height: AppDimensions.getResponsiveHeight(context) * 0.075,
              width: size.width * 0.15,
              decoration: const BoxDecoration(
                  color: AppColors.TITLE_TEXT_COLOR,
                  /*borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(4),
                    topLeft: Radius.circular(4),
                  )*/
                //BorderRadius.circular(4),
              ),
              child: Center(
                child: Text(
                  "WB",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "West Bengal",
                    style: const TextStyle(
                      color: AppColors.TITLE_TEXT_COLOR,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const Text(
                    "INDIA",
                    style: TextStyle(
                      color: AppColors.TITLE_TEXT_COLOR,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: size.width * 0.02),
              child: SvgPicture.asset("assets/images/arrow_right_circle.svg"),
            ),
          ],
        ),
      ),
    );
  }
}
