// ignore_for_file: avoid_print, body_might_complete_normally_nullable

import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../../../app_cubit/appstate.dart';
import '../../../componnent/constants.dart';
import '../../../componnent/http_services.dart';
import '../../cart/model/setting.dart';
import '../../product_detail/model/productcolor_model.dart';
import '../../product_detail/model/singleproduct_model.dart';
import '../model/home_model.dart';

class HomeCubit extends Cubit<AppCubitStates> {
  HomeCubit() : super(AppInitialstates());

  static HomeCubit get(context) => BlocProvider.of(context);

  final String token = prefs.getString('token') ?? '';


  HomeitemsModel? homeitemsModel;
  Future<HomeitemsModel?> getHomeitems() async {
    final String? fcm = await FirebaseMessaging.instance.getToken();
    emit(HomeitemsLoaedingState());
    try {
      var response = await http.get(Uri.parse(EndPoints.HOME_ITEMS),
          headers: {
        'auth-token': token,
        'fcm-token': fcm!,
      });
      var data = jsonDecode(response.body);
      print(response.body);
      if (data['status'] == 1) {
        homeitemsModel = HomeitemsModel.fromJson(data);
      }
      emit(HomeitemsSuccessState());
      return homeitemsModel;
    } catch (error) {
      print("error while get home data =================================$error");
      emit(HomeitemsErrorState(error.toString()));
    }
  }

///////////////////////////////////////////////////////////////////////////////////
  SingleProductModel? singleProductModel;

  Future<SingleProductModel?> getProductdata(
      {required String productId}) async {
    emit(SingleProductLoaedingState());
    print(productId);
    try {
      var response = await http
          .get(Uri.parse("${EndPoints.BASE_URL}get-product/$productId"));
      var data = jsonDecode(response.body);
      print(data);
      if (data['status'] == 1) {
        singleProductModel = SingleProductModel.fromJson(data);
      }
      emit(SingleProductSuccessState());
      return singleProductModel;
    } catch (error) {
      print("error while get home data =================================$error");
      emit(SingleProductErrorState(error.toString()));
    }
  }

  /////////////////////////////////////////////////////////////////////////////////////////////////////////////

  SingleProductColorModel? singleProductColorModel;
  Future<SingleProductColorModel?> getProductColor(
      {required String productId,
      required String sizeId,
      required BuildContext context}) async {
    emit(SingleProductColorLoaedingState());
    try {
      var response = await http
          .get(Uri.parse("${EndPoints.PRODUCT_COLOR}$productId/$sizeId"));
      var data = jsonDecode(response.body);
      if (data['status'] == 1) {
        singleProductColorModel = SingleProductColorModel.fromJson(data);
      }
      emit(SingleProductColorSuccessState());
      return singleProductColorModel;
    } catch (error) {
      print("error while get product color =================================$error");
      emit(SingleProductColorErrorState(error.toString()));
    }
  }
  ///////////////////////////////////////////////////////////////////

  SettingModel? settingModel;
  Future<SettingModel?> getSetting() async {
    emit(SettingDataLoadingState());
    try {
      var response = await http.get(Uri.parse(EndPoints.SETTING));
      var data = jsonDecode(response.body);
      if (data['status'] == 1) {
        settingModel = SettingModel.fromJson(data);
        emit(SettingDataSuccessState());
        return settingModel;
      }
    } catch (e) {
      emit(SettingDataErrorState(e.toString()));
      print("error while get setting : $e");
    }
  }

  ///////////////////////////////////////////////////////////////////

  CheckQuantityModel? checkQuantityModel;

  Future<CheckQuantityModel?> checkQuantity(String days,String productId) async {
    emit(CheckQuantityLoadingState());
    try {
      var response = await http.post(Uri.parse(EndPoints.QUANTITY),body: {
        'BookingDates': days,
        'product_id': productId
      });
      var data = jsonDecode(response.body);
      print(data);
      if (data['status'] == 1) {
        checkQuantityModel = CheckQuantityModel.fromJson(data);
        emit(CheckQuantitySuccessState());
        return checkQuantityModel;
      }else{
        emit(CheckQuantityErrorState(data['message']));
      }
    } catch (e) {
      emit(CheckQuantityErrorState(e.toString()));
      print("error while get setting : $e");
    }
  }
}
CheckQuantityModel checkQuantityModelFromJson(String str) => CheckQuantityModel.fromJson(json.decode(str));

String checkQuantityModelToJson(CheckQuantityModel data) => json.encode(data.toJson());

class CheckQuantityModel {
  int status;
  int quantity;
  List<dynamic> days;

  CheckQuantityModel({
    required this.status,
    required this.quantity,
    required this.days,
  });

  factory CheckQuantityModel.fromJson(Map<String, dynamic> json) => CheckQuantityModel(
    status: json["status"],
    quantity: json["quantity"],
    days: List<dynamic>.from(json["days"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "quantity": quantity,
    "days": List<dynamic>.from(days.map((x) => x)),
  };
}