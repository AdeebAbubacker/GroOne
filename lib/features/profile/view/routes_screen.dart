import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/load_provider/lp_home/cubit/lp_home_cubit.dart';
import 'package:gro_one_app/features/load_provider/lp_home/cubit/lp_home_state.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/recent_routes_model.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

import '../../../data/ui_state/status.dart';

class RouteScreen extends StatefulWidget {
  const RouteScreen({super.key});

  @override
  State<RouteScreen> createState() => _RouteScreenState();
}

class _RouteScreenState extends State<RouteScreen> {

  final lpHomeCubit = locator<LPHomeCubit>();


  @override
  void initState() {
    super.initState();
    initFunction();
  }

  void initFunction() async {
    await lpHomeCubit.fetchRecentRoute();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: context.appText.routes),
      body: _buildRecentRouteList(),
    );
  }

  Widget _buildRecentRouteList() {
    return BlocConsumer<LPHomeCubit, LPHomeState>(
      listener: (_, __) {},
      builder: (context, state) {
        final uiState = state.recentRouteUIState;

        if (uiState == null) return genericErrorWidget(error: GenericError());

        switch (uiState.status) {
          case Status.LOADING:
            return CircularProgressIndicator().center();

          case Status.SUCCESS:
            final routes = uiState.data?.data ?? [];
            if (routes.isEmpty) {
              return genericErrorWidget(error: NotFoundError(message: context.appText.noRouteFound));
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                10.height,
                ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(bottom: 100),
                  itemCount: routes.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 20),
                  itemBuilder: (context, index) =>
                      _buildListBody(index: index, data: routes[index]),
                ).expand(),
              ],
            ).paddingSymmetric(horizontal: 15);

          case Status.ERROR:
            return genericErrorWidget(error: uiState.errorType ?? GenericError());

          default:
            return genericErrorWidget(error: GenericError());
        }
      },
    );
  }


  Widget _buildListBody({required int index, required RecentRouteData data}) {
    final pickUp = data.loadRoute?.pickUpWholeAddr ?? '';
    final drop = data.loadRoute?.dropWholeAddr ?? '';
    final routeTitle = "${data.loadRoute?.pickUpLocation.split(RegExp(r'[,\s]+')).first ?? ''} - ${data.loadRoute?.dropLocation.split(RegExp(r'[,\s]+')).first ?? ''}";

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primaryColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(routeTitle, style: AppTextStyle.h5),
              Icon(Icons.bookmark, color: AppColors.primaryColor),
            ],
          ).paddingSymmetric(horizontal: 10, vertical: 10),
          Container(
            padding: EdgeInsets.all(10),
            decoration: commonContainerDecoration(
              color: AppColors.white,
              borderColor: AppColors.borderColor,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Image.asset(AppImage.png.bookAShipment, width: 18, fit: BoxFit.fitHeight).paddingSymmetric(vertical: 5),
                10.width,

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // Source (Pick Up)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(context.appText.source, style: AppTextStyle.body3.copyWith(fontSize: 14, color: AppColors.textBlackColor)),
                        6.height,
                        Text(pickUp, style: AppTextStyle.body3.copyWith(fontSize: 12, color: AppColors.textBlackColor))
                      ],
                    ),

                    commonDivider(),

                    // Destination
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(context.appText.destination, style: AppTextStyle.body3.copyWith(fontSize: 14, color: AppColors.textBlackColor)),
                        6.height,
                        Text(drop, style: AppTextStyle.body3.copyWith(fontSize: 12, color: AppColors.textBlackColor))
                      ],
                    ),

                  ],
                ).expand()
              ],
            ),
          ).paddingSymmetric(horizontal: 10),

          10.height,
        ],
      ),
    );
  }

}
