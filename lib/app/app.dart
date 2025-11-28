import 'package:estimation_dynamics/features/estimation_list_screen/data/recall_repository.dart';
import 'package:estimation_dynamics/features/login_screen/data/repository/login_repository.dart';
import 'package:estimation_dynamics/features/product_list_dialog/data/repository/product_repository.dart';
import 'package:estimation_dynamics/features/search_customer_dialog/data/customer_repository.dart';
import 'package:estimation_dynamics/features/search_customer_dialog/presentation/bloc/search_customer_bloc.dart';
import 'package:estimation_dynamics/features/splash_screen/data/bloc/token_bloc.dart';
import 'package:estimation_dynamics/features/splash_screen/data/repository/token_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../features/add_estimation_screen/data/repository/estimation_repository.dart';
import '../features/add_estimation_screen/presentation/bloc/estimation_bloc.dart';
import '../features/estimation_list_screen/presentation/bloc/recall_estimation_bloc.dart';
import '../features/login_screen/presentation/blocLogin/login_bloc.dart';
import '../features/login_screen/presentation/blocStore/store_bloc.dart';
import '../features/product_list_dialog/presentation/bloc/product_bloc.dart';
import '../router/app_routers.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => TokenBloc(
                  TokenRepository(),
                )),
        BlocProvider(create: (context) => EstimationBloc(EstimationRepository())),
        BlocProvider(create: (context) => ProductBloc(ProductRepository())),
        BlocProvider(create: (context) => RecallEstimationBloc(RecallRepository())),
        BlocProvider(
            create: (context) => SearchCustomerBloc(
                  CustomerRepository(),
                  context.read<EstimationBloc>(),
                )),
        BlocProvider(
            create: (context) => LoginBloc(
                  LoginRepository(),
                )),
        BlocProvider(
            create: (context) => StoreBloc(
                  LoginRepository(),
                )),
      ],
      child: MaterialApp.router(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        routerDelegate: AppRouters().routers.routerDelegate,
        routeInformationProvider: AppRouters().routers.routeInformationProvider,
        routeInformationParser: AppRouters().routers.routeInformationParser,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          textTheme: TextTheme(
            bodyMedium: GoogleFonts.poppins(),
          ),
          useMaterial3: true,
        ),
        //home: const SplashScreen(),
      ),
    );
  }
}
