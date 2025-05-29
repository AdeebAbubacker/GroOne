import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gro_one_app/features/kavach/view/kavach_checkout_screen.dart';
import 'package:gro_one_app/features/kavach/view/kavach_models_filter_bottom_sheet_Screen.dart';
import 'package:gro_one_app/features/kavach/view/widgets/kavach_models_list_body.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_icon_button.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_route.dart';
import 'package:gro_one_app/utils/app_search_bar.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import '../bloc/kavach_list_bloc/kavach_list_bloc.dart';
import '../bloc/kavach_list_bloc/kavach_list_event.dart';
import '../bloc/kavach_list_bloc/kavach_list_state.dart';
import '../repository/kavach_repository.dart';
import 'package:http/http.dart' as http;

// class KavachModelsScreen extends StatefulWidget {
//   const KavachModelsScreen({super.key});
//
//   @override
//   State<KavachModelsScreen> createState() => _KavachModelsScreenState();
// }
//
// class _KavachModelsScreenState extends State<KavachModelsScreen> {
//
//   final searchController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) => KavachBloc(KavachRepository(client: http.Client()))..add(FetchKavachProducts()),
//       child: Scaffold(
//         appBar: CommonAppBar(title: context.appText.kavachModels),
//         body: SingleChildScrollView(
//           child: Column(
//             children: [
//               buildSearchBarAndFilterWidget(context),
//               buildBodyWidget(context),
//             ],
//           ),
//         ),
//         bottomNavigationBar: buildBuyButtonWidget(),
//       ),
//     );
//   }
//
//
//
//   Widget buildBodyWidget(BuildContext context){
//     return BlocBuilder<KavachBloc, KavachState>(
//       builder: (context, state) {
//         if (state.loading) return Center(child: CircularProgressIndicator());
//         if (state.error != null) return Center(child: Text("Error: ${state.error}"));
//
//         return ListView.separated(
//           itemCount: state.products.length,
//           shrinkWrap: true,
//           physics: NeverScrollableScrollPhysics(),
//           separatorBuilder: (_, __) => 20.height,
//           itemBuilder: (context, index) {
//             final product = state.products[index];
//             final qty = state.quantities[product.id] ?? 0;
//             return KavachModelsListBody(product: product, quantity: qty);
//           },
//         );
//       },
//     );
//   }
//
//   Widget buildBuyButtonWidget(){
//     return AppButton(
//         title: context.appText.buyNow,
//         onPressed: (){
//          Navigator.of(context).push(commonRoute(KavachCheckoutScreen()));
//         },
//     ).bottomNavigationPadding();
//   }
//
//   Widget buildSearchBarAndFilterWidget(BuildContext context){
//     final bloc = context.read<KavachBloc>();
//     return Row(
//       children: [
//         AppSearchBar(
//           searchController: searchController,
//           onChanged: (text) {
//             debounce(() {
//               bloc.add(FetchKavachProducts(search: text));
//             });
//           },
//         ).expand(),
//
//         15.width,
//
//         AppIconButton(
//           onPressed: () {
//             commonBottomSheetWithBGBlur(context: context, screen: KavachModelsFilterBottomSheetScreen());
//           },
//           style: AppButtonStyle.primaryIconButtonStyle,
//           icon: SvgPicture.asset(AppIcons.svg.filter, width: 20),
//         )
//       ],
//     );
//   }
//
//
// }
class KavachModelsScreen extends StatelessWidget {
  const KavachModelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => KavachBloc(KavachRepository(client: http.Client()))..add(FetchKavachProducts()),
      child: const KavachModelsScreenContent(),
    );
  }
}

class KavachModelsScreenContent extends StatefulWidget {
  const KavachModelsScreenContent({super.key});

  @override
  State<KavachModelsScreenContent> createState() => _KavachModelsScreenContentState();
}

class _KavachModelsScreenContentState extends State<KavachModelsScreenContent> {
  final searchController = TextEditingController();
  Timer? _debounce;

  void debounce(VoidCallback action, [Duration duration = const Duration(milliseconds: 400)]) {
    _debounce?.cancel();
    _debounce = Timer(duration, action);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: context.appText.kavachModels),
      body: SafeArea(
        child: Column(
          children: [
            buildSearchBarAndFilterWidget(context),
            15.height,
            Expanded(child: buildBodyWidget(context)),
            20.height
          ],
        ).paddingAll(12),
      ),
      bottomNavigationBar: buildBuyButtonWidget(),
    );
  }

  Widget buildSearchBarAndFilterWidget(BuildContext context) {
    return Row(
      children: [
        AppSearchBar(
          searchController: searchController,
          onChanged: (text) {
            debounce(() {
              context.read<KavachBloc>().add(FetchKavachProducts(search: text));
            });
          },
        ).expand(),
        15.width,
        AppIconButton(
          onPressed: () {
            commonBottomSheetWithBGBlur(context: context, screen: KavachModelsFilterBottomSheetScreen());
          },
          style: AppButtonStyle.primaryIconButtonStyle,
          icon: SvgPicture.asset(AppIcons.svg.filter, width: 20),
        )
      ],
    );
  }

  Widget buildBodyWidget(BuildContext context) {
    return BlocBuilder<KavachBloc, KavachState>(
      builder: (context, state) {
        if (state.loading) return const Center(child: CircularProgressIndicator());
        if (state.error != null) return Center(child: Text("Error: ${state.error}"));
        return ListView.separated(
          itemCount: state.products.length,
          shrinkWrap: true,
          // physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (_, __) => 20.height,
          itemBuilder: (context, index) {
            final product = state.products[index];
            final qty = state.quantities[product.id] ?? 0;
            return KavachModelsListBody(
              product: product,
              quantity: qty,
            );
          },
        );
      },
    );
  }

  Widget buildBuyButtonWidget() {
    return AppButton(
      title: context.appText.buyNow,
      onPressed: () {
        Navigator.of(context).push(commonRoute(KavachCheckoutScreen()));
      },
    ).bottomNavigationPadding();
  }
}
