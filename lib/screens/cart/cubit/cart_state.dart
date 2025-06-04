part of 'cart_cubit.dart';

@immutable
abstract class CartState {}

class CartInitial extends CartState {}

class CheckProductAddcartLoadingState extends CartState {}

class CheckProductAddcartSuccessState extends CartState {
  final int index;
  CheckProductAddcartSuccessState(this.index);
}

class CheckProductAddcartErroState extends CartState {
  final String error;

  CheckProductAddcartErroState(this.error);
}

class DeliveryLoadingState extends CartState {}

class DeliverySuccessState extends CartState {}

class DeliveryErroState extends CartState {
  final String error;

  DeliveryErroState(this.error);
}

class SaveOrderLoadingState extends CartState {}

class SaveOrderSuccessState extends CartState {}

class SaveOrderErroState extends CartState {
  final String error;

  SaveOrderErroState(this.error);
}
