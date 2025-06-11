import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/load_provider/lp_home/api_request/create_load_api_request.dart';
import 'package:gro_one_app/features/load_provider/lp_home/bloc/load_posting/load_posting_bloc.dart';
import 'package:gro_one_app/features/load_provider/lp_home/view/widgets/load_summary_widget.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_dialog.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_dialog_view/common_dialog_view.dart';
import 'package:gro_one_app/utils/common_dialog_view/success_dialog_view.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/custom_log.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/extra_utils.dart';
import 'package:gro_one_app/utils/toast_messages.dart';

class LoadSummaryScreen extends StatefulWidget {
  final CreateLoadApiRequest apiRequest;
  final String pickupAddress;
  final String pickupLocation;
  final String destinationAddress;
  final String destinationLocation;
  final String vehicleType;
  final String vehicleLength;
  final String approxWeight;
  final String category;
  final String price;
  final String date;
  const LoadSummaryScreen({super.key, required this.pickupAddress, required this.destinationAddress, required this.vehicleType, required this.vehicleLength, required this.approxWeight, required this.category, required this.price, required this.apiRequest, required this.date, required this.pickupLocation, required this.destinationLocation});

  @override
  State<LoadSummaryScreen> createState() => _LoadSummaryScreenState();
}

class _LoadSummaryScreenState extends State<LoadSummaryScreen> {

  final loadPostingBloc = locator<LoadPostingBloc>();

  final noteTextController = TextEditingController();


  String calculateTenPercentOfAverage(String priceRange) {
    try {
      final parts = priceRange.replaceAll(' ', '').split('-');
      if (parts.length != 2) return "Invalid range";

      final min = int.tryParse(parts[0]) ?? 0;
      final max = int.tryParse(parts[1]) ?? 0;

      if (min == 0 || max == 0) return "Invalid range";

      final avg = ((min + max) / 2).round();
      final tenPercent = (avg * 0.10).round();

      return "Rs. $tenPercent";
    } catch (e) {
      return "Calculation error";
    }
  }




  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: buildAppBarWidget(context),
      body: buildBodyWidget(context),
      bottomNavigationBar: buildButtonWidget(context),
    );
  }

  // App bar
  PreferredSizeWidget buildAppBarWidget (BuildContext context) {
    return CommonAppBar(
      backgroundColor: AppColors.white,
      title: "Post Load Summary",
      actions: [

        TextButton.icon(
            onPressed: ()=> context.pop(),
            icon: Icon(Icons.edit_outlined, color: AppColors.primaryColor, size: 20),
            label: Text(context.appText.edit, style: AppTextStyle.h5PrimaryColor),
        ),

      ],
    );
  }

// inside buildBodyWidget:
  Widget buildBodyWidget(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(commonSafeAreaPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 20,
          children: [

            // Suggested Price Box
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 16.h),
              decoration: commonContainerDecoration(color: AppColors.lightBlueColor),
              child: Column(
                children: [
                  Text("Suggested Price", style: AppTextStyle.h3PrimaryColor),
                  5.height,
                  Text(
                    widget.price,
                    style: AppTextStyle.h4.copyWith(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Form-style details using TextFields
            buildReadOnlyField("Loading Point", "${widget.pickupAddress},  ${widget.pickupLocation}"),
            buildReadOnlyField("Unloading point", "${widget.destinationAddress},  ${widget.destinationLocation}"),
            buildReadOnlyField("Vehicle type", widget.vehicleType),
            buildReadOnlyField("Vehicle Length", widget.vehicleLength),
            buildReadOnlyField("Consignment weight", "${widget.approxWeight} MT"),
            buildReadOnlyField("Commodity", widget.category),
            buildReadOnlyField("Pickup date & time", widget.date),
            buildReadOnlyField("Expected Delivery Date & Time", widget.date, fillColor: Colors.white),
            buildReadOnlyField("Handling Charges", calculateTenPercentOfAverage(widget.price), fillColor: Colors.white),

            // Notes Field
            AppTextField(
              controller: noteTextController,
              labelText: "Notes/ Instructions",
              hintText: "Handle with care",
              maxLines: 2,
            ),

            10.height,
          ],
        ),
      ),
    );
  }

// Reusable read-only field UI (mimicking input style)
  Widget buildReadOnlyField(String label, String value,{Color? fillColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyle.textFiled),
        6.height,
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: commonContainerDecoration(color: fillColor ?? AppColors.greyIconBackgroundColor, borderRadius: BorderRadius.circular(commonTexFieldRadius), borderColor: AppColors.borderDisableColor),
          child: Text(value, style: AppTextStyle.textFiled),
        ),
      ],
    );
  }

// inside buildButtonWidget:
  Widget buildButtonWidget(BuildContext context) {
    return BlocConsumer<LoadPostingBloc, LoadPostingState>(
      bloc: loadPostingBloc,
      listener: (context, state) {
        if (state is CreateLoadError) {
          frameCallback(() {
            ToastMessages.error(message: getErrorMsg(errorType: state.errorType));
          });
        }
        if (state is CreateLoadSuccess) {
          AppDialog.show(context, child: SuccessDialogView());
        }
      },
      builder: (context, state) {
        final isLoading = state is CreateLoadLoading;
        return Row(
          children: [
            AppButton(
              onPressed: () {
                AppDialog.show(
                  context,
                  child: CommonDialogView(
                    heading: "Call Customer Support",
                    message: "contact our Customer support agent",
                    onSingleButtonText: "Call",
                    onTapSingleButton: (){
                      Navigator.of(context).pop();
                    },
                    child: SvgPicture.asset(AppImage.svg.customerSupport),
                  ),
                );
              },
              style: AppButtonStyle.outline,
              title: "Customer Support",
            ).expand(),
            15.width,

            AppButton(
              title: "Post Load",
              isLoading: isLoading,
              onPressed: isLoading ? () {} : () async {
                final req = widget.apiRequest.copyWith(note: noteTextController.text);
                await loadPostingBloc.loadPostingApiCall(CreateLoadPostingEvent(apiRequest: req));
                await Future.delayed(const Duration(seconds: 3));
                if (!context.mounted) return;
                Navigator.of(context).pop(true);
                Navigator.of(context).pop(true);
              },
            ).expand(),
          ],
        ).bottomNavigationPadding();
      },
    );
  }



  //
  // // Detail Widget
  // Widget detailWidget(BuildContext context) {
  //   return Column(
  //     spacing: 15,
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       LoadSummaryWidget(
  //         title: context.appText.addressDetails,
  //         heading1: context.appText.senderAddress,
  //         heading2: context.appText.unloadingPt,
  //         subheading1: widget.senderAddress,
  //         subheading2: widget.receiverAddress,
  //       ),
  //
  //       LoadSummaryWidget(
  //         title: context.appText.vehicleDetails,
  //         heading1: context.appText.vehicleType,
  //         heading2: context.appText.vehicleLength,
  //         subheading1: widget.vehicleType,
  //         subheading2: widget.vehicleLength,
  //       ),
  //
  //       LoadSummaryWidget(
  //         title: context.appText.packageDetails,
  //         heading1: context.appText.approxWeight,
  //         heading2: context.appText.category,
  //         subheading1: "${widget.approxWeight} ${context.appText.tons}",
  //         subheading2: widget.category,
  //       ),
  //
  //
  //       LoadSummaryWidget(
  //         title: context.appText.priceDetail,
  //         heading1: context.appText.suggestedPrice,
  //         heading2: context.appText.loadingDate,
  //         subheading1: widget.price,
  //         subheading2: widget.date,
  //       ),
  //
  //     ],
  //   );
  // }
  //
  // // Button
  // Widget buildButtonWidget(BuildContext context){
  //   return  BlocConsumer<LoadPostingBloc, LoadPostingState>(
  //     bloc: loadPostingBloc,
  //     listener: (context, state) {
  //       if (state is CreateLoadError) {
  //         frameCallback(() {
  //           ToastMessages.error(message: getErrorMsg(errorType: state.errorType));
  //         });
  //       }
  //       if (state is CreateLoadSuccess){
  //         //disposeFunction();
  //         AppDialog.show(context, child: SuccessDialogView());
  //       }
  //     },
  //     builder: (context, state) {
  //       final isLoading = state is CreateLoadLoading;
  //       return AppButton(
  //         title: context.appText.confirm,
  //         isLoading: isLoading,
  //         onPressed: isLoading ? (){} : () async {
  //           final CreateLoadApiRequest req = widget.apiRequest.copyWith(note: noteTextController.text);
  //           await loadPostingBloc.loadPostingApiCall(CreateLoadPostingEvent(apiRequest: req));
  //           await Future.delayed(const Duration(seconds: 2));
  //           if(!context.mounted) return;
  //           Navigator.of(context).pop(true);
  //           // http://gro-devapi.letsgro.co/load/api/v1/commodity
  //         },
  //       );
  //     },
  //   ).bottomNavigationPadding();
  // }
}
