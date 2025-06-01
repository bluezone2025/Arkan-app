// ignore_for_file: avoid_print, avoid_function_literals_in_foreach_calls, body_might_complete_normally_nullable
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../componnent/http_services.dart';
import '../../../generated/local_keys.dart';
import '../model/favourite.dart';
part 'favourite_state.dart';

class FavouriteCubit extends Cubit<FavouriteState> {
  FavouriteCubit() : super(FavouriteInitial());

  static FavouriteCubit get(context) => BlocProvider.of(context);

  WishlistModel? wishlistModel;
  Map<int, bool> isFavourite = {};

  Future<WishlistModel?> getWishlist() async {
    emit(GetFavouriteLoadingState());
    SharedPreferences pref = await SharedPreferences.getInstance();
    final String token = pref.getString('token').toString();

    try {
      var response = await http
          .get(Uri.parse(EndPoints.WISHLIST), headers: {'auth-token': token});
      var data = jsonDecode(response.body);
      wishlistModel = WishlistModel.fromJson(data);
      wishlistModel!.data!.forEach((element) {
        isFavourite[int.parse(element.id!.toString())] = true;
        emit(GetFavouriteSuccessState());
      });
      emit(GetFavouriteSuccessState());
      return wishlistModel;
    } catch (error) {
      print("errrrrrrrrrrrrrrrrrror: " + error.toString());
      emit(GetFavouriteErrorState(error.toString()));
    }
  }

///////////////////////////////////////////////////////////////////////////////////
  void addtowishlist({required String productId}) async {
    emit(AddFavouriteLoadingState());
    SharedPreferences pref = await SharedPreferences.getInstance();
    final String token = pref.getString('token').toString();

    try {
      Map<String, dynamic> body = {'product_id': productId};
      var response = await http.post(Uri.parse(EndPoints.ADD_WISHLIST),
          body: body, headers: {'auth-token': token});
      var data = jsonDecode(response.body);
      if (data['status'] == 1) {
        if (data['type'] == 'create') {
          Fluttertoast.showToast(
              msg: LocalKeys.ADD_FAV.tr(),
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 16.0);
          isFavourite[int.parse(productId)] = true;
          emit(AddFavouriteSuccessState());
        } else if (data['type'] == 'delete') {
          Fluttertoast.showToast(
              msg: LocalKeys.REMOVE_FAV.tr(),
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 16.0);
          isFavourite[int.parse(productId)] = false;
          emit(AddFavouriteSuccessState());
        }
        emit(AddFavouriteSuccessState());
      }
    } catch (error) {
      print("add to wishlist error :" + error.toString());
      emit(AddFavouriteErrorState(error.toString()));
    }
  }
}
