import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/load_provider/lp_home/api_request/create_load_api_request.dart';
import 'package:gro_one_app/features/load_provider/lp_home/bloc/load_posting/load_posting_bloc.dart';
import 'package:gro_one_app/features/load_provider/lp_home/view/widgets/load_summary_widget.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_dialog.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
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
  final String senderAddress;
  final String receiverAddress;
  final String vehicleType;
  final String vehicleLength;
  final String approxWeight;
  final String category;
  final String price;
  const LoadSummaryScreen({super.key, required this.senderAddress, required this.receiverAddress, required this.vehicleType, required this.vehicleLength, required this.approxWeight, required this.category, required this.price, required this.apiRequest});

  @override
  State<LoadSummaryScreen> createState() => _LoadSummaryScreenState();
}

class _LoadSummaryScreenState extends State<LoadSummaryScreen> {

  final loadPostingBloc = locator<LoadPostingBloc>();

  final noteTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.white,
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

  // Body
  Widget buildBodyWidget(BuildContext context) {
    return  SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(commonSafeAreaPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 10,
          children: [

            detailWidget(context),

            // Notes
            AppTextField(
              controller: noteTextController,
              hintText: "Write Notes...",
              labelText: "Notes",
              maxLines: 3,
            ),

            // Need Support Next
            TextButton(
                onPressed: (){},
                child: Text("Need Our Customer Support Help?",style: AppTextStyle.bodyPrimaryColor),
            ),

            10.height,
          ],
        ),
      ),
    );
  }

  // Detail Widget
  Widget detailWidget(BuildContext context) {
    return Column(
      spacing: 15,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LoadSummaryWidget(
          title: "Address Details",
          heading1: "Sender Address",
          heading2: "Receiver Address",
          subheading1: widget.senderAddress,
          subheading2: widget.receiverAddress,
        ),

        LoadSummaryWidget(
          title: "Vehicle Details",
          heading1: "Vehicle Type",
          heading2: "Vehicle Length",
          subheading1: widget.vehicleType,
          subheading2: widget.vehicleLength,
        ),

        LoadSummaryWidget(
          title: "Package Details",
          heading1: "Approx. Weight",
          heading2: "Category",
          subheading1: "${widget.approxWeight} Tons",
          subheading2: widget.category,
        ),

        LoadSummaryWidget(
          title: "Price Details",
          heading1: "Suggestion Price",
          heading2: "",
          showHeading2: false,
          subheading1: widget.price,
          subheading2: "",
        ),

      ],
    );
  }

  // Button
  Widget buildButtonWidget(BuildContext context){
    return  BlocConsumer<LoadPostingBloc, LoadPostingState>(
      bloc: loadPostingBloc,
      listener: (context, state) {
        if (state is CreateLoadError) {
          addPostFrameCallback(() {
            ToastMessages.error(message: getErrorMsg(errorType: state.errorType));
          });
        }
        if (state is CreateLoadSuccess){
          //disposeFunction();
          AppDialog.show(context, child: SuccessDialogView());
        }
      },
      builder: (context, state) {
        final isLoading = state is CreateLoadLoading;
        return AppButton(
          title: "Confirm",
          isLoading: isLoading,
          onPressed: isLoading ? (){} : () async {
            final CreateLoadApiRequest req = widget.apiRequest.copyWith(note: noteTextController.text);
            await loadPostingBloc.loadPostingApiCall(CreateLoadPostingEvent(apiRequest: req));
            await Future.delayed(const Duration(seconds: 2));
            if(!context.mounted) return;
            Navigator.of(context).pop(true);
            // http://gro-devapi.letsgro.co/load/api/v1/commodity
          },
        );
      },
    ).bottomNavigationPadding();
  }
}
