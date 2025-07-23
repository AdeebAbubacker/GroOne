import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gro_one_app/features/driver/driver_home/helper/driver_load_helper.dart';
import 'package:gro_one_app/features/driver/driver_home/model/driver_load_response.dart';
import 'package:gro_one_app/features/driver/driver_load_details/model/driver_load_details_model.dart';
import 'package:gro_one_app/features/driver/driver_load_details/view/driver_load_details_screen.dart';
import 'package:gro_one_app/features/load_provider/lp_home/helper/lp_home_helper.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/view/widgets/swipe_button_widget.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/toast_messages.dart';

import '../../../../../utils/app_button.dart';
import '../../../../../utils/app_button_style.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_icons.dart';
import '../../../../../utils/app_image.dart';
import '../../../../../utils/app_text_style.dart';
import '../../../../../utils/common_functions.dart';
import '../../../../../utils/common_widgets.dart';
import '../../../../../utils/constant_variables.dart';

class DriverLoadWidget extends StatefulWidget {  
  final void Function()? onClickAssignDriver;
  final DriverLoadDetails driverLoadDetails;
  const DriverLoadWidget({super.key, required this.onClickAssignDriver,required this.driverLoadDetails});

  @override
  State<DriverLoadWidget> createState() => _DriverLoadWidgetState();
}

class _DriverLoadWidgetState extends State<DriverLoadWidget> {
@override
void initState() {
  super.initState();
  _validateButtonStateOnInit();
}
bool _isButtonEnabled = true; 

 // Button Status
  bool _shouldEnableButton(DriverLoadDetails? load) {
  if (load == null) return false;

  final currentStatus = load?.loadStatusId ?? 0;

  // For status 5: Consent + Required documents
  if (currentStatus == 5) {
    final isConsentGiven =load?.driverConsent == 1;

    final nestedDocuments = load?.loadDocument ?? [];
    final documents = nestedDocuments.expand((list) => list).toList();

    const requiredDocs = [
      'lorry receipt',
      'eway bill',
      'material invoice',
    ];

    final uploadedTypes = documents
        .where((doc) => doc.status == 1)
        .map((doc) => doc.documentDetails?.documentType?.toLowerCase() ?? '')
        .toSet();

    final allRequiredDocsUploaded = requiredDocs.every(uploadedTypes.contains);

    return isConsentGiven && allRequiredDocsUploaded;
  }

  // For status 6: POD document uploaded
  if (currentStatus == 6) {
    final nestedDocuments = load?.loadDocument ?? [];
    final documents = nestedDocuments.expand((list) => list).toList();

    final podDocExists = documents.any((doc) =>
        (doc.documentDetails?.documentType?.toLowerCase() == 'proof of document' ||
         doc.documentDetails?.title?.toLowerCase().contains('pod') == true) &&
        doc.status == 1);

    return podDocExists;
  }

  // Default case for other statuses
  return true;
}

//Button Status on init
void _validateButtonStateOnInit() {
  final statusId = widget.driverLoadDetails.loadStatusId;

  if (statusId == 5) {
    final isSimConsentGiven = widget.driverLoadDetails.driverConsent == 1;
    final nestedDocuments = widget.driverLoadDetails.loadDocument ?? [];
    final documents = nestedDocuments.expand((list) => list).toList();

    const requiredDocs = ['lorry receipt', 'eway bill', 'material invoice'];

    final uploadedTypes = documents
        .where((doc) => doc.status == 1)
        .map((doc) => doc.documentDetails?.documentType?.toLowerCase() ?? '')
        .toSet();

    final allRequiredDocsUploaded = requiredDocs.every(uploadedTypes.contains);

    setState(() {
      _isButtonEnabled = isSimConsentGiven && allRequiredDocsUploaded;
    });
    return;
  }

  if (statusId == 6) {
    final nestedDocuments = widget.driverLoadDetails.loadDocument ?? [];
    final documents = nestedDocuments.expand((list) => list).toList();

    final podDocExists = documents.any((doc) =>
        (doc.documentDetails?.documentType?.toLowerCase() == 'proof of document' ||
         doc.documentDetails?.title?.toLowerCase().contains('pod') == true) &&
        doc.status == 1);

    setState(() {
      _isButtonEnabled = podDocExists;
    });
    return;
  }

  setState(() {
    _isButtonEnabled = true;
  });
}

 
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return DriverLoadsLocationDetailsScreen(loadId: widget.driverLoadDetails.loadId,);
        },));
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        decoration: commonContainerDecoration(
          borderColor: AppColors.primaryColor,
          borderWidth: 1,
          color: AppColors.blackishWhite,
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  AppImage.png.truckMyLoad,
                  width: 50,
                ).paddingSymmetric(vertical: 10),
                10.width,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.driverLoadDetails.loadSeriesId, style: AppTextStyle.h5),
                    Text(
                    formatDateTimeKavach(widget.driverLoadDetails.createdAt?.toString()??DateTime.now().toString()),
                    style: AppTextStyle.primaryColor12w400,
                    ),
                  ],
                ).expand(),
                5.width,
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Wrap(
                      children: [
                        _buildLocationInfoWidget(widget.driverLoadDetails.loadRoute?.pickUpWholeAddr ?? "",),
                        Icon(
                          Icons.arrow_right_alt_outlined,
                          color: AppColors.primaryColor,
                        ).paddingSymmetric(horizontal: 2),
                        _buildLocationInfoWidget(widget.driverLoadDetails.loadRoute?.dropWholeAddr ?? "",)
                      ],
                    ),
                     5.height,
                   Container(
              decoration: commonContainerDecoration(
                color: LpHomeHelper.getLoadStatusColor(widget.driverLoadDetails.loadStatusDetails?.loadStatus.toString() ?? '')
              ),
              width: 100,
              child: Text(
                LpHomeHelper.getLoadTypeDisplayText(widget.driverLoadDetails.loadStatusDetails?.loadStatus.toString() ?? ''),
                style: AppTextStyle.body3.copyWith(color: LpHomeHelper.getLoadStatusTextColor(widget.driverLoadDetails.loadStatusDetails?.loadStatus.toString() ?? '')),
              ).center().paddingAll(4),
            ),     5.height,
                  ],
                ).expand(),
              ],
            ),
      
            commonDivider(),
            //  statusButtonWidget(statusBackgroundColor: AppColors.boxGreen, statusTextColor: AppColors.textGreen, statusText: "Advance Paid")
           
      
          //  progressBarWidget(progressValue: 0.5,),
          //  commonDivider(),
      
        if(widget.driverLoadDetails.loadStatusId > 4)
         widget.driverLoadDetails.driverConsent == 0  
          ? Column(
              children: [
                Text(
                  "No SIM tracking consent from driver",
                  style: AppTextStyle.textBlackColor16w400.copyWith(
                    color: AppColors.iconRed,
                  ),
                ),
                commonDivider(),
              ],
            )
          : Column(
              children: [       
                Text(
                  "Driver consent given",
                  style: AppTextStyle.textBlackColor16w400.copyWith(
                    color: AppColors.iconRed,
                  ),
                ),
                commonDivider(),
              ],
            ),
           
           
            Row(
              children: [
                detailWidget(
                   text: widget.driverLoadDetails.truckType?.type ?? "__",
                  iconSvg: AppIcons.svg.deliveryTruckSpeed,
                ),
                detailWidget(
                   text: widget.driverLoadDetails.truckType?.subType ?? "__",
                  iconSvg: AppIcons.svg.deliveryTruckSpeed,
                ),
              ],
            ),
            10.height,
            Row(
              children: [
                detailWidget(
                  text: widget.driverLoadDetails.commodity?.name ?? "__",
                  iconSvg: AppIcons.svg.package,
                ),
                detailWidget(
                  text: "${widget.driverLoadDetails.weightage?.value} Tonn",
                  iconSvg: AppIcons.svg.weight,
                ),
              ],
            ),
            15.height,
           
            10.height,
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    commonSupportDialog(context);
                  },
                  icon: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.primaryColor,
                        width: 1.5,
                      ),
                    ),
                    child: SvgPicture.asset(
                      AppIcons.svg.support,
                      width: 25,
                      colorFilter: AppColors.svg(AppColors.primaryColor),
                    ),
                  ),
                ),
                10.width,
                DriverLoadHelper.loadStatusButtonWidget(
                     enable: _isButtonEnabled,
                      statusId: widget.driverLoadDetails.loadStatusId,
                      onPressed: () {
                        //Check for sim consent and trip doc
                        if (widget.driverLoadDetails.loadStatusId == 5) {
                          final isConsentGiven = widget.driverLoadDetails.driverConsent == 1;
                         final nestedDocuments = widget.driverLoadDetails.loadDocument ?? [];
                        final documents = nestedDocuments.expand((list) => list).toList();
                        const requiredDocs = [
                          'lorry receipt',
                          'eway bill',
                          'material invoice',
                        ];
                        final uploadedTypes = documents
                            .where((doc) => doc.status == 1)
                            .map((doc) => doc.documentDetails?.documentType?.toLowerCase() ?? '')
                            .toSet();

                        final allRequiredDocsUploaded = requiredDocs.every(uploadedTypes.contains);

                          if (!allRequiredDocsUploaded) {
                            setState(() {
                                _isButtonEnabled = false;
                              });
                            ToastMessages.error(message: 'Please upload Lorry Receipt, E-Way Bill, and Material Invoice');
                            return;
                          }
                          if (!isConsentGiven) {
                            setState(() {
                                _isButtonEnabled = false;
                              });
                             ToastMessages.error(message: 'Please ensure SIM consent is given');
                            return;
                          }
                        }
                        
                        // Check for Pod Doc
                            if (widget.driverLoadDetails?.loadStatusId == 6) {
                            final nestedDocuments = widget.driverLoadDetails?.loadDocument ?? [];
                            final documents = nestedDocuments.expand((list) => list).toList();

                            final podDocExists = documents.any((doc) =>
                                (doc.documentDetails?.documentType?.toLowerCase() == 'proof of document' ||
                                doc.documentDetails?.title?.toLowerCase().contains('pod') == true) &&
                                doc.status == 1);

                            if (!podDocExists) {
                              setState(() {
                                _isButtonEnabled = true;
                              });
                              ToastMessages.error(message:  'Please upload POD document');
                              return;
                            }
                          }
                          setState(() {
                                _isButtonEnabled = true;
                              });
                        widget.onClickAssignDriver?.call();
                      },
                    ).expand(),

         ],
            ),
          ],
        ),
      ),
    );
  }

    Widget _buildLocationInfoWidget(String? location){
    String locationText=location?.split(",").first??"";
    return Text(
      locationText,
      style: AppTextStyle.blackColor15w500,
      maxLines: 1,
    );
  }

  Widget detailWidget({required String text, required String iconSvg}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SvgPicture.asset(
          iconSvg,
          width: 18,
          colorFilter: AppColors.svg(AppColors.black),
        ),
        10.width,
        Text(text, style: AppTextStyle.body),
      ],
    ).expand();
  }
}


Widget progressBarWidget({required double progressValue}) {
  final percent = (progressValue * 100).round();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Progress',
            style: AppTextStyle.body3.copyWith(
              fontSize: 12,
              color: AppColors.textBlackColor,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            '$percent%',
            style: AppTextStyle.body3.copyWith(
              color: AppColors.textBlackColor,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
      const SizedBox(height: 8),
      ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: LinearProgressIndicator(
          value: progressValue,
          minHeight: 6,
          backgroundColor: Colors.grey[300],
          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
        ),
      ),
    ],
  );
}



