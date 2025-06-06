import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/features/splash/splash_view_mode.dart';
import 'package:gro_one_app/routing/app_route_name.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/app_json.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/toast_messages.dart';
import 'package:lottie/lottie.dart';
import 'package:video_player/video_player.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  final splashViewModel = locator<SplashViewModel>();

  late VideoPlayerController _controller;

  @override
  void initState() {
    _controller = VideoPlayerController.asset(AppImage.png.splash)
      ..initialize().then((_) {
        if (mounted) {
          setState(() {});
          _controller.play();
        }
      });
    _controller.addListener(() {
      if (_controller.value.position == _controller.value.duration &&
          _controller.value.isInitialized &&
          mounted) {
        setState((){});
        //context.push(AppRouteName.chooseLanguage);
      }
    });
    init(context);
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    _controller.removeListener(() {}); // if you store the listener separately
    _controller.dispose();

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
        addPostFrameCallback(()=> context.push(AppRouteName.chooseLanguage));
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
          addPostFrameCallback(()=> navigateHomeScreen(splashViewModel.userRoleUIState!.data!, context));
        }
      }
    } else {
      ToastMessages.error(message: getErrorMsg(errorType: GenericError()));
    }
  }

  //Navigate Home Screen
  void navigateHomeScreen(String userRole, BuildContext context){
    if (userRole == "1") {
      context.push(AppRouteName.lpBottomNavigationBar);
    } else if (userRole == "2") {
      context.push(AppRouteName.vpBottomNavigationBar);
    } else {
      context.push(AppRouteName.notFound);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _controller.value.isInitialized
          ? SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: _controller.value.size.width,
            height: _controller.value.size.height,
            child: VideoPlayer(_controller),
          ),
        ),
      )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
