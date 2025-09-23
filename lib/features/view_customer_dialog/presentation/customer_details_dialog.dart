import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

class CustomerDetailsDialog extends StatefulWidget {
  const CustomerDetailsDialog({super.key});

  @override
  State<CustomerDetailsDialog> createState() => _CustomerDetailsDialogState();
}

class _CustomerDetailsDialogState extends State<CustomerDetailsDialog> {
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
                      const Expanded(
                        child: Center(
                          child: Text(
                            "Customer Details",
                            style: TextStyle(
                                color: AppColors.TITLE_TEXT_COLOR,
                                fontWeight: FontWeight.w600,
                                fontSize: 18),
                          ),
                        ),
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
                                  AppColors.TITLE_TEXT_COLOR, BlendMode.srcIn),
                            ),
                          )),
                    ],
                  ),
                  Gap(AppDimensions.getResponsiveHeight(context) * 0.02),
                  Container(
                    height: AppDimensions.getResponsiveHeight(context) * 0.6,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.TITLE_TEXT_COLOR,
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: AppDimensions.getResponsiveHeight(context) * 0.05,
                          color: AppColors.TITLE_TEXT_COLOR,
                          child: Center(
                            child: Text("CU000001",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 14,),),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            spacing: AppDimensions.getResponsiveHeight(context) * 0.01,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("Elizabeth Kapoor",style: TextStyle(color: AppColors.TITLE_TEXT_COLOR,fontWeight: FontWeight.w500,fontSize: 16,),),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Phone No: ",style: TextStyle(color: AppColors.TITLE_TEXT_COLOR,fontWeight: FontWeight.w600,fontSize: 16,),),
                                  Text("+91 9830123456",style: TextStyle(color: AppColors.TITLE_TEXT_COLOR,fontWeight: FontWeight.w400,fontSize: 16,),),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("Address:",style: TextStyle(color: AppColors.TITLE_TEXT_COLOR,fontWeight: FontWeight.w600,fontSize: 16,),),
                                  Text("Akshya Nagar 1st Block 1st Cross, Rammurthy  nagar, angalore-560016",style: TextStyle(color: AppColors.TITLE_TEXT_COLOR,fontWeight: FontWeight.w400,fontSize: 16,),textAlign: TextAlign.center,),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
