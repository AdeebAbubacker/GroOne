import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/profile/cubit/masters/masters_cubit.dart';
import 'package:gro_one_app/features/profile/cubit/profile/profile_cubit.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/cubit/vp_create_account_cubit.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/view/prefer_lanse_screen.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_dialog.dart';
import 'package:gro_one_app/utils/app_route.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_dialog_view/success_dialog_view.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/toast_messages.dart';

import '../../../data/ui_state/status.dart';

class PreferLanesTab extends StatefulWidget {
  const PreferLanesTab({super.key});

  @override
  State<PreferLanesTab> createState() => _PreferLanesTabState();
}

class _PreferLanesTabState extends State<PreferLanesTab> {
  final vpCreationCubit = locator<VpCreateAccountCubit>();
  final masterCubit = locator<MastersCubit>();
  final profileCubit = locator<ProfileCubit>();
  List<int> selectedPrefLanesTypeList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        15.height,
        Expanded(child: SingleChildScrollView(child: _buildPreferLensWidget())),
        _buildUpdateButtonWidget(),
        20.height,
      ],
    ).paddingSymmetric(horizontal: 20);
  }

  Widget _buildPreferLensWidget() {
    return BlocConsumer<VpCreateAccountCubit, VpCreateAccountState>(
      bloc: vpCreationCubit,
      listenWhen:
          (previous, current) =>
              previous.prefLaneUIState?.status !=
              current.prefLaneUIState?.status,
      listener: (context, state) {
        final status = state.prefLaneUIState?.status;
        if (status == Status.ERROR) {
          final error = state.prefLaneUIState?.errorType;
          ToastMessages.error(
            message: getErrorMsg(errorType: error ?? GenericError()),
          );
        }
      },
      builder: (context, state) {
        Status? status=state.prefLaneUIState?.status;

        if(status==Status.LOADING){
          return Center(child: CircularProgressIndicator.adaptive());
        }
        if (state.prefLaneUIState?.data?.data != null &&
            state.prefLaneUIState!.data!.data!.items.isNotEmpty) {
          final preferredLaneItems =
              state.selectedPreferLanes;
          if ((preferredLaneItems ?? []).isNotEmpty) {
            selectedPrefLanesTypeList =
                preferredLaneItems?.map((e) => e.masterLaneId??0).toList() ?? [];
          } else {
            selectedPrefLanesTypeList = [];
          }


          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.appText.preferredLanesText,
                style: AppTextStyle.textFiled,
              ),
              8.height,
              GestureDetector(
                onTap: () async {
                  await Navigator.push(
                    context,
                    commonRoute(PreferLensScreen()),
                  );
                },
                child: Container(
                  padding: EdgeInsets.only(
                    left: 15,
                    top: 10,
                    right: 10,
                    bottom: 10,
                  ),
                  constraints: BoxConstraints(minHeight: 50),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.borderColor, width: 1),
                    color: AppColors.textFieldFillColor,
                    borderRadius: BorderRadius.circular(commonTexFieldRadius),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      context.appText.selectLaneType,
                      style: AppTextStyle.textFieldHint,
                    ),
                  ),
                ),
              ),
              10.height,
              if ((preferredLaneItems ?? []).isNotEmpty) ...[
                Wrap(
                  children: List.generate(
                    preferredLaneItems?.length ?? 0,
                    (index) => Chip(
                      label: Text(
                        '${preferredLaneItems?[index].fromLocation?.name ?? ""} - ${preferredLaneItems?[index].toLocation?.name ?? ""}',
                      ),
                      backgroundColor: AppColors.primaryColor,
                      labelStyle: AppTextStyle.body3WhiteColor,
                      deleteIcon: Icon(
                        Icons.clear,
                        color: Colors.white,
                        size: 18,
                      ),
                      onDeleted: () {
                        vpCreationCubit.selectLanes(
                          selected: false,
                          id: preferredLaneItems?[index].masterLaneId,
                        );
                      },
                      deleteIconColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            ],
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildUpdateButtonWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: BlocConsumer<MastersCubit, MastersState>(
        listener: (context, state) {
          Status? status = state.editUserUIState?.status;
          if (status == Status.SUCCESS) {
            showSuccessDialog(context);
          }
          if(status==Status.ERROR){
            ToastMessages.error(message: getErrorMsg(errorType: state.editUserUIState?.errorType??GenericError()));
          }
        },
        builder: (context, state) {
          Status? status = state.editUserUIState?.status;

          return AppButton(
            isLoading: status == Status.LOADING,
            title:context.appText.updateLanes,
            onPressed: () {
              masterCubit.updatePreferLanes(
                  companyName: profileCubit.state.profileDetailUIState?.data?.customer?.companyName??"",
                  companyTypeId:profileCubit.state.profileDetailUIState?.data?.customer?.companyTypeId??0,
                  customerName: profileCubit.state.profileDetailUIState?.data?.customer?.customerName??"",
                  selectedPrefLanesTypeList);
            },
          );
        },
      ),
    );
  }

  // Success Damages Create Dialog
  void showSuccessDialog(BuildContext context) => frameCallback(() {
    AppDialog.show(
      context,
      child: SuccessDialogView(
        heading: context.appText.lanesRecordedSuccessfully,
        message: context.appText.notifiedTheConcernTeam,
        onContinue: () {
          Navigator.of(context).pop(true);
        },
      ),
    );
  });
}
