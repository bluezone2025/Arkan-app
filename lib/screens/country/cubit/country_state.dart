part of 'country_cubit.dart';

@immutable
abstract class CountryState {}

class CountryInitial extends CountryState {}

class GetCountrySccessState extends CountryState {}

class GetCountryLoadingState extends CountryState {}

class GetCountryErrorState extends CountryState {
  final String error;

  GetCountryErrorState(this.error);
}

class GetCitySccessState extends CountryState {}

class GetCityLoadingState extends CountryState {}

class GetCityErrorState extends CountryState {
  final String error;
  GetCityErrorState(this.error);
}
