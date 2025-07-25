import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/features/splash/splash_view_mode.dart';
import 'package:gro_one_app/routing/app_route_name.dart';
import 'package:gro_one_app/utils/app_json.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/custom_log.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/toast_messages.dart';
import 'package:lottie/lottie.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  final splashViewModel = locator<SplashViewModel>();

  @override
  void initState() {
    init(context);
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }


  //  Init Function
  Future<void> init(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 4), () async {
       await splashViewModel.fetchIsUserLogin();
    });

    if (splashViewModel.checkIsUserLoginUIState != null && splashViewModel.checkIsUserLoginUIState?.status != null) {
      if (splashViewModel.checkIsUserLoginUIState?.status == Status.SUCCESS) {
        if (splashViewModel.checkIsUserLoginUIState!.data == true) {
          if (!context.mounted) return;
          await _checkUserType(context);
        }
      }
      if (splashViewModel.checkIsUserLoginUIState?.status == Status.ERROR) {
        if (!context.mounted) return;
        frameCallback(()=> context.push(AppRouteName.chooseLanguage));
      }
    } else {
      ToastMessages.error(message: getErrorMsg(errorType: GenericError()));
    }
  }


  // Check user type (1 LP, 2 VP, 3 Both, 4)
  _checkUserType(BuildContext context) async {
    await splashViewModel.fetchUserType();
    if (splashViewModel.userRoleUIState != null && splashViewModel.userRoleUIState?.status != null) {
      if (splashViewModel.userRoleUIState?.status == Status.ERROR) {
        if(splashViewModel.userRoleUIState?.errorType != null){
          ToastMessages.error(message: getErrorMsg(errorType: splashViewModel.userRoleUIState!.errorType!));
        } else {
          ToastMessages.error(message: getErrorMsg(errorType: GenericError()));
        }
      }
      if (splashViewModel.userRoleUIState?.status == Status.SUCCESS) {
        if (splashViewModel.userRoleUIState?.data != null) {
          frameCallback(()=> navigateHomeScreen(splashViewModel.userRoleUIState!.data!, context));
        }
      }
    } else {
      ToastMessages.error(message: getErrorMsg(errorType: GenericError()));
    }
  }

  //Navigate Home Screen
  void navigateHomeScreen(int userRole, BuildContext context){
    CustomLog.debug(this, "User Role data type : ${userRole.runtimeType}");
    if (userRole == 0) {
      context.go(AppRouteName.driverHome);
    } else if (userRole == 1) {
      context.go(AppRouteName.lpBottomNavigationBar);
    } else if (userRole == 2) {
      context.go(AppRouteName.vpBottomNavigationBar);
    } else if (userRole == 3){
      context.go(AppRouteName.lpBottomNavigationBar);
    } else {
      context.push(AppRouteName.notFound);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Lottie.asset(
          height: MediaQuery.of(context).size.height,
          AppJSON.splash,
          fit: BoxFit.fill,
          width: double.infinity,
          frameRate: FrameRate(120),
          repeat: false,
          filterQuality: FilterQuality.high,
      ),
    );
  }
}
