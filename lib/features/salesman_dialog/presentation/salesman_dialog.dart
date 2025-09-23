import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../widgets/app_widgets.dart';
import '../../add_estimation_screen/presentation/bloc/estimation_bloc.dart';
import '../data/model/employee_model.dart';

class SalesmanDialog extends StatefulWidget {
  const SalesmanDialog({super.key});

  @override
  State<SalesmanDialog> createState() => _SalesmanDialogState();
}

class _SalesmanDialogState extends State<SalesmanDialog> {
  @override
  void initState() {
    context.read<EstimationBloc>().add(FetchSalesmanEvent());
    super.initState();
  }

  final _salesmanNameTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);

    return ScaffoldMessenger(
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
                  AppColors.APP_SCREEN_BACKGROUND_COLOR.withValues(alpha: 0.19),
                ],
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Gap(AppDimensions.getResponsiveHeight(context) * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Salesman",
                        style: TextStyle(
                          color: AppColors.TITLE_TEXT_COLOR,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          height: 25,
                          width: 25,
                          decoration:
                              const BoxDecoration(shape: BoxShape.circle),
                          child: SvgPicture.asset(
                            "assets/images/circle_close.svg",
                            colorFilter: ColorFilter.mode(
                              AppColors.TITLE_TEXT_COLOR,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Gap(AppDimensions.getResponsiveHeight(context) * 0.01),

                  // Search field
                  AppWidgets.buildSearchableField(
                    size,
                    "Salesman name",
                    change: (text) {
                      debugPrint("SEARCHABLE_TEXT==>$text");
                      context.read<EstimationBloc>().add(
                        SearchEmployeeEvent(search: text),
                      );
                    },
                    _salesmanNameTextController,
                    isEnabled: true,
                    // isProductList: false,
                    func: () => null,
                  ),
                  // Gap(AppDimensions.getResponsiveHeight(context) * 0.015),

                  // Title row
                  /*Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Customer List",
                        style: TextStyle(
                          color: AppColors.TITLE_TEXT_COLOR,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),*/
                  Gap(AppDimensions.getResponsiveHeight(context) * 0.01),

                  // 👇 Only this part scrolls
                  Expanded(
                    child: BlocConsumer<EstimationBloc, EstimationState>(
                      listener: (context, state) {},
                      builder: (context, state) {
                        if (state is EstimationDataState) {
                          final isLoading = state.isLoading;
                          final salesmenList = state.filteredSalesmanList ?? []; // make sure you added this field in EstimationDataState
                          if (isLoading) {
                            return const Center(
                              child: CircularProgressIndicator(color: AppColors.BUTTON_COLOR),
                            );
                          } else if (salesmenList.isNotEmpty) {
                            return ListView.builder(
                              itemCount: salesmenList.length,
                              itemBuilder: (context, index) {
                                return _buildSalesmanContainer(salesmenList[index], size);
                              },
                            );
                          } else {
                            return Center(
                              child: Text(
                                "No salesman found",
                                style: TextStyle(
                                  color: AppColors.DEEP_YELLOW_COLOR,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }
                        } else {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search,
                                  color: AppColors.DEEP_YELLOW_COLOR,
                                  size: 50,
                                ),
                                Text(
                                  "Search Customer",
                                  style: TextStyle(
                                    color: AppColors.DEEP_YELLOW_COLOR,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSalesmanContainer(SalesmanPayload salesman, Size size) {
    debugPrint("@@@@--->${salesman.text} , ${salesman.value}");
    return GestureDetector(
      onTap: () {
        context.read<EstimationBloc>().add(SelectSalesmanEvent(salesman));
        Navigator.pop(context);
      },
      child: Container(
        /*margin: EdgeInsets.symmetric(
            horizontal: size.width * 0.01, vertical: AppDimensions.getResponsiveHeight(context) * 0.02),*/
        margin: EdgeInsets.symmetric(
            vertical: AppDimensions.getResponsiveHeight(context) * .005),
        // padding: const EdgeInsets.symmetric(horizontal: 6), //,vertical: 2
        // padding: const EdgeInsets.only(left: 6), //,vertical: 2
        height: AppDimensions.getResponsiveHeight(context) * 0.09,
        decoration: BoxDecoration(
            color: AppColors.APP_SCREEN_BACKGROUND_COLOR,
            border: Border.all(color: AppColors.TITLE_TEXT_COLOR)
            /*index % 2 == 0
              ? AppColors.CONTAINER_BACKGROUND_COLOR_01
              : AppColors.CONTAINER_BACKGROUND_COLOR_02,*/
            ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
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
                    // index % 2 == 0
                    //     ? AppColors.STEPPER_DONE_COLOR
                    //     : AppColors.CONTAINER_BACKGROUND_COLOR_03,
                    borderRadius: BorderRadius.circular(0),
                  ),
                  child: Center(
                    child: Text(
                      "${salesman.value}",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                /*Spacer(),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (context) {
                        return Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          insetPadding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.05,
                              vertical:
                              AppDimensions.getResponsiveHeight(context) *
                                  0.1),
                          // clipBehavior: Clip.antiAliasWithSaveLayer,
                          // backgroundColor: Colors.white,
                          child: const CustomerDetailsDialog(),
                        );
                      },
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(
                        vertical:
                        AppDimensions.getResponsiveHeight(context) * .005,
                        horizontal: size.width * .02),
                    padding: EdgeInsets.symmetric(
                        horizontal: size.width * .002,
                        vertical:
                        AppDimensions.getResponsiveHeight(context) * .002),
                    child: const Text(
                      "View Details",
                      style: TextStyle(
                          color: AppColors.TITLE_TEXT_COLOR,
                          fontSize: 12,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                )*/
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(
                  vertical: AppDimensions.getResponsiveHeight(context) * .005,
                  horizontal: size.width * .01),
              padding: EdgeInsets.symmetric(
                  horizontal: size.width * .002,
                  vertical: AppDimensions.getResponsiveHeight(context) * .002),
              child: Text(
                "${salesman.text}",
                style: const TextStyle(
                    color: AppColors.TITLE_TEXT_COLOR,
                    fontSize: 14,
                    fontWeight: FontWeight.w400),
              ),
            )
          ],
        ),
      ),
    );
  }
}
