import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

import '../../../utils/app_icons.dart';

class NotificationWidget extends StatelessWidget {
  const NotificationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 8,
      separatorBuilder: (context, index) => Column(
        children: [
          10.height,
          commonDivider(
            dividerColor: Color(0xffEAEAEA)
          )
        ],
      ),
      itemBuilder: (context, index) {
      return _notificationWidget();
    },);
  }

  Widget _notificationWidget(){
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
          height: 39,
          width: 39,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xffDFE6FF)
          ),
          child: SvgPicture.asset(
            AppIcons.svg.package,
            height: 20,width: 20,
            color: AppColors.primaryColor,

          ).center()
      ),

      title: Text("A Delhi- Mumbai Load has been posted",style: AppTextStyle.body3.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.textBlackDetailColor

      ),),
      subtitle:   Text("TN 12 J 8617 at 4:30 p.m",style: AppTextStyle.body3.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.textBlackDetailColor
      ),),
      trailing: Text("1 min ago",style: AppTextStyle.body3.copyWith(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: AppColors.textBlackDetailColor
      ),),
    );
  }




}
