import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_dimensions.dart';
import '../main.dart';

class AppWidgets {
  static Widget headerContainer(
      {String? from,
      required BuildContext context,
      bool isLogin = false,
      String? backPageName}) {
    return Container(
      height: AppDimensions.getResponsiveHeight(context) * 0.3,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.HEADER_GRADIENT_START_COLOR,
            AppColors.HEADER_GRADIENT_END_COLOR,
          ],
        ),
      ),
      child: isLogin
          ? Container(
              margin: EdgeInsets.only(
                right: AppDimensions.getResponsiveWidth(context) * 0.05,
                left: AppDimensions.getResponsiveWidth(context) * 0.05,
                top: AppDimensions.getResponsiveHeight(context) * 0.02,
              ),
              alignment: Alignment.topRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  from == null
                      ? GestureDetector(
                          onTap: () => context.go(backPageName!),
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.APP_SCREEN_BACKGROUND_COLOR,
                            ),
                            child: Center(
                              child: Icon(
                                Icons.arrow_back,
                                color: AppColors.TITLE_TEXT_COLOR,
                                size: 24,
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.APP_SCREEN_BACKGROUND_COLOR,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.person_2_outlined,
                        color: AppColors.TITLE_TEXT_COLOR,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Container(),
    );
  }

  static Widget footerContainer(BuildContext context) {
    return Container(
      height: AppDimensions.getResponsiveHeight(context) * 0.665,
      //color: Colors.green,
      decoration: const BoxDecoration(
        color: AppColors.LIGHT_YELLOW_COLOR,
        image: DecorationImage(
          image: AssetImage("assets/images/doodle_bg.png"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  static Widget showIconContainer(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: 10,
        right: 10,
        top: 10,
      ),
      width: MediaQuery.sizeOf(context).width * 0.8,
      child: Image.asset(
        "assets/images/logo.png",
      ),
    );
  }

  static Widget showTitle({required String title, required Size size}) {
    return Text(
      title,
      textAlign: TextAlign.left,
      style: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 20,
        color: AppColors.TITLE_TEXT_COLOR,
      ),
    );
  }

  static Widget showSubTitle({required String subtitle, required Size size}) {
    return Text(
      subtitle,
      textAlign: TextAlign.left,
      style: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 14,
        color: AppColors.TITLE_TEXT_COLOR,
      ),
    );
  }

  static Widget textFieldContainer({
    required IconData? icon,
    required String hintString,
    required TextEditingController? controller,
    bool isEnabled = true
  }) {
    debugPrint("HINT--->$hintString");
    return Container(
      decoration: BoxDecoration(
        color: AppColors.APP_SCREEN_BACKGROUND_COLOR,
        // borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.TITLE_TEXT_COLOR),
      ),
      child: TextField(
        enabled: isEnabled,
        controller: controller,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: hintString,
          counterText: "",
          /*labelText: hintString,
          labelStyle: const TextStyle(
            color: AppColors.TITLE_TEXT_COLOR,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),*/
          prefixIcon: icon != null
              ? Icon(
                  icon,
                  size: 24,
                  color: AppColors.BUTTON_COLOR,
                )
              : null,
          hintStyle: const TextStyle(
            color: AppColors.TITLE_TEXT_COLOR,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
              vertical: 12, horizontal: 10), // Optimized padding
        ),
      ),
    );
  }

  static Widget textFieldNumberContainer(
      {required IconData? icon,
      required String hintString,
      required TextEditingController? controller,
      required int maxLength}) {
    debugPrint("HINT--->$hintString");
    return Container(
      decoration: BoxDecoration(
        color: AppColors.APP_SCREEN_BACKGROUND_COLOR,
        // borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.TITLE_TEXT_COLOR),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.black),
        keyboardType: TextInputType.number,
        maxLength: maxLength,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          hintText: hintString,
          counterText: "",
          /*labelText: hintString,
          labelStyle: const TextStyle(
            color: AppColors.TITLE_TEXT_COLOR,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),*/
          prefixIcon: icon != null
              ? Icon(
                  icon,
                  size: 24,
                  color: AppColors.BUTTON_COLOR,
                )
              : null,
          hintStyle: const TextStyle(
            color: AppColors.TITLE_TEXT_COLOR,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
              vertical: 12, horizontal: 10), // Optimized padding
        ),
      ),
    );
  }

  static Widget textPasswordFieldContainer({
    required String hintString,
    required TextEditingController? controller,
    void Function()? onVisibility,
    required bool isObscure,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.APP_SCREEN_BACKGROUND_COLOR,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.TITLE_TEXT_COLOR),
      ),
      child: TextField(
        obscureText: isObscure,
        controller: controller,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: hintString,
          counterText: "",
          prefixIcon: Icon(
            Icons.lock_outline,
            size: 24,
            color: AppColors.BUTTON_COLOR,
          ),
          suffixIcon: IconButton(
            onPressed: onVisibility,
            icon: Icon(
              isObscure ? Icons.visibility : Icons.visibility_off,
              size: 24,
              color: AppColors.BUTTON_COLOR,
            ),
          ),
          hintStyle: const TextStyle(
            color: AppColors.TITLE_TEXT_COLOR,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
              vertical: 12, horizontal: 10), // Optimized padding
        ),
      ),
    );
  }

  static Widget customButton({
    required String btnName,
    bool? isLoading = false,
    required BuildContext context,
    required void Function() onClick,
  }) {
    return GestureDetector(
        onTap: () => isLoading == false ? onClick() : null,
        child: Container(
          height: AppDimensions.getResponsiveWidth(context) * .12,
          width: AppDimensions.getResponsiveWidth(context) * .5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: AppColors.TITLE_TEXT_COLOR,
          ),
          child: Center(
            child: isLoading == true
                ? LoadingAnimationWidget.newtonCradle(
                    color: Colors.white,
                    size: 50,
                  )
                : Text(
                    btnName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
          ),
        ));
  }

  static Widget searchBoxContainer({
    bool isSearchByDate = false,
    required String hintText,
    required BuildContext context,
    required void Function() func,
  }) {
    return GestureDetector(
      onTap: isSearchByDate ? func : null,
      child: Container(
        /*padding: EdgeInsets.only(
          left: MediaQuery.sizeOf(context).width * 0.008,
          right: MediaQuery.sizeOf(context).width * 0.008,
        ),*/
        decoration: BoxDecoration(
          color: AppColors.LIGHT_YELLOW_COLOR,
          borderRadius: BorderRadius.circular(0),
          border: Border.all(
            color: AppColors.TITLE_TEXT_COLOR,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: null,
                enabled: isSearchByDate ? false : true,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                    hintText: hintText,
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.sizeOf(context).width * 0.02),
                    prefixIcon: isSearchByDate
                        ? Container(
                            margin: EdgeInsets.symmetric(horizontal: 4),
                            child: Icon(
                              Icons.calendar_month,
                              size: 20,
                              color: AppColors.TITLE_TEXT_COLOR,
                            ),
                          )
                        : null,
                    prefixIconConstraints: BoxConstraints(
                      minWidth: 20, // Adjust min width if needed
                      minHeight: 20, // Adjust min height if needed
                    ),
                    hintStyle: const TextStyle(
                      color: Colors.grey, //AppColors.HINT_TEXT_COLOR,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                    border: InputBorder.none),
              ),
            ),
            GestureDetector(
              onTap: func,
              child: Container(
                width: MediaQuery.sizeOf(context).width * 0.14, //45,
                height: MediaQuery.sizeOf(context).height * 0.075, //48,
                decoration: BoxDecoration(
                  color: AppColors.TITLE_TEXT_COLOR,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(0),
                    bottomRight: Radius.circular(0),
                  ),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    "assets/images/search.svg",
                    colorFilter:
                        const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildStepperContainer(Size size, {int pageNo = 1}) {
    return Container(
      // color: Colors.green,
      // height: size.height * .06,//.034,
      margin: EdgeInsets.symmetric(
        horizontal: size.width * .02,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Divider(
                thickness: size.height * .005,
                color: AppColors.TITLE_TEXT_COLOR,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStepperBox(
                    label: "1",
                    text: "New",
                    isActive: true,
                    color: AppColors.TITLE_TEXT_COLOR,
                    size: size,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Divider(
                thickness: size.height * .005,
                color: pageNo == 2
                    ? AppColors.TITLE_TEXT_COLOR
                    : AppColors.STEPPER_PENDING_COLOR,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStepperBox(
                  label: "2",
                  text: "Product",
                  isActive: pageNo == 2,
                  color: pageNo == 2
                      ? AppColors.TITLE_TEXT_COLOR
                      : AppColors.STEPPER_PENDING_COLOR,
                  size: size,
                ),
              ],
            ),
            Expanded(
              child: Divider(
                thickness: size.height * .005,
                color: pageNo == 2
                    ? AppColors.TITLE_TEXT_COLOR
                    : AppColors.STEPPER_PENDING_COLOR,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepperBox({
    required String label,
    required String text,
    required bool isActive,
    required Color color,
    required Size size,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: size.height * .034,
          width: size.width * .085,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        Text(
          text,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget buildCustomerTab(
      Size size, String icon, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        height: size.height * 0.1, // 0.12
        // width: size.width * 0.32,
        decoration: BoxDecoration(
          color: AppColors.CUSTOMER_TAB_BACKGROUND_COLOR,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.3),
              offset: const Offset(0.5, 0.5),
              blurRadius: 1.2,
              spreadRadius: 0.5,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center, // keeps things aligned
          children: [
            // Icon Container
            Container(
              height: size.height * 0.06,
              width: size.width * 0.12, // smaller width looks balanced
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.APP_SCREEN_BACKGROUND_COLOR,
              ),
              child: Center(
                child: SvgPicture.asset(
                  "assets/images/$icon",
                  colorFilter: const ColorFilter.mode(
                    AppColors.TITLE_TEXT_COLOR,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8), // spacing between icon & text
            // Title Text
            Text(
              title,
              style: const TextStyle(
                color: AppColors.TITLE_TEXT_COLOR,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /*Widget buildCustomerTab(
      Size size, String icon, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        height:
            AppDimensions.getResponsiveHeight(navigatorKey.currentContext!) *
                0.12,
        //0.15
        width: AppDimensions.getResponsiveWidth(navigatorKey.currentContext!) *
            0.32,
        //0.35
        decoration: BoxDecoration(
          color: AppColors.CUSTOMER_TAB_BACKGROUND_COLOR, //Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.3),
              offset: const Offset(0.5, 0.5),
              blurRadius: 1.2,
              spreadRadius: 0.5,
            ),
          ],
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon Container
              Container(
                height: AppDimensions.getResponsiveHeight(
                        navigatorKey.currentContext!) *
                    0.06, //0.08
                width: AppDimensions.getResponsiveWidth(
                        navigatorKey.currentContext!) *
                    0.2,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.APP_SCREEN_BACKGROUND_COLOR,
                ),
                child: Center(
                  child: SvgPicture.asset(
                    "assets/images/$icon",
                    colorFilter: const ColorFilter.mode(
                        AppColors.TITLE_TEXT_COLOR, BlendMode.srcIn),
                  ),
                ),
              ),
              // Title Text
              Container(
                margin: EdgeInsets.only(
                    top: AppDimensions.getResponsiveHeight(
                            navigatorKey.currentContext!) *
                        0.01), //0.02
                child: Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.TITLE_TEXT_COLOR,
                    fontSize: 18,//12.5,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }*/

  /*static Widget buildSearchableField(
      Size size,
      String hint,
      TextEditingController? searchTextController, {
        bool isEnabled = false,
        bool isProductList = false,
        TextEditingController? qtyTextController,
        void Function()? func,
        Color color = AppColors.DEEP_YELLOW_COLOR,
        void Function(String sku, String qty)? change, // 👈 changed here
        String? icons = "assets/images/search.svg",
      }) {
    return GestureDetector(
      onTap: () => func?.call(),
      child: Row(
        children: [
          // SKU ID - flex 3
          Expanded(
            flex: 3,
            child: Container(
              margin: EdgeInsets.symmetric(
                vertical: size.height * .005,
                horizontal: size.width * 0.005,
              ),
              padding: EdgeInsets.only(left: size.width * 0.008),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.3),
                    spreadRadius: 1.2,
                    blurRadius: 0.5,
                    offset: const Offset(1.0, 1.0),
                  ),
                ],
              ),
              child: TextField(
                controller: searchTextController,
                onChanged: (value) {
                  debugPrint("SKU ID ---> $value");
                  change?.call(
                    value,
                    qtyTextController?.text ?? "", // pass both
                  );
                },
                enabled: isEnabled,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: const TextStyle(
                    color: AppColors.DEEP_YELLOW_COLOR,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),

          if (isProductList)
            Expanded(
              flex: 2,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: size.height * .005),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.3),
                      spreadRadius: 1.2,
                      blurRadius: 0.5,
                      offset: const Offset(1.0, 1.0),
                    ),
                  ],
                ),
                child: TextField(
                  controller: qtyTextController,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    debugPrint("QTY ---> $value");
                    change?.call(
                      searchTextController?.text ?? "", // pass both
                      value,
                    );
                  },
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: const InputDecoration(
                    hintText: "Qty.",
                    hintStyle: TextStyle(
                      color: AppColors.DEEP_YELLOW_COLOR,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),

          // Action button
          Container(
            width: size.width * 0.14,
            height: size.height * 0.065,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(4),
                bottomRight: Radius.circular(4),
              ),
            ),
            child: Center(
              child: SvgPicture.asset(
                icons!,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }*/

  static Widget buildSearchableField(
      Size size,
      String hint,
      TextEditingController? controller, {
        bool isEnabled = false,
        void Function()? func,
        void Function(String sku)? change,
        String? icons = "assets/images/search.svg",
      }) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical:
        AppDimensions.getResponsiveHeight(navigatorKey.currentContext!) *
            .005,
        horizontal:
        AppDimensions.getResponsiveWidth(navigatorKey.currentContext!) * 0.005,
      ),
      padding: EdgeInsets.only(
        left: AppDimensions.getResponsiveWidth(navigatorKey.currentContext!) *
            0.008,
      ),
      decoration: BoxDecoration(
        color: AppColors.APP_SCREEN_BACKGROUND_COLOR,
        border: Border.all(
          color: AppColors.TITLE_TEXT_COLOR,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: (value) {
                  debugPrint("SKU ID ---> $value");
                  change?.call(
                    value
                  );
                },
              enabled: isEnabled, // ✅ this is the correct property
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(
                  color: AppColors.TITLE_TEXT_COLOR,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                contentPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                border: InputBorder.none,
              ),
            ),
          ),
          GestureDetector(
            onTap: func,
            child: Container(
              width: AppDimensions.getResponsiveWidth(navigatorKey.currentContext!) *
                  0.14,
              height: AppDimensions.getResponsiveHeight(navigatorKey.currentContext!) *
                  0.075,
              color: AppColors.TITLE_TEXT_COLOR,
              child: Center(
                child: SvgPicture.asset(
                  icons!,
                  colorFilter:
                  const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /*static Widget buildSearchableField(
      Size size, String hint, TextEditingController? controller,
      {bool isEnabled = false,
      void Function()? func,
      String? icons = "assets/images/search.svg"}) {
    return GestureDetector(
      onTap: () => func!(),
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical:
              AppDimensions.getResponsiveHeight(navigatorKey.currentContext!) *
                  .005,
          horizontal:
              AppDimensions.getResponsiveWidth(navigatorKey.currentContext!) *
                  0.005,
        ),
        // padding: const EdgeInsets.symmetric(horizontal: 6), //,vertical: 2
        padding: EdgeInsets.only(
          left: AppDimensions.getResponsiveWidth(navigatorKey.currentContext!) *
              0.008,
        ), //,left: 6
        decoration: BoxDecoration(
          color: AppColors.APP_SCREEN_BACKGROUND_COLOR,
          // borderRadius: BorderRadius.circular(4),
          *//*boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.3),
              spreadRadius: 1.2,
              blurRadius: 0.5,
              offset: const Offset(1.0, 1.0),
            ),
          ],*//*
          border: Border.all(
            color: AppColors.TITLE_TEXT_COLOR,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                    hintText: hint,
                    enabled: isEnabled,
                    hintStyle: const TextStyle(
                      color: AppColors.TITLE_TEXT_COLOR,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                    border: InputBorder.none),
              ),
            ),
            Container(
              width: AppDimensions.getResponsiveWidth(
                      navigatorKey.currentContext!) *
                  0.14, //45,
              height: AppDimensions.getResponsiveHeight(
                      navigatorKey.currentContext!) *
                  0.075, //48,
              decoration: const BoxDecoration(
                color: AppColors.TITLE_TEXT_COLOR,
                *//*borderRadius: BorderRadius.only(
                  topRight: Radius.circular(4),
                  bottomRight: Radius.circular(4),
                ),*//*
              ),
              child: Center(
                child: SvgPicture.asset(
                  icons!,
                  colorFilter:
                      const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }*/

  Widget buildTextFormField(Size size,
      {required TextEditingController? controller,
      required String hintText,
      required String labelText,
      TextInputType? textInputType = TextInputType.text,
      bool enabled = true,
      var maxLength,
      FocusNode? focusNode,
      List<TextInputFormatter>? inputFormatters,
      void Function(String? value)? onChange,
      void Function()? onTap}) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: size.height * 0.005,
        horizontal: size.width * 0.005,
      ),
      decoration:
          BoxDecoration(border: Border.all(color: AppColors.TITLE_TEXT_COLOR)),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        onTap: () => onTap!(),
        focusNode: focusNode,
        maxLength: maxLength,
        inputFormatters: inputFormatters,
        keyboardType: textInputType,
        onChanged: (value) => onChange!(value),
        style: const TextStyle(
          fontSize: 16,
          color: AppColors.TITLE_TEXT_COLOR,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          focusColor: AppColors.TITLE_TEXT_COLOR,
          //Colors.white,
          // filled: true,
          // border: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(0.0),
          //   borderSide: BorderSide(
          //     color: AppColors.TITLE_TEXT_COLOR,
          //   )
          // ),
          // focusedBorder: OutlineInputBorder(
          //   borderSide: const BorderSide(
          //       color: AppColors.TITLE_TEXT_COLOR, width: 1.0),
          //   borderRadius: BorderRadius.circular(0.0),
          // ),
          fillColor: AppColors.TITLE_TEXT_COLOR,
          hintText: hintText,
          hintStyle: const TextStyle(
            color: AppColors.TITLE_TEXT_COLOR,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          labelText: labelText,
          labelStyle: const TextStyle(
            color: AppColors.TITLE_TEXT_COLOR,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          contentPadding: const EdgeInsets.symmetric(
              vertical: 10.0, horizontal: 10.0), // Adjust vertical padding here
        ),
      ),
    );
  }

  static void showCustomSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.HEADER_GRADIENT_END_COLOR,
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  static Widget customMobileButton(
      {required Size size,
        required String btnName,
        Color color = AppColors.DEEP_YELLOW_COLOR,
        bool isLoading = false,
        void Function()? func,
        Color textColor = Colors.white}) {
    return GestureDetector(
      onTap: () => func!(),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        height:
        // AppDimensions.getResponsiveHeight(navigatorKey.currentContext!) * .04,
        AppDimensions.getResponsiveHeight(navigatorKey.currentContext!) * .05,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: color,
        ),
        child: Center(
          child: isLoading
              ? LoadingAnimationWidget.staggeredDotsWave(
              color: textColor, size: 22)
              : Text(
            btnName,
            style: TextStyle(fontSize: 16,
                fontWeight: FontWeight.w600,
                color: textColor),
          ),
        ),
      ),
    );
  }

}
