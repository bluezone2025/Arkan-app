part of 'order_cubit.dart';

@immutable
abstract class OrderState {}

class OrderInitial extends OrderState {}

class AllOrdersLoadingState extends OrderState {}

class AllOrdersSuccessState extends OrderState {}

class AllOrdersErrorState extends OrderState {
  final String error;

  AllOrdersErrorState(this.error);
}

class SingleOrdersLoadingState extends OrderState {}

class SingleOrdersSuccessState extends OrderState {}

class SingleOrdersErrorState extends OrderState {
  final String error;

  SingleOrdersErrorState(this.error);
}

class CashOrdersLoadingState extends OrderState {}

class CashOrdersSuccessState extends OrderState {}

class CashOrdersErrorState extends OrderState {
  final String error;

  CashOrdersErrorState(this.error);
}
