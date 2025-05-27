import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/enum/status.dart';
import 'package:gro_one_app/features/splash/splash_view_mode.dart';
import 'package:gro_one_app/routing/app_route_name.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/toast_messages.dart';
import 'package:video_player/video_player.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  late VideoPlayerController _controller;
  final splashViewModel = locator<SplashViewModel>();


  @override
  void initState() {
    _controller = VideoPlayerController.asset(AppImage.png.splash)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });

    _controller.addListener(() {
      if (_controller.value.position == _controller.value.duration && _controller.value.isInitialized) {
        context.push(AppRouteName.chooseLanguage);
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
    _controller.dispose();
    super.dispose();
  }


  //  Init Function
  Future<void> init(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 3), () async {
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
        addPostFrameCallback(()=> context.go(AppRouteName.chooseLanguage));
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
      context.go(AppRouteName.lpBottomNavigationBar);
    } else if (userRole == "2") {
      context.go(AppRouteName.vpBottomNavigationBar);
    } else {
      context.go(AppRouteName.notFound);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _controller.value.isInitialized
          ? Center(
        child: AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        ),
      )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
