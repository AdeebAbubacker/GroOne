import 'package:gro_one_app/features/kavach/model/choose_preference_model.dart';

abstract class KavachProductsListEvent {}

class FetchKavachProducts extends KavachProductsListEvent {
  final String search;
  final int page;
  final bool isLoadMore;
  final ChoosePreferenceModel? preferences;

  FetchKavachProducts({ this.search = "",this.page = 1, this.isLoadMore = false, this.preferences,});
}

class FetchMastersData extends KavachProductsListEvent {}

class UpdateUserPreferences extends KavachProductsListEvent {
  final ChoosePreferenceModel preferences;
  
  UpdateUserPreferences(this.preferences);
}

/// Event to increment product quantity
class IncrementQuantity extends KavachProductsListEvent {
  final String productId;
  IncrementQuantity(this.productId);
}

/// Event to decrement product quantity
class DecrementQuantity extends KavachProductsListEvent {
  final String productId;
  DecrementQuantity(this.productId);
}

/// Event to try incrementing quantity with stock validation
class TryIncrementQuantity extends KavachProductsListEvent {
  final String productId;
  TryIncrementQuantity({required this.productId});
}

/// Event to update Kavach quantities with new values
class UpdateKavachQuantities extends KavachProductsListEvent {
  final Map<String, int> updatedQuantities;
  UpdateKavachQuantities(this.updatedQuantities);
}

/// Event to clear all Kavach quantities
class ClearKavachQuantities extends KavachProductsListEvent {}
