import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

import '../../../utils/app_bottom_sheet_body.dart';
import '../../../utils/app_button.dart';
import '../../../utils/app_button_style.dart';
import 'kavach_checkout_screen.dart';

class KavachShippingAddressListScreen extends StatelessWidget {
  const KavachShippingAddressListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBottomSheetBody(
      title: context.appText.shippingAddress,
      body: _buildBody(context: context),
    );
  }

  Widget _buildBody({required BuildContext context}){
    return SingleChildScrollView(
      child: Column(
        children: [
          AppButton(
            onPressed: ()=> context.pop(),
            title: context.appText.addNewAddress,
            style: AppButtonStyle.outline,
          ),
          // ListView.builder(
          //   itemCount: 2,
          //   shrinkWrap: true,
          //   physics: NeverScrollableScrollPhysics(),
          //   itemBuilder: (context, index){
          //     return
          //   },
          // ),
          ListView.separated(
            padding: EdgeInsets.symmetric(vertical: 20),
            shrinkWrap: true,
            itemCount: 2,
            separatorBuilder: (context, index) => 10.height,
            itemBuilder: (context, index) => addressWidget(),),
          20.height,
          AppButton(
            onPressed: (){},
            title: context.appText.deliverHere,
            style: AppButtonStyle.primary,
          ),
          20.height
        ],
      )
    );
  }
  Widget addressWidget(){
    return Container(
      padding: EdgeInsets.all(5),
      decoration: commonContainerDecoration(color: AppColors.greyContainerBackgroundColor),
      child: Row(
        children: [
          Radio(value: false, groupValue: null, onChanged: (value) {

          },),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('John Doe', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('+91 9988993399'),
                Text('18, 4th Street, MG Road, Nungambakkam, Chennai - 600 034.'),
              ],
            ),
          ),
        ],
      ),
    );
  }


}


