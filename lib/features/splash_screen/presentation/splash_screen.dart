import 'package:estimation_dynamics/core/constants/app_colors.dart';
import 'package:estimation_dynamics/router/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/local/shared_preferences_helper.dart';
import '../data/bloc/token_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    /*Future.delayed(
      Duration(milliseconds: 1500),
      () => context.go(AppPages.LOGIN),
    );*/

    _initializer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.LIGHT_YELLOW_COLOR,
      body: SafeArea(
          child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/doodle_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.8,
                child: Image.asset(
                  "assets/images/logo.png",
                ),
              ),
            ),
            Center(
              child: BlocConsumer<TokenBloc, TokenState>(
                listener: (context, state) async {
                  if (state is TokenLoaded) {
                    if (state.accessToken != null) {
                      debugPrint("TOKEN-->${state.accessToken!}");
                      await SharedPreferencesHelper.init();
                      SharedPreferencesHelper.saveString(
                          AppConstants.ACCESS_TOKEN, state.accessToken!);
                      context.go(AppPages.LOGIN);
                    } else {
                      debugPrint("Access token is null");
                    }
                  } else if (state is TokenError) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(state.message)));
                  }
                },
                builder: (context, state) {
                  switch (state) {
                    case TokenInitial() || TokenLoading():
                      return LoadingAnimationWidget.newtonCradle(
                        color: AppColors.DEEP_YELLOW_COLOR,
                        size: 50,
                      );
                    default:
                      return Container();
                  }
                },
              ),
            ),
            Gap(MediaQuery.sizeOf(context).height * 0.01),
          ],
        ),
      )),
    );
  }

  Future<bool> _checkAccessToken() async {
    // Example token retrieval (adjust to your use case)
    debugPrint(
        "Expired-->${SharedPreferencesHelper.containsKey(AppConstants.ACCESS_TOKEN)}");
    String? accessToken;
    if (SharedPreferencesHelper.containsKey(AppConstants.ACCESS_TOKEN)) {
      accessToken = SharedPreferencesHelper.getString(
          AppConstants.ACCESS_TOKEN); // Replace with your method
    }
    if (accessToken == null || JwtDecoder.isExpired(accessToken)) {
      // Token is expired or doesn't exist
      return true;
    } else {
      // Token is valid
      return false;
    }
  }

  Future<void> _initializer() async {
    await SharedPreferencesHelper.init();
    bool isExpired = await _checkAccessToken();
    debugPrint("isExpired==>$isExpired");
    if (isExpired) {
      context.read<TokenBloc>().add(FetchTokenData());
    } else {
      redirect();
    }
  }

  void redirect() {
    if (SharedPreferencesHelper.containsKey(AppConstants.APP_KEY)) {
      Future.delayed(
          Duration(
            milliseconds: 2000,
          ), () {
        if (mounted) {
          context.go(AppPages.DASHBOARD);
        }
      });
    } else {
      Future.delayed(
          Duration(
            milliseconds: 2000,
          ), () {
        if (mounted) {
          context.go(AppPages.LOGIN);
        }
      });
      context.go(AppPages.LOGIN);
    }
  }
}
