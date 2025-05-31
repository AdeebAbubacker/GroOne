import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

import '../../../utils/app_bottom_sheet_body.dart';
import '../../../utils/app_button.dart';
import '../../../utils/app_button_style.dart';
import '../../../utils/app_button_with_icon.dart';

class KavachAddShippingAddressBottomSheet extends StatefulWidget {
  const KavachAddShippingAddressBottomSheet({super.key});

  @override
  State<KavachAddShippingAddressBottomSheet> createState() => _KavachAddShippingAddressBottomSheetState();
}

class _KavachAddShippingAddressBottomSheetState extends State<KavachAddShippingAddressBottomSheet> {
  final formKey = GlobalKey<FormState>();
  final customerNameController = TextEditingController();
  final mobileNoController = TextEditingController();
  final addressLine1Controller = TextEditingController();
  final addressLine2Controller = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final pinCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AppBottomSheetBody(
      title: context.appText.shippingAddress,
      body: _buildBody(context: context),
    );
  }

  Widget _buildBody({required BuildContext context}){
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextField(controller: customerNameController,hintText: context.appText.name,),
            10.height,
            AppTextField(controller: mobileNoController,hintText: context.appText.mobileNumber,),
            10.height,
            AppTextField(controller: addressLine1Controller,hintText: '${context.appText.addressLine} 1',),
            10.height,
            AppTextField(controller: customerNameController,hintText: '${context.appText.addressLine} 2',),
            10.height,
            AppTextField(controller: customerNameController,hintText: context.appText.city,),
            10.height,
            AppTextField(controller: customerNameController,hintText: context.appText.state,),
            10.height,
            AppTextField(controller: customerNameController,hintText: context.appText.mobileNumber,),
            10.height,
            AppButtonWithIcon(title: context.appText.useMyCurrentLocation ,iconData: Icons.my_location,onPressed: () {
            },),
            30.height,
            Row(
              children: [
                AppButton(
                  onPressed: ()=> context.pop(),
                  title: context.appText.cancel,
                  style: AppButtonStyle.outline,
                ).expand(),
                20.width,
                AppButton(
                  onPressed: (){},
                  title: context.appText.submit,
                  style: AppButtonStyle.primary,
                ).expand()
              ],
            ),
        
          ],
        ),
      ),
    );
  }
}
