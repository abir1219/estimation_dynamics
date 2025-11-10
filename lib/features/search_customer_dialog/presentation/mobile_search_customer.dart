import 'package:estimation_dynamics/features/add_estimation_screen/presentation/bloc/estimation_bloc.dart';
import 'package:estimation_dynamics/features/search_customer_dialog/data/customer_model.dart';
import 'package:estimation_dynamics/features/search_customer_dialog/presentation/bloc/search_customer_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../widgets/app_widgets.dart';

class MobileSearchCustomer extends StatefulWidget {
  const MobileSearchCustomer({super.key});

  @override
  State<MobileSearchCustomer> createState() => _MobileSearchCustomerState();
}

class _MobileSearchCustomerState extends State<MobileSearchCustomer> {
  String? refNumber = "";

  @override
  void initState() {
    super.initState();
    // context.read<SearchCustomerBloc>().add(FetchCustomerEvent());
    final estimationState = context.read<EstimationBloc>().state;
    if (estimationState is EstimationDataState) {
      debugPrint("Ref Number: ${estimationState.refNumber}");
      refNumber = estimationState.refNumber;
      debugPrint("Customer: ${estimationState.customer}");
      debugPrint("Salesman: ${estimationState.salesman}");
    }
  }

  @override
  void dispose() {
    _customerNameTextController.dispose();
    super.dispose();
  }

  final _customerNameTextController = TextEditingController();

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
                        "Search Customer",
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
                    "Customer name,email,phone",
                    _customerNameTextController,
                    isEnabled: true,
                    func: () => context.read<SearchCustomerBloc>().add(
                          FetchCustomerEvent(
                            customerName:
                                _customerNameTextController.text.trim(),
                            refNumber: refNumber,
                          ),
                        ),
                  ),
                  Gap(AppDimensions.getResponsiveHeight(context) * 0.015),

                  // Title row
                  Row(
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
                      /*GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (_) => const MobileAddCustomer(),
                          );
                        },
                        child: const Icon(
                          Icons.add_circle_outline_rounded,
                          color: AppColors.TITLE_TEXT_COLOR,
                          size: 30,
                        ),
                      ),*/
                    ],
                  ),
                  Gap(AppDimensions.getResponsiveHeight(context) * 0.015),

                  // 👇 Only this part scrolls
                  Expanded(
                    child:
                        BlocConsumer<SearchCustomerBloc, SearchCustomerState>(
                      listener: (context, state) {},
                      builder: (context, state) {
                        if (state is SearchCustomerLoading) {
                          return const Center(
                            child: CircularProgressIndicator(
                                color: AppColors.BUTTON_COLOR),
                          );
                        } else if (state is SearchCustomerLoaded) {
                          debugPrint(
                              "PAYLOAD--->${(state.customerModel.dataResult!.payload!.payload != null)}");
                          return state.customerModel.dataResult!.payload!
                                      .payload !=
                                  null
                              ? state.customerModel.dataResult!.payload!
                                      .payload!.customer!.isNotEmpty
                                  ? ListView.builder(
                                      itemCount: state.customerModel.dataResult!
                                          .payload!.payload!.customer!.length,
                                      itemBuilder: (context, index) {
                                        return _buildCustomerContainer(
                                          state
                                              .customerModel
                                              .dataResult!
                                              .payload!
                                              .payload!
                                              .customer![index],
                                          size,
                                        );
                                      },
                                    )
                                  : Expanded(
                                      child: Center(
                                      child: Text(
                                        "No customer found",
                                        style: TextStyle(
                                          color: AppColors.DEEP_YELLOW_COLOR,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ))
                              : Expanded(
                                  child: Center(
                                  child: Text(
                                    "No customer found",
                                    style: TextStyle(
                                      color: AppColors.DEEP_YELLOW_COLOR,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ));
                        } else if (state is SearchCustomerError) {
                          return Center(
                            child: Text(
                              state.errMsg,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }
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

  Widget _buildCustomerContainer(Customer customer, Size size) {
    debugPrint(
        "@@@@--->${customer.accountNumber} , ${customer.fullName} , ${customer.mobile}");
    return GestureDetector(
      onTap: () {
        context
            .read<SearchCustomerBloc>()
            .add(SelectCustomerDataEvent(customer: customer));
        Navigator.pop(context);
      },
      child: Container(
        /*margin: EdgeInsets.symmetric(
            horizontal: size.width * 0.01, vertical: AppDimensions.getResponsiveHeight(context) * 0.02),*/
        margin: EdgeInsets.symmetric(
            vertical: AppDimensions.getResponsiveHeight(context) * .005),
        // padding: const EdgeInsets.symmetric(horizontal: 6), //,vertical: 2
        // padding: const EdgeInsets.only(left: 6), //,vertical: 2
        //height: AppDimensions.getResponsiveHeight(context) * 0.09,
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
                      "${customer.accountNumber}",
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
                "${customer.fullName}, ${customer.mobile}",
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
