import 'dart:async';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _searchText = _searchController.text.trim().toLowerCase());
    });

    // Initial fetch
    // context.read<KavachOrderListBloc>().add(
    //   FetchKavachOrderList(isRefresh: true),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSearchBar(context),
        Expanded(child: _OrdersListViewWithSearch(searchText: _searchText)),
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

class _OrdersListViewWithSearch extends StatefulWidget {
  final String searchText;

  const _OrdersListViewWithSearch({required this.searchText});

  @override
  State<_OrdersListViewWithSearch> createState() =>
      _OrdersListViewWithSearchState();
}

class _OrdersListViewWithSearchState extends State<_OrdersListViewWithSearch> {
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;
  List<KavachOrderListOrderItem> filtered = [];

  @override
  void initState() {
    super.initState();
    filtered.clear();
    context.read<KavachOrderListBloc>().add(
      FetchKavachOrderList(forceRefresh: true),
    );
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (_debounce?.isActive ?? false) return;
    _debounce = Timer(const Duration(milliseconds: 200), () {
      final currentState = context.read<KavachOrderListBloc>().state;
      if (_isBottom &&
          !_isLoading &&
          currentState is KavachOrderListLoaded &&
          !currentState.hasReachedMax) {
        context.read<KavachOrderListBloc>().add(FetchKavachOrderList());
      }
    });
  }

  bool get _isLoading {
    final state = context.read<KavachOrderListBloc>().state;
    return state is KavachOrderListLoading;
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KavachOrderListBloc, KavachOrderListState>(
      builder: (context, state) {
        if (state is KavachOrderListLoading) {
          // Just show loader while fetching the first page
          return const Center(child: CircularProgressIndicator());
        } else if (state is KavachOrderListLoaded) {
          if (state.orders.isEmpty) {
            return Center(child: Text(context.appText.noOrdersFound));
          }

          // Apply search filter
          filtered.addAll(
            state.orders.where((o) {
              return o.orderUniqueId.toLowerCase().contains(widget.searchText);
            }).toList(),
          );

          return ListView.builder(
            controller: _scrollController,
            itemCount:
                state.hasReachedMax ? filtered.length : filtered.length + 1,
            itemBuilder: (context, index) {
              if (index >= filtered.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              return KavachOrderCardWidget(order: filtered[index]);
            },
          );
        } else if (state is KavachOrderListError) {
          return Center(child: Text(state.message));
        }
        return const SizedBox.shrink();
      },
    );
  }
}
