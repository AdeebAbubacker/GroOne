import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/profile/bloc/profile_bloc.dart';
import 'package:gro_one_app/features/profile/model/get_master_response.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_icon_button.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/toast_messages.dart';


class MasterScreen extends StatefulWidget {
  const MasterScreen({super.key});

  @override
  State<MasterScreen> createState() => _MasterScreenState();
}

class _MasterScreenState extends State<MasterScreen> {

  final lpProfileBloc=locator<ProfileBloc>();

  @override
  void initState() {
    initFunction();
    super.initState();
  }

  @override
  void dispose() {
    disposeFunction();
    super.dispose();
  }

  void initFunction() => addPostFrameCallback(() async {
    await lpProfileBloc.getUserId();
    lpProfileBloc.add(MasterRequested(userID: lpProfileBloc.userId ??""));
  });

  MasterResponse? masterResponse;

  void disposeFunction() => addPostFrameCallback(() {});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        actions: [
          AppIconButton(
            onPressed: (){},
            icon: Icon(Icons.add, color: Colors.white),
            style: AppButtonStyle.circularPrimaryColorIconButtonStyle,
          ),
          10.width
        ],
        backgroundColor: Colors.transparent,
        title: Text("Masters", style: AppTextStyle.textBlackColor18w500),
        toolbarHeight: 50.h,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child:BlocConsumer(
            bloc: lpProfileBloc,
            builder: (context, state) {
          return  masterResponse!=null? masterResponse!.data.isNotEmpty  ?ListView.builder(
            shrinkWrap: true,
            itemCount: masterResponse!.data.length,
            physics: BouncingScrollPhysics(),

            itemBuilder: (context, index) {
              return masterInfoWidget();
            },):Center(
            child: Text("No data found!"),
          ):Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor,),
          );
        }, listener: (context, state) {
          if(state is GetMasterSuccess){
            masterResponse=  state.masterResponse;
          }else if(state is ProfileUpdateError){
            ToastMessages.error(
              message: getErrorMsg(errorType: state.errorType),
            );
          }
        },)
      ),
    );
  }

  masterInfoWidget(){
    return   Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: AppColors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 15.h,
        children: [
          Text(
            "Address1",
            style: AppTextStyle.textBlackDetailColor15w500,
          ),
          Row(
            children: [
              SvgPicture.asset(
                AppImage.svg.location,
                height: 47.h,
                width: 20.h,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    Text(
                      "45, Maple Avenue, Greenfield, Karnataka, 560034",
                      style: AppTextStyle.textGreyColor12w400,
                    ),
                    10.height,
                    Text(
                      "45, Maple Avenue, Greenfield, Karnataka, 560034",
                      style: AppTextStyle.textGreyColor12w400,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
