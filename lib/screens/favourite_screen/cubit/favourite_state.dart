part of 'favourite_cubit.dart';

@immutable
abstract class FavouriteState {}

class FavouriteInitial extends FavouriteState {}

class AddFavouriteLoadingState extends FavouriteState {}

class AddFavouriteSuccessState extends FavouriteState {}

class AddFavouriteErrorState extends FavouriteState {
  final String error;

  AddFavouriteErrorState(this.error);
}

class GetFavouriteLoadingState extends FavouriteState {}

class GetFavouriteSuccessState extends FavouriteState {}

class GetFavouriteErrorState extends FavouriteState {
  final String error;

  GetFavouriteErrorState(this.error);
}
