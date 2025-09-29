import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/chat_action_button.dart';
import '../../../data/ui_state/status.dart';
import '../../../dependency_injection/locator.dart';
import '../../../utils/app_image.dart';
import '../../en-dhan_fuel/cubit/en_dhan_cubit.dart';
import '../../en-dhan_fuel/widgets/endhan_card_item.dart';

class EndhanOrderListTabWidget extends StatefulWidget {
  const EndhanOrderListTabWidget({super.key});

  @override
  State<EndhanOrderListTabWidget> createState() =>
      _EndhanOrderListTabWidgetState();
}

class _EndhanOrderListTabWidgetState extends State<EndhanOrderListTabWidget> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = "";

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _searchText = _searchController.text.trim().toLowerCase());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider.value(
        value: locator<EnDhanCubit>()..fetchCards(),
        child: Column(
          children: [
            // _buildSearchBar(context),
            Expanded(
              child: BlocBuilder<EnDhanCubit, EnDhanState>(
                builder: (context, state) {
                  if (state.cardsState?.status == Status.LOADING) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.cardsState?.status == Status.ERROR) {
                    return Center(
                      child: Text(context.appText.failedToLoadData),
                    );
                  }
                  final cards = state.cardsState?.data?.data?.document ?? [];
                  if (cards.isEmpty) {
                    return Center(child: Text(context.appText.noOrdersFound));
                  }

                  final filtered =
                      cards.where((c) {
                        return (c.cardNumber ?? '').toLowerCase().contains(
                              _searchText,
                            ) ||
                            (c.vehicleNumber ?? '').toLowerCase().contains(
                              _searchText,
                            );
                      }).toList();

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final card = filtered[index];
                      return EndhanCardItem(
                        card: {
                          'cardNumber': card.cardNumber,
                          'vehicleNumber': card.vehicleNumber,
                          'mobile': card.cardMobileNo,
                          'image': AppImage.png.endhanCard,
                          'dateTime': card.createdAt,
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: ChatActionButton(),
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
