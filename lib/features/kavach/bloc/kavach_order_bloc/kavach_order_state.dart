abstract class KavachOrderState {}

class KavachOrderInitial extends KavachOrderState {}

class KavachOrderSubmitting extends KavachOrderState {}

class KavachOrderSuccess extends KavachOrderState {}

class KavachOrderFailure extends KavachOrderState {
  final String message;

  KavachOrderFailure(this.message);
}
