import 'package:estimation_dynamics/features/add_estimation_screen/presentation/add_estimation_screen.dart';
import 'package:estimation_dynamics/features/dashboard_screen/presentation/dashboard_screen.dart';
import 'package:estimation_dynamics/features/estimation_list_screen/presentation/estimation_list_screen.dart';
import 'package:estimation_dynamics/features/select_product_screen/presentation/select_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/login_screen/presentation/login_screen.dart';
import '../features/pdf_view_screen/presentation/pdfview_screen.dart';
import '../features/product_list_dialog/data/model/estimation_response_model.dart';
import '../features/product_list_dialog/data/model/reprint_estimation_response_model.dart';
import '../features/splash_screen/presentation/splash_screen.dart';
import '../main.dart';
import 'app_pages.dart';

class AppRouters {
  static final GoRouter _routers = GoRouter(
      navigatorKey: navigatorKey,
      initialLocation: AppPages.SPLASH_SCREEN,
      routes: [
       GoRoute(
          path: AppPages.SPLASH_SCREEN,
          pageBuilder: (context, state) => _defaultTransitionPage(
            key: state.pageKey,
            child: SplashScreen(),
          ),
          // builder: (BuildContext context, GoRouterState state) =>
          //     const SplashScreen(),
        ),
        GoRoute(
          path: AppPages.LOGIN,
          pageBuilder: (context, state) => _defaultTransitionPage(
            key: state.pageKey,
            child: LoginScreen(),
          ),
          // builder: (BuildContext context, GoRouterState state) =>
          //     const SplashScreen(),
        ),
        GoRoute(
            path: AppPages.DASHBOARD,
            pageBuilder: (context, state) => _defaultTransitionPage(
                key: state.pageKey,
                child:  DashboardScreen(),
            ),),

        GoRoute(
          path: AppPages.ESTIMATION,
          pageBuilder: (context, state) => _defaultTransitionPage(
            key: state.pageKey,
            child: EstimationListScreen(),
          ),
          // builder: (BuildContext context, GoRouterState state) =>
          //     const EstimationScreen(),
        ),

        GoRoute(
          path: AppPages.ADD_ESTIMATION,
          pageBuilder: (context, state) => _defaultTransitionPage(
            key: state.pageKey,
            child: AddEstimationScreen(),
          ),
          // builder: (BuildContext context, GoRouterState state) =>
          //     const EstimationScreen(),
        ),
        GoRoute(
          path: AppPages.SELECT_PRODUCT,
          pageBuilder: (context, state) => _defaultTransitionPage(
            key: state.pageKey,
            child: SelectProductScreen(),
          ),
          // builder: (BuildContext context, GoRouterState state) =>
          //     const EstimationScreen(),
        ),

        /*GoRoute(
          path: AppPages.ADD_CUSTOMER,
          pageBuilder: (context, state) => const MaterialPage(
            child: AddCustomerDialog(),
          ),
          // builder: (BuildContext context, GoRouterState state) =>
          //     const AddCustomerDialog(),
        ),
        GoRoute(
          path: AppPages.VIEW_CUSTOMER,
          pageBuilder: (context, state) => const MaterialPage(
            child: ViewCustomer(),
          ),
          // builder: (BuildContext context, GoRouterState state) =>
          //     const AddCustomerDialog(),
        ),
        GoRoute(
          path: AppPages.SEARCH_PRODUCT,
          pageBuilder: (context, state) => const MaterialPage(
            child: ProductSearchScreen(),
          ),
          // builder: (BuildContext context, GoRouterState state) =>
          //     const AddCustomerDialog(),
        ),
        GoRoute(
          path: AppPages.UPDATE_PASSWORD,
          pageBuilder: (context, state) => const MaterialPage(
            child: UpdatePasswordScreen(),
          ),
          // builder: (BuildContext context, GoRouterState state) =>
          //     const AddCustomerDialog(),
        ),*/
        GoRoute(
            path: AppPages.PDFVIEW,
            builder: (BuildContext context, GoRouterState state) {
              // final EstimationResponseModel estimationResponseModel = state.extra as EstimationResponseModel;
              final extra = state.extra as Map<String, dynamic>;
              final EstimationResponseModel? estimationResponseModel = extra['estimationResponseModel'] as EstimationResponseModel?;
              final ReprintEstimationModel? reprintEstimationModel = extra['reprintEstimationModel'] as ReprintEstimationModel?;
              final refNumber = extra['refNumber'] as String;
              return PdfviewScreen(estimationResponseModel: estimationResponseModel,refNumber:refNumber,reprintEstimationModel: reprintEstimationModel,);
            }),
      ]);

  GoRouter get routers => _routers;

  static CustomTransitionPage _defaultTransitionPage({
    required LocalKey key,
    required Widget child,
  }) {
    return CustomTransitionPage(
      key: key,
      child: child,
      transitionDuration: const Duration(milliseconds: 500), // Custom duration
      reverseTransitionDuration: const Duration(milliseconds: 500), // Reverse animation
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }
}
