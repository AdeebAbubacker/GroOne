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
import '../../../dependency_injection/locator.dart';
import '../bloc/kavach_list_bloc/kavach_products_list_bloc.dart';
import '../bloc/kavach_list_bloc/kavach_products_list_event.dart';
import '../bloc/kavach_list_bloc/kavach_products_list_state.dart';
import '../repository/kavach_repository.dart';

class KavachModelsScreen extends StatelessWidget {
  const KavachModelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => KavachProductsListBloc(locator<KavachRepository>())..add(FetchKavachProducts()),
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
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        final bloc = context.read<KavachProductsListBloc>();
        if (!bloc.state.loading && bloc.state.hasMore) {
          bloc.add(FetchKavachProducts(
            search: searchController.text,
            page: bloc.state.currentPage + 1,
            isLoadMore: true,
          ));
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

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
        ).paddingAll(commonSafeAreaPadding),
      ),
      bottomNavigationBar: BlocBuilder<KavachProductsListBloc, KavachProductsListState>(
        builder: (context, state) {
          final totalQuantity = state.quantities.values.fold<int>(0, (sum, qty) => sum + qty);
          if (totalQuantity == 0) return const SizedBox.shrink();
          return buildBuyButtonWidget(totalQuantity);
        },
      ),

    );
  }

  Widget buildSearchBarAndFilterWidget(BuildContext context) {
    return Row(
      children: [
        AppSearchBar(
          searchController: searchController,
          onChanged: (text) {
            debounce(() {
              context.read<KavachProductsListBloc>().add(FetchKavachProducts(search: text));
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
    return BlocBuilder<KavachProductsListBloc, KavachProductsListState>(
      builder: (context, state) {
        return ListView.separated(
          controller: _scrollController,
          itemCount: state.products.length + (state.loading ? 1 : 0),
          separatorBuilder: (_, __) => 20.height,
          itemBuilder: (context, index) {
            if (index == state.products.length) {
              return const Center(child: Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ));
            }
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
  Widget buildBuyButtonWidget(int totalQuantity) {
    return BlocBuilder<KavachProductsListBloc, KavachProductsListState>(
      builder: (context, state) {
        return AppButton(
          title: '$totalQuantity ${context.appText.items} ${context.appText.checkout}',
          onPressed: () async {
            final bloc = context.read<KavachProductsListBloc>();
            final result = await Navigator.of(context).push(
              commonRoute(
                  KavachCheckoutScreen(
                    products: bloc.state.products
                        .where((p) => (bloc.state.quantities[p.id] ?? 0) > 0)
                        .toList(),
                    quantities: Map.from(bloc.state.quantities),
                  )
              ));
            if (result != null) {
              bloc.add(UpdateKavachQuantities(result));
            }
          },
        ).bottomNavigationPadding();
      },
    );
  }
}