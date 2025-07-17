part of 'driver_load_details_cubit.dart';



class DriverLoadDetailsState extends Equatable {
  final UIState<DriverLoadDetailsModel>? lpLoadById;
 



  const DriverLoadDetailsState({
    this.lpLoadById,
  });

  DriverLoadDetailsState copyWith({
    UIState<DriverLoadDetailsModel>? lpLoadById,
   
  }) {
    return DriverLoadDetailsState(
      lpLoadById: lpLoadById ?? this.lpLoadById,
    
    );
  }

  @override
  List<Object?> get props => [
    lpLoadById,
   
  ];
}
