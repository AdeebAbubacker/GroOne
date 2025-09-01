import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/profile/model/profile_detail_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/cubit/vp_create_account_cubit.dart';
import 'package:gro_one_app/helpers/date_helper.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/string_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/extra_utils.dart';
import '../../../utils/app_icons.dart';

class LpMyAccount extends StatefulWidget {
  final Customer? customerDetail;
  final BankDetails? bankDetails;
  final KycDoc? kycDoc;
  const LpMyAccount({super.key, required this.customerDetail, required this.bankDetails,
    required this.kycDoc});

  @override
  State<LpMyAccount> createState() => _LpMyAccountState();
}

class _LpMyAccountState extends State<LpMyAccount> {

  String checkUserDetails(dynamic value){
    if(value != null && value.toString().isNotEmpty){
      return value.toString();
    }else{
      return "--";
    }
  }
  final vpCreationCubit = locator<VpCreateAccountCubit>();
  List<int> selectedPrefLanesTypeList = [];


  @override
  void initState() {

    super.initState();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: context.appText.profile, actions: [
        IconButton(
          onPressed: () {
            commonSupportDialog(context, message: context.appText.toEditProfileContactCustomerSupport);
          },
          icon: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(5),
            child: SvgPicture.asset(
              AppIcons.svg.support,
              width: 25,
            ),
          ),
        ),
      ],),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(commonSafeAreaPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 20,
            children: [
              0.height,

              if (widget.customerDetail != null)...[
                headingText(text: context.appText.personalDetails),
                buildDetailWidget(
                  text1: context.appText.name,
                  text2: checkUserDetails(widget.customerDetail?.customerName.capitalize),
                ),

                buildDetailWidget(
                  text1: context.appText.mobileNumber,
                  text2: checkUserDetails('+91 ${widget.customerDetail?.mobileNumber}'),
                ),

                buildDetailWidget(
                    text1: context.appText.email,
                    text2: checkUserDetails(widget.customerDetail?.emailId)
                ),
                dividerWidget(),

                // Account Detail
                headingText(text: context.appText.accountDetails),
                buildDetailWidget(
                    text1: context.appText.blueMembershipId,
                    text2: checkUserDetails(widget.customerDetail?.blueId)
                ),

                if(widget.customerDetail?.companyType != null)
                  buildDetailWidget(
                    text1: context.appText.accountType,
                    text2: checkUserDetails(widget.customerDetail?.companyType!.companyType),
                  ),

                buildDetailWidget(
                  text1: context.appText.registrationData,
                  text2: widget.customerDetail?.createdAt != null ? DateTimeHelper.getFormattedDateWithShortMonthName(widget.customerDetail!.createdAt!) : "--",
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(context.appText.kycStatus, style: AppTextStyle.textGreyDetailColor14w400).expand(),
                    Text(widget.customerDetail?.kycType?.kycType ?? '', style: AppTextStyle.textGreyDetailColor14w400),
                    if(widget.customerDetail?.isKyc == 3)
                      ...[
                        5.width,
                        const Icon(Icons.verified, color: Colors.green)
                      ]
                  ],
                ),

                dividerWidget(),
              ],



              // Bank Details
              if(widget.bankDetails == null)...[
                headingText(text: context.appText.bankDetails),
                buildDetailWidget(
                  text1: context.appText.accountNumber,
                  text2: checkUserDetails(widget.bankDetails?.bankAccount),
                ),
                buildDetailWidget(
                  text1: context.appText.bankName,
                  text2: checkUserDetails(widget.bankDetails?.bankName),
                ),
                buildDetailWidget(
                  text1: context.appText.branchName,
                  text2: checkUserDetails(widget.bankDetails?.branchName),
                ),
                buildDetailWidget(
                  text1: context.appText.ifscCode,
                  text2: checkUserDetails(widget.bankDetails?.ifscCode),
                ),
                dividerWidget(),

              ],


              // Company Detail
              headingText(text: context.appText.companyDetails),
              if (widget.customerDetail != null)
              buildDetailWidget(
                text1: context.appText.companyName,
                text2: checkUserDetails(widget.customerDetail?.companyName.capitalize),
              ),

              if (widget.customerDetail?.companyType?.id != 2)
                buildDetailWidget(
                  text1: context.appText.gst,
                  text2: checkUserDetails(widget.kycDoc?.gstin ?? ''),
                ),




              20.height,
            ],
          ),
        ),
      ),
    );
  }

 Widget buildDetailWidget({required String text1, required String text2}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(text1, style: AppTextStyle.textGreyDetailColor14w400),
        Text(text2, style: AppTextStyle.textGreyDetailColor14w400),
      ],
    );
  }

}
