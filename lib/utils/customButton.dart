import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_colors.dart';


class CustomButton extends StatelessWidget {
  const CustomButton({required this.onClick,required this.buttonText,this.disable=false,this.loading=false,super.key});
final bool disable;
final bool loading;
final GestureTapCallback onClick;
final String buttonText;
  @override
  Widget build(BuildContext context) {
    return InkWell(onTap: disable?onClick:null,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 48.h,
        decoration: BoxDecoration(color: disable?AppColors.primaryColor:AppColors.buttonDisableColor,borderRadius: BorderRadius.circular(8)),
        child: Center(
          child: !loading?Text(buttonText,style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          )):SizedBox(height: 20.h,width: 20.w,child: CircularProgressIndicator(color: Colors.white,)),
        ),
      ),
    );
  }
}
