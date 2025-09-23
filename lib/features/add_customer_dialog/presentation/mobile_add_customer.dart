import 'package:estimation_dynamics/core/constants/app_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../widgets/app_widgets.dart';

class MobileAddCustomer extends StatefulWidget {

  const MobileAddCustomer({super.key,});

  @override
  State<MobileAddCustomer> createState() => _MobileAddCustomerState();
}

class _MobileAddCustomerState extends State<MobileAddCustomer> {

  final _customerNameController = TextEditingController();
  final _pinController = TextEditingController();
  final _addressController = TextEditingController();
  final _mobileNoTextEditingController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);

    return ScaffoldMessenger(
      child: Scaffold(
        backgroundColor: AppColors.APP_SCREEN_BACKGROUND_COLOR,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
            child: Column(
              spacing: AppDimensions.getResponsiveHeight(context)*0.05,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              // spacing: AppDimensions.getResponsiveHeight(context)*0.02,
              children: [
                // Gap(size.height * 0.02),
                Container(),
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
                      "Add Customer",
                      style: TextStyle(
                        color: AppColors.TITLE_TEXT_COLOR,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
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
                            shape: BoxShape.circle,),
                        child: SvgPicture.asset(
                          "assets/images/circle_close.svg",
                          colorFilter: ColorFilter.mode(
                              AppColors.TITLE_TEXT_COLOR, BlendMode.srcIn),
                        ),
                      ),
                    ),
                  ],
                ),
                // Gap(size.height * 0.02),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: AppDimensions.getResponsiveHeight(context)*0.02,
                      children: [
                        /*AppWidgets.buildField(
                                size, "Customer Code", _customerCodeController),*/
                        AppWidgets.textFieldContainer(
                          controller: _customerNameController,hintString: "Customer Name",icon: null,),
                        AppWidgets.textFieldNumberContainer( hintString:"Mobile Number",
                            controller: _mobileNoTextEditingController, icon: null,maxLength: 10
                            ),
                        AppWidgets.textFieldContainer(
                          controller: _addressController,hintString: "Address",icon: null,),
                        AppWidgets.textFieldNumberContainer(
                          controller: _pinController,hintString: "Pin Number",icon: null, maxLength: 6,),
                      ],
                    ),
                  ),
                ),
                Gap(size.height * .01),
                Container(
                  color: Colors.transparent,
                  padding:
                  EdgeInsets.symmetric(horizontal: size.height * .02),
                  child: Row(
                    spacing: AppDimensions.getResponsiveWidth(context) * 0.01,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: AppWidgets.customButton(
                           context: context,onClick: () {

                           },btnName: 'Reset',),
                      ),
                      Expanded(
                        child: AppWidgets.customButton(
                          context: context,onClick: () {

                        },btnName: 'Cancel',),
                      ),
                      Expanded(
                        child: AppWidgets.customButton(
                          context: context,onClick: () {

                        },btnName: 'Save',),
                      ),
                    ],
                  ),
                ),
                Gap(size.height * 0.02),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
