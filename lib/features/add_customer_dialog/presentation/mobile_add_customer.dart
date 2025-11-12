import 'package:estimation_dynamics/core/constants/app_dimensions.dart';
import 'package:estimation_dynamics/features/search_customer_dialog/presentation/bloc/search_customer_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../widgets/app_widgets.dart';

class MobileAddCustomer extends StatefulWidget {
  const MobileAddCustomer({
    super.key,
  });

  @override
  State<MobileAddCustomer> createState() => _MobileAddCustomerState();
}

class _MobileAddCustomerState extends State<MobileAddCustomer> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _panController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileNoTextEditingController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _panController.dispose();
    _emailController.dispose();
    _mobileNoTextEditingController.dispose();
  }

  void resetData() {
    _firstNameController.text = "";
    _lastNameController.text = "";
    _emailController.text = "";
    _mobileNoTextEditingController.text = "";
    _panController.text = "";
  }

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
              spacing: AppDimensions.getResponsiveHeight(context) * 0.05,
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
                          shape: BoxShape.circle,
                        ),
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
                      spacing:
                      AppDimensions.getResponsiveHeight(context) * 0.02,
                      children: [
                        /*AppWidgets.buildField(
                                size, "Customer Code", _customerCodeController),*/
                        AppWidgets.textFieldContainer(
                          controller: _firstNameController,
                          hintString: "First Name",
                          icon: null,
                        ),
                        AppWidgets.textFieldContainer(
                          controller: _lastNameController,
                          hintString: "Last Name",
                          icon: null,
                        ),
                        AppWidgets.textFieldNumberContainer(
                            hintString: "Mobile Number",
                            controller: _mobileNoTextEditingController,
                            icon: null,
                            maxLength: 10,
                            isEmail: false),
                        AppWidgets.textFieldNumberContainer(
                            hintString: "Email",
                            controller: _emailController,
                            icon: null,
                            isEmail: true),
                        AppWidgets.textFieldNumberContainer(
                          controller: _panController,
                          hintString: "Pan Card",
                          icon: null,
                          isEmail: true,
                          maxLength: 10,
                        ),
                      ],
                    ),
                  ),
                ),
                //Gap(size.height * .01),
                Container(
                  color: Colors.transparent,
                  padding: EdgeInsets.symmetric(horizontal: size.width * .02),
                  child: Row(
                    spacing: AppDimensions.getResponsiveWidth(context) * 0.01,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: AppWidgets.customButton(
                          context: context,
                          onClick: () {
                            resetData();
                          },
                          btnName: 'Reset',
                        ),
                      ),
                      Expanded(
                        child: AppWidgets.customButton(
                          context: context,
                          onClick: () => Navigator.pop(context),
                          btnName: 'Cancel',
                        ),
                      ),
                      Expanded(
                        child: BlocConsumer<SearchCustomerBloc, SearchCustomerState>(
                          listener: (context, state) {
                            if(state is SelectCustomerDataState){
                              Navigator.pop(context);
                            }
                          },
                          builder: (context, state) {
                            return AppWidgets.customButton(
                              context: context,
                              isLoading: state
                              is SearchCustomerLoading
                                  ? true
                                  : false,
                              onClick: () =>
                                  context.read<SearchCustomerBloc>().add(
                                    AddCustomerEvent(
                                      firstName: _firstNameController.text
                                          .trim(),
                                      lastName: _lastNameController.text.trim(),
                                      email: _emailController.text.trim(),
                                      phoneNo: _mobileNoTextEditingController
                                          .text
                                          .trim(),
                                      panCard: _panController.text.trim(),
                                    ),
                                  ),
                              btnName: 'Save',
                            );
                          },
                        ),
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
