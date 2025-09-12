import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/features/driver/driver_home/bloc/driver_loads/driver_loads_bloc.dart';
import 'package:gro_one_app/features/driver/driver_home/helper/driver_load_helper.dart';
import 'package:gro_one_app/features/driver/driver_home/model/driver_load_response.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/routing/app_route_name.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/toast_messages.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_icons.dart';
import '../../../../../utils/app_image.dart';
import '../../../../../utils/app_text_style.dart';
import '../../../../../utils/common_functions.dart';
import '../../../../../utils/common_widgets.dart';


class DriverLoadWidget extends StatefulWidget {
  final void Function()? onClickAssignDriver;
  final DriverLoadDetails driverLoadDetails;
  const DriverLoadWidget({
    super.key,
    required this.onClickAssignDriver,
    required this.driverLoadDetails,
  });

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

  void _validateButtonStateOnInit() {
    final statusId = widget.driverLoadDetails.loadStatusId;

    final nestedDocuments = widget.driverLoadDetails.loadDocument;
    // final documents = nestedDocuments.expand((list) => list).toList();

    final currentStatus = widget.driverLoadDetails.loadStatusId;


    // Status 4: Check if Lp Agreed
    if (currentStatus == 4) {
      final isLpAgreed = widget.driverLoadDetails.isAgreed == 1;
      setState(() {
        _isButtonEnabled = isLpAgreed;
      });
      return;
    }

    if (statusId == 5) {
      //final isSimConsentGiven = widget.driverLoadDetails.driverConsent == 1;

      // Required document types for status 5 (Loading)
      const requiredDocs = ['lorry receipt', 'eway bill', 'material invoice'];

      final uploadedTypes =
          nestedDocuments
              .where((doc) => doc.status == 1)
              .map(
                (doc) =>
                    (doc.documentDetails?.documentType ?? '')
                        .toLowerCase()
                        .trim(),
              )
              .where((type) => type.isNotEmpty)
              .toSet();

      final allRequiredDocsUploaded = requiredDocs.every(
        uploadedTypes.contains,
      );

      setState(() {
        _isButtonEnabled = allRequiredDocsUploaded;
      });
      return;
    }

    // Required document types for status 6 (In Transist)
    if (statusId == 7) {
      const podDocType = 'proof of document';

      final podDocExists = nestedDocuments.any((doc) {
        final docType =
            (doc.documentDetails?.documentType ?? '').toLowerCase().trim();
        final title = (doc.documentDetails?.title ?? '').toLowerCase().trim();
        return (docType == podDocType || title.contains('pod')) &&
            doc.status == 1;
      });

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
        context.push(
          AppRouteName.driverLoadDetails,
          extra: {"loadId": widget.driverLoadDetails.loadId},
        ).then((value) {
          if (mounted) {
            context.read<DriverLoadsBloc>().add(
              FetchDriverLoads(forceRefresh: true),
            );
          }
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                    Text(
                      widget.driverLoadDetails.loadSeriesId,
                      style: AppTextStyle.h5,
                    ),
                    Text(
                      formatDateTimeKavach(
                        widget.driverLoadDetails.createdAt?.toString() ??
                            DateTime.now().toString(),
                      ),
                      style: AppTextStyle.primaryColor12w400,
                    ),
                  ],
                ).expand(),
                5.width,
                if (widget.driverLoadDetails.loadStatusId >= 4)
                  DriverLoadHelper.loadStatusWidget(
                    statusBgColor:
                        widget
                            .driverLoadDetails
                            .loadStatusDetails
                            ?.statusBgColor,
                    statusTxtColor:
                        widget
                            .driverLoadDetails
                            .loadStatusDetails
                            ?.statusTxtColor,
                    (widget.driverLoadDetails.loadOnhold)
                        ? context.appText.loadOnHold
                        : widget
                            .driverLoadDetails
                            .loadStatusDetails!
                            .loadStatus,
                    context,
                  ),
              ],
            ),
            10.height,
            Row(
            children: [
              Expanded(
                child: _buildLocationInfoWidget(
                  widget.driverLoadDetails.loadRoute?.pickUpWholeAddr ?? "",
                ),
              ),
              Spacer(flex: 1), 
              Icon(
                Icons.arrow_right_alt_outlined,
                color: AppColors.primaryColor,
              ),
              Spacer(flex: 1),
              Expanded(
                child: _buildLocationInfoWidget(
                widget.driverLoadDetails.loadRoute?.dropWholeAddr ?? "",
                ),
              ),
            ],
          ),
            commonDivider(),

            //  statusButtonWidget(statusBackgroundColor: AppColors.boxGreen, statusTextColor: AppColors.textGreen, statusText: "Advance Paid")

            //  progressBarWidget(progressValue: 0.5,),
            //  commonDivider(),
            if (widget.driverLoadDetails.loadStatusId > 4)
              widget.driverLoadDetails.driverConsent == 0
                  ? Column(
                    children: [
                      Text(
                        context.appText.noSimTrackingConsentFromDriver,
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
                          color: AppColors.textGreen,
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
                  text: "${widget.driverLoadDetails.weight?.value} ${context.appText.ton}",
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

                DriverLoadHelper.homeloadStatusButtonWidget(
                  context: context,
                  enable: _isButtonEnabled,
                  isLpagreed:  widget.driverLoadDetails.isAgreed == 1,
                  statusId: widget.driverLoadDetails.loadStatusId,
                  onPressed: () {
                    if ((widget.driverLoadDetails.loadStatusId == 4 && widget.driverLoadDetails.isAgreed == 0) || widget.driverLoadDetails.loadStatusId == 9  &&
                        widget.driverLoadDetails.loadMemoDetails == null) {
                      context.push(
                        AppRouteName.driverLoadDetails,
                        extra: {"loadId": widget.driverLoadDetails.loadId},
                      ).then((value) {
                        if (mounted) {
                          context.read<DriverLoadsBloc>().add(
                            FetchDriverLoads(forceRefresh: true),
                          );
                        }
                      });
                      return;
                    }
                    //Check for sim consent and trip doc
                    if (widget.driverLoadDetails.loadStatusId == 5) {
                      //final isConsentGiven = widget.driverLoadDetails.driverConsent == 1;
                      final nestedDocuments =
                          widget.driverLoadDetails.loadDocument;
                      //  final documents = nestedDocuments.expand((list) => list).toList();
                      const requiredDocs = [
                        'lorry receipt',
                        'eway bill',
                        'material invoice',
                      ];
                      final uploadedTypes =
                          nestedDocuments
                              .where((doc) => doc.status == 1)
                              .map(
                                (doc) =>
                                    doc.documentDetails?.documentType
                                        .toLowerCase() ??
                                    '',
                              )
                              .toSet();

                      final allRequiredDocsUploaded = requiredDocs.every(
                        uploadedTypes.contains,
                      );

                      if (!allRequiredDocsUploaded) {
                        setState(() {
                          _isButtonEnabled = false;
                        });
                        ToastMessages.error(
                          message:
                              context.appText.pleaseUploadDocs,
                        );
                        return;
                      }
                      // if (!isConsentGiven) {
                      //   setState(() {
                      //       _isButtonEnabled = false;
                      //     });
                      //    ToastMessages.error(message: 'Please ensure SIM consent is given');
                      //   return;
                      // }
                    }

                    // Check for Pod Doc
                    if (widget.driverLoadDetails.loadStatusId == 7) {
                      final nestedDocuments =
                          widget.driverLoadDetails.loadDocument;
                      //  final documents = nestedDocuments.expand((list) => list).toList();

                      final podDocExists = nestedDocuments.any(
                        (doc) =>
                            (doc.documentDetails?.documentType.toLowerCase() ==
                                    'proof of document' ||
                                doc.documentDetails?.title
                                        .toLowerCase()
                                        .contains('pod') ==
                                    true) &&
                            doc.status == 1,
                      );

                      if (!podDocExists) {
                        setState(() {
                          _isButtonEnabled = true;
                        });
                        ToastMessages.error(
                          message: context.appText.pleaseUploadPodDoc,
                        );
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

  Widget _buildLocationInfoWidget(String? location) {
    String locationText = location?.split(",").first ?? "";
    return Tooltip(
      message: locationText,
      child: Text(
        locationText,
        style: AppTextStyle.blackColor15w500,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget detailWidget({required String text, required String iconSvg}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
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
          backgroundColor: AppColors.lightGrey300,
          valueColor: const AlwaysStoppedAnimation<Color>(
            AppColors.primaryColor,
          ),
        ),
      ),
    ],
  );
}
