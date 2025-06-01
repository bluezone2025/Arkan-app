// ignore_for_file: avoid_print, body_might_complete_normally_nullable

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../componnent/http_services.dart';
import '../model/city.dart';
import '../model/country.dart';
part 'country_state.dart';

class CountryCubit extends Cubit<CountryState> {
  CountryCubit() : super(CountryInitial());

  static CountryCubit get(context) => BlocProvider.of(context);

  CountryModel? countryModel;

  Future<CountryModel?> getCountry() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lang = prefs.get('language').toString();
    emit(GetCountryLoadingState());
    try {
      var response = await http.get(Uri.parse(EndPoints.COUNTRY),
          headers: {'Content-Language': lang});
      var data = jsonDecode(response.body);
      print(data);
      if (data['status'] == 1) {
        countryModel = CountryModel.fromJson(data);
        emit(GetCountrySccessState());
        return countryModel;
      }
    } catch (error) {
      emit(GetCountryErrorState(error.toString()));
      print("errror while get contry : " + error.toString());
    }
  }

  //////////////////////////////////////////////////////////////////////////////////////////////

  CityModel? cityModel;
  Future<CityModel?> getCity() async {
    emit(GetCityLoadingState());
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final String countryId = prefs.getString('country_id') ?? '';
    try {
      Map<String, dynamic> body = {'country_id': countryId};
      var response = await http.post(Uri.parse(EndPoints.CITY), body: body);
      var data = jsonDecode(response.body);
      if (data['status'] == 1) {
        cityModel = CityModel.fromJson(data);
        emit(GetCitySccessState());
        return cityModel;
      }
    } catch (error) {
      emit(GetCityErrorState(error.toString()));
      print("error while get city :" + error.toString());
    }
  }
}
