import 'package:equatable/equatable.dart';
import '../../../../data/model/result.dart';
import '../../model/kavach_product_model.dart';
import '../../model/masters_model.dart';
import '../../model/choose_preference_model.dart';
import 'package:collection/collection.dart';

class KavachProductsListState extends Equatable {
  final List<KavachProduct> products;
  final Map<String, int> quantities;
  final Map<String, int> availableStocks;
  final bool loading;
  final bool hasMore;
  final int currentPage;
  final ErrorType? error;
  
  // Masters data for preferences
  final MastersModel? mastersData;
  final bool mastersLoading;
  final ErrorType? mastersError;
  
  // User preferences
  final ChoosePreferenceModel userPreferences;

  const KavachProductsListState({
    required this.products,
    required this.quantities,
    required this.availableStocks,
    this.loading = false,
    this.hasMore = true,
    this.currentPage = 1,
    this.error,
    this.mastersData,
    this.mastersLoading = false,
    this.mastersError,
    this.userPreferences = const ChoosePreferenceModel(),
  });

  factory KavachProductsListState.initial() {
    return const KavachProductsListState(
      products: [],
      quantities: {},
      availableStocks: {},
      loading: false,
      hasMore: true,
      currentPage: 1,
      error: null,
      mastersData: null,
      mastersLoading: false,
      mastersError: null,
      userPreferences: ChoosePreferenceModel(),
    );
  }

  KavachProductsListState copyWith({
    List<KavachProduct>? products,
    Map<String, int>? quantities,
    Map<String, int>? availableStocks,
    bool? loading,
    bool? hasMore,
    int? currentPage,
    ErrorType? error,
    MastersModel? mastersData,
    bool? mastersLoading,
    ErrorType? mastersError,
    ChoosePreferenceModel? userPreferences,
  }) {
    return KavachProductsListState(
      products: products ?? this.products,
      quantities: quantities ?? this.quantities,
      availableStocks: availableStocks ?? this.availableStocks,
      loading: loading ?? this.loading,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      error: error,
      mastersData: mastersData ?? this.mastersData,
      mastersLoading: mastersLoading ?? this.mastersLoading,
      mastersError: mastersError,
      userPreferences: userPreferences ?? this.userPreferences,
    );
  }

  @override
  List<Object?> get props => [
    products,
    quantities,
    availableStocks,
    loading,
    hasMore,
    currentPage,
    error,
    mastersData,
    mastersLoading,
    mastersError,
    userPreferences,
  ];
}


