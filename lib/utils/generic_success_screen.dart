import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/core/base_state.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_json.dart';
import 'package:gro_one_app/utils/app_string.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:lottie/lottie.dart';

class GenericSuccessScreen extends StatefulWidget {
  final String title;
  final String subtitle;
  final bool residentHome;
  final bool securityHome;
  final bool goBack;
  const GenericSuccessScreen({super.key, required this.title, required this.subtitle,  this.residentHome = false, this.securityHome = false, this.goBack = false});

  @override
  BaseState<GenericSuccessScreen> createState() => _GenericSuccessScreenState();
}

class _GenericSuccessScreenState extends BaseState<GenericSuccessScreen> with SingleTickerProviderStateMixin{

  void navigation (Widget route) {
    addPostFrameCallback((){
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => route), (Route<dynamic> route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.all(commonSafeAreaPadding),
        child: Stack(
          alignment: Alignment.center,
          children: [

            Lottie.asset(AppJSON.accountCreateSuccessfully, repeat: false, frameRate: const FrameRate(60)).paddingBottom(50),

            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(widget.title, textAlign: TextAlign.center, style: AppTextStyle.h2.copyWith(color: AppColors.secondaryColor)),
                250.height,
                Text(widget.subtitle,  textAlign: TextAlign.center, style: AppTextStyle.body2).paddingSymmetric(horizontal: 10),
                30.height,
                AppButton(
                  onPressed: (){
                    // if(widget.residentHome){
                    //   navigation(const MainEntryPoint());
                    // }
                    // if(widget.securityHome){
                    //   navigation(const SecurityHomeScreen());
                    // }
                    if(widget.goBack){
                      context.pop();
                    }
                  },
                  title: AppString.label.backToHome,
                ),
              ],
            ).isAnimate().center(),
          ],
        ),

      ),
    );
  }
}
