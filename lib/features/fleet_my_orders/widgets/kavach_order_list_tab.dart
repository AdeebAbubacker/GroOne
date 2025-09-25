import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/features/kavach/model/kavach_order_list_model.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import '../../kavach/bloc/kavach_order_list_bloc/kavach_order_list_bloc.dart';
import '../../kavach/bloc/kavach_order_list_bloc/kavach_order_list_event.dart';
import '../../kavach/bloc/kavach_order_list_bloc/kavach_order_list_state.dart';
import '../../kavach/view/widgets/kavach_order_card_widget.dart';

class KavachOrderListTabWidget extends StatefulWidget {
  const KavachOrderListTabWidget({super.key});

  @override
  State<KavachOrderListTabWidget> createState() =>
      _KavachOrderListTabWidgetState();
}

class _KavachOrderListTabWidgetState extends State<KavachOrderListTabWidget> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = "";
  final List<KavachOrderListOrderItem> allOrders = [];
  final ScrollController scrollController = ScrollController();
  final PageStorageBucket _bucket = PageStorageBucket();
  int page = 1;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _searchText = _searchController.text.trim().toLowerCase());
    });
    scrollController.addListener(_onScroll);
    // Initial fetch
    context.read<KavachOrderListBloc>().add(
      FetchKavachOrderList(isRefresh: true),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Subscribe to RouteObserver

    if (ModalRoute.of(context)?.isCurrent == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          scrollController.jumpTo(0);
        }
      });
    }
  }

  void _onScroll() {
    final currentState = context.read<KavachOrderListBloc>().state;
    if (!scrollController.hasClients ||
        (currentState is KavachOrderListLoaded &&
            page == currentState.totalPage!)) {
      return;
    }

    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      context.read<KavachOrderListBloc>().add(ResetKavachOrderList());
      page += 1;
      context.read<KavachOrderListBloc>().add(FetchKavachOrderList(page: page));
    }
    // });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void didPopNext() {
    // Reset scroll when coming back to this screen
    _resetScroll();
  }

  void _resetScroll() {
    if (scrollController.hasClients) {
      scrollController.jumpTo(0);
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          scrollController.jumpTo(0);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSearchBar(context),
        Expanded(
          child: BlocConsumer<KavachOrderListBloc, KavachOrderListState>(
            listener: (context, state) {
              if (state is KavachOrderListLoaded) {
                // Append only new items to avoid duplicates
                final newItems = state.orders.where(
                  (o) =>
                      !allOrders.any(
                        (existing) => existing.orderUniqueId == o.orderUniqueId,
                      ),
                );
                debugPrint('dfdfsdgorders${state.orders.length}');
                debugPrint('dfdfsdg${allOrders.length}');
                debugPrint('dfdfsdgnewItems${newItems.length}');
                // if (newItems.isNotEmpty) {
                setState(() {
                  allOrders.addAll(newItems);
                });
                // }
              }
            },
            builder: (context, state) {
              // Calculate filtered list based on search text
              final filtered =
                  allOrders
                      .where(
                        (o) =>
                            o.orderUniqueId.toLowerCase().contains(_searchText),
                      )
                      .toList();

              // Show loader if first page is loading and list is empty
              if (state is KavachOrderListLoading && allOrders.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              // Show error if first page failed
              if (state is KavachOrderListError && allOrders.isEmpty) {
                return Center(child: Text(state.message));
              }

              if (filtered.isEmpty) {
                return Center(child: Text(context.appText.noOrdersFound));
              }

              return PageStorage(
                bucket: _bucket,
                child: ListView.builder(
                  key: const PageStorageKey('kavachListView'),
                  controller: scrollController,
                  itemCount:
                      (state is KavachOrderListLoaded && !state.hasReachedMax)
                          ? filtered.length + 1
                          : filtered.length,
                  itemBuilder: (context, index) {
                    if (index >= filtered.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    return KavachOrderCardWidget(order: filtered[index]);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: context.appText.search,
          prefixIcon: const Icon(Icons.search),
          suffixIcon:
              _searchText.isNotEmpty
                  ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () => _searchController.clear(),
                  )
                  : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
